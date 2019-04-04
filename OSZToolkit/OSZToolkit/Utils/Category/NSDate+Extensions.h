//
//  NSDate+Extension.h
//  YZCCalender
//
//  Created by Jason on 2018/1/17.
//  Copyright © 2018年 jason. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (Extensions)

/// 获取年
+ (NSInteger)year:(NSString *)dateStr;
/// 获取月
+ (NSInteger)month:(NSString *)dateStr;
/// 获取星期
+ (NSInteger)week:(NSString *)dateStr;
/// 获取星期 中文 日
+ (NSString *)getWeekFrom:(NSString *)dateStr;
/// 获取星期 中文 周日
+ (NSString *)getChineseWeekFrom:(NSString *)dateStr;
/// 获取日
+ (NSInteger)day:(NSString *)dateStr;
/// 获取月共有多少天
+ (NSInteger)daysInMonth:(NSString *)dateStr;

/// 获取当前日期 2018-01-01
+ (NSString *)currentDay;
/// 获取当前小时 00:00
+ (NSString *)currentHour;
/// 当前月份的第一天
+ (NSString *)currentMonthFirstDay;
/// 下个月的第一天
+ (NSString *)nextMonthFirstDay;
/// 获取下月最后一天
+ (NSString *)nextMonthLastDay;
/// 获取两个月后第一天
+ (NSString *)nextNextMonthFirstDay;

/// 判断是否是今天
+ (BOOL)isToday:(NSString *)dateStr;
/// 判断是否是明天
+ (BOOL)isTomorrow:(NSString *)dateStr;
/// 判断是否是后天
+ (BOOL)isAfterTomorrow:(NSString *)dateStr;
/// 判断是否是过去的时间
+ (BOOL)isHistoryTime:(NSString *)dateStr;

/// 从时间戳获取具体时间 格式:6:00
+ (NSString *)hourStringWithInterval:(NSTimeInterval)timeInterval;
/// 从时间戳获取具体小时 格式:6
+ (NSString *)hourTagWithInterval:(NSTimeInterval)timeInterval;
/// 从毫秒级时间戳获取具体小时 格式:600
+ (NSString *)hourNumberWithInterval:(NSTimeInterval)timeInterval;
/// 从时间戳获取具体日期 格式:2018-03-05
+ (NSString *)timeStringWithInterval:(NSTimeInterval)timeInterval;
/// 从具体日期获取时间戳 毫秒
+ (NSTimeInterval)timeIntervalFromDateString:(NSString *)dateStr;

/// 获取当前天的后几天的星期
+ (NSString *)getWeekAfterDay:(NSInteger)day;
/// 获取当前天的后几天的日
+ (NSString *)getDayAfterDay:(NSInteger)day;
/// 获取当前月的后几月
+ (NSString *)getMonthAfterMonth:(NSInteger)Month;

@end





/*
 G: 公元时代，例如AD公元
 yy: 年的后2位
 yyyy: 完整年
 MM: 月，显示为1-12
 MMM: 月，显示为英文月份简写,如 Jan
 MMMM: 月，显示为英文月份全称，如 Janualy
 dd: 日，2位数表示，如02
 d: 日，1-2位显示，如 2
 EEE: 简写星期几，如Sun
 EEEE: 全写星期几，如Sunday
 aa: 上下午，AM/PM
 H: 时，24小时制，0-23
 K：时，12小时制，0-11
 m: 分，1-2位
 mm: 分，2位
 s: 秒，1-2位
 ss: 秒，2位
 S: 毫秒
 Z：GMT  
 */










