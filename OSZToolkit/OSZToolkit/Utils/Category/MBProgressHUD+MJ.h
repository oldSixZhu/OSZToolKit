//
//  MBProgressHUD+MJ.h
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (MJ)


#pragma mark - 弹框在UIwindow上

/**
 *  带图片的成功的Toast提示
 *
 *  @param success 成功提示文字
 */
+ (void)showSuccess:(NSString *)success;
+ (void)showSuccess:(NSString *)success model:(BOOL)model;

/**
 *  带图片的错误的Toast提示
 */
+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error model:(BOOL)model;

/**
 *  toast提示框
 */
+ (void)showToastOnWindow:(NSString *)message;
+ (void)showBlackToastOnWindow:(NSString *)message;
+ (void)showToastOnWindow:(NSString *)message model:(BOOL)model;

/**
 *  在window上带文字几秒后提示消失
 */
+ (void)showToastOnWindow:(NSString *)message afterDelay:(NSTimeInterval)delay;
+ (void)showToastOnWindow:(NSString *)message afterDelay:(NSTimeInterval)delay model:(BOOL)model;

/**
 *  带图片的Toast
 */
+ (void)showToastWithImgOnWindow:(NSString *)tipStr toastImg:(UIImage *)toastImg;
+ (void)showToastWithImgOnWindow:(NSString *)tipStr toastImg:(UIImage *)toastImg after:(NSTimeInterval)delay model:(BOOL)model;
/// 黑色的背景，图片+文字
+ (void)showBlackToastWithString:(NSString *)tipStr andImage:(UIImage *)toastImg;

/**
 *  在window上显示转圈的MBProgressHUD (不会自动消失,需要手动调用隐藏方法)
 *
 *  @param tipStr 提示语
 */
+ (void)showLoadingOnWindowWithText:(NSString *)tipStr;
+ (void)showBlackLoadingOnWindowWithText:(NSString *)tipStr;
+ (void)showLoadingOnWindowWithText:(NSString *)tipStr model:(BOOL)model;

/**
 *  隐藏window上创建的MBProgressHUD
 */
+ (void)hideLoadingFromWindow;




#pragma mark - 弹框在指定view上

/**
 *  在指定view上带图片的成功的Toast提示
 *
 *  @param success 成功提示文字
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view model:(BOOL)model;
/**
 *  在指定view上带图片的失败的Toast提示
 *
 */
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view model:(BOOL)model;
/**
 *  展示 结果
 */
+ (void)showToastViewOnView:(UIView *)addView text:(NSString *)message;
+ (void)showToastViewOnView:(UIView *)addView text:(NSString *)message model:(BOOL)model;

/**
 *  在自定义Viwe上带文字暂时卡住页面
 */
+ (void)showToastViewOnView:(UIView *)addView text:(NSString *)message afterDelay:(NSTimeInterval)delay;
+ (void)showToastViewOnView:(UIView *)addView text:(NSString *)message afterDelay:(NSTimeInterval)delay model:(BOOL)model;
/**
 *  带图片的Toast
 */
+ (void)showLoadingToView:(UIView *)view text:(NSString *)text icon:(NSString *)icon;
+ (void)showLoadingToView:(UIView *)addView text:(NSString *)text icon:(UIImage *)icon after:(NSTimeInterval)delay model:(BOOL)model;
/**
 *  在指定view上显示转圈的MBProgressHUD (不会自动消失,需要手动调用隐藏方法,非模态)
 *
 *  @param tipStr 提示语
 */
+ (void)showLoadingWithView:(UIView *)view text:(NSString *)tipStr;
+ (void)showLoadingWithView:(UIView *)addView text:(NSString *)tipStr model:(BOOL)model;
/**
 *
 *  在指定view上显示转圈的MBProgressHUD (不会自动消失,需要手动调用隐藏方法,模态)
 *
 *  @param tipStr 提示语
 */
+ (void)showModelLoadingWithView:(UIView *)addView text:(NSString *)tipStr;

/**
 *  隐藏指定view上创建的MBProgressHUD
 */
+ (void)hideLoadingFromView:(UIView *)view;


#pragma mark - 展示一个带GIF图片的弹框
/**
 *  在指定view上显示提示
 *
 *  @param view 指定view
 */
+ (MBProgressHUD *)showGIFByImageViewToView:(UIView *)view;


/**
 *  手动添加的方法
 */
+ (void)showHUDAnimationZoomWithTip:(NSString *)text ToView:(UIView *)view;

+ (void)showHudTip:(NSString *)tipString;
+ (void)showHudTip:(NSString *)tipString delay:(NSInteger)time;
+ (void)showGifHud:(UIImage *)gifImage text:(NSString *)text;


@end
