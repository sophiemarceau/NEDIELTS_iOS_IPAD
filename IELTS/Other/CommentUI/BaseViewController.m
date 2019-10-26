//
//  BaseViewController.m
//  IELTS
//
//  Created by 李牛顿 on 14-11-12.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@property(nonatomic,assign)BOOL isBackButton;
@property(nonatomic,assign)BOOL isModelButton;//判断模态


@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self  = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.isBackButton = YES;
        self.isModelButton = NO;

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1];
    
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
//    view.backgroundColor = TABBAR_BACKGROUND;
//    [self.view addSubview:view];


    //导航控制器子控制器的个数
    NSUInteger count = self.navigationController.viewControllers.count;
    if ((self.isBackButton && count > 1) || self.isModelButton) {
       UIButton *button = [ZCControl createButtonWithFrame:CGRectMake(0, 0, 64, 44) ImageName:@"titlebar_button_back_9.png" Target:self Action:@selector(backAction) Title:@"返回"];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = backItem;
    }
}


- (void)backAction
{
    if (self.isModelButton)  //是模态就dismiss 其余默认为pop
    {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)addContentView:(UIView *)view
{
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight)];
    contentView.backgroundColor = [UIColor clearColor];
    [contentView addSubview:view];
    [self.view addSubview:contentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
