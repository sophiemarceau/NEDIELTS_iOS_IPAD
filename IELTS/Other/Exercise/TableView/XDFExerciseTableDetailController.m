//
//  XDFExerciseTableDetailController.m
//  IELTS
//
//  Created by 李牛顿 on 15-1-4.
//  Copyright (c) 2015年 Newton. All rights reserved.
//

#import "XDFExerciseTableDetailController.h"
#import "XDFExerciseDetailTableViewCell.h"

#import "XDFExerciseListentController.h"
#import "XDFExerciseSpeakController.h"
#import "XDFExerciseReadController.h"
#import "XDFExerciseWriteController.h"
#import "XDFExerciseVacabulaerController.h"
#import "XDFExerciseGrammarViewController.h"
#import "XDFExerciseSyntheticViewController.h"

#import "XDFGetScoreViewController.h"
#import "DateUtil.h"

#define  kScaleFloat 0.7
#define  kTopViewHeight 100
@interface XDFExerciseTableDetailController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UIView *leftView_;
@property (nonatomic,strong)UIView *rightType_;


@property (nonatomic,strong)UITableView *exerciseDateTableView;  //列表视图
@property (nonatomic,strong)UILabel *titleLable;  //标题
@property (nonatomic,strong)NSArray *dataArray;

@end

@implementation XDFExerciseTableDetailController
@synthesize leftView_,rightType_;
@synthesize exerciseDateTableView,dataArray,titleLable;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    //1.左边
    [self _typeLeft];
    //2.右边
    [self _typeRight];
   
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //3.请求数据
    [self _requestData:self.openDate];
}

- (void)_requestData:(NSString *)dateString
{
    //弹出二级页面
    [[RusultManage shareRusultManage]exerciseDayRuslt:dateString
                                           Controller:self
                                          successData:^(NSDictionary *result) {
                                              
                                              NSArray  *resultData = [result objectForKey:@"Data"];
                                              dataArray = resultData;
                                              [exerciseDateTableView reloadData];
                                              
                                              
                                              NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                                              [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                                              NSDate *date = [dateFormatter dateFromString:dateString];
                                              NSString *month = [ZCControl stringFromDate:date formate:@"MMMM"]; // dd,yyyy EEEE
                                              NSInteger index = [self identifyMonth:month];
                                              if (index == 13) {
                                                  month = month;
                                              }else
                                              {
                                                  NSString *mth = [DateUtil get2MonthString:index];
                                                  month = mth;
                                              }

                                              NSString *year = [ZCControl stringFromDate:date formate:@"yyyy"];
                                              NSString *weekdays = [ZCControl stringFromDate:date formate:@"EEEE"];
                                              NSString *day = [ZCControl stringFromDate:date formate:@"dd"];
//                                              int month =[[DateUtil getCurrentMonth] integerValue];
                                              NSInteger windex = [self identifyWeek:weekdays];
                                              if (windex == 8) {
                                                  weekdays = weekdays;
                                              }else
                                              {
                                                  weekdays = [DateUtil get2DayString:windex];
                                              }
                                              NSString *dateString = [NSString stringWithFormat:@"%@ %@, %@    %@",month,day,year,weekdays];
                                              titleLable.text = dateString;
                                              
                                          }];
    
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

- (NSInteger)identifyMonth:(NSString *)moth
{
    NSArray *months = @[@"一月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"十二月"];
    NSArray *months2 = @[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月"];
    if ([months containsObject:moth]) {
        NSInteger index = [months indexOfObject:moth];
        return index;
    }
    if ([months2 containsObject:moth]) {
        NSInteger index = [months2 indexOfObject:moth];
        return index;
    }
    return 13;
}


#pragma mark -Left
- (void)_typeLeft
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
    
    //后退按钮
    CGFloat beforeW = 86*kScaleFloat;
    CGFloat beforeH = 86*kScaleFloat;
    
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
    
    //按钮控制处理
    if (self.dateArray > 0) {
        NSString *dateFir = [self.dateArray firstObject];
        NSString *dateLast = [self.dateArray lastObject];
        
        if ([dateLast isEqualToString:dateFir]) {
            nextButton.enabled = NO;
            beforeButton.enabled = NO;
        }else if ([self.openDate isEqualToString:dateFir]){
            beforeButton.enabled = NO;
        }else if ([self.openDate isEqualToString:dateLast]){
            nextButton.enabled = NO;
        }
    }
}

//返回
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
//后退
- (void)leftAction:(UIButton *)button
{
    NDLog(@"后退");
    UIButton *nextButton = (UIButton *)[super.view viewWithTag:101];
    if (self.dateArray > 0) {   //判断是否有数据

        NSString *dateFir = [self.dateArray firstObject];   //第一天
        if ([self.openDate isEqualToString:dateFir]) {  //当前选择日期等于第一天
            button.enabled = NO;           //后退不可点击
            [self _requestData:self.openDate];
        }else
        {
            button.enabled = YES;
            nextButton.enabled = YES;
            
            NSRange rang = {0,self.dateArray.count};   //范围
            NSUInteger index = [self.dateArray indexOfObject:self.openDate inRange:rang]; //取出当天的位置
            
            NSString *stringType = [self.dateArray objectAtIndex:index-1];  //取当天的前一天
            
            if ([stringType isEqualToString:dateFir]) { //等于第一天
                button.enabled = NO;
            }
            [self _requestData:stringType];
            self.openDate = stringType;
        }
    }
}
//前进
- (void)rightAction:(UIButton *)button
{
    UIButton *beforeButton = (UIButton *)[super.view viewWithTag:100];
    if (self.dateArray > 0) {
        NSString *dateLast = [self.dateArray lastObject];  //取最后条

        if ([self.openDate isEqualToString:dateLast]) {   //当前日期等于最后一条
            button.enabled = NO;
            [self _requestData:self.openDate];
        }else
        {
            button.enabled = YES;
            beforeButton.enabled = YES;
            
            NSRange rang = {0,self.dateArray.count};
            NSUInteger index = [self.dateArray indexOfObject:self.openDate inRange:rang]; //搜索当前日期所在的位置
            
            NSString *stringType = [self.dateArray objectAtIndex:index+1];   //取出后一条
            
            if ([stringType isEqualToString:dateLast]) {    //等于最后一条
                button.enabled = NO;
            }
            [self _requestData:stringType];
            self.openDate = stringType;
        }
    }
}


#pragma mark - 初始化视图
- (void)_typeRight
{
    //右边
    rightType_ = [[UIView alloc]initWithFrame:CGRectMake(kSecondLevelLeftWidth, 20, kScreenWidth - kSecondLevelLeftWidth, kScreenHeight)];
    rightType_.backgroundColor = rgb(230, 230, 230, 1);
    [self.view addSubview:rightType_];
    
    [self _initBeginView];
    
    [self _initTopView];
}

//创建表格
- (void)_initBeginView
{
    exerciseDateTableView = [[UITableView alloc]initWithFrame:CGRectMake(100, kTopViewHeight, kScreenWidth-kSecondLevelLeftWidth-200, kScreenHeight-kTopViewHeight) style:UITableViewStylePlain];
    exerciseDateTableView.delegate = self;
    exerciseDateTableView.dataSource = self;
    exerciseDateTableView.rowHeight = 90;
    exerciseDateTableView.showsVerticalScrollIndicator = NO;
    exerciseDateTableView.showsHorizontalScrollIndicator = NO;
    exerciseDateTableView.backgroundColor = [UIColor clearColor];
    exerciseDateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [rightType_ addSubview:exerciseDateTableView];
}
//初始化头部视图
- (void)_initTopView
{
    //创建背景视图
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-kSecondLevelLeftWidth, kTopViewHeight)];
    topView.backgroundColor = [UIColor whiteColor];
    [rightType_ addSubview:topView];
    
    //创建标题
    titleLable = [ZCControl createLabelWithFrame:CGRectMake((topView.width-300)/2, (kTopViewHeight-40)/2, 300, 40) Font:20 Text:@""];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.textColor = TABBAR_BACKGROUND_SELECTED;
    titleLable.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:titleLable];
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
    if (dataArray.count > 0) {
        NSDictionary *dataDic = dataArray[indexPath.row];
        NSString *lcName = [dataDic objectForKey:@"lcName"];
        [self intoController:lcName data:dataDic];
    }
}
#pragma mark -进入练习
- (void)intoController:(NSString *)path  data:(NSDictionary *)dataDic
{
    NSString *p_id = [[dataDic objectForKey:@"P_ID"]stringValue];
    
    NSString *ST_ID = [[dataDic objectForKey:@"ST_ID"]stringValue];
    BOOL st_IdStatus = [[dataDic objectForKey:@"Status"] boolValue];
    
    NSString *status = [NSString stringWithFormat:@"%@finish",p_id];
    BOOL isMark = [kUserDefaults boolForKey:status];
    if (kStringEqual(path, @"听力")) {
        if (!isMark) {
            NSString *domainPFolder = [dataDic objectForKey:@"domainPFolder"];
            NSString * lastPath = [domainPFolder lastPathComponent];
            if ([lastPath isEqualToString:@"null"]) {
                [[RusultManage shareRusultManage]tipAlert:@"试卷获取失败,请于管理员联系"viewController:self];
                return;
            }
            
            if (!st_IdStatus) {
                [[RusultManage shareRusultManage]tellServerTaskSTID:ST_ID];
            }
            
            XDFExerciseListentController *exListent = [[XDFExerciseListentController alloc]init];
            exListent.dataDic = dataDic;
            exListent.testType = path;
            exListent.isChack = NO;
            [self.navigationController pushViewController:exListent animated:YES];
        }else
        {
            //进入评分页面
            XDFGetScoreViewController *getScore = [[XDFGetScoreViewController alloc]init];
            getScore.dataDic = dataDic;
            getScore.testType = path;
            getScore.dayDetailController = self;
            getScore.dayType = DayOrTypeDay;
            [self.navigationController pushViewController:getScore animated:YES];
        }
    }else if(kStringEqual(path, @"阅读"))
    {
        if (!isMark) {
            NSString *domainPFolder = [dataDic objectForKey:@"domainPFolder"];
            NSString * lastPath = [domainPFolder lastPathComponent];
            if ([lastPath isEqualToString:@"null"]) {
                [[RusultManage shareRusultManage]tipAlert:@"试卷获取失败,请于管理员联系"viewController:self];
                return;
            }

            if (!st_IdStatus) {
                [[RusultManage shareRusultManage]tellServerTaskSTID:ST_ID];
            }

            
            XDFExerciseReadController *speak = [[XDFExerciseReadController alloc]init];
            speak.dataDic = dataDic;
            speak.testType = path;
            speak.isChack = NO;
            [self.navigationController pushViewController:speak animated:YES];
        }else
        {
            //进入评分页面
            XDFGetScoreViewController *getScore = [[XDFGetScoreViewController alloc]init];
            getScore.dataDic = dataDic;
            getScore.testType = path;
            getScore.dayDetailController = self;
            getScore.dayType = DayOrTypeDay;
            [self.navigationController pushViewController:getScore animated:YES];
        }
        
    }else if(kStringEqual(path, @"口语"))
    {
        if (!isMark) {
            NSString *domainPFolder = [dataDic objectForKey:@"domainPFolder"];
            NSString * lastPath = [domainPFolder lastPathComponent];
            if ([lastPath isEqualToString:@"null"]) {
                [[RusultManage shareRusultManage]tipAlert:@"试卷获取失败,请于管理员联系"viewController:self];
                return;
            }
            
            if (!st_IdStatus) {
                [[RusultManage shareRusultManage]tellServerTaskSTID:ST_ID];
            }


            XDFExerciseSpeakController *speak = [[XDFExerciseSpeakController alloc]init];
            speak.dataDic = dataDic;
            speak.testType = path;
            speak.isChack = NO;
            [self.navigationController pushViewController:speak animated:YES];
        }else
        {
            //进入评分页面
            XDFGetScoreViewController *getScore = [[XDFGetScoreViewController alloc]init];
            getScore.dataDic = dataDic;
            getScore.testType = path;
            getScore.dayDetailController = self;
            getScore.dayType = DayOrTypeDay;
            [self.navigationController pushViewController:getScore animated:YES];
        }
        
    }else if(kStringEqual(path, @"写作"))
    {
        if (!isMark) {
            NSString *domainPFolder = [dataDic objectForKey:@"domainPFolder"];
            NSString * lastPath = [domainPFolder lastPathComponent];
            if ([lastPath isEqualToString:@"null"]) {
                [[RusultManage shareRusultManage]tipAlert:@"试卷获取失败,请于管理员联系"viewController:self];
                return;
            }

            if (!st_IdStatus) {
                [[RusultManage shareRusultManage]tellServerTaskSTID:ST_ID];
            }

            XDFExerciseWriteController *speak = [[XDFExerciseWriteController alloc]init];
            speak.dataDic = dataDic;
            speak.testType = path;
            speak.isChack = NO;
            [self.navigationController pushViewController:speak animated:YES];
        }else
        {
            //进入评分页面
            XDFGetScoreViewController *getScore = [[XDFGetScoreViewController alloc]init];
            getScore.dataDic = dataDic;
            getScore.testType = path;
            getScore.dayDetailController = self;
            getScore.dayType = DayOrTypeDay;
            [self.navigationController pushViewController:getScore animated:YES];
        }
        
    }else if(kStringEqual(path, @"词汇"))
    {
        if (!isMark) {
            NSString *domainPFolder = [dataDic objectForKey:@"domainPFolder"];
            NSString * lastPath = [domainPFolder lastPathComponent];
            if ([lastPath isEqualToString:@"null"]) {
                [[RusultManage shareRusultManage]tipAlert:@"试卷获取失败,请于管理员联系"viewController:self];
                return;
            }
            
            if (!st_IdStatus) {
                [[RusultManage shareRusultManage]tellServerTaskSTID:ST_ID];
            }


            XDFExerciseVacabulaerController *speak = [[XDFExerciseVacabulaerController alloc]init];
            speak.dataDic = dataDic;
            speak.testType = path;
            speak.isChack = NO;
            [self.navigationController pushViewController:speak animated:YES];
        }else
        {
            //进入评分页面
            XDFGetScoreViewController *getScore = [[XDFGetScoreViewController alloc]init];
            getScore.dataDic = dataDic;
            getScore.testType = path;
            getScore.dayDetailController = self;
            getScore.dayType = DayOrTypeDay;
            [self.navigationController pushViewController:getScore animated:YES];
        }
        
    }else if(kStringEqual(path, @"语法"))
    {
        if (!isMark) {
            NSString *domainPFolder = [dataDic objectForKey:@"domainPFolder"];
            NSString * lastPath = [domainPFolder lastPathComponent];
            if ([lastPath isEqualToString:@"null"]) {
                [[RusultManage shareRusultManage]tipAlert:@"试卷获取失败,请于管理员联系"viewController:self];
                return;
            }
            
            if (!st_IdStatus) {
                [[RusultManage shareRusultManage]tellServerTaskSTID:ST_ID];
            }

            XDFExerciseGrammarViewController *speak = [[XDFExerciseGrammarViewController alloc]init];
            speak.dataDic = dataDic;
            speak.testType = path;
            speak.isChack = NO;
            [self.navigationController pushViewController:speak animated:YES];
        }else
        {
            //进入评分页面
            XDFGetScoreViewController *getScore = [[XDFGetScoreViewController alloc]init];
            getScore.dataDic = dataDic;
            getScore.testType = path;
            getScore.dayDetailController = self;
            getScore.dayType = DayOrTypeDay;
            [self.navigationController pushViewController:getScore animated:YES];
        }
    }else if(kStringEqual(path, @"综合"))
    {
        if (!isMark) {
            NSString *domainPFolder = [dataDic objectForKey:@"domainPFolder"];
            NSString * lastPath = [domainPFolder lastPathComponent];
            if ([lastPath isEqualToString:@"null"]) {
                [[RusultManage shareRusultManage]tipAlert:@"试卷获取失败,请于管理员联系"viewController:self];
                return;
            }
            
            if (!st_IdStatus) {
                [[RusultManage shareRusultManage]tellServerTaskSTID:ST_ID];
            }


            XDFExerciseSyntheticViewController *speak = [[XDFExerciseSyntheticViewController alloc]init];
            speak.dataDic = dataDic;
            speak.testType = path;
            speak.isChack = NO;
            [self.navigationController pushViewController:speak animated:YES];
        }else
        {
            //进入评分页面
            XDFGetScoreViewController *getScore = [[XDFGetScoreViewController alloc]init];
            getScore.dataDic = dataDic;
            getScore.testType = path;
            getScore.dayType = DayOrTypeDay;
            getScore.dayDetailController = self;
            [self.navigationController pushViewController:getScore animated:YES];
        }
    }
}





@end
