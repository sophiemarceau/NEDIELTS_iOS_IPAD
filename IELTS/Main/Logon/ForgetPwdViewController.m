//
//  ForgetPwdViewController.m
//  IELTS
//
//  Created by 李牛顿 on 14-11-14.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import "ForgetPwdViewController.h"
//#import "XDFForgetPwdTwoViewController.h"
#import "XDFForgetPwdTwoView.h"
#import "MyMD5.h"
#import "NetworkManager.h"
@interface ForgetPwdViewController ()<UIAlertViewDelegate,UITextFieldDelegate,XDFForgetPwdTwoViewDelegate>
{
    CGFloat org_y;
}
@property (nonatomic,strong)NSString *passwordForget;

@property (nonatomic,strong)  XDFForgetPwdTwoView *forgetPwd;

@end

@implementation ForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [ZCControl presentNavController:self Width:354 Height:480];
    
    
    _forgetPwd = [[[NSBundle mainBundle]loadNibNamed:@"XDFForgetPwdTwoView" owner:self options:nil]lastObject];
    _forgetPwd.delegate = self;
    [self.view addSubview:_forgetPwd];
    _forgetPwd.hidden = YES;
    self.backImgView.hidden = NO;
    
    self.mailTextBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.mailTextBgView.layer.borderWidth = 0.5;
    self.mailTextBgView.layer.cornerRadius = 5.0;
    
    self.mailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.mailTextField.delegate = self;
    
    self.titleBgLabel.textColor = TABBAR_BACKGROUND_SELECTED;
    
    [self _initData];
}

//初始化数据
- (void)_initData
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardRegisterWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardRegisterWillHide:) name:UIKeyboardWillHideNotification object:nil];
    org_y = -1;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -keyboard Action
- (void) keyboardRegisterWillShow:(NSNotification *)sender
{
//    if (IS_IOS8) {
        NSValue *keyboardBoundsValue = [[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
        
        CGRect keyboardBounds;
        [keyboardBoundsValue getValue:&keyboardBounds];
        
        CGFloat yChange = 0.0f;
        if ([self.mailTextField isFirstResponder])
        {
            yChange = keyboardBounds.origin.y+350;
        }
        if([self.mailTextField isFirstResponder])
        {
            if(org_y<0){
                org_y = self.view.frame.origin.y;
            }
            NSInteger offset = 768 - yChange;
//            CGRect listFrame  = CGRectMake(0, -offset, kScreenWidth,768);
            CGRect listFrame  = CGRectMake((kScreenWidth-self.view.width)/2, offset/10, self.view.width,self.view.height);
            [UIView beginAnimations:@"anim" context:NULL];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.3];
            //处理移动事件，将各视图设置最终要达到的状态
            self.view.frame=listFrame;
            
            [UIView commitAnimations];
        }
//    }
}
//[self.userCellPhone isFirstResponder] ||
- (void) keyboardRegisterWillHide:(id)sender
{
//    if (IS_IOS8) {
    
        if( [self.mailTextField isFirstResponder])
        {
            if(org_y >= 0)
            {
                CGRect rect = self.view.frame;
                rect.origin.y = org_y;
                self.view.frame = rect;
            }
        }
//    }
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self requestAction];
    return YES;
}

- (void)requestAction
{
    self.passwordForget = (self.mailTextField.text == nil) ? nil : self.mailTextField.text;
    if ([self.passwordForget isEqualToString:@""] || self.passwordForget.length == 0  || self.passwordForget == nil) {
        [[RusultManage shareRusultManage] tipAlert:@"请输入邮箱地址"];
        return;
    }
    
    if (![self validateEmail:self.passwordForget]) {
        [[RusultManage shareRusultManage] tipAlert:@"请输入正确地邮箱地址"];
        return;
    }
    
//    NSDictionary *dic = @{@"u":self.passwordForget};
    NSString *method = @"ResetPwdStep1SendCode";
    NSString *guid = [self getUniqueStrByUUID];
    NSString *user = self.passwordForget;
    NSString *signText = [[NSString stringWithFormat:@"%@%@%@%@%@",method,U2AppId,guid,user,U2AppKey]lowercaseString ];
    NSString *sign = [[MyMD5 md5:signText]uppercaseString];
    
    
    NSDictionary *dataPramar = @{@"method":method,
                                 @"appid":U2AppId,
                                 @"guid":guid,
                                 @"user":user,
                                 @"sign":sign};

    [[NetworkManager SharedNetworkManager]registPostU2WithParameters:dataPramar
                                                            onTarget:self
                                                             success:^(NSDictionary *result, NSDictionary *headers) {
                                                                 if (![[result objectForKey:@"Status"] isKindOfClass:[NSNull class]]) {
                                                                     if ([[[result objectForKey:@"Status"] stringValue] isEqualToString:@"1"]) {

                                                                         [[RusultManage shareRusultManage]tipAlert:@"已发送邮件验证码到您的邮箱" viewController:self];
                                                                         _forgetPwd.hidden = NO;
                                                                         _forgetPwd.emailString = user;
                                                                         self.backImgView.hidden = YES;
                                                                     }else
                                                                     {
                                                                         if (![[result objectForKey:@"Message"] isKindOfClass:[NSNull class]]) {
                                                                             NSString *message = [result objectForKey:@"Message"];
                                                                             [[RusultManage shareRusultManage]tipAlert:message viewController:self];
                                                                         }
                                                                     }
                                                                 }
                                                                 
                                                             } failure:^(NSError *error) {
                                                                 
                                                                 
                                                                 
                                                             }];

}

- (IBAction)getPwdAction:(UIButton *)sender {
    [self requestAction];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//   [self dismissViewControllerAnimated:YES completion:nil];
    [self maskCrl];
    
//    XDFForgetPwdTwoViewController *forget = [[XDFForgetPwdTwoViewController alloc]init];
}

#pragma mark - 验证邮箱
-(BOOL)validateEmail:(NSString *)email

{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    
    return [emailTest evaluateWithObject:email];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)maskCrl
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shutForgetModelView)]) {
        [self.delegate shutForgetModelView];
    }

}
#define mark -  XDFForgetPwdTwoViewDelegate
- (void)logonInAction
{
    [self maskCrl];
}
- (void)backForgetAction
{
    _forgetPwd.hidden = YES;
    self.backImgView.hidden = NO;
}


- (IBAction)lognButtonAction:(UIButton *)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self maskCrl];
}



- (NSString *)getUniqueStrByUUID
{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    
    //get the string representation of the UUID
    
    NSString    *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
    
    CFRelease(uuidObj);
    return uuidString ;
}


@end
