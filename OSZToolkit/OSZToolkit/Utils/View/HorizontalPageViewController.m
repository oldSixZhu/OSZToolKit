//
//  HorizontalPageViewController.m
//  TYFitFore
//
//  Created by apple on 2018/5/15.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import "HorizontalPageViewController.h"

#import "HorizontalPageableLayout.h"

static NSString *const pageCollectionViewCellIdentifier = @"pageCollectionViewCellIdentifier";

@interface HorizontalPageViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) HorizontalPageableLayout *pageLayout;
@property (nonatomic, strong) UICollectionView *pageCollectionView;

@property (nonatomic, assign) NSInteger selectedIndex;                              /**< 当前选中的控制器下标  */

@end

@implementation HorizontalPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.pageCollectionView];
    AdjustsScrollViewInsetNever(self, self.pageCollectionView)
}

#pragma mark - event
//选中指定的item
- (void)moveToIndex:(NSInteger)index animated:(BOOL)animated {
    
    NSInteger numberOfPages = 0;
    if ([self.delegate respondsToSelector:@selector(numberOfPages)]) {
        numberOfPages = [self.delegate numberOfPages];
    }
    
    if (index >=0 && index < numberOfPages) {
        [self.pageCollectionView setContentOffset:CGPointMake(index * self.pageSize.width, 0) animated:animated];
    }
}

#pragma mark - UICollectionView代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(numberOfPages)]) {
        return [self.delegate numberOfPages];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:pageCollectionViewCellIdentifier forIndexPath:indexPath];
    //添加视图
    if ([self.delegate respondsToSelector:@selector(pageViewForIndexPath:)]) {
        UIView *subview = [self.delegate pageViewForIndexPath:indexPath];
        [cell addSubview:subview];
    }
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    
    if (self.pageSize.width > 0) {
        self.selectedIndex = roundl(offsetX/self.pageSize.width);
        if ([self.delegate respondsToSelector:@selector(pageViewDidSelectedIndex:)]) {
            [self.delegate pageViewDidSelectedIndex:self.selectedIndex];
        }
    }
}

#pragma mark - getter
- (HorizontalPageableLayout *)pageLayout {
    if (!_pageLayout) {
        _pageLayout = [[HorizontalPageableLayout alloc] init];
        //item间距
        NSInteger numberOfPages = 0;
        if ([self.delegate respondsToSelector:@selector(numberOfPages)]) {
            numberOfPages = [self.delegate numberOfPages];
        }
        _pageLayout.itemCountPerRow = numberOfPages;
        _pageLayout.sectionInset = UIEdgeInsetsZero;
        _pageLayout.rowCount = 1;
        _pageLayout.minimumLineSpacing = 0;
        _pageLayout.minimumInteritemSpacing = 0;
        _pageLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _pageLayout.itemSize = self.pageSize;
    }
    return _pageLayout;
}

- (UICollectionView *)pageCollectionView {
    if (!_pageCollectionView) {
        _pageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.pageSize.width, self.pageSize.height) collectionViewLayout:self.pageLayout];
        _pageCollectionView.backgroundColor = UIColorFromHex(0x182845);
        _pageCollectionView.delegate = self;
        _pageCollectionView.dataSource = self;
        _pageCollectionView.showsVerticalScrollIndicator = NO;
        _pageCollectionView.showsHorizontalScrollIndicator = NO;
        _pageCollectionView.pagingEnabled = YES;
        _pageCollectionView.bounces = self.bounces;
        //注册cell
        [_pageCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:pageCollectionViewCellIdentifier];
    }
    return _pageCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
