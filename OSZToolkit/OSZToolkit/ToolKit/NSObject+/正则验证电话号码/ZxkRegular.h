//
//  ZxkRegular.h
//  PassKepper
//
//  Created by Ucard on 14/6/28.
//  Copyright (c) 2014年 晓坤张. All rights reserved.
//

#import <Foundation/Foundation.h>
//正则验证
@interface ZxkRegular : NSObject

+ (BOOL)regularEmail:(NSString *)string;

+ (BOOL)regularPhone:(NSString *)string;

+ (BOOL)regularFloatNumber:(NSString *)string;

@end
