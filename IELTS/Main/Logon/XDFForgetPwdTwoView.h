//
//  XDFForgetPwdTwoView.h
//  IELTS
//
//  Created by DevNiudun on 15/7/24.
//  Copyright (c) 2015年 Newton. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XDFForgetPwdTwoViewDelegate <NSObject>
- (void)logonInAction;
- (void)backForgetAction;
@end

@interface XDFForgetPwdTwoView : UIView


@property (nonatomic,assign)id<XDFForgetPwdTwoViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UITextField *authCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *againTextField;

- (IBAction)logonInButton:(UIButton *)sender;

- (IBAction)backForgetPwd:(UIButton *)sender;



@property (nonatomic,copy) NSString *emailString;

@end
