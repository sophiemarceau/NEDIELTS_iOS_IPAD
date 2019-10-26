//
//  Dlg_AddExamTimeViewController.m
//  IELTS
//
//  Created by melp on 14/12/2.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "Dlg_AddExamTimeViewController.h"

@interface Dlg_AddExamTimeViewController ()<UITextFieldDelegate>

@end

@implementation Dlg_AddExamTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [ZCControl presentNavController:self Width:480 Height:320];
    
    self.yearTextField.delegate = self;
    self.monthTextField.delegate = self;
    self.dayTextField.delegate = self;
    
    self.yearTextField.returnKeyType = UIReturnKeyNext;
    self.monthTextField.returnKeyType = UIReturnKeyNext;
    self.dayTextField.returnKeyType = UIReturnKeySend;
    
    //新增时间
    switch (self.typeTime) {
        case TypeTimeAboadDate:  //留学
        {
            self.titlLabel.text = @"设定我的留学申请日期";
            self.titlLabel.textColor = TABBAR_BACKGROUND_SELECTED;
            
            if (self.abroadTimes.length > 0) {
                NSDate *date = [ZCControl dateFromString:self.abroadTimes formate:@"yyyy-MM-dd"];
                NSString *year = [ZCControl stringFromDate:date formate:@"yyyy"];
                NSString *month = [ZCControl stringFromDate:date formate:@"MM"];
                NSString *day = [ZCControl stringFromDate:date formate:@"dd"];
                
                self.yearTextField.text = year;
                self.monthTextField.text = month;
                self.dayTextField.text = day;
            }
            
        }
            break;
        case TypeTimeTestDate:  //考试
        {
            self.titlLabel.text = @"设定我的考试日期";
            self.titlLabel.textColor = TABBAR_BACKGROUND_SELECTED;
        }
            break;
        default:
            break;
    }

    
    self.tipLabelExamTime.textColor = TABBAR_BACKGROUND_SELECTED;
    self.tipLabelExamTime.hidden = YES;
    
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.yearTextField isFirstResponder]) {
        [self.yearTextField resignFirstResponder];
        [self.monthTextField becomeFirstResponder];
    }else if ([self.monthTextField isFirstResponder])
    {
        [self.monthTextField resignFirstResponder];
        [self.dayTextField becomeFirstResponder];
    
    }else if ([self.dayTextField isFirstResponder])
    {
        [self.dayTextField resignFirstResponder];
        [self submitData];
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kNumbers] invertedSet];
    NSString *filtered =
    [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [string isEqualToString:filtered];
    
    return basic;
}



- (IBAction)onSubmit:(id)sender {
    [self submitData];
}

- (void)submitData
{
    NSString *year = self.yearTextField.text.length > 0 ? self.yearTextField.text : @"";
    NSString *month = self.monthTextField.text.length > 0 ? self.monthTextField.text : @"";
    NSString *day = self.dayTextField.text > 0 ? self.dayTextField.text : @"";
    
    //判断非空
    if ([year isEqualToString:@""]) {
        self.tipLabelExamTime.hidden = NO;
        self.tipLabelExamTime.text = @"提示:请输入年份";
        return;
    }else
    {
        self.tipLabelExamTime.hidden = YES;
        self.tipLabelExamTime.text = @"";
    }
    
    if ([month isEqualToString:@""]) {
        self.tipLabelExamTime.hidden = NO;
        self.tipLabelExamTime.text = @"提示:请输入月份";
        return;
    }else
    {
        self.tipLabelExamTime.hidden = YES;
        self.tipLabelExamTime.text = @"";
    }
    
    if ([day isEqualToString:@""]) {
        self.tipLabelExamTime.hidden = NO;
        self.tipLabelExamTime.text = @"提示:请输入天数";
        return;
    }else
    {
        self.tipLabelExamTime.hidden = YES;
        self.tipLabelExamTime.text = @"";
    }
    //判断范围
    if ([year integerValue] < 2015 || [year integerValue] > 2050) {
        self.tipLabelExamTime.hidden = NO;
        self.tipLabelExamTime.text = @"提示:输入合理的年份";
        return;
    }else
    {
        self.tipLabelExamTime.hidden = YES;
        self.tipLabelExamTime.text = @"";
    }
    
    if ([month integerValue] > 12 || [month integerValue] == 0) {
        self.tipLabelExamTime.hidden = NO;
        self.tipLabelExamTime.text = @"提示:输入合理的月份";
        return;
    }else
    {
        self.tipLabelExamTime.hidden = YES;
        self.tipLabelExamTime.text = @"";
    }
    
    if ([day integerValue] > 31 || [day integerValue] == 0) {
        self.tipLabelExamTime.hidden = NO;
        self.tipLabelExamTime.text = @"提示:输入合理的天数";
        return;
    }else
    {
        self.tipLabelExamTime.hidden = YES;
        self.tipLabelExamTime.text = @"";
    }
    
    NSString *dateString = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    
    if (self.tDate_ID.length > 0 && ![self.tDate_ID isEqualToString:@""]) {
        //修改时间
        [[RusultManage shareRusultManage]sysUpdateTestDateController:nil
                                                             tDateId:self.tDate_ID
                                                            destDate:dateString
                                                         SuccessData:^(NSDictionary *result) {
                                                             NDLog(@"修改时间,%@",result);
                                                             if (self.delegate && [self.delegate respondsToSelector:@selector(typeDate:typeTime:resultDic:)]) {
                                                                 [self.delegate typeDate:dateString typeTime:TypeTimeAboadDate resultDic:result];
                                                             }
                                                             //                                                             [self dismissViewControllerAnimated:YES completion:nil];
                                                             [self shutMyself];
                                                         }];
    }else
    {
        //新增时间
        switch (self.typeTime) {
            case TypeTimeAboadDate:  //留学
            {
                [self _requestAddDate:dateString dateTypeId:@"2" typeTime:TypeTimeAboadDate];
            }
                break;
            case TypeTimeTestDate:  //考试
            {
                [self _requestAddDate:dateString dateTypeId:@"1" typeTime:TypeTimeTestDate];
            }
                break;
                
            default:
                break;
        }
    }

}

- (void)_requestAddDate:(NSString *)dateString dateTypeId:(NSString *)typeId  typeTime:(TypeTimes)typetimes
{
    
    [[RusultManage shareRusultManage]sysAddTestDateController:self
                                                   dateTypeId:typeId
                                                     destDate:dateString
                                                  SuccessData:^(NSDictionary *result) {
                                                      /*1,考试，2，留学*/
                                                      NDLog(@"新增时间,%@",result);
                                                      if (self.delegate && [self.delegate respondsToSelector:@selector(typeDate:typeTime:resultDic:)]) {
                                                          [self.delegate typeDate:dateString typeTime:typetimes resultDic:result];
                                                      }
//                                                      [self dismissViewControllerAnimated:YES completion:nil];
                                                      [self shutMyself];
                                                  }];
}

- (IBAction)onCancel:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self shutMyself];
}


- (void)shutMyself
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shutAddExamTimeView)]) {
        [self.delegate shutAddExamTimeView];
    }

}

@end
