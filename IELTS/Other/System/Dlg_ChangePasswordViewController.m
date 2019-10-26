//
//  Dlg_ChangePasswordViewController.m
//  IELTS
//
//  Created by melp on 14/12/1.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "Dlg_ChangePasswordViewController.h"
#import "XDFPresentationController.h"
#import "ZCControl.h"

@interface Dlg_ChangePasswordViewController ()<UITextFieldDelegate>

@end

@implementation Dlg_ChangePasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [ZCControl presentNavController:self Width:352 Height:400];
    
    self.bgImgView.layer.cornerRadius = 10;
    self.bgImgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.bgImgView.layer.borderWidth = 0.5;
    
    //
    self.line.height = 0.5;
    self.line2.height = 0.5;
    
    self.txtOldPassword.delegate = self;
    self.txtNewPassword.delegate = self;
    self.txtRePassword.delegate = self;
    
    self.txtOldPassword.returnKeyType = UIReturnKeyNext;
    self.txtNewPassword.returnKeyType = UIReturnKeyNext;
    self.txtRePassword.returnKeyType = UIReturnKeySend;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.txtOldPassword isFirstResponder]) {
        [self.txtOldPassword resignFirstResponder];
        [self.txtNewPassword becomeFirstResponder];
    }else if ([self.txtNewPassword isFirstResponder])
    {
        [self.txtNewPassword resignFirstResponder];
        [self.txtRePassword becomeFirstResponder];
    }else if ([self.txtRePassword isFirstResponder])
    {
        [self.txtRePassword resignFirstResponder];
        [self changeSure];
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)shutSelf
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shutChangePassWordModelView)]) {
        [self.delegate shutChangePassWordModelView];
    }

}

- (IBAction)onCancel:(id)sender
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self shutSelf];
}

- (IBAction)onSubmit:(id)sender
{
    [self changeSure];
}

- (void)changeSure
{
    NSString *oldPass = self.txtOldPassword.text;
    NSString *newPass = self.txtNewPassword.text;
    NSString *rePass  = self.txtRePassword.text;
    
    if([oldPass isEqual:@""] || [newPass isEqual:@""])
    {
        [ZCControl AlertBox:@"请输入密码"];
        return;
    }
    
    if(![newPass isEqual:rePass])
    {
        [ZCControl AlertBox:@"确认密码输入不正确"];
        return;
    }
    
    NSDictionary *data = @{@"newPass":newPass,
                           @"oldPass":oldPass,
                           @"userId":[RusultManage shareRusultManage].userId};
    
    [[RusultManage shareRusultManage] passChangeRusult:data viewController:nil successData:^(NSDictionary *result)
     {
         if ([[result objectForKey:@"Result"]boolValue]) {
             [ZCControl AlertBox:@"密码修改成功"];
         }else
         {
             ;
             if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]]) {
                 [ZCControl AlertBox:[result objectForKey:@"Infomation"]];
             }
         }
         
         //         [self dismissViewControllerAnimated:YES completion:nil];
         [self shutSelf];
     }];
}


@end
