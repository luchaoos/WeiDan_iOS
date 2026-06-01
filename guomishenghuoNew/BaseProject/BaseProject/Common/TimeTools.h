//
//  TimeTools.h
//  ChengJiaXiaoChi
//
//  Created by Wangjc on 16/7/18.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeTools : NSObject

+(NSString *)GettitleForDate:(NSString *)dateStr;
//根据日期获取周几
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;
//根据字符串获取nsdate
+(NSDate *)getDateWithStr:(NSString *)str withFormate:(NSString *)format;
//根据Nsdate获取字符串
+(NSString *)getStrWithDate:(NSDate *)date withFormate:(NSString *)format;
//比较两个nsdate的时间 date1 ＝＝ date2 return 0 date1早于date2 return －1 date1晚于date2 return 1;
+(int)compareDate:(NSDate *)date1 andDate2:(NSDate *)date2;
@end
