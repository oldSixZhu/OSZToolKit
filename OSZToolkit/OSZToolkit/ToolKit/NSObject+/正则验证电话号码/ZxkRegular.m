//
//  ZxkRegular.m
//  PassKepper
//
//  Created by Ucard on 14/6/28.
//  Copyright (c) 2014年 晓坤张. All rights reserved.
//

#import "ZxkRegular.h"

@implementation ZxkRegular

+ (BOOL)regularEmail:(NSString *)string
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if(![emailTest evaluateWithObject:string])
    {
        return NO;
    }
    return YES;
}

+ (BOOL)regularPhone:(NSString *)string
{
    NSString *phoneRegex = @"[0-9\\+\\-]{6,19}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    if(![phoneTest evaluateWithObject:string])
    {
        return NO;
    }
    return YES;

}

+ (BOOL)regularFloatNumber:(NSString *)string
{
    NSString *phoneRegex = @"[+\-]?(?:[0-9]*\.[0-9]+|[0-9]+\.)";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    if(![phoneTest evaluateWithObject:string])
    {
        return NO;
    }
    return YES;
    
}

@end
