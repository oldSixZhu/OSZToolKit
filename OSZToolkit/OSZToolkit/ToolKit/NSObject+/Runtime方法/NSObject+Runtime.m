//
//  NSObject+Runtime.m
//  表情键盘
//
//  Created by 屠泽玉 on 16/3/4.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "NSObject+Runtime.h"
#import <objc/runtime.h>

@implementation NSObject (Runtime)

/// 遍历当前视图的成员变量 - 仅供测试使用
- (void)hm_ivarsList {
    
    uint32_t count = 0;
    // 获取成员变量列表
    Ivar *ivars = class_copyIvarList(self.class, &count);
    
    for (UInt32 i = 0; i < count; ++i) {
        Ivar ivar = ivars[i];
        
        const char *cName = ivar_getName(ivar);
        NSString *name = [[NSString alloc] initWithUTF8String:cName];
        
        NSLog(@"%@", name);
    }
    
    // 释放成员变量列表
    free(ivars);
}

@end
