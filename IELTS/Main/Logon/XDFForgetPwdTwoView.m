//
//  XDFForgetPwdTwoView.m
//  IELTS
//
//  Created by DevNiudun on 15/7/24.
//  Copyright (c) 2015年 Newton. All rights reserved.
//

#import "XDFForgetPwdTwoView.h"
#import "MyMD5.h"
#import "NetworkManager.h"
@implementation XDFForgetPwdTwoView



- (IBAction)logonInButton:(UIButton *)sender {
    NSString *authCode = self.authCodeTextField.text == nil ? @"" : self.authCodeTextField.text;
    NSString *pwdTextField =  self.pwdTextField.text == nil ? @"" : self.pwdTextField.text;
    NSString *againPwd = self.againTextField.text == nil ? @"" : self.againTextField.text;
    
    if ([authCode isEqualToString:@""]) {
        [[RusultManage shareRusultManage] tipAlert:@"请输入验证码"  viewController:self.viewController];
        return;
    }
    
    if ([pwdTextField isEqualToString:@""]) {
        [[RusultManage shareRusultManage] tipAlert:@"请输入新密码" viewController:self.viewController];
        return;
    }
    
    if ([againPwd isEqualToString:@""]) {
        [[RusultManage shareRusultManage] tipAlert:@"请再次输入新密码" viewController:self.viewController];
        return;
    }
    
    if (![againPwd isEqualToString:pwdTextField]) {
        [[RusultManage shareRusultManage] tipAlert:@"再次输入密码错误" viewController:self.viewController];
        return;
    }
    
    
    NSString *method = @"ResetPwdStep2VerifyCode";
    NSString *guid = [self getUniqueStrByUUID];
    
    NSString *code = authCode;
    
    NSString *signText = [[NSString stringWithFormat:@"%@%@%@%@%@%@",method,U2AppId,guid,self.emailString,code,U2AppKey]lowercaseString];
    NSString *sign = [[MyMD5 md5:signText]uppercaseString];
    
    
//    CHECK_STRING_IS_NULL(guid);
//    CHECK_STRING_IS_NULL(user);
//    CHECK_STRING_IS_NULL(sign);
    
    NSDictionary *dataPramar = @{@"method":method,
                                 @"appid":U2AppId,
                                 @"guid":guid,
                                 @"code":code,
                                 @"user":self.emailString,
                                 @"sign":sign};
    
    [[NetworkManager SharedNetworkManager]registPostU2WithParameters:dataPramar
                                                            onTarget:self.viewController
                                                             success:^(NSDictionary *result, NSDictionary *headers) {
         if (![[result objectForKey:@"Status"] isKindOfClass:[NSNull class]]) {
             if ([[[result objectForKey:@"Status"] stringValue] isEqualToString:@"1"]) {
                 [self ResetPwdStep3:code newPwd:againPwd];
             }else
             {
                 if (![[result objectForKey:@"Message"] isKindOfClass:[NSNull class]]) {
                     NSString *message = [result objectForKey:@"Message"];
                     [[RusultManage shareRusultManage]tipAlert:message viewController:self.viewController];
                 }
             }
         }
    } failure:^(NSError *error) {
        
    }];
}


- (void)ResetPwdStep3:(NSString *)code newPwd:(NSString *)newPwd
{

    NSString *method = @"ResetPwdStep3SetNewPwd";
    NSString *guid = [self getUniqueStrByUUID];
    
    NSString *signText = [[NSString stringWithFormat:@"%@%@%@%@%@%@%@",method,U2AppId,guid,self.emailString,code,newPwd,U2AppKey]lowercaseString];
    NSString *sign = [[MyMD5 md5:signText]uppercaseString];
    
    NSDictionary *dataPramar = @{@"method":method,
                                 @"appid":U2AppId,
                                 @"guid":guid,
                                 @"code":code,
                                 @"user":self.emailString,
                                 @"newPwd":newPwd,
                                 @"sign":sign};
    
    
    [[NetworkManager SharedNetworkManager]registPostU2WithParameters:dataPramar
                                                            onTarget:self.viewController
                                                             success:^(NSDictionary *result, NSDictionary *headers) {
             if (![[result objectForKey:@"Status"] isKindOfClass:[NSNull class]]) {
                 if ([[[result objectForKey:@"Status"] stringValue] isEqualToString:@"1"]) {
                     
                      [[RusultManage shareRusultManage]tipAlert:@"密码修改成功" viewController:self.viewController];
                     //登录
                     if (self.delegate && [self.delegate respondsToSelector:@selector(logonInAction)]) {
                         [self.delegate logonInAction];
                     }

                 }else
                 {
                     if (![[result objectForKey:@"Message"] isKindOfClass:[NSNull class]]) {
                         NSString *message = [result objectForKey:@"Message"];
                         [[RusultManage shareRusultManage]tipAlert:message viewController:self.viewController];
                     }
                 }
             }
         } failure:^(NSError *error) {
             
         }];
}


//返回上一级页面
- (IBAction)backForgetPwd:(UIButton *)sender {
    //返回
    if (self.delegate && [self.delegate respondsToSelector:@selector(backForgetAction)]) {
        [self.delegate backForgetAction];
    }
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
