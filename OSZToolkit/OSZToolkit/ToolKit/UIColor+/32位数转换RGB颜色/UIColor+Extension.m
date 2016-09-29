//
//  UIColor+Extension.m
//  Bugly测试
//
//  Created by oldSix_Zhu on 16/9/28.
//  Copyright © 2016年 oldSix_Zhu. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

+(instancetype)osz_colorWithHex:(u_int32_t)hex
{
    int red = (hex & 0xFF0000) >> 16;
    int green = (hex & 0X00FF00) >> 8;
    int blue = hex & 0X0000FF; 
    
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
}

@end
