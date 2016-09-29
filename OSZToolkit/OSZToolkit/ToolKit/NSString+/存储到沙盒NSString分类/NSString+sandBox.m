//
//  NSString+sandBox.m
//  沙盒存储Nsstring分类练习
//
//  Created by oldSix_Zhu on 16/8/1.
//  Copyright © 2016年 oldSix_Zhu. All rights reserved.
//

#import "NSString+sandBox.h"

@implementation NSString (sandBox)


-(instancetype)appendCache
{
    return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject ] stringByAppendingPathComponent:[self lastPathComponent]];
}


-(instancetype)appendDocument
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[self lastPathComponent]];
}

-(instancetype)appendTemp
{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:[self lastPathComponent]];

}

@end
