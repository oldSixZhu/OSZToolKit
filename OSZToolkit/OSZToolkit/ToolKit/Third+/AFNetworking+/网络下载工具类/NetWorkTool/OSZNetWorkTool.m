//
//  OSZNetWorkTool.m
//  网易新闻 1.0
//
//  Created by oldSix_Zhu on 16/8/14.
//  Copyright © 2016年 oldSix_Zhu. All rights reserved.
//

#import "OSZNetWorkTool.h"

@implementation OSZNetWorkTool

+(instancetype)sharedOSZNetWorkTool
{
    static OSZNetWorkTool *_instanceType;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [NSURL URLWithString:@"http://c.m.163.com/nc/"];
        _instanceType = [[OSZNetWorkTool alloc]initWithBaseURL:url];
    });
    return _instanceType;
}

@end
