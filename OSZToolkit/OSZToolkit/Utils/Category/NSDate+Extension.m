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

#pragma mark - 下个月的日期
- (NSDate *)dateOfNextMonth {
    //当天日期的下个月的日期
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:unit fromDate:self];
    [components setMonth:[components month] + 1];
    return [gregorian dateFromComponents:components];
}

#pragma mark - 查询指定日期所在月份总共有多少天
- (NSInteger)numberOfDaysInMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    NSUInteger numberOfDaysInMonth = range.length;
    return numberOfDaysInMonth;
}

#pragma mark - 当前月份的第一天
- (NSDate *)firstDay {
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:unit fromDate:self];
    [components setDay:1];
    return [gregorian dateFromComponents:components];
}

#pragma mark - 判断日期是否是后天
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
    NSTimeInterval interval = [self timeIntervalSince1970];
    
    long totalMilliseconds = interval * 1000;
    
    return [NSString stringWithFormat:@"%li", (long)totalMilliseconds];
}

/** 根据格式转为字符串 */
- (NSString *)toDateStringWithFormatter:(NSString *)formatter {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:formatter];
    return [fmt stringFromDate:self];
}

#pragma mark 两个日期相差多少天
+ (NSInteger)betweenDaysFrom:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitDay;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:fromDate toDate:toDate options:0];
    return [comps day];
}

#pragma mark fromDate相差between天的日期
+ (NSDate *)afterDateFrom:(NSDate *)fromDate between:(NSInteger)between {
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:unit fromDate:fromDate];
    [components setDay:[components day] + between];
    return [gregorian dateFromComponents:components];
}

#pragma mark 两个日期相差多少个月
+ (NSInteger)betweenMonthFrom:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitMonth;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:fromDate toDate:toDate options:0];
    return [comps month];
}

#pragma mark fromDate相差between月的日期
+ (NSDate *)afterMonthFrom:(NSDate *)fromDate between:(NSInteger)between {
    NSCalendarUnit unit = NSCalendarUnitMonth | NSCalendarUnitYear;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:unit fromDate:fromDate];
    [components setMonth:[components month] + between];
    return [gregorian dateFromComponents:components];
}

#pragma mark 时间戳转NSDate
+ (NSDate *)dateFromTimestamp:(NSInteger)timestamp {
    if (timestamp == 0) {
        return nil;
    }
    
    return [[NSString stringWithFormat:@"%li", (long)timestamp] millisecondToDate];
}

#pragma mark 判断两个日期是否相等
+ (BOOL)isSameDateWithDate:(NSDate *)aDate andDate:(NSDate *)bDate {
    return ([aDate year] == [bDate year] && [aDate month] == [bDate month] && [aDate day] == [bDate day]);
}

#pragma mark 判断两个日期的月份是否相等
+ (BOOL)isSameMonthDateWithDate:(NSDate *)aDate andDate:(NSDate *)bDate {
    return ([aDate year] == [bDate year] && [aDate month] == [bDate month]);
}

#pragma mark 获取中文月份
+ (NSString *)getChineseMonth:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    [dateFormatter setDateFormat:@"MMM"];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    NSString *zhMonth = [dateFormatter stringFromDate:date];
    return zhMonth;
}

#pragma mark - 获取英文月份
+ (NSString *)getEnglishMonth:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setDateFormat:@"MMMM"];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSString * enMonth = [dateFormatter stringFromDate:date];
    return enMonth;
}

#pragma mark - 一天中的最后一个时间点
+ (NSInteger)theLastTimeOfDay:(NSDate *)date {
    
    //当天日期的第二天日期
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:unit fromDate:date];
    [components setDay:[components day] + 1];
    NSDate *nextDate = [gregorian dateFromComponents:components];
    
    //第二天的前一秒
    components = [gregorian components:unit fromDate:nextDate];
    [components setSecond:[components second] - 1];
    NSDate *rightDate = [gregorian dateFromComponents:components];
    
    return [[rightDate toString] integerValue];
}

@end
