//
//  XDFDock.m
//  IELTS
//
//  Created by 李牛顿 on 14-11-29.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFDock.h"
#import "XDFTabItem.h"

#import "NetworkManager.h"
#import "RusultManage.h"
#import "UIImageView+WebCache.h"

@interface XDFDock()
{
    XDFTabItem *_selectedItem;
}
@end
@implementation XDFDock
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.自动伸缩(高度 + 右边间距)
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
        
        // 2.设置背景
        self.backgroundColor = TABBAR_BACKGROUND;
        
        // 3.添加头像
        [self addHead];
        
        // 4.添加选项标签
        [self addTabs];
  }
    return self;
}

#pragma mark 添加选项标签
- (void)addTabs
{
    NSArray *title = @[@"首页",@"计划",@"学习",@"练习",@"模考",@"设置"];
    for (int i=0; i< title.count; i++) {
        
        NSString *normalImg = [NSString stringWithFormat:@"tab_%d.png",i+1];
        NSString *selectImg = [NSString stringWithFormat:@"tab_%d_1.png",i+1];
        
        [self addOneTab:normalImg selectedIcon:selectImg index:i+1 titleItem:title[i]];
    }
}

- (void)addOneTab:(NSString *)icon selectedIcon:(NSString *)selectedIcon index:(int)index  titleItem:(NSString *)item
{
    XDFTabItem *tab = [[XDFTabItem alloc] init];
    [tab setIcon:icon selectedIcon:selectedIcon];
    tab.titleItems = item;
    tab.frame = CGRectMake(0, kDockItemH * 0.7 * index+100, 0, 0);
    [tab addTarget:self action:@selector(tabClick:) forControlEvents:UIControlEventTouchDown];
    tab.tag = index - 1;
    
    [self addSubview:tab];
    
    if (index == 1) {
        [self tabClick:tab];
    }
}
#pragma mark 跳转页面控制
- (void)dockTabChangeTo:(NSInteger)to
{
    XDFTabItem *tab = (XDFTabItem *)[self viewWithTag:to];
    [self tabClick:tab];
}

#pragma mark 监听tab点击
- (void)tabClick:(XDFTabItem *)tab
{
    // 0.通知代理
    if ([_delegate respondsToSelector:@selector(dock:tabChangeFrom:to:)]) {
        [_delegate dock:self tabChangeFrom:_selectedItem.tag to:tab.tag];
    }
    
    // 1.控制状态
    _selectedItem.enabled = YES;
    tab.enabled = NO;
    _selectedItem = tab;
}

#pragma mark 添加头像
- (void)addHead
{    
    UserModel *um = [RusultManage shareRusultManage].userMode;
    //用户头像
    self.UserIconImg = [[UIImageView alloc] initWithFrame:CGRectMake((kDockItemW-75)/2, 30, 75, 75)];
    NSString *UserIconPath = [NSString stringWithFormat:@"%@/%@",BaseUserIconPath,um.IconUrl];
    [self.UserIconImg sd_setImageWithURL:[NSURL URLWithString:UserIconPath] placeholderImage:[UIImage imageNamed:@"tou.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
     }];
    [ZCControl circleImage:self.UserIconImg];
    self.UserIconImg.userInteractionEnabled = YES;
    [self addSubview:self.UserIconImg];
    
    //点击头像跳转
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeViewController)];
    [self.UserIconImg addGestureRecognizer:tap];
    
    //用户名称
    UILabel *lusername = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                   0,
                                                                   self.UserIconImg.frame.origin.y+self.UserIconImg.frame.size.height,
                                                                   kDockItemW,
                                                                   40)];
    [lusername setText:um.NickName];
    [lusername setTextColor:[UIColor whiteColor]];
    [lusername setTextAlignment:NSTextAlignmentCenter];
    [lusername setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:lusername];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUserIconUpdate object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserIconUpdate:) name:kUserIconUpdate object:nil];
}

//控制器跳转
- (void)changeViewController
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeToUserInfo" object:nil];
    [self dockTabChangeTo:5];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUserIconUpdate object:nil];
    NDLog(@"kUserIconUpdateDealloc");
}

- (void)onUserIconUpdate:(NSNotification *)notifi
{
    UserModel *um = [RusultManage shareRusultManage].userMode;
    NSString *UserIconPath = [NSString stringWithFormat:@"%@/%@",BaseUserIconPath,um.IconUrl];
    [self.UserIconImg sd_setImageWithURL:[NSURL URLWithString:UserIconPath] placeholderImage:[UIImage imageNamed:@"tou.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
     }];
}


#pragma mark 重写setFrame方法：内定自己的宽度
- (void)setFrame:(CGRect)frame
{
    frame.size.width = DEFAULT_TAB_BAR_HEIGHT;
    frame.size.height = kScreenHeight;
    [super setFrame:frame];
}

@end
