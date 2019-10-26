//
//  XDFNoReadMessageViewController.m
//  IELTS
//
//  Created by 李牛顿 on 15-1-4.
//  Copyright (c) 2015年 Newton. All rights reserved.
//

#import "XDFNoReadMessageViewController.h"

#define kTopViewHeight 70
@interface XDFNoReadMessageViewController ()

@end

@implementation XDFNoReadMessageViewController

/*
 {
 "MState" : 1,
 "Title" : "H 123",
 "Account" : "admin1",
 "Body" : " 肉体华仁堂",
 "MI_ID" : 3033,
 "MR_ID" : 3040,
 "CreateTime" : 1419572801000,
 "AssignRoleID" : 3
 }
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = rgb(230, 230, 230, 1);
    NSLog(@"%f",self.view.frame.size.width
          );
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //顶部
    [self topView_];
    //内容
    [self contentView_];
}

//顶部视图
- (void)topView_
{
    UIView *viewsTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0,540, kTopViewHeight)];
    viewsTop.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewsTop];
 
    //创建返回按钮
    UIButton *backButton = [ZCControl createButtonWithFrame:CGRectMake(0, (viewsTop.height-35)/2, 80, 35) ImageName:@"" Target:self Action:@selector(backACtion:) Title:@"返回"];
    [viewsTop addSubview:backButton];
    
    //创建标题
    NSString *title = [self.dataDic objectForKey:@"Title"];
    UILabel *titleLabel = [ZCControl createLabelWithFrame:CGRectMake((viewsTop.width-300)/2, (viewsTop.height-50)/2, 300, 50) Font:20.0f Text:title];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = TABBAR_BACKGROUND_SELECTED;
    [viewsTop addSubview:titleLabel];
}
//内容视图
- (void)contentView_
{
    //内容背景视图
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, kTopViewHeight+2, 540, self.view.height-kTopViewHeight+20)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    //内容
    NSString *body = [self.dataDic objectForKey:@"Body"];
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, contentView.width, contentView.height)];
    textView.text = body;
    textView.font = [UIFont systemFontOfSize:18.0f];
    textView.editable = NO;
    [contentView addSubview:textView];
    
}

//返回
- (void)backACtion:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
