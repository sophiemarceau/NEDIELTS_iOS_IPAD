//
//  XDFResultViewController.m
//  IELTS
//
//  Created by 李牛顿 on 14-12-27.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFResultViewController.h"
#import "NALLabelsMatrix.h"
#import "XDFSetScoreViewController.h"

#import "XDFExaminaTestHome.h"

#define  kScaleFloat 0.7
#define  kTopView_ 100
@interface XDFResultViewController ()<XDFSetScoreViewControllerDelegeat>

@property (nonatomic,strong) UIView *leftView_;  //左侧视图
@property (nonatomic,strong) UIView *rigthView_; //右侧视图
@property (nonatomic,strong) UIView *topView_; //顶部视图

@property (nonatomic,strong) NALLabelsMatrix* matrixTop;
@property (nonatomic,strong) NALLabelsMatrix* matrixDom;

@property (nonatomic,strong) NSString *scoreLabel;
@property (nonatomic,strong) NSString *timeLabel;

@property (nonatomic,strong) NSString *examInfoId;

@property (nonatomic,strong) NSString *writeTscore;
@property (nonatomic,strong) NSString *speakTscore;

@property (nonatomic,strong) UILabel *usesTime;
@property (nonatomic,strong) UILabel *getScores;

@property (nonatomic,strong) XDFSetScoreViewController *setScoreView;
@property (nonatomic,strong) UIControl *maskControlView; //控制收起搜索框搜索框

@end

@implementation XDFResultViewController
@synthesize leftView_,rigthView_,topView_;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    //左边
    [self _initRight];
    //右边
    [self _initLeft];
    //请求数据
    [self _requestData];
}
#pragma mark - init
- (void)_initRight
{
    //左边   btn_back.png 93 × 43   arraw_Left.png 86*86 arraw_Right.png
    leftView_ = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kSecondLevelLeftWidth, kScreenHeight)];
    leftView_.backgroundColor = TABBAR_BACKGROUND;
    
    //返回按钮 93/2, 43/2
    CGFloat backW = 93*kScaleFloat;
    CGFloat backH = 43*kScaleFloat;
    
    UIButton *backButton = [ZCControl createButtonWithFrame:CGRectMake((kSecondLevelLeftWidth-backW)/2, 30, backW, backH) ImageName:@"" Target:self Action:@selector(resultBackAction:) Title:@""];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    
    [leftView_ addSubview:backButton];
    [self.view addSubview:leftView_];
}

- (void)_initLeft
{
    //顶部视图
    rigthView_ = [[UIView alloc]initWithFrame:CGRectMake(kSecondLevelLeftWidth, 20, kScreenWidth-kSecondLevelLeftWidth, kScreenHeight)];
    rigthView_.backgroundColor = rgb(230, 230, 230, 1.0);
    [self.view addSubview:rigthView_];
    
    topView_ = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-80,kTopView_)];
    topView_.backgroundColor = [UIColor whiteColor];
    [rigthView_ addSubview:topView_];
    
    //1.创建图标
    NSString *titleString = @"";
    if ([self.dataDic objectForKey:@"Name"]) {
        titleString = [NSString stringWithFormat:@"%@报告",[self.dataDic objectForKey:@"Name"]];
    }
    NSString *imgString = @"120_ExainaView.png";
    
    UIImageView *imgView  =[[UIImageView alloc]initWithFrame:CGRectMake(30,(topView_.height-60)/2, 60, 60)];
    imgView.image = [UIImage imageNamed:imgString];
    [topView_ addSubview:imgView];
    
    //2.创建标题
    UILabel *titleLabel = [ZCControl createLabelWithFrame:CGRectMake(imgView.right+10, (topView_.height-40)/2, 300, 40) Font:24.0f Text:titleString];
    titleLabel.textColor =TABBAR_BACKGROUND_SELECTED;
    titleLabel.font = [UIFont boldSystemFontOfSize:24.0f];
    [topView_ addSubview:titleLabel];
    
    //3.创建表格
    [self _creatNALLabelMatrix];
    
}
//网络请求
- (void)_requestData
{
    /*
     {
     "ListenScore" : "未打分",
     "ReadScore" : "未打分",
     "paperName" : null,
     "ReadWrongSubject" : null,
     "ListenRightRate" : null,
     "SpeakScore" : "未打分",
     "ListenWrongSubject" : null,
     "WriteScore" : "未打分",
     "MyWrite" : "未打分",
     "examInfoId" : null,
     "TotalScore" : "",
     "ReadRightRate" : null,
     "CostTime" : null,
     "MySpeak" : "未打分"
     }
     */
    if ([self.dataDic objectForKey:@"P_ID"]) {
         NSString *pid = [self.dataDic objectForKey:@"P_ID"];
        //模考请求
        [[RusultManage shareRusultManage]requestMyMarkReportOfMk:pid
                                                  viewController:self
                                                     SuccessData:^(NSDictionary *result) {

                                                         NSDictionary *data = [result objectForKey:@"Data"];
                                                         if (data.count > 0) {
                                                             [self _dealScore:data];
                                                         }
                                                     }errorData:^(NSError *error) {
                                                         [self cannotSetScore];
                                                     }];


    }
}

- (void)_dealScore:(NSDictionary *)data
{
    self.getScores.text = [[data objectForKey:@"TotalScore"] isKindOfClass:[NSNull class]]?@"总分:0.0":[data objectForKey:@"TotalScore"];   //总分
    self.usesTime.text = [[data objectForKey:@"CostTime"] isKindOfClass:[NSNull class]]?@"":[data objectForKey:@"CostTime"];     //总时间。
    //一表
    NSString *listenScore = [[data objectForKey:@"ListenScore"] isKindOfClass:[NSNull class]]?@"":[data objectForKey:@"ListenScore"] ;
    NSString *listenWrongSubject = [[data objectForKey:@"ListenWrongSubject"] isKindOfClass:[NSNull class]]?@"":[data objectForKey:@"ListenWrongSubject"];
    NSString *listenRightRate = [[data objectForKey:@"ListenRightRate"] isKindOfClass:[NSNull class]] ?@"":[data objectForKey:@"ListenRightRate"];
    
    NSString *readScore =[[data objectForKey:@"ReadScore"] isKindOfClass:[NSNull class]] ? @"":[data objectForKey:@"ReadScore"];
    NSString *readWrongSubject =[[data objectForKey:@"ReadWrongSubject"] isKindOfClass:[NSNull class]] ? @"":[data objectForKey:@"ReadWrongSubject"];
    NSString *readRightRate = [[data objectForKey:@"ReadRightRate"] isKindOfClass:[NSNull class]] ? @"":[data objectForKey:@"ReadRightRate"];
    
    //表格1
    UIView *view = (UIView *)[rigthView_ viewWithTag:1024];
    if (self.matrixTop != nil) {
        [self.matrixTop removeFromSuperview];
        self.matrixTop = nil;
    }
    CGFloat width = 810;
    NALLabelsMatrix* matrix = [[NALLabelsMatrix alloc] initWithFrame:CGRectMake((view.width-width)/2, 100, width, 400)
                                                    andColumnsWidths:[[NSArray alloc] initWithObjects:@203,@203,@203,@203,nil]];
    [matrix addRecord:[[NSArray alloc] initWithObjects:@"科目", @"得分", @"错题",@"正确率",nil]];
    [matrix addRecord:[[NSArray alloc] initWithObjects:@"听力", listenScore,listenWrongSubject,listenRightRate, nil]];
    [matrix addRecord:[[NSArray alloc] initWithObjects:@"阅读", readScore,readWrongSubject,readRightRate, nil]];
    self.matrixTop = matrix;
    [view addSubview:matrix];

    
    //二表
    NSString *writeScore = [[data objectForKey:@"WriteScore"] isKindOfClass:[NSNull class]]?@"":[data objectForKey:@"WriteScore"];
    NSString *myWrite =[[data objectForKey:@"MyWrite"] isKindOfClass:[NSNull class]]?@"":[data objectForKey:@"MyWrite"];
    
    NSString *speakScore = [[data objectForKey:@"SpeakScore"] isKindOfClass:[NSNull class]]?@"":[data objectForKey:@"SpeakScore"];
    NSString *mySpeak =[[data objectForKey:@"MySpeak"] isKindOfClass:[NSNull class]]?@"":[data objectForKey:@"MySpeak"];
    
    self.writeTscore = writeScore;
    self.speakTscore = speakScore;
    
    if (self.matrixDom != nil) {
        [self.matrixDom removeFromSuperview];
        self.matrixDom = nil;
    }
    NALLabelsMatrix* matrix2 = [[NALLabelsMatrix alloc] initWithFrame:CGRectMake((rigthView_.width-10-810)/2,self.matrixTop.bottom+50, 810, 400)
                                                     andColumnsWidths:[[NSArray alloc] initWithObjects:@270,@270,@270,nil]];
    [matrix2 addRecord:[[NSArray alloc] initWithObjects:@"科目", @"教师评分", @"自我评分",nil]];
    [matrix2 addRecord:[[NSArray alloc] initWithObjects:@"写作", writeScore,myWrite, nil]];
    [matrix2 addRecord:[[NSArray alloc] initWithObjects:@"口语", speakScore,mySpeak, nil]];
    self.matrixDom = matrix2;
    [view addSubview:matrix2];
    
   
    if (![[data objectForKey:@"examInfoId"] isKindOfClass:[NSNull class]]) {
        NSString *examInfoId = [data objectForKey:@"examInfoId"];
        self.examInfoId = examInfoId;
    }else
    {
        [self cannotSetScore];
    }
}
//如果存在
- (void)setExamInfoId:(NSString *)examInfoId
{
    if (_examInfoId != examInfoId) {
        _examInfoId = examInfoId;
        [self canSetScore];
    }
}

- (void)canSetScore
{
   UIButton *button = (UIButton *)[rigthView_ viewWithTag:2123];
    button.enabled = YES;
}

- (void)cannotSetScore
{
    UIButton *button = (UIButton *)[rigthView_ viewWithTag:2123];
    button.enabled = NO;
}



//创建表格

- (void)_creatNALLabelMatrix
{
    UIView *matBg = [[UIView alloc]initWithFrame:CGRectMake(5, topView_.bottom+5, rigthView_.width-10, kScreenHeight-kTopView_-10)];
    matBg.backgroundColor = [UIColor whiteColor];
    matBg.tag = 1024;
    [rigthView_ addSubview:matBg];
    
    //表格1
     CGFloat width = 810;
     NALLabelsMatrix* matrix = [[NALLabelsMatrix alloc] initWithFrame:CGRectMake((matBg.width-width)/2, 100, width, 400)
                                                    andColumnsWidths:[[NSArray alloc] initWithObjects:@203,@203,@203,@203,nil]];

    [matrix addRecord:[[NSArray alloc] initWithObjects:@"科目", @"得分", @"错题",@"正确率",nil]];
    [matrix addRecord:[[NSArray alloc] initWithObjects:@"听力", @"",@"",@"", nil]];
    [matrix addRecord:[[NSArray alloc] initWithObjects:@"阅读", @"",@"",@"", nil]];
    
    [matBg addSubview:matrix];
    self.matrixTop = matrix;
    
    //创建分数
    UILabel *scoreLabel = [ZCControl createLabelWithFrame:CGRectMake(matrix.left, 10, 300, 50) Font:30.0f Text:@""];
    scoreLabel.textColor = TABBAR_BACKGROUND_SELECTED;
    scoreLabel.text = @"分数:0.0";
    [matBg addSubview:scoreLabel];
    self.getScores = scoreLabel;
    //创建用时
    UILabel *timeLabel = [ZCControl createLabelWithFrame:CGRectMake(scoreLabel.left, scoreLabel.bottom-10, 300, 30) Font:18.0f Text:@"用时:"];
    [matBg addSubview:timeLabel];
    self.usesTime = timeLabel;
    //表格2
    CGFloat width2 = 810;
    NALLabelsMatrix* matrix2 = [[NALLabelsMatrix alloc] initWithFrame:CGRectMake((matBg.width-width2)/2,matrix.bottom+50, width2, 400)
                                                    andColumnsWidths:[[NSArray alloc] initWithObjects:@270,@270,@270,nil]];
    
    [matrix2 addRecord:[[NSArray alloc] initWithObjects:@"科目", @"教师评分", @"自我评分",nil]];
    [matrix2 addRecord:[[NSArray alloc] initWithObjects:@"写作", @"",@"", nil]];
    [matrix2 addRecord:[[NSArray alloc] initWithObjects:@"口语", @"",@"", nil]];

    
    [matBg addSubview:matrix2];
    
    self.matrixDom = matrix2;
    
    //创建答题按钮
    UIButton *checkButton = [ZCControl createButtonWithFrame:CGRectMake((matBg.width-261*2-20)/2, matrix2.bottom+80, 261, 50) ImageName:@"bg.png" Target:self Action:@selector(checkExaminaAction:) Title:@"查看题目"];
    [checkButton setTitleColor:TABBAR_BACKGROUND_SELECTED forState:UIControlStateNormal];
    [matBg addSubview:checkButton];
    
    //创建评分按钮
    UIButton *gradeButton = [ZCControl createButtonWithFrame:CGRectMake(checkButton.right+20, matrix2.bottom+80, 261, 50) ImageName:@"bg.png" Target:self Action:@selector(gradeCtion:) Title:@"自我评分"];
    [gradeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [gradeButton setBackgroundImage:[UIImage imageNamed:@"btn2_blank.png"] forState:UIControlStateDisabled];
    [gradeButton setTitleColor:TABBAR_BACKGROUND_SELECTED forState:UIControlStateNormal];
    gradeButton.tag = 2123;
    [matBg addSubview:gradeButton];
}

#pragma mark - action
//结果按钮
-(void)resultBackAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
//查看题目
- (void)checkExaminaAction:(UIButton *)button
{
    
    if (self.dataDic.count > 0) {
        NSString *pid = [[self.dataDic objectForKey:@"P_ID"] stringValue];
        NSString *stid = [[self.dataDic objectForKey:@"ST_ID"] stringValue];
        NSString *taskType =[[self.dataDic objectForKey:@"TaskType"]stringValue];
        NSString *name = [self.dataDic objectForKey:@"Name"];
        XDFExaminaTestHome *testController = [[XDFExaminaTestHome alloc]init];
//        testController.view.frame = CGRectMake(0, 20, kScreenWidth, kScreenHeight);
        testController.isChack = YES;
        testController.dicData = self.dataDic;
        testController.taskType = taskType;
        testController.pId = pid;  //试卷id
        testController.stId = stid;
        testController.testTitles = name;
        testController.resultView = self;
        [self.navigationController pushViewController:testController animated:YES];
    }
}

//设置评分
- (void)gradeCtion:(UIButton *)button
{
    XDFSetScoreViewController *regist = [[XDFSetScoreViewController alloc]init];
    regist.delegate = self;
    regist.examInfoId = self.examInfoId;
    
    
    regist.delegate = self;
    CGFloat with =  regist.view.frame.size.width;
    CGFloat heigt = regist.view.frame.size.height;
    
    regist.view.frame = CGRectMake((1024-with)/2, self.view.frame.size.height,with, heigt);
    [UIView animateWithDuration:0.35 animations:^{
        regist.view.frame = CGRectMake((1024-with)/2, (768-heigt)/2, with, heigt);
    }];
    [self _initMask:regist.view];
    
    [self.view addSubview:regist.view];
    self.setScoreView = regist;
//    [ZCControl presentModalFromController:self toController:regist isHiddenNav:YES Width:480 Height:320];
}
#pragma mark -  XDFSetScoreViewControllerDelegate
- (void)shutSetScoreView
{
    [self maskControlView:nil];
}

#pragma mark - 实现点击键盘以外都收起键盘
- (void)_initMask:(UIView *)textView
{
    //创建点击视图
    if (_maskControlView == nil) {
        _maskControlView = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, 1024 , 768)];
        [_maskControlView addTarget:self action:@selector(maskControlView:) forControlEvents:UIControlEventTouchUpInside];
        _maskControlView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self.view insertSubview:_maskControlView belowSubview:textView];
    }
}
//隐藏alert
- (void)maskControlView:(UIControl *)maskView
{
    CGFloat with =  self.setScoreView.view.frame.size.width;
    CGFloat heigt = self.setScoreView.view.frame.size.height;
    self.setScoreView.view.frame = CGRectMake((1024-with)/2, (768-heigt)/2, with, heigt);
    
    [UIView animateWithDuration:0.35 animations:^{
        self.setScoreView.view.frame = CGRectMake((1024-with)/2, self.view.height,with, heigt);
        [_maskControlView removeFromSuperview];
        _maskControlView = nil;
    } completion:^(BOOL finished) {
        
        [self.setScoreView.view removeFromSuperview];
        self.setScoreView.view = nil;
        
        [self.setScoreView removeFromParentViewController];
        self.setScoreView = nil;
    }];
}
#pragma mark - XDFSetScoreViewControllerDelegate
- (void)setScoreView:(NSString *)score1 scoreString:(NSString *)score2
{
    
    if (self.matrixDom != nil) {
        [self.matrixDom removeFromSuperview];
        self.matrixDom = nil;
    }
    if (self.speakTscore.length > 0 && self.writeTscore.length > 0 ) {
        NALLabelsMatrix* matrix2 = [[NALLabelsMatrix alloc] initWithFrame:CGRectMake((rigthView_.width-10-810)/2,self.matrixTop.bottom+50, 810, 400)
                                                         andColumnsWidths:[[NSArray alloc] initWithObjects:@270,@270,@270,nil]];
        [matrix2 addRecord:[[NSArray alloc] initWithObjects:@"科目", @"教师评分", @"自我评分",nil]];
        [matrix2 addRecord:[[NSArray alloc] initWithObjects:@"写作", self.writeTscore,score1, nil]];
        [matrix2 addRecord:[[NSArray alloc] initWithObjects:@"口语", self.speakTscore,score2, nil]];
        self.matrixDom = matrix2;
        UIView *view = (UIView *)[rigthView_ viewWithTag:1024];
        [view addSubview:matrix2];
    }
}

@end
