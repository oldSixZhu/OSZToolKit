//
//  CalenderView.m
//  YZCCalender
//
//  Created by Jason on 2018/1/17.
//  Copyright © 2018年 jason. All rights reserved.
//

#import "CalenderView.h"
#import "CalenderHeaderView.h"
#import "CalenderCollectionCell.h"

#import "NSDate+Extensions.h"
#import "CalenderModel.h"

@interface CalenderView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIView *weekView;                      /**< 星期视图 */
@property (nonatomic, strong) UICollectionView *collectionView;      /**< 日历视图 */
@property (nonatomic, copy) NSString *startDay;                      /**< 开始日期,格式YYYY-MM-dd */
@property (nonatomic, copy) NSString *endDay;                        /**< 结束日期,格式YYYY-MM-dd */
@property (nonatomic, strong) NSMutableArray *dataSource;            /**< 数据源 */

@end

static NSString *const reuseIdentifier  = @"collectionViewCell";
static NSString *const headerIdentifier = @"headerIdentifier";

@implementation CalenderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //今天的日期为开始和下个月最后一日为结束
        self.startDay = [NSDate currentDay];
        self.endDay = [NSDate nextMonthLastDay];
        [self buildSource];
        [self addSubview:self.weekView];
        [self addSubview:self.collectionView];
    }
    return self;
}

#pragma mark - 设置数据源
- (void)buildSource {
    //初始化数据源的组
    for (int i = 0; i < 2; i++) {
        NSMutableArray *array = [NSMutableArray array];
        [self.dataSource addObject:array];
    }
    //准备数据源
    for (int i = 0; i < 2; i++) {
        int month = ((int)[NSDate month:self.startDay] + i)%12;
        //获取下个月的年月日信息,并将其转为date
        NSDateComponents *components = [[NSDateComponents alloc]init];
        components.month = month ? month : 12;
        components.year = 2018 + i/12;
        components.day = 1;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *nextDate = [calendar dateFromComponents:components];
        //获取该月第一天星期几
        NSInteger firstDayWeek = [NSDate firstWeekdayInThisMonth:nextDate];
        //该月有多少天
        NSInteger daysInThisMounth = [NSDate totaldaysInMonth:nextDate];
        //如果是当前月
        if (month == (int)[NSDate month:self.startDay]) {
            //"第一天星期几"就以今天的星期为开始
            firstDayWeek = [NSDate week:self.startDay];
        }
        //每天的数字
        for (int j = 0; j < 42; j++) {
            CalenderModel *model = [[CalenderModel alloc] init];
            model.year = [NSString stringWithFormat:@"%ld",(long)components.year];
            model.month = [NSString stringWithFormat:@"%ld",(long)components.month];
            model.dayType = Other;
            //在第一天之前的格子为空
            if (j < firstDayWeek) {
                model.day = @"";
            //在所有天数加上第一个星期之后的,跳出循环,不添加进数据源
            } else if ( j > daysInThisMounth + firstDayWeek - 1){
                continue;
            //其他的都是有效数据
            } else {
                model.day = [NSString stringWithFormat:@"%ld", j - firstDayWeek + 1];
                model.date = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)components.year,(long)components.month,(long)(j - firstDayWeek + 1)];
                //如果是过去的时间,就跳出循环,不添加进数据源
                if (![NSDate isActivity:model.date withStartDay:self.startDay andEndDay:self.endDay]) {
                    continue;
                }
                //今天明天后天
                if ([NSDate isToday:model.date]) {
                    model.dayType = Today;
                    model.isSelected = YES;
                } else if ([NSDate isTomorrow:model.date]) {
                    model.dayType = Tomorrow;
                } else if ([NSDate isAfterTomorrow:model.date]) {
                    model.dayType = AfterTomorrow;
                }
                
            }
            [[self.dataSource objectAtIndex:i]addObject:model];
        }
    }
}

//更新数据源
- (void)refreshCalenderWithSelectedDay:(NSString *)date {
    [self.dataSource enumerateObjectsUsingBlock:^(NSMutableArray  * _Nonnull array, NSUInteger idx, BOOL * _Nonnull stop) {
        [array enumerateObjectsUsingBlock:^(CalenderModel * _Nonnull calenderModel, NSUInteger idx, BOOL * _Nonnull stop) {
            calenderModel.isSelected = NO;
            if ([calenderModel.date isEqualToString:date]) {
                calenderModel.isSelected = YES;
            }
        }];
    }];
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self.dataSource objectAtIndex:section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CalenderCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    CalenderModel *model = self.dataSource[indexPath.section][indexPath.item];
    cell.model = model;
    return cell;
}

//组头
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        CalenderHeaderView *heardView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        CalenderModel *model = self.dataSource[indexPath.section][indexPath.item];
        heardView.yearAndMonthLabel.text = [NSString stringWithFormat:@"%@年%@月", model.year, model.month];
        return heardView;
    }
    return nil;
}

//点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CalenderCollectionCell * cell = (CalenderCollectionCell *)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    CalenderModel *model = cell.model;
    //点击空白格就返回
    if (model.day.length <= 0) {
        return;
    }
    //如果点击已选中的就返回
    if ([cell.model.date isEqualToString:self.selectedDate]) {
        return;
    }
    //初始化所有日状态为未选择
    [self.dataSource enumerateObjectsUsingBlock:^(NSMutableArray  * _Nonnull array, NSUInteger idx, BOOL * _Nonnull stop) {
        [array enumerateObjectsUsingBlock:^(CalenderModel * _Nonnull calenderModel, NSUInteger idx, BOOL * _Nonnull stop) {
            calenderModel.isSelected = NO;
        }];
    }];
    model.isSelected = YES;
    self.selectedDate = model.date;
    [self.collectionView reloadData];
    
    //传出去
    if (self.delegate && ([self.delegate respondsToSelector:@selector(selectedDate:)])) {
        [self.delegate selectedDate:self.selectedDate];
    }
}


#pragma mark - getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        float cellw = (self.v_width - 20) / 7;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setHeaderReferenceSize:CGSizeMake(self.v_width, 50)];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, -1, 0, 0);
        flowLayout.minimumInteritemSpacing = -1;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.itemSize = CGSizeMake(cellw, 50);
        
        CGFloat collectionViewY = CGRectGetMaxY(self.weekView.frame);
        CGFloat collectionViewH = self.frame.size.height - collectionViewY;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, collectionViewY, self.v_width - 20, collectionViewH)  collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        [_collectionView registerClass:[CalenderHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
        [_collectionView registerClass:[CalenderCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
    }
    return _collectionView;
}

//星期视图
- (UIView *)weekView {
    if (!_weekView) {
        _weekView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _weekView.backgroundColor = UIColorFromHex(0xF3F3F3);
        //加入星期数
        NSArray *weekArray = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
        CGFloat labelW = SCREEN_WIDTH / weekArray.count;
        CGFloat labelY = 0;
        CGFloat labelH = _weekView.v_height;
        for (int i = 0; i < weekArray.count; i++) {
            CGFloat labelX = i * labelW;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = UIColorFromHex(0x4A4A4A);
            label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
            label.text = weekArray[i];
            [_weekView addSubview:label];
        }
    }
    return _weekView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end

