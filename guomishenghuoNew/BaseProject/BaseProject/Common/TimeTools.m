//
//  TimeTools.m
//  ChengJiaXiaoChi
//
//  Created by Wangjc on 16/7/18.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import "TimeTools.h"

@implementation TimeTools


+(NSString *)GettitleForDate:(NSString *)dateStr
{
    @try {
        NSString * resultStr=@"";
        
        if (dateStr.length>0) {
            
            NSDate * nowDate=[NSDate date];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSDate *date = [dateFormatter dateFromString:dateStr];
            
            NSTimeInterval a_hour = 60*60;
            
            NSDate *other = [date addTimeInterval: a_hour];
            
            
            
            if ([nowDate compare:other]==NSOrderedDescending) {
                
                NSTimeInterval a_day = 24*60*60;
                
                NSDate *othersecond = [[self extractDate:date] addTimeInterval: a_day];
                if ([nowDate compare:othersecond]==NSOrderedDescending) {
                    if ([nowDate compare:[othersecond addTimeInterval:a_day]]==NSOrderedDescending) {
                        if ([nowDate compare:[[othersecond addTimeInterval:a_day] addTimeInterval:a_day] ]==NSOrderedDescending) {
                            [dateFormatter setDateFormat:@"MM月dd日"];
                            NSString *strHour = [dateFormatter stringFromDate:date];
                            return [NSString stringWithFormat:@"%@",strHour];
                        }
                        else
                        {
                            return @"前天发布";
                        }
                    }
                    else
                    {
                        return @"昨天发布";
                    }
                }
                else
                {
                    [dateFormatter setDateFormat:@"HH:mm"];
                    NSString *strHour = [dateFormatter stringFromDate:date];
                    return [NSString stringWithFormat:@"%@",strHour];
                }
            }
            else
            {
                return @"刚刚发布";
            }
        }
        
        return resultStr;
    }
    @catch (NSException *exception) {
        return @"";
    }
    @finally {
        
    }
}


+ (NSDate *)extractDate:(NSDate *)date {
    if (!date) {
        date=[NSDate date];
    }
    //get seconds since 1970
    NSTimeInterval interval = [date timeIntervalSince1970];
    int daySeconds = 24 * 60 * 60;
    //calculate integer type of days
    NSInteger allDays = interval / daySeconds;
    
    return [NSDate dateWithTimeIntervalSince1970:allDays * daySeconds];
}




+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}



+(NSDate *)getDateWithStr:(NSString *)str withFormate:(NSString *)format
{
    NSDateFormatter *dateFormatter = nil;
    if (format == nil) {
        format = @"yyyy-MM-dd";
    }
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format/*@"yyyy-MM-dd"*/];
    
    
    
    return [dateFormatter dateFromString:str];
}


+(NSString *)getStrWithDate:(NSDate *)date  withFormate:(NSString *)format
{
    NSDateFormatter *dateFormatter = nil;
    if (format == nil) {
        format = @"yyyy-MM-dd";
    }
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format/*@"yyyy-MM-dd"*/];
    
    
    
    return [dateFormatter stringFromDate:date];
}



+(int)compareDate:(NSDate *)date1 andDate2:(NSDate *)date2
{
    NSTimeInterval time1 = [date1 timeIntervalSince1970];
    NSTimeInterval time2 = [date2 timeIntervalSince1970];
    
    if (time1 == time2) {
        return 0;
    }
    else if (time1 > time2) {
        return 1;
    }
    else
    {
        return -1;
    }
    
    
    
}


@end
