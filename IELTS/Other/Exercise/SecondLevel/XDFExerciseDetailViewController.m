//
//  XDFExerciseDetailViewController.m
//  IELTS
//
//  Created by 李牛顿 on 14-12-2.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFExerciseDetailViewController.h"
#import "XDFExerciseDetailTableViewCell.h"

@interface XDFExerciseDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation XDFExerciseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.创建顶部标题
    [self _initTopArea];
    //2.创建页面列表
    [self _initList];
    
    //3.请求数据
    [self _initRequestData:self.typs];

}
#pragma mark-创建顶部标题
- (void)_initTopArea
{
    UIView *bgTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-kSecondLevelLeftWidth, 100)];
    bgTop.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgTop];
    //主标题
    UILabel *tipTitle = [ZCControl createLabelWithFrame:CGRectMake((bgTop.width-200)/2+40, 20, 200, 40) Font:28 Text:@"Listening"];
    tipTitle.textColor = TABBAR_BACKGROUND_SELECTED;
    [bgTop addSubview:tipTitle];
    //副标题
    UILabel *detailTitle = [ZCControl createLabelWithFrame:CGRectMake((bgTop.width-200)/2+40, tipTitle.bottom-10, 300, 30) Font:18 Text:@"任务完成度:18/25"];
    [bgTop addSubview:detailTitle];
    
    //头像
    UIImageView *imageViews = [[UIImageView alloc]initWithImage:[ZCControl createImageWithColor:[UIColor lightGrayColor]]];
    imageViews.frame = CGRectMake((bgTop.width-200)/2-40, (bgTop.height-60)/2, 60, 60);
    [ZCControl circleImage:imageViews];
    [bgTop addSubview:imageViews];
    
}
#pragma mark-创建页面列表
- (void)_initList
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(40, 100, kScreenWidth-kSecondLevelLeftWidth-80, kScreenHeight-100) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 90;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];

}
#pragma mark-请求数据
- (void)_initRequestData:(NSString *)types
{
    [[RusultManage shareRusultManage]exerciseTypeRuslt:types
                                           Controller:self
                                          successData:^(NSDictionary *result) {
                                              NDLog(@"%@",result);
    }];
}

- (void)setTyps:(NSString *)typs
{
    if (_typs != typs) {
        _typs = typs;
        [self _initRequestData:typs];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 25;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indetify = @"cellIndetifyDetail";
    XDFExerciseDetailTableViewCell *cell = (XDFExerciseDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:indetify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XDFExerciseDetailTableViewCell" owner:self options:nil]lastObject];
        cell.height = 90;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //重新调整坐标
    CGFloat w = kScreenWidth- kSecondLevelLeftWidth;
    CGFloat h = kScreenHeight;
    self.view.frame = CGRectMake(0, 0, w, h);
}




@end
