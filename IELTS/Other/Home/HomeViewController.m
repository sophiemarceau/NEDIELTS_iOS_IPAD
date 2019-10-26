//
//  HomeViewController.m
//  IELTS
//
//  Created by 李牛顿 on 14-11-12.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeNewsView.h"
#import "RMDownloadIndicator.h"
#import "HomeDayPlanView.h"
#import "MaterialContentViewController.h"

#import "XDFDownLoadViewController.h"
#import "DateUtil.h"
#import "XDFUpDataAnswers.h"

//#import "XDFTryRecordViewController.h"

#define kLeftViewWidth  325
#define delayIn 0.3

@interface HomeViewController ()<HomeNewViewDelegate>
{
    UIView *viewLeft;
    UIView *viewRight;
  
}

@property (strong, nonatomic) UIView *homePlan;

@property (strong, nonatomic) RMDownloadIndicator *closedIndicator1;
@property (strong, nonatomic) RMDownloadIndicator *closedIndicator2;
@property (strong, nonatomic) RMDownloadIndicator *closedIndicator3;
@property (strong, nonatomic) RMDownloadIndicator *closedIndicator4;

@property (assign, nonatomic)CGFloat downloadedBytes;
@property (assign, nonatomic)CGFloat downloadedBytes2;
@property (assign, nonatomic)CGFloat downloadedBytes3;
@property (assign, nonatomic)CGFloat downloadedBytes4;

//圆环进度
@property (nonatomic,assign)CGFloat kcProgress;
@property (nonatomic,assign)CGFloat lxProgress;
@property (nonatomic,assign)CGFloat mkProgress;
@property (nonatomic,assign)CGFloat xxProgress;


//任务数据
@property (nonatomic,strong)NSDictionary *taskData;

//任务区
@property (nonatomic,strong)HomeDayPlanView *homeTask;
//消息区
@property (nonatomic,strong)HomeNewsView *news ;
@property (nonatomic,strong)NSArray *newsData ;

//设置考试时间
@property (nonatomic,strong)UILabel *setTime;

@property (nonatomic,assign)BOOL isFinishProgress;
@property (nonatomic,assign)BOOL isFinishTask;
@property (nonatomic,assign)BOOL isFinishDownList;


@end

@implementation HomeViewController
@synthesize homePlan;
@synthesize isFinishDownList,isFinishProgress,isFinishTask;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [self _initData];
    isFinishProgress = NO;
    isFinishTask = NO;
    isFinishDownList = NO;
    
    
    [self _initLeftView];
    
    [self _initRightView];

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

//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNoNewtWork_ object:nil];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:kHasNewtWork_ object:nil];
//}

////无网退出登陆。
//- (void)noNetWork:(NSNotification *)notifucation
//{
//    [[XDFUpDataAnswers shareUpDataAnswers]tuichuApp];
//}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
//}
//

//此处得刷新数据
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //请求数据
    [self _initData];
    //提交上次一次的答案
    [self checkLastAnswers];
}

- (void)_initData
{
    //进度条
    __block HomeViewController *this = self;
    if (!isFinishProgress) {
        isFinishProgress = YES;
        [[RusultManage shareRusultManage]completeRateviewController:self
                                                        successData:^(NSDictionary *result) {
                                                            NSDictionary *proDataDic = [result objectForKey:@"Data"];
                                                            this.kcProgress = [[proDataDic objectForKey:@"kc"]floatValue];
                                                            this.lxProgress = [[proDataDic objectForKey:@"lx"]floatValue];
                                                            this.mkProgress = [[proDataDic objectForKey:@"mk"]floatValue];
                                                            this.xxProgress = [[proDataDic objectForKey:@"xx"]floatValue];
                                                            
                                                            if (![[proDataDic objectForKey:@"ksTime"] isKindOfClass:[NSNull class]]) {
                                                                NSString  *ksTime = [[proDataDic objectForKey:@"ksTime"] stringValue];
                                                                if (ksTime.length > 0) {
                                                                    self.setTime.text = [NSString stringWithFormat:@"距离考试还有%@天",ksTime];
                                                                    self.setTime.userInteractionEnabled = NO;
                                                                }else
                                                                {
                                                                    self.setTime.text = [NSString stringWithFormat:@"点击设置考试日期"];
                                                                    self.setTime.userInteractionEnabled = YES;
                                                                }
                                                            }
                                                            //圆环
                                                            [this startAnimation];
                                                            
                                                            isFinishProgress = NO;
                                                            
                                                        } errorData:^(NSError *error) {
                                                            
                                                            self.setTime.text = [NSString stringWithFormat:@"点击设置考试日期"];
                                                            self.setTime.userInteractionEnabled = YES;

                                                            isFinishProgress = NO;
                                                        }];
    }

    
    //我的任务
    if (!isFinishTask) {
        isFinishTask = YES;
        [self showHudInView:self.view hint:@"Loading ..."];
        [[RusultManage shareRusultManage]myTaskListRusult:nil
                                           viewController:self
                                              successData:^(NSDictionary *result) {
                                                  if ([[result objectForKey:@"Result"]boolValue]) {
                                                      NSDictionary *taskDataDic = [result objectForKey:@"Data"];
                                                      this.taskData = taskDataDic;
                                                      isFinishTask = NO;
                                                  }
                                                  [self hideHud];
                                              } errorData:^(NSError *error) {
                                                  isFinishTask = NO;
                                                  [self hideHud];
                                              }];

    }
    
//    //请求下载列表
//    if (!isFinishDownList) {
//        isFinishDownList = YES;
//    }
    
    [[RusultManage shareRusultManage]sysDownLoadController:nil
                                               SuccessData:^(NSDictionary *result) {
                                                   NDLog(@"%@",result);
//                                                   isFinishDownList = NO;
                                                   NSArray *loadArray = [result objectForKey:@"Data"];
                                                   [[XDFDownLoadViewController shardedDownLoadManage]_initData:loadArray];
                                               } errorData:^(NSError *error) {
//                                                   isFinishDownList = NO;
                                               }];
    
    if (_news != nil) {
        [_news startReloadData];
    }
}



/*
 @"pidsAnswer":pidsAnswer,
 @"pidsTims":times,
 @"pid":pId,
 @"stid":stID};
 */


#pragma mark -
#pragma mark - 左边视图
- (void)_initLeftView
{
    viewLeft = [ZCControl viewWithFrame:CGRectMake(9,9, kLeftViewWidth, kScreenHeight-18)];
    viewLeft.backgroundColor = [UIColor clearColor];
    viewLeft.layer.borderColor = [UIColor clearColor].CGColor;
    viewLeft.layer.borderWidth = 1;
    viewLeft.layer.cornerRadius = 5;
    viewLeft.layer.masksToBounds = YES;
    
    [self.view addSubview:viewLeft];
#pragma mark -第一部分
    UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kLeftViewWidth, 119/2)];
    firstView.backgroundColor = TABBAR_BACKGROUNDLight;
    //时间label
    NSString *year = [DateUtil getCurrentYear];
    int month =[[DateUtil getCurrentMonth] integerValue];
    NSString *date = [DateUtil getCurrentDate];
    
    NSString *weekdays = [ZCControl stringFromDate:[NSDate date] formate:@"EEEE"];
    NSInteger windex = [self identifyWeek:weekdays];
    if (windex == 8) {
        weekdays = weekdays;
    }else
    {
        weekdays = [DateUtil get2DayString:windex];
    }
    NSString *months;
    if (month > 0) {
        months =  [DateUtil get2MonthString:month-1];
    }
    NSString *dateString = [NSString stringWithFormat:@"%@ %@, %@       %@",months,date,year,weekdays];
    UILabel *timeLabel = [ZCControl createLabelWithFrame:CGRectMake(18, 4, viewLeft.width-20, 35) Font:24.0f Text:dateString];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    [firstView addSubview:timeLabel];
    
    //设置考试时间
    UILabel *setTime = [ZCControl createLabelWithFrame:CGRectMake(18, timeLabel.bottom-10, viewLeft.width-20, 30) Font:18.0f Text:@"点击设置考试日期"];
    setTime.textColor = [UIColor whiteColor];
    setTime.userInteractionEnabled = YES;
    self.setTime = setTime;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setTestTime:)];
    [setTime addGestureRecognizer:tap];
    [firstView addSubview:setTime];
    
    //设置分割线
//    UILabel *line=  [ZCControl createLabelLineFrame:CGRectMake(0, setTime.bottom, viewLeft.width, 0.5)];
//    [firstView addSubview:line];
    [viewLeft addSubview:firstView];
    
#pragma mark -第二部分
    homePlan= [[UIView alloc]initWithFrame: CGRectMake(0, 0, viewLeft.width, 315)];
    homePlan.top = firstView.bottom;
    homePlan.backgroundColor = [UIColor whiteColor];
    homePlan.layer.borderColor = [UIColor clearColor].CGColor;
    homePlan.layer.borderWidth = 1;
    homePlan.layer.cornerRadius = 5;
    homePlan.layer.masksToBounds = YES;
    [viewLeft addSubview:homePlan];
    
    UIButton *button =  [ZCControl createButtonWithFrame:CGRectMake((viewLeft.width-150)/2, 261, 150, 40) ImageName:@"btn2_blank.png" Target:self Action:@selector(testAction:) Title:@"考前预测"];
     button.enabled = NO;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [homePlan addSubview:button];
    
//    UILabel *line2=  [ZCControl createLabelLineFrame:CGRectMake(0, homePlan.bottom, viewLeft.width, 0.5)];
//    [viewLeft addSubview:line2];
    
#pragma mark -第三部分
    _news = [[HomeNewsView alloc]initWithFrame:CGRectMake(0, homePlan.bottom+5, viewLeft.width, kScreenHeight-homePlan.bottom-20-5)];
    _news.backgroundColor = [UIColor whiteColor];
    _news.layer.borderColor = [UIColor clearColor].CGColor;
    _news.layer.borderWidth = 1;
    _news.layer.cornerRadius = 5;
    _news.layer.masksToBounds = YES;
    _news.delegate = self;
    [viewLeft addSubview:_news];
}

- (NSInteger)identifyWeek:(NSString *)moth
{
    NSArray *months = @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"];
    if ([months containsObject:moth]) {
        NSInteger index = [months indexOfObject:moth];
        return index;
    }
    return 8;
}

//考前预测
- (void)testAction:(UIButton *)button
{
    [[RusultManage shareRusultManage]tipAlert:@"未确定外部连接,暂不提供该功能。"];
//    MaterialContentViewController *mater = [[MaterialContentViewController alloc]init];
//    mater.urlPath = @"http://yunku.gokuai.com/file/c93px21h";
//    [self presentViewController:mater animated:YES completion:nil];
}

//顶部设置时间
- (void)setTestTime:(UITapGestureRecognizer *)tap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeTabChangeTo:typeString:)]) {
//        [self.delegate homeTabChangeTo:5];
        [self.delegate homeTabChangeTo:5 typeString:@"6"];
    }
    NDLog(@"设置考试时间");
}
#pragma mark -消息代理
- (void)selectMessageType:(NSString *)type
{
    /*
     * 1. 课程当天提醒，【每一课】一条消息
     * 2. 考试为学生自定义时间，前一天+当天提醒
     * 3. 留学申请当天提醒
     * 4. 资料只提醒老师分配到班号但未指定课次的内容(前三天老师上传的资料)
     * 5. 所有未读的系统消息
     */
    
    NSInteger pageIndex;
    if ([type isEqualToString:@"1"]) {
        pageIndex = 1;
    }else if ([type isEqualToString:@"2"])  //考试时间
    {
        pageIndex = 1;
    }else if ([type isEqualToString:@"3"])  //留学申请时间
    {
        pageIndex = 1;
    }
    else if ([type isEqualToString:@"4"])   
    {
        pageIndex = 2;
    }
    else if ([type isEqualToString:@"5"])   //未读消息
    {
        pageIndex = 5;
    }else
    {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeTabChangeTo:typeString:)]) {
        [self.delegate homeTabChangeTo:pageIndex typeString:type];
    }
}

#pragma mark -
#pragma mark - 圆环 Views
- (void)startAnimation
{
    [self addDownloadIndicators];
    
    self.downloadedBytes = 0;
    self.downloadedBytes2 = 0;
    self.downloadedBytes3 = 0;
    self.downloadedBytes4 = 0;
    
    
    typeof(self) __weak weakself = self;
    
    double delayInSeconds1 = delayIn;
    dispatch_time_t popTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds1 * NSEC_PER_SEC));
    dispatch_after(popTime1, dispatch_get_main_queue(), ^(void){
        [weakself updateView:weakself.kcProgress];
    });
    
    double delayInSeconds2 = delayIn;
    dispatch_time_t popTime2 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds2 * NSEC_PER_SEC));
    dispatch_after(popTime2, dispatch_get_main_queue(), ^(void){
        [weakself updateView2:weakself.lxProgress];
    });
    
    double delayInSeconds3 = delayIn;
    dispatch_time_t popTime3 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds3 * NSEC_PER_SEC));
    dispatch_after(popTime3, dispatch_get_main_queue(), ^(void){
        [weakself updateView3:weakself.mkProgress];
    });
    
    double delayInSeconds4 = delayIn;
    dispatch_time_t popTime4 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds4 * NSEC_PER_SEC));
    dispatch_after(popTime4, dispatch_get_main_queue(), ^(void){
        [weakself updateView4:weakself.xxProgress];
    });
}

- (void)addDownloadIndicators
{
    [_closedIndicator1 removeFromSuperview];
    _closedIndicator1 = nil;
    [_closedIndicator2 removeFromSuperview];
    _closedIndicator2 = nil;
    [_closedIndicator3 removeFromSuperview];
    _closedIndicator3 = nil;
    [_closedIndicator4 removeFromSuperview];
    _closedIndicator4 = nil;
    
    
    RMDownloadIndicator *closedIndicator1 = [[RMDownloadIndicator alloc]initWithFrame:CGRectMake((viewLeft.width/2-kClosedIndicatorWidth)/2, 15, kClosedIndicatorWidth, kClosedIndicatorWidth) type:kRMClosedIndicator];
    [closedIndicator1 setBackgroundColor:[UIColor whiteColor]];
    [closedIndicator1 setFillColor:kIndicatorColor];
    [closedIndicator1 setStrokeColor:kIndicatorColorPro];
    [closedIndicator1 setTitleLabelText:@"课程"];
    
    [homePlan addSubview:closedIndicator1];
    
    [closedIndicator1 loadIndicator];
    _closedIndicator1 = closedIndicator1;
    
    RMDownloadIndicator *closedIndicator2 = [[RMDownloadIndicator alloc]initWithFrame:CGRectMake((viewLeft.width/2-kClosedIndicatorWidth)/2+viewLeft.width/2, 15, kClosedIndicatorWidth, kClosedIndicatorWidth) type:kRMClosedIndicator];
    [closedIndicator2 setBackgroundColor:[UIColor whiteColor]];
    [closedIndicator2 setFillColor:kIndicatorColor];
    [closedIndicator2 setStrokeColor:kIndicatorColorPro];
    [closedIndicator2 setTitleLabelText:@"练习"];
    [homePlan addSubview:closedIndicator2];
    
    [closedIndicator2 loadIndicator];
    _closedIndicator2 = closedIndicator2;
    
    RMDownloadIndicator *closedIndicator3 = [[RMDownloadIndicator alloc]initWithFrame:CGRectMake((viewLeft.width/2-kClosedIndicatorWidth)/2, (viewLeft.width/2-kClosedIndicatorWidth)/2+viewLeft.width/2, kClosedIndicatorWidth, kClosedIndicatorWidth) type:kRMClosedIndicator];
    [closedIndicator3 setBackgroundColor:[UIColor whiteColor]];
    [closedIndicator3 setFillColor:kIndicatorColor];
    [closedIndicator3 setStrokeColor:kIndicatorColorPro];
    [closedIndicator3 setTitleLabelText:@"模考"];
    [homePlan addSubview:closedIndicator3];
    
    [closedIndicator3 loadIndicator];
    _closedIndicator3 = closedIndicator3;
    
    closedIndicator3.left = closedIndicator1.left;
    closedIndicator3.top = closedIndicator1.bottom + 21;
    
    
    RMDownloadIndicator *closedIndicator4 = [[RMDownloadIndicator alloc]initWithFrame:CGRectMake((viewLeft.width/2-kClosedIndicatorWidth)/2+viewLeft.width/2, (viewLeft.width/2-kClosedIndicatorWidth)/2+viewLeft.width/2, kClosedIndicatorWidth, kClosedIndicatorWidth) type:kRMClosedIndicator];
    [closedIndicator4 setBackgroundColor:[UIColor whiteColor]];
    [closedIndicator4 setFillColor:kIndicatorColor];
    [closedIndicator4 setStrokeColor:kIndicatorColorPro];
    [closedIndicator4 setTitleLabelText:@"在线学习"];
    [homePlan addSubview:closedIndicator4];
    
    [closedIndicator4 loadIndicator];
    _closedIndicator4 = closedIndicator4;
    
    closedIndicator4.left = closedIndicator2.left;
    closedIndicator4.top = closedIndicator2.bottom + 21;
}


- (void)updateView:(CGFloat)val
{
    self.downloadedBytes+=val;
    [_closedIndicator1 updateWithTotalBytes:100 downloadedBytes:self.downloadedBytes];
}

- (void)updateView2:(CGFloat)val
{
    self.downloadedBytes2+=val;
    [_closedIndicator2 updateWithTotalBytes:100 downloadedBytes:self.downloadedBytes2];
}

- (void)updateView3:(CGFloat)val
{
    self.downloadedBytes3+=val;
    [_closedIndicator3 updateWithTotalBytes:100 downloadedBytes:self.downloadedBytes3];
}

- (void)updateView4:(CGFloat)val
{
    self.downloadedBytes4+=val;
    [_closedIndicator4 updateWithTotalBytes:100 downloadedBytes:self.downloadedBytes4];
}



#pragma mark -
#pragma mark - 右边视图
- (void)_initRightView
{
    viewRight = [ZCControl viewWithFrame:CGRectMake(viewLeft.right+9,9, kScreenWidth - 107.0f - viewLeft.width-20-9, kScreenHeight-18)];
    viewRight.backgroundColor = [UIColor whiteColor];
    viewRight.layer.borderColor = [UIColor clearColor].CGColor;
    viewRight.layer.borderWidth = 1;
    viewRight.layer.cornerRadius = 5;
    viewRight.layer.masksToBounds = YES;

    _homeTask = [[HomeDayPlanView alloc]initWithFrame:CGRectMake(0, 0, viewRight.width, kScreenHeight-18)];
    
    [viewRight addSubview:_homeTask];
    [self.view addSubview:viewRight];
}

- (void)setTaskData:(NSDictionary *)taskData
{
    if (_taskData != taskData) {
        _homeTask.taskData = taskData;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
