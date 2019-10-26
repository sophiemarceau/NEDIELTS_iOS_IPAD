//
//  Sys_ClassNumberBindView.m
//  IELTS
//
//  Created by melp on 14/11/17.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import "Sys_ClassNumberBindView.h"
#import "RusultManage.h"
#import "ZCControl.h"
#import "NetworkManager.h"
#import "UIImageView+WebCache.h"
#import "Dlg_BindCodeViewController.h"

@interface Sys_ClassNumberBindView ()<Dlg_BindCodeViewControllerDelegate>

@property (nonatomic,strong)Dlg_BindCodeViewController *bindCode;
@property (nonatomic,strong) UIControl *maskControlView; //控制收起搜索框搜索框

@end

@implementation Sys_ClassNumberBindView


- (IBAction)onShowBindForm:(id)sender
{
    Dlg_BindCodeViewController *dlg = [[Dlg_BindCodeViewController alloc] initWithNibName:@"Dlg_BindCodeViewController" bundle:nil];
    dlg.delegate = self;
    CGFloat with =  dlg.view.frame.size.width;
    CGFloat heigt = dlg.view.frame.size.height;
    
    dlg.view.frame = CGRectMake((1024-with)/2, self.viewController.view.frame.size.height,with, heigt);
    [UIView animateWithDuration:0.35 animations:^{
        dlg.view.frame = CGRectMake((1024-with)/2, (768-heigt)/2, with, heigt);
    }];
    [self _initMask:dlg.view];
    
    [self.viewController.parentViewController.parentViewController.view addSubview:dlg.view];
    self.bindCode = dlg;

//    [ZCControl presentModalFromController:self.ParentViewControll toController:dlg isHiddenNav:YES Width:338 Height:354];
}
#pragma mark -Dlg_BindCodeViewControllerDelegate
- (void)shutBindCodeModelView
{
    [self maskControlView:nil];
}

#pragma mark - 实现点击键盘以外都收起键盘
- (void)_initMask:(UIView *)textView
{
    //创建点击视图
    if (_maskControlView == nil) {
        _maskControlView = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, 1024 , 768)];
//        [_maskControlView addTarget:self action:@selector(maskControlView:) forControlEvents:UIControlEventTouchUpInside];
        _maskControlView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self.viewController.parentViewController.parentViewController.view insertSubview:_maskControlView belowSubview:textView];
    }
}
//隐藏alert
- (void)maskControlView:(UIControl *)maskView
{
    CGFloat with =  self.bindCode.view.frame.size.width;
    CGFloat heigt = self.bindCode.view.frame.size.height;
    self.bindCode.view.frame = CGRectMake((1024-with)/2, (768-heigt)/2, with, heigt);
    
    [UIView animateWithDuration:0.35 animations:^{
        self.bindCode.view.frame = CGRectMake((1024-with)/2, self.viewController.view.height,with, heigt);
        [_maskControlView removeFromSuperview];
        _maskControlView = nil;
    } completion:^(BOOL finished) {
        
        [self.bindCode.view removeFromSuperview];
        self.bindCode.view = nil;
        
        [self.bindCode removeFromParentViewController];
        self.bindCode = nil;
    }];
}
//#pragma mark - Dlg_ChangePasswordViewControllerDelegate
//- (void)shutChangePassWordModelView
//{
//    [self maskControlView:nil];
//}



- (void)onBindSuccessed:(id)sender
{
    [self onDisplayView];
}

- (void)initView:(UIViewController *)parentView
{
    if(self.IsInited) return;
    
    [super initView:parentView];
    
    UserModel *um = [RusultManage shareRusultManage].userMode;
    
    //用户头像
    NSString *UserIconPath = [NSString stringWithFormat:@"%@/%@",BaseUserIconPath,um.IconUrl];
    [self.imgUserIcon sd_setImageWithURL:[NSURL URLWithString:UserIconPath] placeholderImage:[UIImage imageNamed:@"tou.png"]];
    
    //将头像处理为圆形
    [ZCControl circleImage:self.imgUserIcon];
    
    //用户昵称
    self.txtUserName.text = um.NickName;
    self.txtUserName.font = [UIFont systemFontOfSize:20.0f];
    self.txtUserName.textColor = rgb(95, 95, 95, 1.0);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBindSuccessed:) name:@"ON_BindCodeSuccess" object:nil];
    
    self.IsInited = YES;
}

- (void)onDisplayView
{    
    [[RusultManage shareRusultManage] LoadbindStudentCodeRusult:nil viewController:nil successData:^(NSDictionary *result)
    {
        [self displayBindCode:result];
    }];
}

- (void)displayBindCode:(NSDictionary *)result
{
    for (UIView *v in [self.scrollView subviews]) {
        [v removeFromSuperview];
    }
    
    NSArray *list = [result objectForKey:@"Data"];
    int i = 0;
    for (NSDictionary *info in list)
    {
        NSString *name = [info objectForKey:@"sCode"];
        NSString *labelName = [NSString stringWithFormat:@"学员号: %@",name];
        
        UILabel *l = [ZCControl createLabelWithFrame:CGRectMake(0,i*40, self.scrollView.width, 40) Font:18.0f Text:labelName];
        [l setTextAlignment:NSTextAlignmentCenter];
        l.textColor = rgb(95, 95, 95, 1.0);
        [self.scrollView addSubview:l];
        i++;
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, i*40);
    if (i*40+self.scrollView.top < 740) {
        self.scrollView.height = i*40;
    }else
    {
        self.scrollView.height = 740 - self.scrollView.top;
    }
}

@end
