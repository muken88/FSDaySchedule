//
//  NSString+MKObjcSugar.h
//  FSDaySchedule
//
//  Created by liaoyu on 2025/11/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (MKObjcSugar)

- (BOOL)mk_lessThan:(NSString *)dateStr;

- (BOOL)mk_greaterThan:(NSString *)dateStr;

@end

NS_ASSUME_NONNULL_END
