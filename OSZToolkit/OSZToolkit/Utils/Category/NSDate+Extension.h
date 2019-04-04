//
//  NSDate+Extension.h
//  FitForceCoach
//
//  Created by xuyang on 2017/12/4.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

/** 判断日期是否为今天 */
- (BOOL)isToday;
/** 判断日期是否是明天 */
- (BOOL)isTomorrow;
/** 判断日期是否是后天 */
- (BOOL)isDayAfterTomorrow;
/** 获取一小时后的时间 */
- (NSDate *)afterOneHour;
/** 下个月的日期 */
- (NSDate *)dateOfNextMonth;
/** 查询指定日期所在月份总共有多少天 */
- (NSInteger)numberOfDaysInMonth;
/** 当前月份的第一天 */
- (NSDate *)firstDay;

/** 判断日期是否是今年 */
- (BOOL)isYear;

#pragma mark - 获取时间的Components
- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)day;
- (NSInteger)hour;
- (NSInteger)minute;
- (NSInteger)second;
/** 周几：周日是第一天 */
- (NSInteger)weekday;

/** 毫秒时间戳 */
- (NSString *)toString;
/** 根据格式转为字符串 */
- (NSString *)toDateStringWithFormatter:(NSString *)formatter;

#pragma mark - 天
/** 两个日期相差多少天 */
+ (NSInteger)betweenDaysFrom:(NSDate *)fromDate toDate:(NSDate *)toDate;
/** fromDate相差between天的日期 */
+ (NSDate *)afterDateFrom:(NSDate *)fromDate between:(NSInteger)between;
#pragma mark - 月
/** 两个日期相差多少个月 */
+ (NSInteger)betweenMonthFrom:(NSDate *)fromDate toDate:(NSDate *)toDate;
/** fromDate相差between月的日期 */
+ (NSDate *)afterMonthFrom:(NSDate *)fromDate between:(NSInteger)between;

/** 时间戳转NSDate */
+ (NSDate *)dateFromTimestamp:(NSInteger)timestamp;


/** 判断两个日期是否相等 */
+ (BOOL)isSameDateWithDate:(NSDate *)aDate andDate:(NSDate *)bDate;
/** 判断两个日期的月份是否相等 */
+ (BOOL)isSameMonthDateWithDate:(NSDate *)aDate andDate:(NSDate *)bDate;

/** 获取中文月份 */
+ (NSString *)getChineseMonth:(NSDate *)date;
/** 获取英文月份 */
+ (NSString *)getEnglishMonth:(NSDate *)date;

/** 一天中的最后一个时间点 */
+ (NSInteger)theLastTimeOfDay:(NSDate *)date;

@end
