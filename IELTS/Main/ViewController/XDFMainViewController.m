//
//  XDFMainViewController.m
//  IELTS
//
//  Created by 李牛顿 on 14-11-29.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFMainViewController.h"
#import "HomeViewController.h"
#import "ScheduleSecondViewController.h"
#import "MaterialsViewController.h"
#import "ExerciseViewController.h"
#import "ExaminationViewController.h"
#import "SystemViewController.h"

#import "BaseNavigationController.h"

#import "XDFDock.h"
#import "XDFTabItem.h"

@interface XDFMainViewController ()<XDFDockDelegate,HomeViewControllerDelegate,ExerciseViewControllerDelegate>
{
    UIView *_contentView;
}
@property (nonatomic,strong)XDFDock *dock;
@property (nonatomic,strong)SystemViewController *sysView;
@property (nonatomic,strong)NSString *changeTypes;
@property (nonatomic,strong)ScheduleSecondViewController *secondView;


@end

@implementation XDFMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //.跳转到账户管理通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeToUserInfo) name:@"changeToUserInfo" object:nil];
    //1.创建Dock
    [self _initDock];
    // 2.添加内容view
    _contentView = [[UIView alloc] init];
    CGFloat w = self.view.frame.size.width - kDockItemW;
    CGFloat h = self.view.frame.size.height;
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _contentView.frame = CGRectMake(kDockItemW, 20, w, h);
    [self.view addSubview:_contentView];

    //2.创建视图控制器
    [self _initViewController];
    

}
- (void)changeToUserInfo
{
    [self.sysView changeindexTabToUsesInfo];
}

- (void)_initDock
{
    XDFDock *dock = [[XDFDock alloc]init];
    dock.frame = CGRectMake(0, 20, 0, self.view.frame.size.height);
    dock.delegate = self;
    _dock = dock;
    [self.view addSubview:dock];

}
- (void)_initViewController
{
    //Create view controllers
    HomeViewController *home                = [[HomeViewController alloc]init];
    home.delegate = self;
    ScheduleSecondViewController *schedule  = [[ScheduleSecondViewController alloc]init];
    self.secondView = schedule;
    MaterialsViewController *mater          = [[MaterialsViewController alloc]init];
    ExerciseViewController *exercise        = [[ExerciseViewController alloc]init];
    exercise.delegate = self;
    ExaminationViewController *examination  = [[ExaminationViewController alloc]init];
    SystemViewController *system            = [[SystemViewController alloc]init];
    self.sysView = system;
    NSArray *controller = @[home,schedule,mater,exercise,examination,system];
    for (int i=0; i<controller.count; i++)
    {
        UIViewController * view = (UIViewController *)controller[i];
        BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:view];
        nav.navigationBarHidden = YES;
        [self addChildViewController:nav];
    }
    
    // 5.默认选中团购控制器
    [self dock:nil tabChangeFrom:0 to:0];

}

#pragma mark 点击了Dock上的某个标签
- (void)dock:(XDFDock *)dock tabChangeFrom:(NSInteger)from to:(NSInteger)to
{
    NDLog(@"from %ld--to---%ld",(long)from,(long)to);
    // 1.先移除旧的
    UIViewController *old = self.childViewControllers[from];
    [old.view removeFromSuperview];
    
    // 2.添加新的
    UIViewController *new = self.childViewControllers[to];
    new.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    new.view.frame = _contentView.bounds;
    [_contentView addSubview:new.view];
    
    [self performSelector:@selector(chengeIndexTab) withObject:self afterDelay:0.5];
}

- (void)chengeIndexTab
{
    if (kStringEqual(self.changeTypes, @"5"))
    {
        self.changeTypes = @"";
        [self.sysView changeindexTabToNews];
    }
    
    if (kStringEqual(self.changeTypes, @"6")) {
        self.changeTypes = @"";
        [self.sysView changeindexTabToTageter];
    }
}

#pragma mark -
#pragma mark - 首页页面跳转
- (void)homeTabChangeTo:(NSInteger)to typeString:(NSString *)types
{
    self.changeTypes = types;
    [_dock dockTabChangeTo:to];
}
#pragma mark - 练习页面跳转到日历
- (void)exerciseToPage:(NSInteger)index
{
    [_dock dockTabChangeTo:index];
}

@end
