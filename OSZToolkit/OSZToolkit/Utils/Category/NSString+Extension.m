//
//  NSString+Extension.m
//  FitForceCoach
//
//  Created by apple on 2017/12/27.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

#pragma mark - 毫秒字符串转NSDate
- (NSDate *)millisecondToDate {
    if (self.length != 13) {
        return nil;
    }
    long long longTime = [self longLongValue];
    return [[NSDate alloc] initWithTimeIntervalSince1970:longTime/1000.0];
}

@end
