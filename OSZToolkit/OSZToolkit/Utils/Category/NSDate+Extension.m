//
//  NSDate+Extension.m
//  FitForceCoach
//
//  Created by xuyang on 2017/12/4.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

#pragma mark - 判断日期是否是今天
- (BOOL)isToday {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    
    //1.获得当前时间的 年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    //2.获得self
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return (selfCmps.year == nowCmps.year) && (selfCmps.month == nowCmps.month) && (selfCmps.day == nowCmps.day);
}

#pragma mark - 判断日期是否是后天
- (BOOL)isTomorrow {
    //当天日期的第二天日期
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:unit fromDate:[NSDate date]];
    [components setDay:([components day]+1)];
    NSDate *tomorrow = [gregorian dateFromComponents:components];
    
    //2.获得self
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return (selfCmps.year == [tomorrow year]) && (selfCmps.month == [tomorrow month]) && (selfCmps.day == [tomorrow day]);
}

#pragma mark - 获取一小时后的时间
- (NSDate *)afterOneHour {
    //当天日期的第二天日期
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:unit fromDate:self];
    [components setHour:[components hour]+1];
    return [gregorian dateFromComponents:components];
}

#pragma mark - 判断日期是否是明天
- (BOOL)isDayAfterTomorrow {
    //当天日期的第二天日期
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:unit fromDate:[NSDate date]];
    [components setDay:([components day]+2)];
    NSDate *tomorrow = [gregorian dateFromComponents:components];
    
    //2.获得self
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return (selfCmps.year == [tomorrow year]) && (selfCmps.month == [tomorrow month]) && (selfCmps.day == [tomorrow day]);
}

#pragma mark - 判断日期是否是今年
- (BOOL)isYear {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    
    //1.获得当前时间的 年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    //2.获得self
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return (selfCmps.year == nowCmps.year);
}

#pragma mark - 获取时间的Components
- (NSDateComponents *)dateComponents {
    //时间以公历为准
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSDateComponents *comp = [calendar components:unit fromDate:self];
    return comp;
}

- (NSInteger)year {
    return [[self dateComponents] year];
}

- (NSInteger)month {
    return [[self dateComponents] month];
}

- (NSInteger)day {
    return [[self dateComponents] day];
}

- (NSInteger)hour {
    return [[self dateComponents] hour];
}

- (NSInteger)minute {
    return [[self dateComponents] minute];
}

- (NSInteger)second {
    return [[self dateComponents] second];
}

- (NSInteger)weekday {
    return [[self dateComponents] weekday];
}

- (NSString *)toString {
    //根据当前时间和系统所在时区得到和标准时间的Interval，然后得到效验后的时间localeDate，最后[localeDate timeIntervalSince1970]获取效验后的时间和1970年时间的差值，也就是时间戳
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:self];
    
    NSDate *localeDate = [self  dateByAddingTimeInterval: interval];
    return [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970] * 1000];
}

/** 根据格式转为字符串 */
- (NSString *)toDateStringWithFormatter:(NSString *)formatter {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:formatter];
    return [fmt stringFromDate:self];
}

@end
