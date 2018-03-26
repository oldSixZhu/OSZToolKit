//
//  UIButton+Customise.h
//  LaiCai
//
//  Created by SmartMin on 15-8-10.
//  Copyright (c) 2015年 LaiCai. All rights reserved.
//
// 自定义按钮
#import <UIKit/UIKit.h>

@interface UIButton (Customise)

@property (nonatomic, assign) UIEdgeInsets touchAreaInsets;/**< 额外点击区域*/

- (void)buttonWithBlock:(void(^)(UIButton *button))buttonClickBlock;

/** 给button设置背景颜色的图片 */
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

/** 倒计时 */
- (void)startWithTime:(NSInteger)time btnNormalTitle:(NSString *)norTitle selectedTitle:(NSString *)selTitle normalColor:(UIColor *)norColor selectedColor:(UIColor *)selColor completeBlock:(void(^)(void))blcok;

+ (UIImage *)imageWithColor:(UIColor *)color;

@end
