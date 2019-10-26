//
//  LogonViewController.h
//  IELTS
//
//  Created by melp on 14/11/9.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogonViewController : UIViewController
- (IBAction)onLogon:(id)sender;           //登陆
- (IBAction)onRegist:(UIButton *)sender;  //注册
- (IBAction)onForget:(UIButton *)sender;  //忘记密码

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;     //昵称
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField; //密码

@property (weak, nonatomic) IBOutlet UIButton *logonButton;   //登陆

@property (weak, nonatomic) IBOutlet UIButton *registerButton;//注册
@property (weak, nonatomic) IBOutlet UIButton *forgetPSWButton; //忘记密码


@property (weak, nonatomic) IBOutlet UIView *LogonBgView; //登陆背景图片

@property (weak, nonatomic) IBOutlet UILabel *cuteLine;  //切线


@property (weak, nonatomic) IBOutlet UIView *bgImgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabls;

@end
