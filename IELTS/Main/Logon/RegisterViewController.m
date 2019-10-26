//
//  RegisterViewController.m
//  IELTS
//
//  Created by 李牛顿 on 14-11-14.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import "RegisterViewController.h"
#import "NetworkManager.h"
#import "MyMD5.h"

@interface RegisterViewController ()<UIAlertViewDelegate,UITextFieldDelegate>
{
    CGFloat org_y;
}
@property (nonatomic,strong)NSString *userName;
@property (nonatomic,strong)NSString *passWord;
@property (nonatomic,strong)NSString *nickName;
@property (nonatomic,strong)NSString *email;
@property (nonatomic,strong)NSString *againPassWord;


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     
//     [ZCControl  presentNavController:self Width:354 Height:554];
    
     self.titleLabels.textColor = TABBAR_BACKGROUND_SELECTED;
    
     [self _initView];
    
     [self _initData];
    
}
- (void)_initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.textFiledBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textFiledBgView.layer.borderWidth = 0.5;
    self.textFiledBgView.layer.cornerRadius = 5.0;
    
    
    self.line1.height = 0.5;
    self.line2.height = 0.5;
    self.line3.height = 0.5;
    self.line4.height = 0.5;
    
    
    self.userNameField.delegate = self;
    self.pswField.delegate = self;
    self.againPswField.delegate = self;
    self.nameField.delegate = self;
    
    self.userNameField.keyboardType = UIKeyboardTypeEmailAddress;
    self.userNameField.returnKeyType = UIReturnKeyNext;
    self.nameField.returnKeyType = UIReturnKeyNext;
    self.pswField.returnKeyType = UIReturnKeyNext;
    self.againPswField.returnKeyType = UIReturnKeyDone;
    
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
        if ([self.pswField isFirstResponder])
        {
            yChange = keyboardBounds.origin.y+280;
        }
        else if ([self.againPswField isFirstResponder])
        {
            yChange = keyboardBounds.origin.y+320;
        }
        else if ([self.userNameField isFirstResponder])
        {
            yChange = keyboardBounds.origin.y+400;
        }
        else if ([self.nameField isFirstResponder])
        {
            yChange = keyboardBounds.origin.y+350;
        }

        if([self.pswField isFirstResponder] ||
           [self.againPswField isFirstResponder]||
           [self.userNameField isFirstResponder]||
           [self.nameField isFirstResponder])
        {
            if(org_y<0){
                org_y = self.view.frame.origin.y;
            }
            
            NSInteger offset = 768 - yChange;
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
        if([self.pswField isFirstResponder] ||
           [self.againPswField isFirstResponder]||
           [self.userNameField isFirstResponder]||
           [self.nameField isFirstResponder])
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
    if ([self.userNameField isFirstResponder])
    {
        [self.userNameField resignFirstResponder];
        [self.nameField becomeFirstResponder];
    }
    else if ([self.nameField isFirstResponder])
    {
        [self.nameField resignFirstResponder];
        [self.pswField becomeFirstResponder];
    }
    else if ([self.pswField isFirstResponder])
    {
        [self.pswField resignFirstResponder];
        [self.againPswField becomeFirstResponder];
    }
    else if ([self.againPswField isFirstResponder])
    {
        [self.view endEditing:YES];
        [self reggister];
    }
    return YES;
}

//点击注册
- (IBAction)registerAction:(UIButton *)sender {
    [self reggister];
}

- (void)reggister
{
    self.nickName = (self.nameField.text ==nil) ? nil : self.nameField.text;
    
    self.againPassWord = (self.againPswField.text == nil)?nil:self.againPswField.text;
    self.passWord = (self.pswField.text ==nil) ? nil : self.pswField.text;
    
    self.userName = (self.userNameField.text ==nil) ? nil : self.userNameField.text;
    self.email = (self.mailTextField.text ==nil) ? nil : self.mailTextField.text;

    if ([self.userName isEqualToString:@""] || self.userName.length == 0  || self.userName == nil) {
        [[RusultManage shareRusultManage] tipAlert:@"请输入邮箱地址"];
        return;
    }
    if (![self validateEmail:self.userName]) {
        [[RusultManage shareRusultManage] tipAlert:@"请输入正确的邮箱"];
        return;
    }
    if ([self.nickName isEqualToString:@""] || self.nickName.length == 0  || self.nickName == nil) {
        [[RusultManage shareRusultManage] tipAlert:@"请输入昵称"];
        return;
    }
    
    if ([self.passWord isEqualToString:@""] || self.passWord.length == 0  || self.passWord == nil) {
        [[RusultManage shareRusultManage] tipAlert:@"请输入密码"];
        return;
    }
    if ([self.againPassWord isEqualToString:@""] || self.againPassWord.length == 0  || self.againPassWord == nil) {
        [[RusultManage shareRusultManage] tipAlert:@"请再次输入密码"];
        return;
    }
    if (![self.againPassWord isEqualToString:self.passWord]) {
        [[RusultManage shareRusultManage] tipAlert:@"密码不相同,请重新输入。"];
        return;
    }
    if ([self.email isEqualToString:@""] || self.email.length == 0  || self.email == nil) {
        //[[RusultManage shareRusultManage] tipAlert:@"请输入邮箱"];
        //return;
        self.email = @"null";
    }
    
    NSString *method = @"RegisterV2";
    NSString *user = self.userName;
    NSString *nickName = self.nickName;
    NSString *pwd = self.passWord;
    NSString *guid= [self getUniqueStrByUUID];
    NSString *signText = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",method,U2AppId,guid,user,nickName,pwd,U2AppKey];
    signText = [signText lowercaseString];
    NSString *sign = [MyMD5 md5:signText];
    sign = [sign uppercaseString];
    NSDictionary *dic = @{@"method":method,
                          @"appid":U2AppId,
                          @"user":user,
                          @"nickName":nickName,
                          @"pwd":pwd,
                          @"smsCode":@"",
                          @"guid":guid,
                          @"sign":sign};
    
    [[NetworkManager SharedNetworkManager]registPostU2WithParameters:dic
                                                            onTarget:self
                                                             success:^(NSDictionary *result, NSDictionary *headers) {
//                                                                 NDLog(@"%@",result);
                                                                 if (![[result objectForKey:@"Status"] isKindOfClass:[NSNull class]]) {
                                                                     if ([[[result objectForKey:@"Status"] stringValue] isEqualToString:@"1"]) {
                                                                         UIAlertView *alertS =   [[UIAlertView alloc]initWithTitle:@"提示"
                                                                                                                           message:@"注册成功！"
                                                                                                                          delegate:self
                                                                                                                 cancelButtonTitle:@"确定"
                                                                                                                 otherButtonTitles:nil];
                                                                         [alertS show];
                                                                     }else
                                                                     {
                                                                         NSString *message = [result objectForKey:@"Message"];
                                                                         [[RusultManage shareRusultManage]tipAlert:message viewController:self];
                                                                     }
                                                                 }
                                                             } failure:^(NSError *error) {
                                                                    [[RusultManage shareRusultManage]tipAlert:[error localizedDescription]];
                                                             }];
//    NSDictionary *regist = @{@"u":self.userName,  //邮箱
//                             @"p":self.passWord,  //密码
//                             @"nickName":self.nickName,  //用户名
//                             @"email":self.email};
//    [[RusultManage shareRusultManage]registRusult:regist
//                                   viewController:self
//                                      successData:^(NSDictionary *result) {
//                                          NDLog(@"%@",result);
//                                          UIAlertView *alertS =   [[UIAlertView alloc]initWithTitle:@"提示"
//                                                                                            message:@"注册成功！"
//                                                                                           delegate:self
//                                                                                  cancelButtonTitle:@"确定"
//                                                                                  otherButtonTitles:nil];
//                                          [alertS show];
//                                      }];

}

- (NSString *)getUniqueStrByUUID
{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    
    //get the string representation of the UUID
    
    NSString    *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
    
    CFRelease(uuidObj);
    return uuidString ;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self modeCtrl];
}


#pragma mark - 验证邮箱
-(BOOL)validateEmail:(NSString *)email

{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

- (void)modeCtrl
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shutModelView)]) {
        [self.delegate shutModelView];
    }
}


//返回登陆界面
- (IBAction)logonButtonAction:(UIButton *)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self modeCtrl];
}


@end
