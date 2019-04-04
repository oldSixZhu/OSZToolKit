//
//  NSDate+ServerTime.h
//  TYFitFore
//
//  Created by apple on 2018/12/20.
//  Copyright © 2018 tangpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (ServerTime)

+ (instancetype)serverDate;

//获取服务器时间戳信息
+ (NSInteger)serverTimestamp;

/** 判断日期是否过期 */
+ (BOOL)isExpiredDate:(NSDate *)lastDate;

@end

NS_ASSUME_NONNULL_END
