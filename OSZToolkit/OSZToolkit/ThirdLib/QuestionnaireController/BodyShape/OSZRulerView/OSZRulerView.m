//
//  OSZRulerView.m
//  TYFitFore
//
//  Created by TanYun on 2018/1/17.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import "OSZRulerView.h"
#import "OSZRulerViewCell.h"


@interface OSZRulerView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UIView *centerLine;                    /**< 绿色的线 */


@end



@implementation OSZRulerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorFromRGB_A(0xE4E6EB, 0.3);
        //设置渐变
        [self addStartGradientLayer];
        [self addEndGradientLayer];
    }
    return self;
}

#pragma mark - 添加渐变
//添加开始渐变
- (void)addStartGradientLayer {
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    CAGradientLayer *startGradientLayer = [CAGradientLayer layer];
    startGradientLayer.frame = self.bounds;
    //设置渐变区域的起始和终止位置（颜色渐变范围为0-1）
    startGradientLayer.startPoint = CGPointMake(0, 0);
    startGradientLayer.endPoint = CGPointMake(1, 0);
    //设置颜色数组
    startGradientLayer.colors = @[(__bridge id)[UIColor whiteColor].CGColor,
                                       (__bridge id)[[UIColor whiteColor]colorWithAlphaComponent:0.0f].CGColor];
    //设置颜色分割点（区域渐变范围：0-1）
    startGradientLayer.locations = @[@(0.0f), @(0.3f)];
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [self.layer addSublayer:startGradientLayer];
}

//添加结束渐变
- (void)addEndGradientLayer {
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    CAGradientLayer *endGradientLayer = [CAGradientLayer layer];
    endGradientLayer.frame = self.bounds;
    //设置渐变区域的起始和终止位置（颜色渐变范围为0-1）
    endGradientLayer.startPoint = CGPointMake(0, 0);
    endGradientLayer.endPoint = CGPointMake(1, 0);
    //设置颜色数组
    endGradientLayer.colors = @[(__bridge id)[[UIColor whiteColor]colorWithAlphaComponent:0.0f].CGColor,
                                     (__bridge id)[UIColor whiteColor].CGColor];
    //设置颜色分割点（区域渐变范围：0-1）
    endGradientLayer.locations = @[@(0.7f), @(1.0f)];
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [self.layer addSublayer:endGradientLayer];
}


#pragma mark - collectionView
//组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//行
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

//cell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    OSZRulerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OSZRulerViewCell" forIndexPath:indexPath];
    cell.rulerModel = self.dataArray[indexPath.row];
//    cell.backgroundColor = [UIColor blueColor];
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(40, 55);
}

//定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//头尾视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    //头视图
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
        reusableView = headerView;
    //尾视图
    }else if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer" forIndexPath:indexPath];
        reusableView = footerView;
    }
    return reusableView;
}

#pragma mark - scrollViewDelegate
//让cell刚好居中
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGPoint originalTargetContentOffset = CGPointMake(targetContentOffset->x, targetContentOffset->y);
    CGPoint targetCenter = CGPointMake(originalTargetContentOffset.x + CGRectGetWidth(self.rulerView.bounds)/2, CGRectGetHeight(self.rulerView.bounds) / 2);
    NSIndexPath *indexPath = nil;
    NSInteger i = 0;
    while (indexPath == nil) {
        targetCenter = CGPointMake(originalTargetContentOffset.x + CGRectGetWidth(self.rulerView.bounds)/2 + 10*i, CGRectGetHeight(self.rulerView.bounds) / 2);
        indexPath = [self.rulerView indexPathForItemAtPoint:targetCenter];
        i++;
    }
    //这里用attributes比用cell要好很多，因为cell可能因为不在屏幕范围内导致cellForItemAtIndexPath返回nil
    UICollectionViewLayoutAttributes *attributes = [self.rulerView.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
    if (attributes) {
        *targetContentOffset = CGPointMake(attributes.center.x - CGRectGetWidth(self.rulerView.bounds)/2, originalTargetContentOffset.y);
    }
    //    NSLog(@"center is %@; indexPath is {%@, %@}; cell is %@",NSStringFromCGPoint(targetCenter), @(indexPath.section), @(indexPath.item), attributes);
}

//提取最后的cell,更新视图
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 将collectionView在控制器view的中心点转化成collectionView上的坐标
    CGPoint pInView = [self convertPoint:self.rulerView.center toView:self.rulerView];
    // 获取这一点的indexPath
    NSIndexPath *indexPath = [self.rulerView indexPathForItemAtPoint:pInView];
    //更新视图
    OSZRulerModel *rulerModel = self.dataArray[indexPath.row];
    rulerModel.isCenter = YES;
    [self.rulerView reloadData];
    //通知外部改变
    if (self.delegate && ([self.delegate respondsToSelector:@selector(valueChange:)])) {
        [self.delegate valueChange:rulerModel];
    }
    
}


#pragma mark - setter
-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    [self addSubview:self.rulerView];
    [self addSubview:self.centerLine];
}


#pragma mark - getter
//中间的绿线
-(UIView *)centerLine{
    if (!_centerLine) {
        _centerLine = [[UIView alloc]initWithFrame:CGRectMake(128.5, 37, 3, 18)];
        _centerLine.backgroundColor = UIColorFromHex(0x00C6B8);
        //上面圆角,以第一个值为准
        [Tools setCornerRadiuswithView:_centerLine targetAngles:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(1.5, 1.5)];
    }
    return _centerLine;
}

-(UICollectionView *)rulerView{
    if (!_rulerView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //设置头部大小
        layout.headerReferenceSize=CGSizeMake(128.5,50);
        //设置尾部大小
        layout.footerReferenceSize=CGSizeMake(128.5,50);

        _rulerView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        _rulerView.pagingEnabled = NO;
        _rulerView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0];
        _rulerView.showsHorizontalScrollIndicator = NO;
        _rulerView.dataSource = self;
        _rulerView.delegate = self;
        //注册cell
        [_rulerView registerClass:[OSZRulerViewCell class] forCellWithReuseIdentifier:@"OSZRulerViewCell"];
        //注册头部视图
        [_rulerView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
        // 注册尾部视图
        [_rulerView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer"];

        //默认滚动
        [_rulerView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:10 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    return _rulerView;
}


@end
