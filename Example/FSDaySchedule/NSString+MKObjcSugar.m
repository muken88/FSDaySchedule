//
//  NSString+MKObjcSugar.m
//  FSDaySchedule
//
//  Created by liaoyu on 2025/11/26.
//

#import "NSString+MKObjcSugar.h"

@implementation NSString (MKObjcSugar)

- (BOOL)mk_lessThan:(NSString *)dateStr {
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1 =[dateFormat1 dateFromString:self];
    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
    [dateFormat2 setDateFormat:@"yyyy-MM-dd"];
    NSDate *date2 =[dateFormat2 dateFromString:dateStr];
    NSComparisonResult result = [date1 compare:date2];
    if (result == NSOrderedAscending) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)mk_greaterThan:(NSString *)dateStr {
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1 = [dateFormat1 dateFromString:self];
    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
    [dateFormat2 setDateFormat:@"yyyy-MM-dd"];
    NSDate *date2 = [dateFormat2 dateFromString:dateStr];
    NSComparisonResult result = [date1 compare:date2];
    if (result == NSOrderedDescending) {
        return YES;
    } else {
        return NO;
    }
}

@end
