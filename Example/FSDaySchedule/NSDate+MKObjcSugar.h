//
//  NSDate+MKObjcSugar.h
//  FSDaySchedule
//
//  Created by liaoyu on 2025/11/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (MKObjcSugar)

+ (NSString *)mk_date:(NSDate *)date format:(NSString *)format;

+ (CGFloat)mk_formatDaySchedule:(NSString *)time ymd:(NSString *)ymd isStart:(BOOL)isStart;

@end

NS_ASSUME_NONNULL_END
