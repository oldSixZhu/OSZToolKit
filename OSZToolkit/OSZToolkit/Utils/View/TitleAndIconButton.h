//
//  TitleAndIconButton.h
//  TYFitFore
//
//  Created by apple on 2018/5/26.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TitleIconDirectionType) {
    iconLeftType = 0,                               //icon左，title右
    iconRightType,                                  //title左，icon右
    iconTopType,                                    //icon上，title下
    iconBottomType                                  //title上，icon下
};

@interface TitleAndIconButton : UIButton

@property (nonatomic, assign) CGSize expandSize;

/** 根据类型初始化视图，并初始化视图SIZE */
- (instancetype)initWithType:(TitleIconDirectionType)type
                       title:(NSString *)title
                   titleFont:(UIFont *)titleFont
                  titleColor:(UIColor *)titleColor
                    iconName:(NSString *)iconName
                    iconSize:(CGSize)iconSize
                       space:(CGFloat)space;

/** 根据类型初始化视图，并初始化视图SIZE 设置文字最大宽度 */
- (instancetype)initWithType:(TitleIconDirectionType)type
                       title:(NSString *)title
                   titleFont:(UIFont *)titleFont
                  titleColor:(UIColor *)titleColor
                    iconName:(NSString *)iconName
                    iconSize:(CGSize)iconSize
                       space:(CGFloat)space
                textMaxWidth:(CGFloat)textMaxWidth;

@end
