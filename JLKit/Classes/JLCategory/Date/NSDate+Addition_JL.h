//
//  NSDate+Addition_JL.h
//  JLKit-OC
//
//  Created by wangjian on 2019/10/28.
//  Copyright © 2019 wangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define NSDateHelperFormatFullDateWithTime    @"MMM d, yyyy h:mm a"
#define NSDateHelperFormatFullDate            @"MMM d, yyyy"
#define NSDateHelperFormatShortDateWithTime   @"MMM d h:mm a"
#define NSDateHelperFormatShortDate           @"MMM d"
#define NSDateHelperFormatWeekday             @"EEEE"
#define NSDateHelperFormatWeekdayWithTime     @"EEEE h:mm a"
#define NSDateHelperFormatTime                @"h:mm a"
#define NSDateHelperFormatTimeWithPrefix      @"'at' h:mm a"
#define NSDateHelperFormatSQLDate             @"yyyy-MM-dd"
#define NSDateHelperFormatSQLTime             @"HH:mm:ss"
#define NSDateHelperFormatSQLDateWithTime     @"yyyy-MM-dd HH:mm:ss"
#define NSDateHelperFormatYear                @"yyyy"
#define NSDateHelperFormatMonth               @"MM"
#define NSDateHelperFormatDay                 @"dd"
#define NSDateHelperFormatHour24System        @"HH"
#define NSDateHelperFormatHour12System        @"hh"

#define D_MINUTE    60
#define D_HOUR      3600
#define D_DAY       86400
#define D_WEEK      604800
#define D_YEAR      31556926

static const unsigned jl_componentFlags = (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal);

@interface NSDate (Addition_JL)

+ (NSCalendar *) jl_currentCalendar;
+ (NSDate *) jl_convertDateToLocalTime: (NSDate *)forDate;

#pragma mark - 相对日期
+ (NSDate *) jl_dateNow;
+ (NSDate *) jl_dateTomorrow;
+ (NSDate *) jl_dateYesterday;
+ (NSDate *) jl_dateWithDaysFromNow: (NSInteger) days;
+ (NSDate *) jl_dateWithDaysBeforeNow: (NSInteger) days;
+ (NSDate *) jl_dateWithHoursFromNow: (NSInteger) dHours;
+ (NSDate *) jl_dateWithHoursBeforeNow: (NSInteger) dHours;
+ (NSDate *) jl_dateWithMinutesFromNow: (NSInteger) dMinutes;
+ (NSDate *) jl_dateWithMinutesBeforeNow: (NSInteger) dMinutes;

#pragma 字符串转日期
+ (NSDate *) jl_dateWithString: (NSString *) string format: (NSString *) format;

#pragma mark - 日期转字符串
- (NSString *) jl_stringWithDateStyle: (NSDateFormatterStyle) dateStyle timeStyle: (NSDateFormatterStyle) timeStyle;
- (NSString *) jl_stringWithFormat: (NSString *) format;
@property (nonatomic, readonly) NSString *jl_shortString;
@property (nonatomic, readonly) NSString *jl_shortDateString;
@property (nonatomic, readonly) NSString *jl_shortTimeString;
@property (nonatomic, readonly) NSString *jl_mediumString;
@property (nonatomic, readonly) NSString *jl_mediumDateString;
@property (nonatomic, readonly) NSString *jl_mediumTimeString;
@property (nonatomic, readonly) NSString *jl_longString;
@property (nonatomic, readonly) NSString *jl_longDateString;
@property (nonatomic, readonly) NSString *jl_longTimeString;

#pragma mark - 日期比较
- (BOOL) jl_isEqualToDateIgnoringTime: (NSDate *) aDate;

- (BOOL) jl_isToday;
- (BOOL) jl_isTomorrow;
- (BOOL) jl_isYesterday;

- (BOOL) jl_isSameWeekAsDate: (NSDate *) aDate;
- (BOOL) jl_isThisWeek;
- (BOOL) jl_isNextWeek;
- (BOOL) jl_isLastWeek;

- (BOOL) jl_isSameMonthAsDate: (NSDate *) aDate;
- (BOOL) jl_isThisMonth;
- (BOOL) jl_isNextMonth;
- (BOOL) jl_isLastMonth;

- (BOOL) jl_isSameYearAsDate: (NSDate *) aDate;
- (BOOL) jl_isThisYear;
- (BOOL) jl_isNextYear;
- (BOOL) jl_isLastYear;

- (BOOL) jl_isEarlierThanDate: (NSDate *) aDate;
- (BOOL) jl_isLaterThanDate: (NSDate *) aDate;

- (BOOL) jl_isInFuture;
- (BOOL) jl_isInPast;

#pragma mark - 日期规则
- (BOOL) jl_isTypicallyWorkday;
- (BOOL) jl_isTypicallyWeekend;

#pragma mark - 调整日期
- (NSDate *) jl_dateByAddingYears: (NSInteger) dYears;
- (NSDate *) jl_dateBySubtractingYears: (NSInteger) dYears;
- (NSDate *) jl_dateByAddingMonths: (NSInteger) dMonths;
- (NSDate *) jl_dateBySubtractingMonths: (NSInteger) dMonths;
- (NSDate *) jl_dateByAddingDays: (NSInteger) dDays;
- (NSDate *) jl_dateBySubtractingDays: (NSInteger) dDays;
- (NSDate *) jl_dateByAddingHours: (NSInteger) dHours;
- (NSDate *) jl_dateBySubtractingHours: (NSInteger) dHours;
- (NSDate *) jl_dateByAddingMinutes: (NSInteger) dMinutes;
- (NSDate *) jl_dateBySubtractingMinutes: (NSInteger) dMinutes;

#pragma mark - 极端日期
- (NSDate *) jl_dateAtStartOfDay;
- (NSDate *) jl_dateAtEndOfDay;

#pragma mark - 日期间隔
- (NSInteger) jl_minutesAfterDate: (NSDate *) aDate;
- (NSInteger) jl_minutesBeforeDate: (NSDate *) aDate;
- (NSInteger) jl_hoursAfterDate: (NSDate *) aDate;
- (NSInteger) jl_hoursBeforeDate: (NSDate *) aDate;
- (NSInteger) jl_daysAfterDate: (NSDate *) aDate;
- (NSInteger) jl_daysBeforeDate: (NSDate *) aDate;
- (NSInteger) jl_distanceInDaysToDate:(NSDate *)anotherDate;
- (NSDateComponents *) jl_distanceInDateComponentsToDate:(NSDate *)anotherDate unitFlags:(NSCalendarUnit)unitFlags;
- (NSDate *) jl_distanceInDateToDate:(NSDate *)anotherDate unitFlags:(NSCalendarUnit)unitFlags;

#pragma mark - 分解日期
@property (readonly) NSInteger jl_nearestHour;
@property (readonly) NSInteger jl_hour;
@property (readonly) NSInteger jl_minute;
@property (readonly) NSInteger jl_seconds;
@property (readonly) NSInteger jl_day;
@property (readonly) NSInteger jl_month;
@property (readonly) NSInteger jl_weekOfMonth;
@property (readonly) NSInteger jl_weekOfYear;
@property (readonly) NSInteger jl_weekday;
@property (readonly) NSInteger jl_nthWeekday; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger jl_year;

@end

NS_ASSUME_NONNULL_END
