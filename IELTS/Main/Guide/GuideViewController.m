//
//  GuideViewController.m
//  IELTS
//
//  Created by 李牛顿 on 14-11-12.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import "GuideViewController.h"
#import "XDFGuideView1.h"
#import "XDFGuideView2.h"
#import "XDFGuideView3.h"
#import "XDFGuideView4.h"
#import "XDFGuideView6.h"

#import "LogonViewController.h"

#define kWidth 1024
#define kHeight 768
#define kTopHeight 145

@interface GuideViewController ()<UIScrollViewDelegate,XDFGuideView1Delegate,XDFGuideView2Delegate,XDFGuideView4Delegate,XDFGuideView6Delegate>
{
    UIScrollView *sv;
}

@end

@implementation GuideViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.\
    
    //隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    UIImageView *topView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kTopHeight)];
    topView.image = [UIImage imageNamed:@"title.png"];
    [self.view addSubview:topView];
    
    XDFGuideView1 *guideView1 = [[[NSBundle mainBundle]loadNibNamed:@"XDFGuideView1" owner:self options:nil]lastObject];
    guideView1.delegate = self;
    XDFGuideView2 *guideView2 = [[[NSBundle mainBundle]loadNibNamed:@"XDFGuideView2" owner:self options:nil]lastObject];
    guideView2.delegate = self;
    XDFGuideView3 *guideView3 = [[[NSBundle mainBundle]loadNibNamed:@"XDFGuideView3" owner:self options:nil]lastObject];
    XDFGuideView4 *guideView4 = [[[NSBundle mainBundle]loadNibNamed:@"XDFGuideView4" owner:self options:nil]lastObject];
    guideView4.delegate = self;
    XDFGuideView6 *guideView6 = [[[NSBundle mainBundle]loadNibNamed:@"XDFGuideView6" owner:self options:nil]lastObject];
    guideView6.delegate = self;
    
    NSArray *guideImages = @[guideView1,
                             guideView2,
                             guideView3,
                             guideView4,
                             guideView6
                             ];
    sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0,kTopHeight, kWidth, kHeight-kTopHeight)];
    sv.showsHorizontalScrollIndicator = NO;
    sv.showsVerticalScrollIndicator = NO;
    sv.bounces = NO;
    sv.contentSize = CGSizeMake(kWidth*guideImages.count, kHeight-kTopHeight);
    sv.delegate = self;
    sv.pagingEnabled = YES;
    [self.view addSubview:sv];
    
    for (int i = 0; i < guideImages.count; i++) {
        UIView *guideName = (UIView *)guideImages[i];
        guideName.frame = CGRectMake(kWidth*i, 0, kWidth, kHeight-kTopHeight);
        [sv addSubview:guideName];
    }
}

#define make - 页面deleget
//引导页第一页，点击跳过进入首页delegate
- (void)clickSkipeAction
{
    [self inLogonPage];
}

//引导页第二页，点击按钮跳到下一个页面
- (void)typeButtonAction
{
    CGPoint p = CGPointMake(2*kWidth, 0);
    //通过修改偏移量滚动视图
    [sv setContentOffset:p animated:YES];
}
//引导页第二页，点击按钮跳到下一个页面
- (void)timeUndetermine
{
    CGPoint p = CGPointMake(4*kWidth, 0);
    //通过修改偏移量滚动视图
    [sv setContentOffset:p animated:YES];
}

//引导页第五页，点击开始进入首页delegate
- (void)startStudyAction
{
    [self inLogonPage];
}


#define  mark - 进入登陆页面
- (void)inLogonPage
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINMainTab" object:nil];
    
//    [[UIApplication sharedApplication]setStatusBarHidden:NO];
//    //    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    LogonViewController *main = [[LogonViewController alloc] initWithNibName:@"LogonViewController" bundle:nil];;
//    /*
//     如果视图view直接或间接的显示在window上,则通过view.window能获取到window对象
//     */
//    self.view.window.rootViewController = main;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
@end
