//
//  RegisterViewController.h
//  IELTS
//
//  Created by 李牛顿 on 14-11-14.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegisterViewControllerDelegate<NSObject>
@optional
- (void)shutModelView;
@end

@interface RegisterViewController : UIViewController

@property (nonatomic,unsafe_unretained)id<RegisterViewControllerDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIView *textFiledBgView;

@property (weak, nonatomic) IBOutlet UILabel *line1;
@property (weak, nonatomic) IBOutlet UILabel *line2;
@property (weak, nonatomic) IBOutlet UILabel *line3;
@property (weak, nonatomic) IBOutlet UILabel *line4;

@property (weak, nonatomic) IBOutlet UILabel *titleLabels;


@property (weak, nonatomic) IBOutlet UITextField *mailTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;    //昵称
@property (weak, nonatomic) IBOutlet UITextField *pswField;
@property (weak, nonatomic) IBOutlet UITextField *againPswField;
@property (weak, nonatomic) IBOutlet UITextField *userNameField;  //用户名


@property (weak, nonatomic) IBOutlet UIButton *registerButton;
- (IBAction)registerAction:(UIButton *)sender;


- (IBAction)logonButtonAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *logonButton;


@end
