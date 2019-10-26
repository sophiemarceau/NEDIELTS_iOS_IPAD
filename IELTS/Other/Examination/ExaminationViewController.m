//
//  ExaminationViewController.m
//  IELTS
//
//  Created by 李牛顿 on 14-11-12.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import "ExaminationViewController.h"
#import "XDFExaminaTableViewCell.h"
#import "SHLineGraphView.h"
#import "SHPlot.h"
#import "XDFResultViewController.h"
//#import "XDFExaminaTestViewController.h"
#import "XDFExaminaTestHome.h"
#import "XDFUpDataAnswers.h"

#define kTopViewHeight 300
@interface ExaminationViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray *testArray;  //卷子数据
@property (nonatomic,strong) UILabel *tagValue;  //目标分
@property (nonatomic,strong) UILabel *avgValue;  //平均分

@property (nonatomic,strong) SHLineGraphView *lineGraph ;
@property (nonatomic,strong) SHPlot *plot1;

@property (nonatomic,strong) UITableView *examTable;
@property (nonatomic,assign) BOOL hasNetWork;
@end

@implementation ExaminationViewController
@synthesize testArray,tagValue,avgValue,examTable;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hasNetWork = NO;
    //    self.dicData
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNoNewtWork_ object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(curentExaminNoNetWork) name:kNoNewtWork_ object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kHasNewtWork_ object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(curentExaminHasNetWork) name:kHasNewtWork_ object:nil];
    
    testArray = [[NSArray alloc]init];
    //1.topView
    [self _initTopView];
    //2.bottomView
    [self _initBottomView];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];;
}

- (void)curentExaminNoNetWork
{
    self.hasNetWork = NO;
}
- (void)curentExaminHasNetWork
{
    self.hasNetWork = YES;
//    [self checkLastAnswers];
}

#pragma mark 提交离线答案
- (void)checkLastAnswers
{
    NSString *uid = [UserModel LoadUserInfoFromLocal].UID;
    NSString *users = [NSString stringWithFormat:@"LastAnswers%@_",uid];
    if ([[XDFAnswersManage shardedAnswersManage]getLastAnswer:users] != nil) {
        NSDictionary *lastAnswers = [[XDFAnswersManage shardedAnswersManage]getLastAnswer:users];
        NSString *pidsAnswer = [lastAnswers objectForKey:@"pidsAnswer"];
        NSString *pid = [lastAnswers objectForKey:@"pid"];
        NSString *stid = [lastAnswers objectForKey:@"stid"];
        NSString *pidsTims = [lastAnswers objectForKey:@"pidsTims"];
        NSString *taskType = [lastAnswers objectForKey:@"staskType"];
        
        XDFUpDataAnswers *upData = [XDFUpDataAnswers shareUpDataAnswers];
        upData.stId = stid;
        upData.pId = pid;
        upData.taskType = taskType;
        [upData  upLoadAnwer:pidsAnswer times:pidsTims];
    }
}

/*
 {
 AssignCount = "<null>";
 AssignDate = "<null>";
 "CC_ID" = 110;
 "C_ID" = 17285;
 Catagory = "<null>";
 CreateTime = "<null>";
 ExTime = "<null>";
 Name = "<null>";          //标题
 NickName = "<null>";
 OpenDate = "2014-11-27";  //根据时间判断
 "P_ID" = "<null>";        //卷子的id
 PaperNumber = "<null>";
 RefID = 2;
 RoleId = "<null>";
 "ST_ID" = 9;
 Source = "<null>";
 SubjectiveIn = "<null>";
 "TF_ID" = "<null>";       //已完成的
 Target = "<null>";
 TaskType = 1;
 UID = "<null>";
 },

 */

//页面出现请求数据
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self _requestData];
}

#pragma mark - 请求数据
- (void)_requestData
{
    [[RusultManage shareRusultManage]examinationViewController:self
                                                   successData:^(NSDictionary *result) {
                                                        NSDictionary *dicData =   [result objectForKey:@"Data"];
                                                        [self _dealData:dicData];
                                                       
                                                        }];
    
    

}
#pragma mark - 处理数据
- (void)_dealData:(NSDictionary *)dicData
{
//------顶部
    
    NSArray *allksScore = [dicData objectForKey:@"allKsScoreList"];  //分数列表
    if (allksScore.count > 0) {
        NSMutableArray *times= [[NSMutableArray alloc]initWithCapacity:allksScore.count];
        NSMutableArray *scores= [[NSMutableArray alloc]initWithCapacity:allksScore.count];
        NSMutableArray *scoreValue = [[NSMutableArray alloc]initWithCapacity:allksScore.count];
        for (int i=0; i< allksScore.count; i++) {
            NSDictionary *scoreDic = allksScore[i];
            
            //包装成NSNumber
            NSNumber *number = [[NSNumber alloc]initWithInt:i+1];
            
            if (![[scoreDic objectForKey:@"TotalScore"] isKindOfClass:[NSNull class]]) {
                 NSString *totalScore =  [scoreDic objectForKey:@"TotalScore"];
                 NSNumber *scrNumber = [[NSNumber alloc]initWithFloat:[totalScore floatValue]];
                [scores addObject:@{number:scrNumber}];
                [scoreValue addObject:totalScore];
            }
            
            if (![[scoreDic objectForKey:@"CreateTime"] isKindOfClass:[NSNull class]] &&
                ![[scoreDic objectForKey:@"TotalScore"] isKindOfClass:[NSNull class]]) {
                
                 NSString *time = [scoreDic objectForKey:@"CreateTime"];
                 [times addObject:@{number:time}];
            }
        }
        

        _lineGraph.xAxisValues = times;
        _plot1.plottingValues = scores;
        _plot1.plottingPointsLabels = scoreValue;
    }


    //平均分
    if (![[dicData objectForKey:@"totalScoreAvg"] isKindOfClass:[NSNull class]]) {
         float avgScores = [[dicData objectForKey:@"totalScoreAvg"] floatValue];
         avgValue.text = [NSString stringWithFormat:@"平均分数: %.1f",avgScores];
    }else
    {
        avgValue.text = [NSString stringWithFormat:@"平均分数: 0.0"];
    }
    
    //设置目标分
    if (![[dicData objectForKey:@"myTargetScore"] isKindOfClass:[NSNull class]]) {
       float targScore = [[dicData objectForKey:@"myTargetScore"] floatValue];
        _lineGraph.tagertValue = targScore;
        tagValue.text = [NSString stringWithFormat:@"目标分数: %.1f",targScore];
    }else
    {
        tagValue.text = [NSString stringWithFormat:@"目标分数: 0.0"];
    }
    
    [_lineGraph addPlot:_plot1];

    [_lineGraph setupPlotView];
//-------底部
    testArray = [dicData objectForKey:@"MkMapList"];
    
//    [self upLoadLastAnswer:testArray];

    [examTable reloadData];
}

/*
 {
 AssignCount = "<null>";
 AssignDate = "<null>";
 "CC_ID" = "<null>";
 "C_ID" = 1233;
 Catagory = "<null>";
 CreateTime = "<null>";
 ExTime = "<null>";
 Name = "<null>";
 NickName = "<null>";
 OpenDate = "<null>";
 "P_ID" = "<null>";
 PaperNumber = "<null>";
 RefID = 2;
 RoleId = "<null>";
 "ST_ID" = 1037;
 Source = "<null>";
 SubjectiveIn = "<null>";
 "TF_ID" = "<null>";
 Target = "<null>";
 TaskType = 1;
 UID = "<null>";
 ifJieSuo = no;
 },
 */
//- (void)upLoadLastAnswer:(NSArray *)data
//{
//    NSString *uid = [UserModel LoadUserInfoFromLocal].UID;
//    if (data.count > 0) {
//        for (NSDictionary *dataDic in data) {
//            NSString *pid =  [dataDic objectForKey:@"P_ID"];
//            NSString *users = [NSString stringWithFormat:@"%@_%@",uid,pid];
//            if ([[XDFAnswersManage shardedAnswersManage]getLastAnswer:users] != nil) {
//                NSDictionary *dic = [[XDFAnswersManage shardedAnswersManage]getLastAnswer:users];
//                NSString *pidsAnswer =  [dic objectForKey:@"pidsAnswer"];
//                NSString *pidsTims = [dic objectForKey:@"pidsTims"];
////                [self upLoadAnwer:pidsAnswer times:pidsTims];
//                
//            }
//        }
//    }
//}


#pragma mark -初始化视图
- (void)_initTopView
{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-DEFAULT_TAB_BAR_HEIGHT,kTopViewHeight)];
    topView.backgroundColor = [UIColor whiteColor];
    
    //1.添加标题
    UILabel *titleLabel  = [ZCControl createLabelWithFrame:CGRectMake((topView.width-200)/2, 10, 200, 30) Font:20 Text:@"我的模考成绩"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    [topView addSubview:titleLabel];
    //2.添加目标分和评价分
    tagValue = [ZCControl createLabelWithFrame:CGRectMake(topView.width-140, titleLabel.bottom-20, 100, 30) Font:14 Text:@""];
    tagValue.textColor = [UIColor redColor];
    [topView addSubview:tagValue];
    
    avgValue = [ZCControl createLabelWithFrame:CGRectMake(topView.width-140, tagValue.bottom-15, 100, 30) Font:14 Text:@""];
    [topView addSubview:avgValue];

    
    
    //3.添加折线图
    _lineGraph = [[SHLineGraphView alloc] initWithFrame:CGRectMake(20, titleLabel.bottom, (topView.width-40), kTopViewHeight-titleLabel.bottom)];
    
    NSDictionary *_themeAttributes = @{
                                       kXAxisLabelColorKey : [UIColor lightGrayColor],//[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.4],
                                       kXAxisLabelFontKey : [UIFont fontWithName:@"TrebuchetMS" size:10],
                                       kYAxisLabelColorKey : [UIColor lightGrayColor], //[UIColor colorWithRed:0.48 green:0.48 blue:0.49 alpha:0.4],
                                       kYAxisLabelFontKey : [UIFont fontWithName:@"TrebuchetMS" size:10],
                                       kYAxisLabelSideMarginsKey : @20,
                                       kPlotBackgroundLineColorKye : [UIColor colorWithRed:0.48 green:0.48 blue:0.49 alpha:0.4]
                                       };
    _lineGraph.themeAttributes = _themeAttributes;
    _lineGraph.yAxisRange = @(9);
    _lineGraph.yAxisSuffix = @"";
    _lineGraph.tagertColor = [UIColor redColor];

    
    //create a new plot object that you want to draw on the `_lineGraph`
    _plot1 = [[SHPlot alloc] init];
    NSDictionary *_plotThemeAttributes = @{
                                           //                                         kPlotFillColorKey : [UIColor colorWithRed:0.47 green:0.75 blue:0.78 alpha:0.5],
                                           kPlotStrokeWidthKey : @1.5,
                                           kPlotStrokeColorKey : [UIColor lightGrayColor], //折线
                                           kPlotPointFillColorKey : [UIColor lightGrayColor], //圆点
                                           kPlotPointValueFontKey : [UIFont fontWithName:@"TrebuchetMS" size:18]
                                           };
    
     _plot1.plotThemeAttributes = _plotThemeAttributes;
    [_lineGraph addPlot:_plot1];
    //You can as much `SHPlots` as you can in a `SHLineGraphView`
    [topView addSubview:_lineGraph];
    
    [_lineGraph setupTheView];
    [self.view addSubview:topView];
}


#pragma mark -底部列表
- (void)_initBottomView
{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(100, kTopViewHeight , kScreenWidth-DEFAULT_TAB_BAR_HEIGHT-200,kScreenHeight-kTopViewHeight)];
    bottomView.backgroundColor = [UIColor clearColor];
    //1.创建列表
    examTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, bottomView.width, bottomView.height) style:UITableViewStylePlain];
    examTable.delegate = self;
    examTable.dataSource = self;
    examTable.showsHorizontalScrollIndicator = NO;
    examTable.showsVerticalScrollIndicator = NO;
    examTable.rowHeight = 90;
    examTable.backgroundColor = [UIColor clearColor];
    examTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [bottomView addSubview:examTable];
    [self.view addSubview:bottomView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return testArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *identify = @"identifyExamCell";
    XDFExaminaTableViewCell *cell = (XDFExaminaTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XDFExaminaTableViewCell" owner:self options:nil]lastObject];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.dataDic = testArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *pid = [[testArray[indexPath.row] objectForKey:@"P_ID"] stringValue];
    NSString *stid = [[testArray[indexPath.row] objectForKey:@"ST_ID"] stringValue];
    NSString *taskType = [[testArray[indexPath.row] objectForKey:@"TaskType"] stringValue];
    
    NSLog(@"%@",testArray[indexPath.row]);
    
    BOOL  stidStatus =  [[testArray[indexPath.row] objectForKey:@"Status"] boolValue];
    //判断是否完成
    NSString *finishPID = [NSString stringWithFormat:@"%@finish",pid];
    if (!self.hasNetWork) {
        [self.parentViewController.parentViewController.view makeToast:@"当前网络不可用,请检测网络。" duration:2.0 position:@"bottom"];
        return;
    }
    if (![kUserDefaults boolForKey:finishPID]) { //未完成
            //判断文件是否存在
            NSString *zipFloderPath = [[DownLoadManage ShardedDownLoadManage]useIDSelect:pid];  //文件夹
            if (zipFloderPath.length > 0) {
                
                if (!stidStatus) {
                    [[RusultManage shareRusultManage]tellServerTaskSTID:stid];
                }
                
                XDFExaminaTestHome *testController = [[XDFExaminaTestHome alloc]init];
                testController.pId = pid;  //试卷id
                testController.stId = stid;
                testController.taskType = taskType;
                testController.isChack = NO;
                testController.testTitles =  [testArray[indexPath.row] objectForKey:@"Name"];
                [self.parentViewController.parentViewController.navigationController pushViewController:testController animated:NO];
            }else
            {
                [[RusultManage shareRusultManage]tipAlert:@"正在下载模考试卷,请稍后再试!" viewController:self];
                return;
            }
    }else //完成
    {
        XDFResultViewController *result = [[XDFResultViewController alloc]init];
        result.dataDic = testArray[indexPath.row];
        [self.parentViewController.parentViewController.navigationController pushViewController:result animated:YES];
    }
}


@end
