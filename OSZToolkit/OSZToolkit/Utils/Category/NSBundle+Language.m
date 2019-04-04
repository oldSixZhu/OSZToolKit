//
//  NSBundle+Language.m
//  TYFitFore
//
//  Created by apple on 2018/7/6.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import "NSBundle+Language.h"

#import <objc/runtime.h>

static const char _bundle = 0;

@interface BundleEx : NSBundle

@end

@implementation BundleEx

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName {
    //是否设置指定语言
    NSBundle *bundle = objc_getAssociatedObject(self, &_bundle);
    //是：从指定语言的bundle文件中查找对应key的字符创
    //否：从系统语言文件中查找对应key的字符串
    return bundle ? [bundle localizedStringForKey:key value:value table:tableName] : [super localizedStringForKey:key value:value table:tableName];
}

@end

@implementation NSBundle (Language)

+ (void)setLanguage:(NSString *)language {
    static dispatch_once_t onceToken;
    //动态交换：将NSBundle的isa指针指向子类BundleEx
    //好处：当调用 localizedStringForKey:value:table: 方法查找字符串时，会调用子类BundleEx的这个方法
    dispatch_once(&onceToken, ^{
        object_setClass([NSBundle mainBundle], [BundleEx class]);
    });
    //将指定语言的bundle设置为mainBundle的属性
    objc_setAssociatedObject([NSBundle mainBundle], &_bundle, language ? [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:language ofType:@"lproj"]] : nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
