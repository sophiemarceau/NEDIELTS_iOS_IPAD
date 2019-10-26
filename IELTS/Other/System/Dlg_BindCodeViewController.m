//
//  Dlg_BindCodeViewController.m
//  IELTS
//
//  Created by melp on 14/12/1.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "Dlg_BindCodeViewController.h"
#import "ZCControl.h"

@interface Dlg_BindCodeViewController ()<UITextFieldDelegate>

@end

@implementation Dlg_BindCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [ZCControl presentNavController:self Width:338 Height:354];
    
    self.bgViews.layer.cornerRadius = 10;
    self.bgViews.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.bgViews.layer.borderWidth = 0.5;
    
    //
    self.line1.height = 0.5;
    
    self.txtCode.delegate = self;
    self.txtName.delegate = self;
    
    self.txtCode.returnKeyType = UIReturnKeyNext;
    self.txtName.returnKeyType = UIReturnKeyDone;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.txtCode isFirstResponder]) {
        [self.txtCode resignFirstResponder];
        [self.txtName becomeFirstResponder];
    }else if ([self.txtName isFirstResponder])
    {
        [self.txtName resignFirstResponder];
        [self sureBindCode];
    }
    return YES;
}

- (void)cancellAction:(UIButton *)button
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self shutBindView];
}

- (void)sureBindCode
{
    NSString *sCode = self.txtCode.text;
    NSString *sName = self.txtName.text;
    
    if([sCode isEqual:@""] || [sName isEqual:@""])
    {
        [ZCControl AlertBox:@"请输入完整信息"];
        return;
    }
    
    NSDictionary *data = @{@"stuCode": sCode,@"stuName":sName};
    [[RusultManage shareRusultManage] bindStudentCodeRusult:data viewController:nil successData:^(NSDictionary *result)
     {
         BOOL ret = [[result objectForKey:@"Result"] boolValue];
         if(ret)
         {
             [ZCControl AlertBox:@"绑定成功"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"ON_BindCodeSuccess" object:nil];
             
             [self shutBindView];
//             [self dismissViewControllerAnimated:YES completion:nil];
         }
         else
         {
             if ([[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]]) {
                 return ;
             }
             [ZCControl AlertBox:[result objectForKey:@"Infomation"]];
         }
     }];
}

- (IBAction)onSubmit:(id)sender
{
    [self sureBindCode];
}
- (void)shutBindView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shutBindCodeModelView)]) {
        [self.delegate shutBindCodeModelView];
    }
}

- (IBAction)onCancel:(id)sender
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self shutBindView];
}

@end
