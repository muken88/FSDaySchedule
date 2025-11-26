//
//  NSDate+MKObjcSugar.m
//  FSDaySchedule
//
//  Created by liaoyu on 2025/11/26.
//

#import "NSDate+MKObjcSugar.h"
#import "NSString+MKObjcSugar.h"

@implementation NSDate (MKObjcSugar)


+ (NSCalendar *)mk_sharedCalendar {
    static NSCalendar *calendar;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [NSCalendar currentCalendar];
    });
    return calendar;
}

+ (NSString *)mk_date:(NSDate *)date format:(NSString *)format {
    NSDateFormatter *formatter = [NSDate mk_dateFormatterWithFormat:format];
    return [formatter stringFromDate:date];
}

+ (CGFloat)mk_formatDaySchedule:(NSString *)time ymd:(NSString *)ymd isStart:(BOOL)isStart {
    NSString *t = [time componentsSeparatedByString:@" "][0];
    if (isStart) {
        BOOL lessThan = [t mk_lessThan:ymd];
        if (lessThan) {
            return 0;
        } else {
            return [self mk_formatDaySchedule:time];
        }
    } else {
        BOOL greaterThan = [t mk_greaterThan:ymd];
        if (greaterThan) {
            return 24;
        } else {
            return [self mk_formatDaySchedule:time];
        }
    }
}

+ (CGFloat)mk_formatDaySchedule:(NSString *)time {
    NSDate *date = [NSDate mk_transformDateWithStr:time];
    NSUInteger units = NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *cps = [[NSDate mk_sharedCalendar] components:units fromDate:date];
    NSInteger hour = cps.hour;
    NSInteger minute = cps.minute;
    CGFloat t = hour + minute / 60.0;
    return t;
}

+ (NSDate *)mk_transformDateWithStr:(NSString *)time {
    return [NSDate mk_transformDateWithStr:time format:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSDate *)mk_transformDateWithStr:(NSString *)time format:(NSString *)format {
    NSDateFormatter *formatter = [NSDate mk_dateFormatterWithFormat:format];
    return [formatter dateFromString:time];
}

+ (NSDateFormatter *)mk_dateFormatterWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:format];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_cn"];
    return formatter;
}

@end
