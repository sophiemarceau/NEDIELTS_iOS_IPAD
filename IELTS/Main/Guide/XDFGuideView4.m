//
//  XDFGuideView4.m
//  IELTS
//
//  Created by 李牛顿 on 14-12-9.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFGuideView4.h"
//#import "BaseFillBlankView.h"
@interface XDFGuideView4()<UITextFieldDelegate>
//@property (nonatomic,strong)UIButton *selectButton;  //选中按钮
//@property (nonatomic,strong)NSArray *array;   //文字数组
@property (nonatomic,strong) UILabel *tipLabel;
@end


@implementation XDFGuideView4

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self _initView];
    
}
//初始化视图
- (void)_initView
{
    
    self.yearTextField.delegate = self;
    self.monthTextField.delegate = self;
    self.dayTextField.delegate = self;
    
    self.yearTextField.returnKeyType = UIReturnKeyNext;
    self.monthTextField.returnKeyType = UIReturnKeyNext;
    self.dayTextField.returnKeyType = UIReturnKeyDone;
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    tipLabel.textColor = TABBAR_BACKGROUND_SELECTED;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont systemFontOfSize:16.0];
    [self.timeBgView addSubview:tipLabel];
    self.tipLabel.hidden = YES;
    self.tipLabel = tipLabel;
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tipLabel.frame = CGRectMake((self.timeBgView.width-200)/2, 0, 200, 40);
    self.tipLabel.top = self.monthTextField.bottom;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kNumbers] invertedSet];
    NSString *filtered =
    [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [string isEqualToString:filtered];
    
    return basic;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self _saveData];
    return YES;
}

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
        [self _saveData];
    }
    return YES;
}

- (void)_saveData
{
    NSString *year = self.yearTextField.text.length > 0 ? self.yearTextField.text : @"";
    NSString *month = self.monthTextField.text.length > 0 ? self.monthTextField.text : @"";
    NSString *day = self.dayTextField.text > 0 ? self.dayTextField.text : @"";
    
    //判断非空
    if ([year isEqualToString:@""] && [month isEqualToString:@""] && [day isEqualToString:@""]) {
        return;
    }
    
    if ([year integerValue] < 2015 || [year integerValue] > 2050) {
        self.tipLabel.text = @"请输入正确的年份";
        self.tipLabel.hidden = NO;
        return;
    }
    
    if ([month integerValue] > 12 || [month integerValue] <= 0) {
        self.tipLabel.text = @"请输入正确的月";
        self.tipLabel.hidden = NO;
        return;
    }
    
    if ([day integerValue] > 31 || [day integerValue] <= 0) {
        self.tipLabel.text = @"请输入正确的天";
        self.tipLabel.hidden = NO;
        return;
    }
    self.tipLabel.hidden = YES;
    NSString *dateString = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    
    //保存时间数据
    [kUserDefaults setObject:dateString forKey:@"destDate"];
    [kUserDefaults setObject:@"1" forKey:@"dateTypeId"];
    [kUserDefaults synchronize];
}



- (IBAction)undeterminedButton:(UIButton *)sender {

    [kUserDefaults setObject:@"" forKey:@"destDate"];
    [kUserDefaults setObject:@"" forKey:@"dateTypeId"];
    [kUserDefaults synchronize];

    //记录状态
    sender.selected = !sender.selected;
    //跳过这一页
    [self skipTime];
}

- (void)skipTime
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(timeUndetermine)]) {
        [self.delegate timeUndetermine];
    }

}




@end
