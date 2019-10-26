//
//  BaseSecondViewController.m
//  IELTS
//
//  Created by 李牛顿 on 14-11-29.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import "BaseSecondViewController.h"


#define  kScaleFloat 0.7
@interface BaseSecondViewController ()

@property (nonatomic,strong)UIView *contentView;

@end

@implementation BaseSecondViewController
@synthesize starButton,leftView_;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    //1.创建左边栏
    [self _initLeftView];
    //2.创建右边栏
    [self _initRightView];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

}

#pragma mark-左边栏
- (void)_initLeftView
{
    //左边   btn_back.png 93 × 43   arraw_Left.png 86*86 arraw_Right.png
    leftView_ = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kSecondLevelLeftWidth, kScreenHeight)];
    leftView_.backgroundColor = TABBAR_BACKGROUND;
    
    //返回按钮 93/2, 43/2
    CGFloat backW = 93*kScaleFloat;
    CGFloat backH = 43*kScaleFloat;
    
    UIButton *backButton = [ZCControl createButtonWithFrame:CGRectMake((kSecondLevelLeftWidth-backW)/2, 30, backW, backH) ImageName:@"" Target:self Action:@selector(backAction:) Title:@""];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];

    [leftView_ addSubview:backButton];
    
    //收藏按钮 star.png 47*44
    CGFloat starW = 47*kScaleFloat;
    CGFloat starH = 44*kScaleFloat;
    
    //后退按钮
    CGFloat beforeW = 86*kScaleFloat;
    CGFloat beforeH = 86*kScaleFloat;

    
    starButton = [ZCControl createButtonWithFrame:CGRectMake((kSecondLevelLeftWidth-starW)/2, kScreenHeight-beforeW*3-60, starW, starH)ImageName:@"" Target:self Action:@selector(starAction:) Title:@""];
    [starButton setBackgroundImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
    [starButton setBackgroundImage:[UIImage imageNamed:@"star-1.png"] forState:UIControlStateSelected];
    [leftView_ addSubview:starButton];

    

    UIButton *beforeButton = [ZCControl createButtonWithFrame:CGRectMake((kSecondLevelLeftWidth-beforeW)/2, kScreenHeight-beforeW*2-60, beforeW, beforeH)ImageName:@"" Target:self Action:@selector(leftAction:) Title:@""];
    [beforeButton setBackgroundImage:[UIImage imageNamed:@"arraw_Left.png"] forState:UIControlStateNormal];
    beforeButton.tag = 100;
    [leftView_ addSubview:beforeButton];
    
    //前进按钮
    UIButton *nextButton = [ZCControl createButtonWithFrame:CGRectMake((kSecondLevelLeftWidth-beforeW)/2, kScreenHeight- beforeW-40, beforeH, beforeH) ImageName:@"" Target:self Action:@selector(rightAction:) Title:@""];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"arraw_Right.png"] forState:UIControlStateNormal];
    nextButton.tag = 101;
    [leftView_ addSubview:nextButton];

    [self.view addSubview:leftView_];
}

//返回
- (void)backAction:(UIButton *)button
{    
    [self dismissViewControllerAnimated:YES completion:nil];
}
//后退
- (void)leftAction:(UIButton *)button
{
    NDLog(@"后退");
}
//前进
- (void)rightAction:(UIButton *)button
{
    NDLog(@"前进");
}
//收藏
- (void)starAction:(UIButton *)button
{
    button.selected = !button.selected;

}
#pragma mark-右边栏
-(void)_initRightView
{
    _contentView = [[UIView alloc]init];
    _contentView.backgroundColor = [UIColor clearColor];
    CGFloat w = kScreenWidth- kSecondLevelLeftWidth;
    CGFloat h = kScreenHeight;
    
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _contentView.frame = CGRectMake(kSecondLevelLeftWidth, 20, w, h);
    [self.view addSubview:_contentView];
}

//添加内容
- (void)addContentViewController:(UIViewController *)viewController
{
    viewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    viewController.view.frame = _contentView.bounds;
    viewController.view.backgroundColor = rgb(230, 230, 230, 1);
    [_contentView addSubview:viewController.view];
}






@end
