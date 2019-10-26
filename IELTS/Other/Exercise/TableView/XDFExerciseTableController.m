//
//  XDFExerciseTableController.m
//  IELTS
//
//  Created by 李牛顿 on 14-12-4.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFExerciseTableController.h"
#import "XDFEexrciseDateViewController.h"

@interface XDFExerciseTableController ()
@property (nonatomic,strong)XDFEexrciseDateViewController *dateViewController;

@property (nonatomic,strong)NSString *currentDate;  //当前日期


@end

@implementation XDFExerciseTableController
@synthesize dateViewController;
- (void)viewDidLoad {
    [super viewDidLoad];
    //创建内容控制器
     dateViewController = [[XDFEexrciseDateViewController alloc]init];
     dateViewController.openDate = self.openDate;
     [self addContentViewController:dateViewController];
    
    //保存当前天数
    self.currentDate = self.openDate;
    //取出前进后退按钮
    UIButton *nextButton = (UIButton *)[super.view viewWithTag:101];
    UIButton *beforeButton = (UIButton *)[super.view viewWithTag:100];
    //按钮控制处理
    if (self.dateArray > 0) {
        NSString *dateFir = [self.dateArray firstObject];
        NSString *dateLast = [self.dateArray lastObject];
    
        if ([dateLast isEqualToString:dateFir]) {
            nextButton.enabled = NO;
            beforeButton.enabled = NO;
        }else if ([self.openDate isEqualToString:dateFir]){
            beforeButton.enabled = NO;
        }else if ([self.openDate isEqualToString:dateLast]){
            nextButton.enabled = NO;
        }
    }
    //隐藏星星视图
    self.starButton.hidden = YES;

}

//后腿
- (void)leftAction:(UIButton *)button
{
    UIButton *nextButton = (UIButton *)[super.view viewWithTag:101];
    if (self.dateArray > 0) {   //判断是否有数据
        NSString *dateFir = [self.dateArray firstObject];   //第一天
        
        if ([self.currentDate isEqualToString:dateFir]) {  //当前选择日期等于第一天
            button.enabled = NO;           //后退不可点击
            dateViewController.openDate = self.currentDate;
            
        }else
        {
            button.enabled = YES;
            nextButton.enabled = YES;
            
            NSRange rang = {0,self.dateArray.count};   //范围
            NSUInteger index = [self.dateArray indexOfObject:self.currentDate inRange:rang]; //取出当天的位置
            
            NSString *stringType = [self.dateArray objectAtIndex:index-1];  //取当天的前一天

            if (index == 0) {   //第一天
                button.enabled = NO;
                dateViewController.openDate = self.currentDate;
            }else
            {
                if ([stringType isEqualToString:dateFir]) { //等于第一天
                    button.enabled = NO;
                    dateViewController.openDate = stringType;
                    self.currentDate = stringType;
                    
                }else //不等于第一天
                {
                    dateViewController.openDate = stringType;
                    self.currentDate = stringType;
                }
            }
        }
    }
}

//前进
- (void)rightAction:(UIButton *)button
{
    UIButton *beforeButton = (UIButton *)[super.view viewWithTag:100];
    if (self.dateArray > 0) {
        NSString *dateLast = [self.dateArray lastObject];  //取最后条
        
        if ([self.currentDate isEqualToString:dateLast]) {   //当前日期等于最后一条
            button.enabled = NO;
            dateViewController.openDate = self.currentDate;
            
        }else
        {
            button.enabled = YES;
            beforeButton.enabled = YES;
            
            NSRange rang = {0,self.dateArray.count};
            NSUInteger index = [self.dateArray indexOfObject:self.currentDate inRange:rang]; //搜索当前日期所在的位置
            
            NSString *stringType = [self.dateArray objectAtIndex:index+1];   //取出后一条
            
            if (index == (self.dateArray.count-1)) {   //等于最后一条
                button.enabled = NO;
                dateViewController.openDate = self.currentDate;
            }else
            {
                if ([stringType isEqualToString:dateLast]) {    //等于最后一条
                    button.enabled = NO;
                    dateViewController.openDate = stringType;
                    self.currentDate = stringType;
                    
                }else
                {
                    dateViewController.openDate = stringType;
                    self.currentDate = stringType;
                }
                
            }
        }
    }
}

@end
