//
//  XDFEexrciseDateViewController.m
//  IELTS
//
//  Created by 李牛顿 on 14-12-4.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFEexrciseDateViewController.h"
#import "XDFExerciseDetailTableViewCell.h"

#define kTopViewHeight 100
@interface XDFEexrciseDateViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *exerciseDateTableView;  //列表视图
@property (nonatomic,strong)UILabel *titleLable;  //标题
@property (nonatomic,strong)NSArray *dataArray;

@end

@implementation XDFEexrciseDateViewController
@synthesize exerciseDateTableView,dataArray,titleLable;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    //1.创建列表
    [self _initTopView];

    //2.创建顶部日期
    [self _initBeginView];
    
}

#pragma mark -处理数据
- (void)setOpenDate:(NSString *)openDate
{
    if (_openDate != openDate) {
        _openDate = openDate;
        [self _requestData:openDate];
    }
}

- (void)_requestData:(NSString *)dateString
{
    //弹出二级页面
    [[RusultManage shareRusultManage]exerciseDayRuslt:dateString
                                           Controller:nil
                                          successData:^(NSDictionary *result) {
                                              
                                              NSArray  *resultData = [result objectForKey:@"Data"];
                                              dataArray = resultData;
                                              [exerciseDateTableView reloadData];
                                              

                                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                                            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                                            NSDate *date = [dateFormatter dateFromString:dateString];
                                            NSString *titleDate = [ZCControl stringFromDate:date formate:@"MMMM dd,yyyy EEEE"]; // dd,yyyy EEEE
                                          
                                            titleLable.text = titleDate;

                                          }];

}
#pragma mark - 初始化视图
//创建表格
- (void)_initBeginView
{
    exerciseDateTableView = [[UITableView alloc]initWithFrame:CGRectMake(40, kTopViewHeight, kScreenWidth-kSecondLevelLeftWidth-80, kScreenHeight-kTopViewHeight) style:UITableViewStylePlain];
    exerciseDateTableView.delegate = self;
    exerciseDateTableView.dataSource = self;
    exerciseDateTableView.rowHeight = 90;
    exerciseDateTableView.showsVerticalScrollIndicator = NO;
    exerciseDateTableView.showsHorizontalScrollIndicator = NO;
    exerciseDateTableView.backgroundColor = [UIColor clearColor];
    exerciseDateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:exerciseDateTableView];
}
//初始化头部视图
- (void)_initTopView
{
    //创建背景视图
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-kSecondLevelLeftWidth, kTopViewHeight)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];

    //创建标题
    titleLable = [ZCControl createLabelWithFrame:CGRectMake((topView.width-300)/2, (kTopViewHeight-40)/2, 300, 40) Font:20 Text:@""];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.textColor = TABBAR_BACKGROUND_SELECTED;
    titleLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLable];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
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
    cell.exerType = ExerciseCellDate;
    cell.dataDic = dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NDLog(@"日期练习");
    NSDictionary *dataDic  =  dataArray[indexPath.row];
    

}



//初始化话页面大小
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //重新调整坐标
    CGFloat w = kScreenWidth- kSecondLevelLeftWidth;
    CGFloat h = kScreenHeight;
    self.view.frame = CGRectMake(0, 0, w, h);
}


@end
