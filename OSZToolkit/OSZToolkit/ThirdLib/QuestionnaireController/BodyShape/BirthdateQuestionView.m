//
//  BirthdateQuestionView.m
//  TYFitFore
//
//  Created by TanYun on 2018/1/14.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import "BirthdateQuestionView.h"
#import "OSZRulerView.h"
#import "OSZRulerModel.h"

@interface BirthdateQuestionView ()<OSZRulerViewDelegate>

@property (nonatomic,strong) UILabel *detailLabel;               /**< 注: */
@property (nonatomic,strong) UILabel *yearLabel;                 /**< 年 */
@property (nonatomic,strong) OSZRulerView *yearRulerView;        /**< 年刻度尺 */
@property (nonatomic,strong) UILabel *monthLabel;               /**< 月 */
@property (nonatomic,strong) OSZRulerView *monthRulerView;      /**< 月刻度尺 */
@property (nonatomic,strong) UILabel *dayLabel;                 /**< 日 */
@property (nonatomic,strong) OSZRulerView *dayRulerView;         /**< 日刻度尺 */
@property (nonatomic,strong) UILabel *warnLabel;                 /**< 如实填写 */

@property (nonatomic, strong) NSMutableArray *leapYearArray;         /**< 所有闰年年份,判断是否闰年使用 */
@property (nonatomic,strong) NSString *year;                     /**< 年值 */
@property (nonatomic,strong) NSString *month;                    /**< 月值 */
@property (nonatomic,strong) NSString *day;                      /**< 日值 */

@end




@implementation BirthdateQuestionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        [self.bjView addSubview:self.detailLabel];
        [self.bjView addSubview:self.yearLabel];
        [self.bjView addSubview:self.yearRulerView];
        [self.bjView addSubview:self.monthLabel];
        [self.bjView addSubview:self.monthRulerView];
        [self.bjView addSubview:self.dayLabel];
        [self.bjView addSubview:self.dayRulerView];
        [self.bjView addSubview:self.warnLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.detailLabel.frame = CGRectMake(20, self.titleLabel.v_bottom+10, self.v_width-40, 16);
    
    self.yearLabel.frame = CGRectMake(150, self.titleLabel.v_bottom+25, 20, 14);
    self.yearRulerView.v_y = self.yearLabel.v_bottom+5;
    
    self.monthLabel.frame = CGRectMake(150, self.yearRulerView.v_bottom+25, 20, 14);
    self.monthRulerView.v_y = self.monthLabel.v_bottom+5;
    
    self.dayLabel.frame = CGRectMake(150, self.monthRulerView.v_bottom+25, 20, 14);
    self.dayRulerView.v_y = self.dayLabel.v_bottom+5;
    
    self.warnLabel.frame = CGRectMake(0, self.v_height-14-15, self.v_width, 14);
}


#pragma mark - getter
//注:
-(UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.textColor = UIColorFromHex(0x9B9B9B);
        _detailLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _detailLabel.text = ZYSString(@"sport_questionnaire_sexDetail");
    }
    return _detailLabel;
}
//年
-(UILabel *)yearLabel{
    if (!_yearLabel) {
        _yearLabel = [[UILabel alloc]init];
        _yearLabel.textColor = UIColorFromHex(0x9B9B9B);
        _yearLabel.textAlignment = NSTextAlignmentCenter;
        _yearLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    }
    return _yearLabel;
}

-(OSZRulerView *)yearRulerView{
    if (!_yearRulerView) {
        _yearRulerView = [[OSZRulerView alloc]initWithFrame:CGRectMake(32.5, 0, 260, 55)];
        _yearRulerView.delegate = self;
    }
    return _yearRulerView;
}

//月
-(UILabel *)monthLabel{
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc]init];
        _monthLabel.textColor = UIColorFromHex(0x9B9B9B);
        _monthLabel.textAlignment = NSTextAlignmentCenter;
        _monthLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    }
    return _monthLabel;
}

-(OSZRulerView *)monthRulerView{
    if (!_monthRulerView) {
        _monthRulerView = [[OSZRulerView alloc]initWithFrame:CGRectMake(32.5, 0, 260, 55)];
        _monthRulerView.delegate = self;
    }
    return _monthRulerView;
}


//日
-(UILabel *)dayLabel{
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc]init];
        _dayLabel.textColor = UIColorFromHex(0x9B9B9B);
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        _dayLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    }
    return _dayLabel;
}

-(OSZRulerView *)dayRulerView{
    if (!_dayRulerView) {
        _dayRulerView = [[OSZRulerView alloc]initWithFrame:CGRectMake(32.5, 0, 260, 55)];
        _dayRulerView.delegate = self;
    }
    return _dayRulerView;
}


-(UILabel *)warnLabel{
    if (!_warnLabel) {
        _warnLabel = [[UILabel alloc]init];
        _warnLabel.textAlignment = NSTextAlignmentCenter;
        _warnLabel.text = ZYSString(@"sport_questionnaire_warn");
        _warnLabel.textColor = [UIColorFromHex(0x868D9A) colorWithAlphaComponent:0.8];
        _warnLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    }
    return _warnLabel;
}

#pragma mark - setter
-(void)setQuestionModel:(QuestionModel *)questionModel{
    _questionModel = questionModel;
    //配置数据
    self.numLabel.text = @"02";
    self.titleNumLabel.text = @"OF 02";
    self.titleImageView.image = [UIImage imageNamed:@"word_body_shape"];
    self.titleLabel.text = questionModel.title;
    //年月日
    self.leapYearArray = [NSMutableArray array];
    NSMutableArray *dataArrayYear = [NSMutableArray array];
    NSMutableArray *dataArrayMonth = [NSMutableArray array];
    NSMutableArray *dataArrayDay = [NSMutableArray array];
    //判断长度
    if (questionModel.options.count != 3) {
        return;
    }
    
    //准备年数据
    OptionModel *yearOption = questionModel.options[0];
    self.yearLabel.text = yearOption.descriptions;
    //年份范围
    NSString *startYear = yearOption.range[0];
    NSString *endYear = [[Tools currentTime] substringToIndex:4];
    
    for (NSInteger i = startYear.integerValue ; i<= endYear.integerValue-1; i++) {
        //获取所有闰年年份
        if ([self isLeapYear:i]) {
            [self.leapYearArray addObject:[NSString stringWithFormat:@"%ld",(long)i]];
        }
        
        OSZRulerModel *rulerModel = [[OSZRulerModel alloc]init];
        rulerModel.isCenter = NO;
        rulerModel.unit = @"year";
        rulerModel.value = [NSString stringWithFormat:@"%ld",(long)i];
        [dataArrayYear addObject:rulerModel];
    }
    
    //准备月数据
    OptionModel *monthOption = questionModel.options[1];
    self.monthLabel.text = monthOption.descriptions;
    //月份范围
    NSString *startMonth = monthOption.range[0];
    NSString *endMonth = monthOption.range[1];
    
    for (NSInteger i = startMonth.integerValue ; i<= endMonth.integerValue; i++) {
        OSZRulerModel *rulerModel = [[OSZRulerModel alloc]init];
        rulerModel.isCenter = NO;
        rulerModel.unit = @"month";
        rulerModel.value = [NSString stringWithFormat:@"%ld",(long)i];
        [dataArrayMonth addObject:rulerModel];
    }
    
    //准备日数据
    OptionModel *dayOption = questionModel.options[2];
    self.dayLabel.text = dayOption.descriptions;
    //日范围
    NSString *startDay = dayOption.range[0];
    NSString *endDay = dayOption.range[1];
    
    for (NSInteger i = startDay.integerValue ; i<= endDay.integerValue; i++) {
        OSZRulerModel *rulerModel = [[OSZRulerModel alloc]init];
        rulerModel.isCenter = NO;
        rulerModel.unit = @"day";
        rulerModel.value = [NSString stringWithFormat:@"%ld",(long)i];
        [dataArrayDay addObject:rulerModel];
    }
    


    self.yearRulerView.dataArray = dataArrayYear;
    self.monthRulerView.dataArray = dataArrayMonth;
    self.dayRulerView.dataArray = dataArrayDay;
    
    //默认滚动1990
    NSInteger defaultYear = yearOption.defaultValue.integerValue - startYear.integerValue;
    self.yearRulerView.rulerView.contentOffset = CGPointMake(defaultYear * 40 , 0);
    //默认滚动6
    NSInteger defaultMonth = monthOption.defaultValue.integerValue - startMonth.integerValue;
    self.monthRulerView.rulerView.contentOffset = CGPointMake(defaultMonth * 40 , 0);
    //默认滚动15
    NSInteger defaultDay = dayOption.defaultValue.integerValue - startDay.integerValue;
    self.dayRulerView.rulerView.contentOffset = CGPointMake(defaultDay * 40 , 0);
    
//    [self.yearRulerView.rulerView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:defaultYear inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
//    [self.yearRulerView.rulerView selectItemAtIndexPath:[NSIndexPath indexPathForItem:defaultYear inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}


#pragma mark - OSZRulerViewDelegate
-(void)valueChange:(OSZRulerModel *)rulerModel{
//    //提取今天日期
//    NSString *currentTime = [Tools currentTime];
//    NSString *currentYear = [currentTime substringToIndex:4];
//    NSString *currentMonth = [currentTime substringWithRange:NSMakeRange(5,2)];
//    NSString *currentDay = [currentTime substringWithRange:NSMakeRange(8,2)];
    NSInteger endDay = 30;
    //年滚轮变化
    if ([rulerModel.unit isEqualToString:@"year"]) {
        self.year = rulerModel.value;
        //判断当前选择月份是2月份
        if ([self.month isEqualToString:@"2"]) {
            endDay = 28;
            self.day = @"";
            //判断当前选择年份如果是闰年,为29天
            for (NSString *year in self.leapYearArray) {
                if ([self.year isEqualToString:year]) {
                    endDay = 29;
                }
            }
            //准备日滚轮数据
            [self setupDayRulerViewWithEndDay:endDay];
        }
        
    }else if ([rulerModel.unit isEqualToString:@"month"]) {
        //月滚轮变化
        self.month = rulerModel.value;
        //大月31天，小月30天，2月28天（闰年29天)
        if ([self.month isEqualToString:@"4"] || [self.month isEqualToString:@"6"] || [self.month isEqualToString:@"9"] || [self.month isEqualToString:@"11"] ) {
            //4,6,9,11为30天
            endDay = 30;
        } else if ([self.month isEqualToString:@"2"]) {
            endDay = 28;
            self.day = @"";
            //判断当前选择年份如果是闰年,为29天
            for (NSString *year in self.leapYearArray) {
                if ([self.year isEqualToString:year]) {
                    endDay = 29;
                }
            }
        } else {
            //一﹑三﹑五﹑七﹑八﹑十﹑十二 为大,31天
            endDay = 31;
        }
        //准备日滚轮数据
        [self setupDayRulerViewWithEndDay:endDay];
        //---------------------------------------------------------------------------
    }else if ([rulerModel.unit isEqualToString:@"day"]) {
        //日滚轮变化
        self.day = rulerModel.value;
    }
    
    //三个全都有才传值,否则按钮禁用
    if ((self.year.length >0)&&(self.month.length >0)&&(self.day.length >0)) {
        if (self.delegate &&([self.delegate respondsToSelector:@selector(birthdateValueChange:)])) {
            NSNumber *year = @(self.year.integerValue);
            NSNumber *month = @(self.month.integerValue);
            NSNumber *day = @(self.day.integerValue);
            
            NSArray *valueArray = @[year,month,day];
            [self.delegate birthdateValueChange:valueArray];
        }
    } else {
        if (self.delegate &&([self.delegate respondsToSelector:@selector(enableSubmitButton)])) {
            [self.delegate enableSubmitButton];
        }
    }
}


//准备日滚轮数据
- (void)setupDayRulerViewWithEndDay:(NSInteger)endDay {
    NSMutableArray *dataArrayDay = [NSMutableArray array];
    NSString *currentDay = self.day;
    self.day = @"";
    for (NSInteger i = 1 ; i<= endDay; i++) {
        OSZRulerModel *rulerModel = [[OSZRulerModel alloc]init];
        rulerModel.isCenter = NO;
        rulerModel.unit = @"day";
        rulerModel.value = [NSString stringWithFormat:@"%ld",(long)i];
        //当前选择的日期小于等于最大日期,才让模型中的日期标记为选中,当从大月到小月变化时就清空当前日期,提交按钮禁用
        if ((self.day.integerValue <= endDay) && ([rulerModel.value isEqualToString:currentDay])) {
            rulerModel.isCenter = YES;
            self.day = currentDay;
        }
        [dataArrayDay addObject:rulerModel];
    }
    self.dayRulerView.dataArray = dataArrayDay;
    [self.dayRulerView.rulerView reloadData];
}

//判断是否闰年
- (BOOL)isLeapYear:(NSInteger)year {
    BOOL result  = YES;
    if (((year % 4  == 0) && (year % 100 != 0))|| (year % 400 == 0)) {
        result = YES;
    } else {
        result = NO;
    }
    return result;
}



@end













