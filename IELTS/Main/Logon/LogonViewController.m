//
//  LogonViewController.m
//  IELTS
//
//  Created by melp on 14/11/9.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import "LogonViewController.h"
#import "ZipArchive.h"
#import "RegisterViewController.h"
#import "ForgetPwdViewController.h"
#import "UserModel.h"

#import "XDFDownLoadViewController.h"

@interface LogonViewController ()<UITextFieldDelegate,RegisterViewControllerDelegate,ForgetPwdViewControllerDelegate>
{
    CGFloat org_y;
}

@property (nonatomic,strong)NSString *userName;
@property (nonatomic,strong)NSString *passWord;

@property (nonatomic,strong) UIControl *maskControlView; //控制收起搜索框搜索框
@property (nonatomic,strong) RegisterViewController *rgisterView;
@property (nonatomic,strong) ForgetPwdViewController *forgetView;


@end

@implementation LogonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self _initView];
    [self _initData];
}
//初始化视图
- (void)_initView
{
    self.LogonBgView.layer.cornerRadius = 10;
    self.LogonBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.LogonBgView.layer.borderWidth = 0.5;
    
    self.cuteLine.top = self.LogonBgView.height/2;
    self.cuteLine.height = 0.5;

//    self.nameTextField.text = @"1229";
//    self.passWordTextField.text = @"1229";
    
    self.titleLabls.textColor = TABBAR_BACKGROUND_SELECTED;
    
    self.passWordTextField.returnKeyType =  UIReturnKeyDone;
    self.nameTextField.returnKeyType = UIReturnKeyNext;
    self.passWordTextField.delegate = self;
    self.nameTextField.delegate = self;
    
    UserModel* userinfo = [UserModel LoadUserInfoFromLocal];
    if(userinfo != nil)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGONCHANGE" object:nil];
    }
    
}
//初始化数据
- (void)_initData
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    org_y = -1;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark -keyboard Action
- (void) keyboardWillShow:(NSNotification *)sender
{
    NSValue *keyboardBoundsValue = [[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardBounds;
    [keyboardBoundsValue getValue:&keyboardBounds];
    
    CGFloat yChange = 0.0f;
    if ([self.nameTextField isFirstResponder])
    {
        yChange = keyboardBounds.origin.y+300;
    }
    else if ([self.passWordTextField isFirstResponder])
    {
        yChange = keyboardBounds.origin.y+300;
    }
    if( [self.nameTextField isFirstResponder] ||
       [self.passWordTextField isFirstResponder])
    {
        if(org_y<0){
            if (IS_IOS8) {
                org_y = self.view.frame.origin.y;
            }else
            {
                org_y = self.view.frame.origin.x;
            }
        }
        NSInteger offset = 768 - yChange;
        CGRect listFrame;
        if (IS_IOS8) {
            listFrame  = CGRectMake(0, -offset, kScreenWidth,768);
        }else
        {
            if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
                listFrame  = CGRectMake(-offset/5, 0, 768,kScreenWidth);
            }else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)
            {
                listFrame  = CGRectMake(offset/5, 0, 768,kScreenWidth);
            }
        }
        [UIView beginAnimations:@"anim" context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        //处理移动事件，将各视图设置最终要达到的状态
        self.view.frame=listFrame;
        
        [UIView commitAnimations];
    }
}
//[self.userCellPhone isFirstResponder] ||
- (void) keyboardWillHide:(id)sender
{
    if([self.nameTextField isFirstResponder] || [self.passWordTextField isFirstResponder])
    {
        if(org_y >= 0)
        {
            CGRect rect = self.view.frame;
            if (IS_IOS8) {
                rect.origin.y = org_y;
            }else
            {
                rect.origin.x = org_y;
            }

            self.view.frame = rect;
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.nameTextField isFirstResponder]) {
        [self.nameTextField resignFirstResponder];
        [self.passWordTextField becomeFirstResponder];
    }else if ([self.passWordTextField isFirstResponder])
    {
        //做登录操作
        [self.view endEditing:YES];
        [self LogonAction];
    }
    return YES;
}


- (IBAction)onLogon:(id)sender
{
    [self LogonAction];
}

- (void)LogonAction
{

    self.userName = (self.nameTextField.text ==nil) ? nil : self.nameTextField.text;
    self.passWord = (self.passWordTextField.text ==nil) ? nil : self.passWordTextField.text;
    
    
    if ([self.userName isEqualToString:@""] || self.userName.length == 0  || self.userName == nil) {
        [[RusultManage shareRusultManage]tipAlert:@"请输入邮箱地址" ];
        return;
    }
    if ([self.passWord isEqualToString:@""] || self.passWord.length == 0  || self.passWord == nil) {
        [[RusultManage shareRusultManage]tipAlert:@"请输入密码"];
        return;
    }
    
//    NSDictionary *dic = @{@"u":self.userName,
//                          @"p":self.passWord,
//                          @"DeviceToken":@"1234",
//                          @"DeviceTokenType":@"iPad"};
    NSDictionary *dic = @{@"u":self.userName,
                          @"p":self.passWord};
    
    [[RusultManage shareRusultManage]logonRusult:dic
                                  viewController:self
                                     successData:^(NSDictionary *result) {
                                         //                                        判断是不是第一次进入
                                         if (![kUserDefaults boolForKey:@"requestGuideData"]) {
                                             [self _dealGuideDate];
                                             //设置成功以后设置成Yes,保证此处只调用一次。
                                             [kUserDefaults setBool:YES forKey:@"requestGuideData"];
                                             [kUserDefaults synchronize];
                                         }
                                         
                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGONCHANGE" object:nil];
                                     }];
}


//处理引导页数据
- (void)_dealGuideDate
{
    
    //1.有类型数据
    if (![[kUserDefaults objectForKey:@"examType"] isKindOfClass:[NSNull class]] || [kUserDefaults objectForKey:@"examType"] != nil) {
        if ([[kUserDefaults objectForKey:@"examType"] isEqualToString:@"1"] || [[kUserDefaults objectForKey:@"examType"] isEqualToString:@"2"]) {
            //设置考试类别
            [[RusultManage shareRusultManage]sysTargetController:self examType:[kUserDefaults objectForKey:@"examType"] SuccessData:^(NSDictionary *result) {
                NDLog(@"类别设置%@",result);
                //设置成功后移除信息
                [kUserDefaults removeObjectForKey:@"examType"];
                [kUserDefaults synchronize];//同步数据
            }];
        }
    }
    
    //2.设置目标成绩
    NSNumber *listenNum = [kUserDefaults objectForKey:@"lisent"];
    NSNumber *speakNum = [kUserDefaults objectForKey:@"speak"];
    NSNumber *readNum = [kUserDefaults objectForKey:@"read"];
    NSNumber *writeNum  = [kUserDefaults objectForKey:@"write"];
    if (listenNum != nil && speakNum!=nil && readNum!=nil  & writeNum!=nil) {
        
        [[RusultManage shareRusultManage]sysTargetController:nil
                                                      Lisent:[listenNum stringValue]
                                                       Speak:[speakNum stringValue]
                                                        Read:[readNum stringValue]
                                                       write:[writeNum stringValue]
                                                 SuccessData:^(NSDictionary *result) {
                                                     NDLog(@"目标分数设置成功设置%@",result);
                                                     //成功后移除信息
                                                     [kUserDefaults removeObjectForKey:@"lisent"];
                                                     [kUserDefaults removeObjectForKey:@"speak"];
                                                     [kUserDefaults removeObjectForKey:@"read"];
                                                     [kUserDefaults removeObjectForKey:@"write"];
                                                     [kUserDefaults synchronize];//同步数据
                                                 }];
        

    }
    //3.设置考试时间
    if (![[kUserDefaults objectForKey:@"dateTypeId"] isEqualToString:@""]) {
        
        if ([[kUserDefaults objectForKey:@"dateTypeId"] isEqualToString:@"1"]) {
            [[RusultManage shareRusultManage]sysAddTestDateController:nil
                                                           dateTypeId:[kUserDefaults objectForKey:@"dateTypeId"]
                                                             destDate:[kUserDefaults objectForKey:@"destDate"]
                                                          SuccessData:^(NSDictionary *result) {
                                                              /*1,考试，2，留学*/
                                                              NDLog(@"新增时间,%@",result);
                                                              [kUserDefaults removeObjectForKey:@"dateTypeId"];
                                                              [kUserDefaults removeObjectForKey:@"destDate"];
                                                              [kUserDefaults synchronize];
                                                          }];
            
        }
    }
    
    //4.考试成绩------------------
    /*
     [[NSUserDefaults standardUserDefaults]setObject:listenNum forKey:@"currentLisent"];
     [[NSUserDefaults standardUserDefaults]setObject:speakNum forKey:@"currentSpeak"];
     [[NSUserDefaults standardUserDefaults]setObject:readNum forKey:@"currentRead"];
     [[NSUserDefaults standardUserDefaults]setObject:writeNum forKey:@"currentWrite"];
     */
    
      NSNumber *curListenNum = [kUserDefaults objectForKey:@"currentLisent"];
      NSNumber *curSpeakNum = [kUserDefaults objectForKey:@"currentSpeak"];
      NSNumber *curReadNum = [kUserDefaults objectForKey:@"currentRead"];
      NSNumber *curWriteNum = [kUserDefaults objectForKey:@"currentWrite"];
    if (curListenNum!=nil && curSpeakNum !=nil && curReadNum !=nil && curWriteNum !=nil) {
        [[RusultManage shareRusultManage]sysCurrentController:nil
                                                       Lisent:[curListenNum stringValue]
                                                        Speak:[curSpeakNum stringValue]
                                                         Read:[curReadNum stringValue]
                                                        write:[curWriteNum stringValue]
                                                  SuccessData:^(NSDictionary *result) {
                                                      NDLog(@"当前考试成绩:%@",result);
                                                      [kUserDefaults removeObjectForKey:@"currentLisent"];
                                                      [kUserDefaults removeObjectForKey:@"currentSpeak"];
                                                      [kUserDefaults removeObjectForKey:@"currentRead"];
                                                      [kUserDefaults removeObjectForKey:@"currentWrite"];
                                                      [kUserDefaults synchronize];
                                                      
                                                  }];
    }
}

#pragma mark - 实现点击灰色背景，收起视图
- (void)_initMask:(UIView *)textView
{
    //创建点击视图
    if (_maskControlView == nil) {
        _maskControlView = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, 1024 , 768)];
//        [_maskControlView addTarget:self action:@selector(maskControlView:) forControlEvents:UIControlEventTouchUpInside];
        _maskControlView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self.view insertSubview:_maskControlView belowSubview:textView];
    }
}
//隐藏alert
- (void)maskControlView:(UIControl *)maskView
{
    if (self.rgisterView != nil) {
        [self actionForView:self.rgisterView];
    }else if (self.forgetView != nil)
    {
        [self actionForView:self.forgetView];
    }
}

- (void)actionForView:(UIViewController *)contrl
{
    CGFloat with =  contrl.view.frame.size.width;
    CGFloat heigt = contrl.view.frame.size.height;
    contrl.view.frame = CGRectMake((1024-with)/2, (768-heigt)/2, with, heigt);
    
    [UIView animateWithDuration:0.35 animations:^{
        contrl.view.frame = CGRectMake((1024-with)/2, self.view.frame.size.height,with, heigt);
        [_maskControlView removeFromSuperview];
        _maskControlView = nil;
    } completion:^(BOOL finished) {
        
        [contrl.view removeFromSuperview];
        contrl.view = nil;
        
        [contrl removeFromParentViewController];
        self.forgetView = nil;
        self.rgisterView = nil;
    }];
}

#pragma mark -RegisterViewControllerDelegate 关闭视图
- (void)shutModelView
{
    [self maskControlView:nil];
}
- (void)shutForgetModelView
{
    [self maskControlView:nil];
}


- (IBAction)onRegist:(UIButton *)sender {
    RegisterViewController *regist = [[RegisterViewController alloc]init];
    regist.delegate = self;
    CGFloat with =  regist.view.frame.size.width;
    CGFloat heigt = regist.view.frame.size.height;
    
    regist.view.frame = CGRectMake((1024-with)/2, self.view.frame.size.height,with, heigt);
    [UIView animateWithDuration:0.35 animations:^{
        regist.view.frame = CGRectMake((1024-with)/2, (768-heigt)/2, with, heigt);
    }];
    [self _initMask:regist.view];
    
    [self.view addSubview:regist.view];
    self.rgisterView = regist;

//    [ZCControl presentModalFromController:self toController:regist isHiddenNav:YES Width:354 Height:554];
}

- (IBAction)onForget:(UIButton *)sender {

    ForgetPwdViewController *regist = [[ForgetPwdViewController alloc]init];
    regist.delegate = self;
    CGFloat with =  regist.view.frame.size.width;
    CGFloat heigt = regist.view.frame.size.height;
    
    regist.view.frame = CGRectMake((1024-with)/2, self.view.frame.size.height,with, heigt);
    [UIView animateWithDuration:0.35 animations:^{
        regist.view.frame = CGRectMake((1024-with)/2, (768-heigt)/2, with, heigt);
    }];
    [self _initMask:regist.view];
    
    [self.view addSubview:regist.view];
    self.forgetView = regist;

//    [ZCControl presentModalFromController:self toController:regist  isHiddenNav:YES Width:354 Height:480];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
