//
//  HorizontalPageViewController.h
//  TYFitFore
//
//  Created by apple on 2018/5/15.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HorizontalPageViewControllerDelegate <NSObject>

/** 总页数 */
- (NSInteger)numberOfPages;
/** 每页的视图 */
- (UIView *)pageViewForIndexPath:(NSIndexPath *)indexPath;
/** 当前选中视图 */
- (void)pageViewDidSelectedIndex:(NSInteger)index;

@end

@interface HorizontalPageViewController : UIViewController

@property (nonatomic, weak) id<HorizontalPageViewControllerDelegate> delegate;          /**< 代理方法  */
@property (nonatomic, assign) CGSize pageSize;                                          /**< 每页的size  */
@property (nonatomic, assign) BOOL bounces;                                             /**< 边缘弹簧效果  */

/** 移动到指定的下标 */
- (void)moveToIndex:(NSInteger)index animated:(BOOL)animated;

@end
