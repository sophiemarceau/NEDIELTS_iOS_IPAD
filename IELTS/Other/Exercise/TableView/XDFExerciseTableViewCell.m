//
//  XDFExerciseTableViewCell.m
//  IELTS
//
//  Created by 李牛顿 on 14-12-2.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFExerciseTableViewCell.h"

@implementation XDFExerciseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.img1.hidden = YES;
    self.img2.hidden = YES;
    self.label1.hidden = YES;
    self.label2.hidden = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    if (_dataDic != dataDic) {
        _dataDic = dataDic;
      NSString *accuracy = [_dataDic objectForKey:@"accuracy"];  //正确率
      NSString *allDayLx = [_dataDic objectForKey:@"allDayLx"]; //总数
      NSString *dateWeek = [_dataDic objectForKey:@"dateWeek"];  //星期
      NSString *finishDayLx = [_dataDic objectForKey:@"finishDayLx"]; //完成数
      NSString *openDay = [_dataDic objectForKey:@"openDay"];  //日期
       
      NSDate *dateMonth = [ZCControl dateFromString:openDay formate:@"yyyy-MM-dd"];
      NSString *yearMonth = [ZCControl stringFromDate:dateMonth formate:@"dd, yyyy"];
    
      NSString *months = [ZCControl stringFromDate:dateMonth formate:@"MMM"];
      NSInteger index = [self identifyMonth:months];
      NSString *mont = @"";
     if (index == 13) {
         mont = months;
     }else
     {
         mont = [self get2MonthString:index];
     }
       NSString *monthString = [NSString stringWithFormat:@"%@ %@",mont,yearMonth];
        self.monthLabel.text = monthString;
    
//      NSDate *date =  [ZCControl dateFromString:dateWeek formate:@"EEEE"];
//      NSString *week = [ZCControl stringFromDate:date formate:@"EEEE"];
        NSInteger weekInt =  [self identifyWeek:dateWeek];
        if (weekInt == 8) {
            self.weekLabel.text = dateWeek;
        }else
        {
           self.weekLabel.text = [self get2DayString:weekInt];
        }
        

      
      self.scheduleLabel.text = [ NSString stringWithFormat:@"%@/%@",finishDayLx,allDayLx];
      self.accuracyLabel.text = [NSString stringWithFormat:@"%@",accuracy];
        
      self.img1.hidden = NO;
      self.img2.hidden = NO;
      self.label1.hidden = NO;
      self.label2.hidden = NO;
    }
}

- (NSInteger)identifyWeek:(NSString *)moth
{
    NSArray *months = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    if ([months containsObject:moth]) {
        NSInteger index = [months indexOfObject:moth];
        return index;
    }
    return 8;
}



- (NSString*)get2DayString:(NSInteger)index
{
    NSArray *daysInWeeks = [[NSArray alloc]initWithObjects:@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday", nil];
    if (index < daysInWeeks.count) {
        return [daysInWeeks objectAtIndex:index];
    }
    return nil;
}

- (NSString*)get2MonthString:(NSInteger)index
{
    NSArray *months = [[NSArray alloc]initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec", nil];
    if (index < months.count) {
        return [months objectAtIndex:index];
    }
    return nil;
}

- (NSInteger)identifyMonth:(NSString *)moth
{
    NSArray *months2 = @[@"一月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"十二月"];
    NSArray *months = @[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月"];
    if ([months containsObject:moth]) {
        NSInteger index = [months indexOfObject:moth];
        return index;
    }
    if ([months2 containsObject:moth]) {
        NSInteger index = [months2 indexOfObject:moth];
        return index;
    }
    return 13;
}






@end
