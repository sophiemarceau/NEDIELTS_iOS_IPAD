//
//  XDFGetScoreViewController.m
//  IELTS
//
//  Created by 李牛顿 on 15-1-5.
//  Copyright (c) 2015年 Newton. All rights reserved.
//

#import "XDFGetScoreViewController.h"
#import "NALLabelsMatrix.h"
//#import "XDFSetScoreViewController.h"

#import "XDFExerciseListentController.h"
#import "XDFExerciseSpeakController.h"
#import "XDFExerciseReadController.h"
#import "XDFExerciseWriteController.h"
#import "XDFExerciseVacabulaerController.h"
#import "XDFExerciseGrammarViewController.h"
#import "XDFExerciseSyntheticViewController.h"


#define  kScaleFloat 0.7
#define  kTopView_ 100

@interface XDFGetScoreViewController ()

@property (nonatomic,strong)UIView *leftView_;  //左侧视图
@property (nonatomic,strong)UIView *rigthView_; //右侧视图
@property (nonatomic,strong) UIView *topView_; //顶部视图

@property (nonatomic,strong)NALLabelsMatrix* matrixTop;
@property (nonatomic,strong)NALLabelsMatrix* matrixDom;

@property (nonatomic,strong)NSString *scoreLabel;
@property (nonatomic,strong)NSString *timeLabel;

@end

@implementation XDFGetScoreViewController
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
 
    
    NSString *imgString = [ZCControl imgTypeCatagory:self.testType];
    
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
    if (![[self.dataDic objectForKey:@"P_ID"] isKindOfClass:[NSNull class]]) {
        NSString *pid = [self.dataDic objectForKey:@"P_ID"];
        //练习请求
        [[RusultManage shareRusultManage]requestMyMarkReportOfLX:pid
                                                  viewController:self
                                                     SuccessData:^(NSDictionary *result) {
                                                         NDLog(@"练习成绩单");
                                                         NSDictionary *data = [result objectForKey:@"Data"];
                                                         if (data.count > 0) {
                                                             NSString *rightRate = [data objectForKey:@"rightRate"]; //正确率
                                                             NSString *wrongSubject =[data objectForKey:@"wrongSubject"]; //错题
                                                             NSString *costTime =[data objectForKey:@"costTime"];   //用时
                                                             [self setScoreView:rightRate wrongSubject:wrongSubject costTime:costTime];
                                                         }
                                                     }errorData:^(NSError *error) {
                                                         
                                                     }];
    }
}

//填充分数
- (void)setScoreView:(NSString *)rightRate wrongSubject:(NSString *)wrongSubject costTime:(NSString *)costTime
{
    if (self.matrixDom != nil) {
        [self.matrixDom removeFromSuperview];
        self.matrixDom = nil;
        NALLabelsMatrix* matrix2 = [[NALLabelsMatrix alloc] initWithFrame:CGRectMake((rigthView_.width-10-810)/2,100+50, 810, 400)
                                                         andColumnsWidths:[[NSArray alloc] initWithObjects:@270,@270,@270,nil]];
        [matrix2 addRecord:[[NSArray alloc] initWithObjects:@"用时", @"错题", @"正确率",nil]];
        [matrix2 addRecord:[[NSArray alloc] initWithObjects:costTime, wrongSubject,rightRate, nil]];
        self.matrixDom = matrix2;
        UIView *view = (UIView *)[rigthView_ viewWithTag:1024];
        [view addSubview:matrix2];
    }
}

//创建表格
- (void)_creatNALLabelMatrix
{
    UIView *matBg = [[UIView alloc]initWithFrame:CGRectMake(5, topView_.bottom+5, rigthView_.width-10, kScreenHeight-kTopView_-10)];
    matBg.backgroundColor = [UIColor whiteColor];
    matBg.tag = 1024;
    [rigthView_ addSubview:matBg];
    
    //表格2
    CGFloat width2 = 810;
    
    NALLabelsMatrix* matrix2 = [[NALLabelsMatrix alloc] initWithFrame:CGRectMake((matBg.width-width2)/2,100+50, width2, 400)
                                                     andColumnsWidths:[[NSArray alloc] initWithObjects:@270,@270,@270,nil]];
    
    [matrix2 addRecord:[[NSArray alloc] initWithObjects:@"用时", @"错题", @"正确率",nil]];
    [matrix2 addRecord:[[NSArray alloc] initWithObjects:@"", @"",@"", nil]];
    [matBg addSubview:matrix2];
    
    self.matrixDom = matrix2;
    
    //创建答题按钮
    UIButton *checkButton = [ZCControl createButtonWithFrame:CGRectMake((matBg.width-261*2-20)/2, matrix2.bottom+80, 261, 50) ImageName:@"bg.png" Target:self Action:@selector(checkAction:) Title:@"再做一次"];
    [checkButton setTitleColor:TABBAR_BACKGROUND_SELECTED forState:UIControlStateNormal];
    [matBg addSubview:checkButton];
    
    //创建评分按钮
    UIButton *gradeButton = [ZCControl createButtonWithFrame:CGRectMake(checkButton.right+20, matrix2.bottom+80, 261, 50) ImageName:@"bg.png" Target:self Action:@selector(gradeCtion:) Title:@"查看题目"];
    [gradeButton setTitleColor:TABBAR_BACKGROUND_SELECTED forState:UIControlStateNormal];
    [matBg addSubview:gradeButton];
}

#pragma mark - action
//结果按钮
-(void)resultBackAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
//在做一次
- (void)checkAction:(UIButton *)button
{
    NDLog(@"再做一次");
    //修改做题状态
    NSString *pid = [self.dataDic objectForKey:@"P_ID"];
    NSString *status = [NSString stringWithFormat:@"%@finish",pid];
    [kUserDefaults setBool:NO forKey:status];
    [kUserDefaults synchronize];

    [self pushToTest:NO];
}
//查看题目
- (void)gradeCtion:(UIButton *)button
{
    NDLog(@"查看题目");
    [self pushToTest:YES];
    
}

- (void)pushToTest:(BOOL)isChack
{
    if (kStringEqual(self.testType, @"听力")) {
        XDFExerciseListentController *exercise = [[XDFExerciseListentController alloc]init];
        exercise.dataDic = self.dataDic;
        exercise.testType = self.testType;
        exercise.isFromScore = YES;
        exercise.isChack = isChack;
        exercise.st_ID = self.st_Id;
        switch (self.dayType) {
            case DayOrTypeTypes:
                exercise.listController = self.listController;
                exercise.controlType = ControlTypeTypes;
                break;
            case DayOrTypeDay:
                exercise.dayDetailController = self.dayDetailController;
                exercise.controlType = ControlTypeDay;
                break;
            case DayOrTypeHome:
                exercise.controlType = ControlTypeHome;
                break;
            case DayOrTypeSchedule:
                exercise.controlType = ControlTypeSchedule;
                break;
            default:
                break;
        }
        [self.navigationController pushViewController:exercise animated:YES];
    }else if(kStringEqual(self.testType, @"阅读"))
    {
        XDFExerciseReadController *exercise = [[XDFExerciseReadController alloc]init];
        exercise.dataDic = self.dataDic;
        exercise.isChack = isChack;
        exercise.isFromScore = YES;
        exercise.testType = self.testType;
        exercise.st_ID = self.st_Id;
        switch (self.dayType) {
            case DayOrTypeTypes:
                exercise.listController = self.listController;
                exercise.controlType = ControlTypeTypes;
                break;
            case DayOrTypeDay:
                exercise.dayDetailController = self.dayDetailController;
                exercise.controlType = ControlTypeDay;
                break;
            case DayOrTypeHome:
                exercise.controlType = ControlTypeHome;
                break;
            case DayOrTypeSchedule:
                exercise.controlType = ControlTypeSchedule;
                break;
            default:
                break;
        }
        [self.navigationController pushViewController:exercise animated:YES];
        
    }else if(kStringEqual(self.testType, @"口语"))
    {
        XDFExerciseSpeakController  *exercise = [[XDFExerciseSpeakController alloc]init];
        exercise.dataDic = self.dataDic;
        exercise.isChack = isChack;
        exercise.testType = self.testType;
        exercise.isFromScore = YES;
        exercise.st_ID = self.st_Id;
        switch (self.dayType) {
            case DayOrTypeTypes:
                exercise.listController = self.listController;
                exercise.controlType = ControlTypeTypes;
                break;
            case DayOrTypeDay:
                exercise.dayDetailController = self.dayDetailController;
                exercise.controlType = ControlTypeDay;
                break;
            case DayOrTypeHome:
                exercise.controlType = ControlTypeHome;
                break;
            case DayOrTypeSchedule:
                exercise.controlType = ControlTypeSchedule;
                break;
            default:
                break;
        }
        [self.navigationController pushViewController:exercise animated:YES];
        
        
    }else if(kStringEqual(self.testType, @"写作"))
    {
        XDFExerciseWriteController *exercise = [[XDFExerciseWriteController alloc]init];
        exercise.dataDic = self.dataDic;
        exercise.isChack = isChack;
        exercise.testType = self.testType;
        exercise.isFromScore = YES;
        exercise.st_ID = self.st_Id;
        switch (self.dayType) {
            case DayOrTypeTypes:
                exercise.listController = self.listController;
                exercise.controlType = ControlTypeTypes;
                break;
            case DayOrTypeDay:
                exercise.dayDetailController = self.dayDetailController;
                exercise.controlType = ControlTypeDay;
                break;
            case DayOrTypeHome:
                exercise.controlType = ControlTypeHome;
                break;
            case DayOrTypeSchedule:
                exercise.controlType = ControlTypeSchedule;
                break;
            default:
                break;
        }
        [self.navigationController pushViewController:exercise animated:YES];
        
    }else if(kStringEqual(self.testType, @"词汇"))
    {
        XDFExerciseVacabulaerController *exercise = [[XDFExerciseVacabulaerController alloc]init];
        exercise.dataDic = self.dataDic;
        exercise.isChack = isChack;
        exercise.testType = self.testType;
        exercise.isFromScore = YES;
        exercise.st_ID = self.st_Id;
        switch (self.dayType) {
            case DayOrTypeTypes:
                exercise.listController = self.listController;
                exercise.controlType = ControlTypeTypes;
                break;
            case DayOrTypeDay:
                exercise.dayDetailController = self.dayDetailController;
                exercise.controlType = ControlTypeDay;
                break;
            case DayOrTypeHome:
                exercise.controlType = ControlTypeHome;
                break;
            case DayOrTypeSchedule:
                exercise.controlType = ControlTypeSchedule;
                break;
            default:
                break;
        }
        [self.navigationController pushViewController:exercise animated:YES];
        
    }else if(kStringEqual(self.testType, @"语法"))
    {
        XDFExerciseGrammarViewController *exercise = [[XDFExerciseGrammarViewController alloc]init];
        exercise.dataDic = self.dataDic;
        exercise.isChack = isChack;
        exercise.isFromScore = YES;
        exercise.testType = self.testType;
        exercise.st_ID = self.st_Id;
        switch (self.dayType) {
            case DayOrTypeTypes:
                exercise.listController = self.listController;
                exercise.controlType = ControlTypeTypes;
                break;
            case DayOrTypeDay:
                exercise.dayDetailController = self.dayDetailController;
                exercise.controlType = ControlTypeDay;
                break;
            case DayOrTypeHome:
                exercise.controlType = ControlTypeHome;
                break;
            case DayOrTypeSchedule:
                exercise.controlType = ControlTypeSchedule;
                break;
            default:
                break;
        }
        [self.navigationController pushViewController:exercise animated:YES];
        
    }else if(kStringEqual(self.testType, @"综合"))
    {
        XDFExerciseSyntheticViewController *exercise = [[XDFExerciseSyntheticViewController alloc]init];
        exercise.dataDic = self.dataDic;
        exercise.isChack = isChack;
        exercise.isFromScore = YES;
        exercise.st_ID = self.st_Id;
        exercise.testType = self.testType;
        switch (self.dayType) {
            case DayOrTypeTypes:
                exercise.listController = self.listController;
                exercise.controlType = ControlTypeTypes;
                break;
            case DayOrTypeDay:
                exercise.dayDetailController = self.dayDetailController;
                exercise.controlType = ControlTypeDay;
                break;
            case DayOrTypeHome:
                exercise.controlType = ControlTypeHome;
                break;
            case DayOrTypeSchedule:
                exercise.controlType = ControlTypeSchedule;
                break;
            default:
                break;
        }
        [self.navigationController pushViewController:exercise animated:YES];
    }
}

@end
