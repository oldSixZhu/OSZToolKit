//
//  MBProgressHUD+MJ.m
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+MJ.h"

#import "LoadingAnimationView.h"

static CGFloat showtime = 2.0;

@implementation MBProgressHUD (MJ)


#pragma mark - 弹框在UIwindow上

+ (UIWindow *)removeHUDFromWindow
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //在window上显示就可点击
    window.userInteractionEnabled = YES;
    for (UIView *tipVieww in window.subviews) {
        if ([tipVieww isKindOfClass:[MBProgressHUD class]]) {
            [tipVieww removeFromSuperview];
        }
    }
    return window;
}


/**
 *  隐藏window上创建的MBProgressHUD
 */
+ (void)hideLoadingFromWindow
{
    UIWindow *window = [self removeHUDFromWindow];
    //警告:配对出现不能删除
    window.userInteractionEnabled = YES;
    for (UIView *tipView in window.subviews) {
        //NSLog(@"隐藏window上创建的MBProgressHUD:%@",tipView);
        if ([tipView isKindOfClass:[MBProgressHUD class]]) {
            MBProgressHUD *HUD = (MBProgressHUD *)tipView;
            [HUD hideAnimated:YES];
            [HUD removeFromSuperview];
        }
    }
}


/**
 *  在window上带图片的成功的Toast提示
 *
 *  @param success 成功提示文字
 */
+ (void)showSuccess:(NSString *)success
{
    [self hideLoadingFromWindow];
    [self showSuccess:success toView:nil];
}
+ (void)showSuccess:(NSString *)success model:(BOOL)model
{
    [self hideLoadingFromWindow];
    [self showSuccess:success toView:nil model:model];
}

/**
 *  在window上带图片的错误的Toast提示
 *
 */
+ (void)showError:(NSString *)error
{
    [self hideLoadingFromWindow];
    [self showError:error toView:nil];
}
+ (void)showError:(NSString *)error model:(BOOL)model
{
    [self showError:error toView:nil model:model];
}

/**
 *  在window上带文字几秒后提示消失
 *
 *  @param message 提示文字
 *  @param delay   几秒消失
 */
+ (void)showToastOnWindow:(NSString *)message afterDelay:(NSTimeInterval)delay
{
    UIWindow *window = [self removeHUDFromWindow];
    
    MBProgressHUD *alert = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:alert];
    alert.mode = MBProgressHUDModeText;
    alert.detailsLabel.text = message;
    alert.detailsLabel.font = kFontMake(16);
    alert.bezelView.color = [UIColor whiteColor];
    alert.detailsLabel.textColor = [UIColor blackColor];
    [alert showAnimated:YES];
    [alert hideAnimated:YES afterDelay:delay];
}

+ (void)showToastOnWindow:(NSString *)message afterDelay:(NSTimeInterval)delay model:(BOOL)model
{
    UIWindow *window = [self removeHUDFromWindow];
    
    MBProgressHUD *alert = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:alert];
    alert.mode = MBProgressHUDModeText;
    alert.detailsLabel.text = message;
    alert.detailsLabel.font = kFontMake(16);
    if (model==YES) {
        alert.userInteractionEnabled = YES;
    }else{
        alert.userInteractionEnabled = NO;
    }
    [alert showAnimated:YES];
    [alert hideAnimated:YES afterDelay:delay];
}


/**
 *  在window上带文字提示Toast暂时卡住页面
 *
 *  @param message 提示语
 */
+ (void)showToastOnWindow:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [self removeHUDFromWindow];
        MBProgressHUD *alert = [[MBProgressHUD alloc] initWithView:window];
        [window addSubview:alert];
        alert.mode = MBProgressHUDModeText;
        alert.detailsLabel.text = message;
        alert.detailsLabel.font = kFontMake(16);
        [alert showAnimated:YES];
        [alert hideAnimated:YES afterDelay:showtime];
    });
}

+ (void)showToastOnWindow:(NSString *)message model:(BOOL)model
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [self removeHUDFromWindow];
        MBProgressHUD *alert = [[MBProgressHUD alloc] initWithView:window];
        [window addSubview:alert];
        alert.mode = MBProgressHUDModeText;
        alert.detailsLabel.text = message;
        alert.detailsLabel.font = kFontMake(16);
        if(model==YES) {
            alert.userInteractionEnabled = YES;
        }else{
            alert.userInteractionEnabled = NO;
        }
        [alert showAnimated:YES];
        [alert hideAnimated:YES afterDelay:showtime];
        
    });
}

+ (void)showBlackToastOnWindow:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [self removeHUDFromWindow];
        MBProgressHUD *alert = [[MBProgressHUD alloc] initWithView:window];
        [window addSubview:alert];
        alert.mode = MBProgressHUDModeText;
        alert.detailsLabel.text = message;
        alert.detailsLabel.font = FontCustomSize(16);
        alert.bezelView.color = [UIColor blackColor];
        alert.detailsLabel.textColor = [UIColor whiteColor];
        [alert showAnimated:YES];
        [alert hideAnimated:YES afterDelay:2.0f];
    });
}

/**
 *  在window上带图片的Toast暂时卡住页面
 *
 *  @param tipStr 提示语
 *  @param toastImg 图片
 */

+ (void)showToastWithImgOnWindow:(NSString *)tipStr toastImg:(UIImage *)toastImg
{
    UIWindow *window = [self removeHUDFromWindow];
    if (!toastImg) {
        toastImg = [UIImage imageNamed:@"success"];
    }
    MBProgressHUD *alert = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:alert];
    alert.customView = [[UIImageView alloc] initWithImage:toastImg];
    alert.mode = MBProgressHUDModeCustomView;
    alert.detailsLabel.text = tipStr;
    alert.detailsLabel.font = FontCustomSize(16);
    alert.userInteractionEnabled = NO;
    [alert showAnimated:YES];
    [alert hideAnimated:YES afterDelay:showtime];
}

+ (void)showToastWithImgOnWindow:(NSString *)tipStr toastImg:(UIImage *)toastImg after:(NSTimeInterval)delay model:(BOOL)model
{
    UIWindow *window = [self removeHUDFromWindow];
    if (!toastImg) {
        toastImg = [UIImage imageNamed:@"success"];
    }
    MBProgressHUD *alert = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:alert];
    alert.customView = [[UIImageView alloc] initWithImage:toastImg];
    alert.mode = MBProgressHUDModeCustomView;
    alert.detailsLabel.text = tipStr;
    alert.detailsLabel.font = FontCustomSize(16);
    if (model==YES) {
        alert.userInteractionEnabled = YES;
    }else{
        alert.userInteractionEnabled = NO;
    }
    [alert showAnimated:YES];
    if (delay==0) {
        [alert hideAnimated:YES afterDelay:showtime];
    }else{
        [alert hideAnimated:YES afterDelay:delay];
    }
    
}

// 黑色的背景，图片+文字
+ (void)showBlackToastWithString:(NSString *)tipStr andImage:(UIImage *)toastImg
{
    UIWindow *window = [self removeHUDFromWindow];
    if (!toastImg) {
        toastImg = [UIImage imageNamed:@"icon_toast_success"];
    }
    MBProgressHUD *alert = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:alert];
    alert.customView = [[UIImageView alloc] initWithImage:toastImg];
    alert.mode = MBProgressHUDModeCustomView;
    alert.detailsLabel.text = tipStr;
    alert.detailsLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:kFloat(15)];
    alert.detailsLabel.textColor = [UIColor whiteColor];
    alert.bezelView.color = [UIColor blackColor];
    alert.userInteractionEnabled = NO;
    [alert showAnimated:YES];
    [alert hideAnimated:YES afterDelay:1.0];
}


/**
 *  在window上显示转圈的MBProgressHUD (不会自动消失,需要手动调用隐藏方法)
 *
 *  @param tipStr 提示语
 */
+ (void)showLoadingOnWindowWithText:(NSString *)tipStr
{
    UIWindow *window = [self removeHUDFromWindow];
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:HUD];
//    HUD.mode = MBProgressHUDModeIndeterminate;
//    HUD.label.text = tipStr;
//    HUD.userInteractionEnabled = NO;
//
//    //在window上显示就不让其点击
    window.userInteractionEnabled = NO;

    HUD.mode = MBProgressHUDModeCustomView;
    LoadingAnimationView *loadingView = [[LoadingAnimationView alloc] initWithFrame:CGRectMake(0, 0, 37, 37)];
    HUD.customView = loadingView;
    HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    HUD.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.9f];
    
    [HUD showAnimated:YES];
}

+ (void)showLoadingOnWindowWithText:(NSString *)tipStr model:(BOOL)model
{
    UIWindow *window = [self removeHUDFromWindow];
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:HUD];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.label.text = tipStr;
    if (model==YES) {
        HUD.userInteractionEnabled = YES;
    }else{
        HUD.userInteractionEnabled = NO;
    }
    [HUD showAnimated:YES];
}

+ (void)showBlackLoadingOnWindowWithText:(NSString *)tipStr {
    UIWindow *window = [self removeHUDFromWindow];
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:HUD];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.label.text = tipStr;
    HUD.userInteractionEnabled = NO;
    
    //在window上显示就不让其点击
    window.userInteractionEnabled = NO;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    HUD.activityIndicatorColor = [UIColor whiteColor];
#pragma clang diagnostic pop
    
    HUD.label.textColor = [UIColor whiteColor];
    HUD.bezelView.color = [UIColor blackColor];
    
    [HUD showAnimated:YES];
}

#pragma mark - 弹框在指定view上

/**
 *  获取子view
 */
+ (UIView *)getHUDFromSubview:(UIView *)addView
{
    if (addView) {
        for (UIView *tipVieww in addView.subviews) {
            if ([tipVieww isKindOfClass:[MBProgressHUD class]]) {
                if (tipVieww.superview) {
                    [tipVieww removeFromSuperview];
                }
            }
        }
    } else {
        addView = [UIApplication sharedApplication].keyWindow;
    }
    return addView;
}


/**
 *  在指定view上带图片的成功的Toast提示
 *
 *  @param success 成功提示文字
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view{
    [self showLoadingToView:view text:success icon:@"popup_ok"];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view model:(BOOL)model
{
    [self showLoadingToView:view text:success icon:[UIImage imageNamed:@"popup_ok"] after:0 model:model];
}

/**
 *  在指定view上带图片的失败的Toast提示
 *
 */
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self showLoadingToView:view text:error icon:@"popup_cancel"];
}
+ (void)showError:(NSString *)error toView:(UIView *)view model:(BOOL)model{
    [self showLoadingToView:view text:error icon:[UIImage imageNamed:@"popup_cancel"] after:0 model:model];
}

/**
 *  在自定义view上暂时卡住页面
 */
+ (void)showToastViewOnView:(UIView *)addView text:(NSString *)message
{
    addView = [self getHUDFromSubview:addView];
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:addView];
    [addView addSubview:HUD];
    
    if (message.length>14) {
        HUD.detailsLabel.text = message;
    } else {
        if(message) HUD.label.text = message;
        else HUD.label.text = @"请稍等";
    }
    
    HUD.mode = MBProgressHUDModeText;
    HUD.removeFromSuperViewOnHide = YES;
    // HUD.dimBackground = YES;// YES代表需要蒙版效果
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:showtime];
}

+ (void)showToastViewOnView:(UIView *)addView text:(NSString *)message model:(BOOL)model
{
    addView = [self getHUDFromSubview:addView];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:addView];
    [addView addSubview:HUD];
    
    if (message.length>14) {
        HUD.detailsLabel.text = message;
    } else {
        
        if(message) HUD.label.text = message;
        else HUD.label.text = @"请稍等";
    }
    
    HUD.mode = MBProgressHUDModeText;
    HUD.removeFromSuperViewOnHide = YES;
    // HUD.dimBackground = YES;// YES代表需要蒙版效果
    if (model==YES) {
        HUD.userInteractionEnabled = YES;
    }else{
        HUD.userInteractionEnabled = NO;
    }
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:showtime];
}

/**
 *  在自定义Viwe上带文字暂时卡住页面
 *
 *  @param message 提示文字
 *  @param delay   几秒后消失
 */
+ (void)showToastViewOnView:(UIView *)addView text:(NSString *)message afterDelay:(NSTimeInterval)delay
{
    addView = [self getHUDFromSubview:addView];
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:addView];
    [addView addSubview:HUD];
    HUD.mode = MBProgressHUDModeText;
    if(message) HUD.label.text = message;
    else HUD.label.text = @"";
    HUD.bezelView.color = [UIColor whiteColor];
    HUD.label.textColor = [UIColor blackColor];
    HUD.label.numberOfLines = 0;
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:delay];
}

+ (void)showToastViewOnView:(UIView *)addView text:(NSString *)message afterDelay:(NSTimeInterval)delay model:(BOOL)model
{
    addView = [self getHUDFromSubview:addView];
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:addView];
    [addView addSubview:HUD];
    HUD.mode = MBProgressHUDModeText;
    if(message) HUD.label.text = message;
    else HUD.label.text = @"";
    if (model==YES) {
        HUD.userInteractionEnabled = YES;
    }else{
        HUD.userInteractionEnabled = NO;
    }
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:delay];
}

/**
 *  在自定义Viwe上带文字暂时卡住页面
 *
 *  @param icon   显示的图片
 */
+ (void)showLoadingToView:(UIView *)addView text:(NSString *)text icon:(NSString *)icon
{
    UIImage *img = [UIImage imageNamed:icon];
    addView = [self getHUDFromSubview:addView];
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:addView];
    [addView addSubview:hud];
    [addView bringSubviewToFront:hud];
    
    hud.label.text = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:img];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    hud.label.text = text;
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:showtime];

    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
}

+ (void)showLoadingToView:(UIView *)addView text:(NSString *)text icon:(UIImage *)icon after:(NSTimeInterval)delay model:(BOOL)model
{
    addView = [self getHUDFromSubview:addView];
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:addView];
    [addView addSubview:hud];
    [addView bringSubviewToFront:hud];
    
    hud.label.text = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:icon];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    hud.label.text = text;
    if (model==YES) {
        hud.userInteractionEnabled = YES;
    }else{
        hud.userInteractionEnabled = NO;
    }
    [hud showAnimated:YES];
    if (delay==0) {
        [hud hideAnimated:YES afterDelay:showtime];
    }else{
        [hud hideAnimated:YES afterDelay:delay];
    }
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
}


/**
 *  在指定view上显示转圈的MBProgressHUD (不会自动消失,需要手动调用隐藏方法)
 *
 *  @param tipStr 提示语
 */
+ (void)showLoadingWithView:(UIView *)addView text:(NSString *)tipStr
{
    addView = [self getHUDFromSubview:addView];

    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:addView];
    [addView addSubview:HUD];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.userInteractionEnabled = NO;
    HUD.bezelView.color = [UIColor whiteColor];
    HUD.label.text = tipStr;
    [HUD showAnimated:YES];
}

+ (void)showLoadingWithView:(UIView *)addView text:(NSString *)tipStr model:(BOOL)model
{
    addView = [self getHUDFromSubview:addView];
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:addView];
    [addView addSubview:HUD];
    HUD.mode = MBProgressHUDModeIndeterminate;
    if (model==YES) {
        HUD.userInteractionEnabled = YES;
    }else{
        HUD.userInteractionEnabled = NO;
    }
    HUD.label.text = tipStr;
    [HUD showAnimated:YES];
}


+ (void)showModelLoadingWithView:(UIView *)addView text:(NSString *)tipStr
{
    addView = [self getHUDFromSubview:addView];

    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:addView];
    [addView addSubview:HUD];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.userInteractionEnabled = YES;
    HUD.label.text = tipStr;
    [HUD showAnimated:YES];
}


/**
 *  隐藏指定view上创建的MBProgressHUD
 */
+ (void)hideLoadingFromView:(UIView *)view
{
    for (UIView *tipView in view.subviews) {
        if ([tipView isKindOfClass:[MBProgressHUD class]]) {
            MBProgressHUD *HUD = (MBProgressHUD *)tipView;
            if (tipView.superview) {
                [tipView removeFromSuperview];
            }
            [HUD hideAnimated:YES];
        }
    }
}


#pragma mark - 展示一个带GIF图片的弹框

+ (MBProgressHUD *)showGIFByImageViewToView:(UIView *)view
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.mode = MBProgressHUDModeCustomView;
//    HUD.dimBackground = NO;
    HUD.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    HUD.backgroundView.color = [UIColor clearColor];
    
    __block UIImageView *imageView;
    dispatch_sync(dispatch_get_main_queue(), ^{
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 150)];
        imageView.backgroundColor = [UIColor redColor];
        //imageView.gifPath = [[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"];
        //[imageView startGIF];
    });
    HUD.customView = imageView;
    //HUD.minSize = CGSizeMake(135.f, 135.f);
    return HUD;
}


/**
 *  城市表格列表用到
 */
+ (void)showHUDAnimationZoomWithTip:(NSString *)text ToView:(UIView *)view
{
    UILabel *centerLabel = [[UILabel alloc] init];
    centerLabel.center = view.center;
    centerLabel.bounds = CGRectMake(0, 0, 85, 85);
    centerLabel.text = text;
    centerLabel.textAlignment = NSTextAlignmentCenter;
    centerLabel.font = kFontMake(28);
    centerLabel.textColor = [UIColor whiteColor];
    centerLabel.backgroundColor = [UIColor darkGrayColor];
    centerLabel.layer.masksToBounds = YES;
    centerLabel.layer.cornerRadius = 5.f;
    [view addSubview:centerLabel];
    [self performSelector:@selector(removeCenterLabel:) withObject:centerLabel afterDelay:1.f];
}

+ (void)removeCenterLabel:(UILabel *)tempLabel
{
    [tempLabel removeFromSuperview];
}

//提示页
+ (void)showHudTip:(NSString *)tipString{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = tipString;
    hud.label.textColor = [UIColor whiteColor];
    hud.label.font = font48;

    hud.removeFromSuperViewOnHide = YES;
    hud.bezelView.color = [UIColor blackColor];
    hud.v_height = kFloat(130);
    [hud hideAnimated:YES afterDelay:1.5];
}

+ (void)showHudTip:(NSString *)tipString delay:(NSInteger)time{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = tipString;
    hud.label.textColor = [UIColor whiteColor];
    hud.label.font = font48;
    
    hud.removeFromSuperViewOnHide = YES;
    hud.bezelView.color = [UIColor blackColor];
    hud.v_height = kFloat(130);
    [hud hideAnimated:YES afterDelay:time];
}

+ (void)showGifHud:(UIImage *)gifImage text:(NSString *)text{
    UIWindow *window = [self removeHUDFromWindow];
    if (!gifImage) {
        gifImage = [UIImage imageNamed:@"success"];
    }
    MBProgressHUD *alert = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:alert];
    alert.mode = MBProgressHUDModeCustomView;
    alert.customView = [[UIImageView alloc] initWithImage:gifImage];
    alert.detailsLabel.text = text;
    alert.detailsLabel.font = FontCustomSize(16);
    alert.userInteractionEnabled = NO;
    [alert showAnimated:YES];
}

@end
