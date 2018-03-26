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
+ (NSInteger)year:(NSString *)date;
/// 获取月
+ (NSInteger)month:(NSString *)date;
/// 获取星期
+ (NSInteger)week:(NSString *)date;
/// 获取日
+ (NSInteger)day:(NSString *)date;
/// 获取当月第一天星期
+ (NSInteger)firstWeekdayInThisMonth:(NSDate *)date;
/// 获取当前月有多少天
+ (NSInteger)totaldaysInMonth:(NSDate *)date;
/// 计算两个日期之间相差天数
+ (NSDateComponents *)calcDaysbetweenDate:(NSString *)startDateStr endDateStr:(NSString *)endDateStr;
/// 从时间戳获取具体时间 格式:6:00
+ (NSString *)hourStringWithInterval:(NSTimeInterval)timeInterval;
/// 从时间戳获取具体日期 格式:2018-03-05
+ (NSString *)timeStringWithInterval:(NSTimeInterval)timeInterval;
/// 从具体日期获取时间戳 毫秒
+ (NSTimeInterval)timeIntervalFromDateString:(NSString *)dateString;

///判断是否是今天
+ (BOOL)isToday:(NSString *)date;
///判断是否是明天
+ (BOOL)isTomorrow:(NSString *)date;
///判断是否是后天
+ (BOOL)isAfterTomorrow:(NSString *)date;

///判断是否是这个月 格式：2018-01
+ (BOOL)isCurrenMonth:(NSString *)date;

///获取当前日期 2018-01-01
+ (NSString *)currentDay;
///获取当前小时 00:00
+ (NSString *)currentHour;
///获取下月最后一天
+ (NSString *)nextMonthLastDay;
/// 判断是否是可使用的时间
+ (BOOL)isActivity:(NSString *)dateStr withStartDay:(NSString *)startDateStr andEndDay:(NSString *)endDateStr;

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










