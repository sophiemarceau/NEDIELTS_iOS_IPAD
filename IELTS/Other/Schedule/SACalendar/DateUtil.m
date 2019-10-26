//
//  DateUtil.m
//  SACalendarExample
//
//  Created by Nop Shusang on 7/11/14.
//  Copyright (c) 2014 SyncoApp. All rights reserved.
//
//  Distributed under MIT License

#import "DateUtil.h"

@implementation DateUtil

+(NSString*)getCurrentDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [formatter setCalendar:gregorianCalendar];
    [formatter setDateFormat:@"dd"];
    return [formatter stringFromDate:[NSDate date]];
}

+(NSString*)getCurrentMonth
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [formatter setCalendar:gregorianCalendar];
    [formatter setDateFormat:@"MM"];
    return [formatter stringFromDate:[NSDate date]];
}

+(NSString*)getCurrentYear
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [formatter setCalendar:gregorianCalendar];
    [formatter setDateFormat:@"yyyy"];
    return [formatter stringFromDate:[NSDate date]];
}

+(NSString*)getCurrentDay
{
    NSDateFormatter* theDateFormatter = [[NSDateFormatter alloc] init];
    [theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [theDateFormatter setDateFormat:@"EEEE"];
    NSString *weekDay =  [theDateFormatter stringFromDate:[NSDate date]];
    return weekDay;
}

+(NSString*)getCurrentDateString
{
    return [NSString stringWithFormat:@"%@/%@/%@",[self getCurrentMonth],[self getCurrentDate],[self getCurrentYear]];
}


+(NSString*)getMonthString:(int)index
{
    NSArray *months = [[NSArray alloc]initWithObjects:@"January",@"Febuary",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December", nil];
    return [months objectAtIndex:index-1];
}

+(NSString*)get2MonthString:(int)index
{
    NSArray *months = [[NSArray alloc]initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec", nil];
    if (index < months.count) {
        return [months objectAtIndex:index];
    }
    return nil;
}


+(NSString*)getDayString:(int)index
{
    NSArray *daysInWeeks = [[NSArray alloc]initWithObjects:@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday", nil];
    return [daysInWeeks objectAtIndex:index];
}

+(NSString*)get2DayString:(int)index
{
    NSArray *daysInWeeks = [[NSArray alloc]initWithObjects:@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday", nil];
    if (index < daysInWeeks.count) {
        return [daysInWeeks objectAtIndex:index];
    }
    return nil;
}




+(int)getDaysInMonth:(int)month year:(int)year
{
    int daysInFeb = 28;
    if (year%4 == 0) {
        daysInFeb = 29;
    }
    int daysInMonth [12] = {31,daysInFeb,31,30,31,30,31,31,30,31,30,31};
    return daysInMonth[month-1];
}

+(NSString*)getDayOfDate:(int)date month:(int)month year:(int)year
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSDate *capturedStartDate = [dateFormatter dateFromString: [NSString stringWithFormat:@"%04i-%02i-%02i",year,month,date]];
    
    NSDateFormatter *weekday = [[NSDateFormatter alloc] init];
    [weekday setDateFormat: @"EEEE"];
    
    /*
     Monday,
     Tuesday,
     Wednesday,
     Thursday,
     Friday,
     Saturday,
     Sunday
     */
    NSString *week = [weekday stringFromDate:capturedStartDate];
    if ([week isEqualToString:@"星期一"]) {
        return @"Monday";
    }else if([week isEqualToString:@"星期二"])
    {
        return @"Tuesday";
    }else if([week isEqualToString:@"星期三"])
    {
        return @"Wednesday";
    }else if([week isEqualToString:@"星期四"])
    {
        return @"Thursday";
    }else if([week isEqualToString:@"星期五"])
    {
        return @"Friday";
    }else if([week isEqualToString:@"星期六"])
    {
        return @"Saturday";
    }else if([week isEqualToString:@"星期日"])
    {
        return @"Sunday";
    }
    return [weekday stringFromDate:capturedStartDate];
}


@end
