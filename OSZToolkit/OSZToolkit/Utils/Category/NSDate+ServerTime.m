//
//  NSDate+ServerTime.m
//  TYFitFore
//
//  Created by apple on 2018/12/20.
//  Copyright © 2018 tangpeng. All rights reserved.
//

#import "NSDate+ServerTime.h"

@implementation NSDate (ServerTime)

+ (instancetype)serverDate {
    NSNumber *serverTimeObject = [[NSUserDefaults standardUserDefaults] objectForKey:kServerTimeKey];
    NSDate *serverDate = nil;
    if ([serverTimeObject isKindOfClass:[NSNumber class]] && [serverTimeObject integerValue] > 0) {
        serverDate = [[NSDate alloc] initWithTimeIntervalSince1970:[serverTimeObject integerValue]/1000.0];
    }
    
    if (!serverDate) {
        serverDate = [NSDate date];
    }
    
    return serverDate;
}

//获取服务器时间戳信息
+ (NSInteger)serverTimestamp {
    NSDate *date = [self serverDate];
    NSString *stringTime = [date toDateStringWithFormatter:@"yyyy-MM-dd"];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    return [[[fmt dateFromString:stringTime] toString] integerValue];
}

//判断日期是否过期
+ (BOOL)isExpiredDate:(NSDate *)lastDate {
    //如果日期为空，则默认已过期
    if (!lastDate) {
        return YES;
    }
    //当前日期
    NSDate *date = [NSDate serverDate];
    //如果当前日期跟上次提醒日期是同一天，则表示未过期
    //提醒日期和当前日期非同一天，则表示已过期
    return ![NSDate isSameDateWithDate:date andDate:lastDate];
}

@end
