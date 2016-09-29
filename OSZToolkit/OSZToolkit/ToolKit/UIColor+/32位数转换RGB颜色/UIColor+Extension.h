//
//  UIColor+Extension.h
//  Bugly测试
//
//  Created by oldSix_Zhu on 16/9/28.
//  Copyright © 2016年 oldSix_Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

//根据无符号的32位整数转换成对应的rgb颜色

+(instancetype)osz_colorWithHex:(u_int32_t)hex;

@end
