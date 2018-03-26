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

@end
