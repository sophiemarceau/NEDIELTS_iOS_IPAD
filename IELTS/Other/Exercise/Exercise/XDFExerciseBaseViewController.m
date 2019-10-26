//
//  XDFExerciseBaseViewController.m
//  IELTS
//
//  Created by 李牛顿 on 15-1-5.
//  Copyright (c) 2015年 Newton. All rights reserved.
//

#import "XDFExerciseBaseViewController.h"
#import "XDFExaminSegement.h"
#import "AFSoundManager.h"
#import "XDFExerciseTypeListController.h"
#import "XDFExerciseTableDetailController.h"

#define  userDefaulfKey(p_Id) [NSString stringWithFormat:@"%@listent",p_Id]  //存储时间

@interface XDFExerciseBaseViewController ()<UIWebViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) XDFExaminSegement *segmentMenu;
@property (nonatomic,strong) UIView *leftView;
@property (nonatomic,strong) NSString *audioString; //音频文件
@property (nonatomic,strong) UIButton *audioButton;
@property (nonatomic,strong) NSArray *sectionArray; //section数组，控制切换section

@property (nonatomic,strong) NSMutableArray *fileNameArray;  //html数据
@property (nonatomic,strong) NSMutableArray *pidArray;      //存储答案的key
@property (nonatomic,strong) NSMutableArray *readArray;    //阅读数组
//@property (nonatomic,strong) NSMutableArray *speakArray;   //口语数组

@property (nonatomic,strong) NSString  *urlString;   //URL链接

//@property (nonatomic,strong) NSString *curenPid;     //当前页面的pid
@property (nonatomic,assign) NSInteger curenSection; //当前的section
@property (nonatomic,assign) NSInteger curenPage; //当前的section
@property (nonatomic,strong) UILabel *titleLabel; //副标题
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,strong) NSTimer *timer; //进入就开始
@property (nonatomic,assign) NSInteger time_i; //
@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic,assign) BOOL isLeft;
@property (nonatomic,assign) BOOL isRight;

@property (nonatomic,strong) NSArray *explainArray;  //解析数组
@property (nonatomic,strong) NSMutableArray *hasExplainArray; //有解析的数组
@property (nonatomic,strong) NSString *listenBody;
@property (nonatomic,strong) NSString *testBody;
@property (nonatomic,strong) NSString *writeBody;
@property (nonatomic,strong) NSString *answerBody;

@property (nonatomic,strong) NSMutableArray *upDateMusicArray;
@property (nonatomic,strong) UIButton *buttAction; //解析按钮
@property (nonatomic,strong) UIWebView *explainWebView; //解析网页

@property (nonatomic,strong) NSIndexPath *selectIndexPath;

@end

@implementation XDFExerciseBaseViewController

@synthesize fileNameArray,pidArray,listenWeb,readArray;
//,speakArray;
@synthesize time_i;
@synthesize rightView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    _sectionArray = [[NSArray alloc]init];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(HeadphonesAudio) name:k_HeadphonesAudio object:nil];
    
    
    self.curenSection = 0;
//    self.curenPage = 0;
//    _curenPid = @"lisen";
    //1.创建左侧
    [self creatLeftView];
    
    //2.创建右侧
    [self creatRightView];
    
    //3.获取配置文件
    [self getRouseceConfig];
    
}


- (void)HeadphonesAudio
{
    if (self.audioButton != nil) {
        self.audioButton.selected = NO;
    }
}



- (void)enterBackAction:(NSNotification *)nofication
{
    [self saveAnswer];  //保存答案
    [self saveTime];  //保存时间
    
}

- (void)startLessons:(NSTimer *)time
{
//    NDLog(@"%02d:%02d:%02d",time_i/(60*60),time_i/60,time_i%60);
//    NDLog(@"%d",time_i++);
    time_i++;
}

//试卷数据结构
/*  DataDic
 {
 "Target" : 2,
 "ST_ID" : 6304,
 "domainPFolder" : "http:\/\/115.28.129.210:8082\/IELTS\/paperzip\/TempPaper_7088",
 "lcName" : "听力",
 "TF_ID" : null,
 "ExTime" : null,
 "Catagory" : 2005,
 "Name" : "雅思练习试卷11",
 "UID" : 6,
 "C_ID" : 53955,
 "NickName" : "Admin1",
 "RefID" : 7088,
 "CC_ID" : null,
 "PaperFolder" : "TempPaper_7088",
 "domainPZip" : "http:\/\/115.28.129.210:8082\/IELTS\/paperzip\/70881420356778541690.zip",
 "OpenDate" : null,
 "TaskType" : 2,
 "Source" : null,
 "P_ID" : 7088,
 "PaperNumber" : "雅思练习试卷11",
 "PaperZip" : "70881420356778541690.zip"
 }
 */
//试卷config结构
/*
 {
 "PaperName" : "雅思练习试卷11",
 "PaperNumber" : "雅思练习试卷11",
 "PaperCatagoryList" : [
 {
 "paperSectionList" : [{
 "QNumberEnd" : 11,
 "QuestionPageList" : [
 {
 "QNumberBegin" : 1,
 "QNumberEnd" : 1,
 "AudioFiles" : [
 "1420189041826323.mp3"
 ],
 "PID" : 3180,
 "FileName" : "Question_6149_4106_3180.html",
 "PageNumber" : 0
 },
 {
 "QNumberBegin" : 1,
 "QNumberEnd" : 6,
 "AudioFiles" : [
 
 ],
 "PID" : 3181,
 "FileName" : "Question_6149_4106_3181.html",
 "PageNumber" : 1
 },
 {
 "QNumberBegin" : 6,
 "QNumberEnd" : 9,
 "AudioFiles" : [
 
 ],
 "PID" : 3182,
 "FileName" : "Question_6149_4106_3182.html",
 "PageNumber" : 2
 },
 {
 "QNumberBegin" : 9,
 "QNumberEnd" : 11,
 "AudioFiles" : [
 
 ],
 "PID" : 3183,
 "FileName" : "Question_6149_4106_3183.html",
 "PageNumber" : 3
 }
 ],
 "QID" : "4106",
 "SectionID" : "6149",
 "ScCount" : "10",
 "QNumberBegin" : 1
 }],
 "Name" : "听力"
 }
 ]
 }
 */

- (void)getRouseceConfig
{
    NSString *domainPFolder = [self.dataDic objectForKey:@"domainPFolder"];
    NSString *path = [domainPFolder stringByAppendingPathComponent:@"config.json"];
    
    [[RusultManage shareRusultManage] ruquestServerConfig:self path:path SuccessData:^(NSDictionary *result) {
        //处理数据
        [self _dealRusult:result];
        
        [self startTestTime];
    } errorData:^(NSError *error) {
        
    }];
}

- (void)startTestTime
{
    //获取时间
    NSInteger interger = [self getThisTime];
    if (interger > 0) {
        time_i = interger;
    }else
    {
        time_i = 0;
    }
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startLessons:) userInfo:nil repeats:YES];
}

- (void)_dealRusult:(NSDictionary *)result
{
    if (result.count > 0 && result != nil) {
        _titleLabel.text = [result objectForKey:@"PaperName"];  //试卷名字
        NSArray *dataArray = [result objectForKey:@"PaperCatagoryList"];  //目录列表
        if (dataArray.count > 0) {
            for (NSDictionary *dic in dataArray) {
                NSArray *sectionList = [dic objectForKey:@"paperSectionList"];//试卷section个数
                _sectionArray = sectionList;
                
                self.upDateMusicArray = [[NSMutableArray alloc]init];
                for (NSDictionary *dicSection in _sectionArray) {
                    NSArray *pageList = [dicSection objectForKey:@"QuestionPageList"];
                    for (NSDictionary *page in pageList) {
                        NSInteger begin = [[page objectForKey:@"QNumberBegin"] integerValue];
                        NSInteger end = [[page objectForKey:@"QNumberEnd"] integerValue];
                        if (end - begin != 0) {
                            NSString *pid = [[page objectForKey:@"PID"] stringValue];
                            [self.upDateMusicArray addObject:pid];
                        }
                    }
                }
                if (_sectionArray.count > 0) {  //有section
                    UIButton *nextButton = (UIButton *)[self.view viewWithTag:101];
                    nextButton.enabled = YES;
                    //处理segment
                    [self _dealSegment];
                }
            }
        }
    }
}

//处理segment
- (void)_dealSegment
{
    NSDictionary *sectionDic =  _sectionArray[self.curenSection];
    //是查看题目
    if (self.isChack) {
        NSString *qid = [sectionDic objectForKey:@"QID"];
        [self requestAnalysis:qid];
    }
    NSArray *pageList = [sectionDic objectForKey:@"QuestionPageList"]; //每一页的list
    
//    NSInteger numberBegin = [[sectionDic objectForKey:@"QNumberBegin"]integerValue];
//    NSInteger numberEnd = [[sectionDic objectForKey:@"QNumberEnd"]integerValue];
//    NSString *titles = [NSString stringWithFormat:@"Questions %ld—%ld",(long)numberBegin,(long)numberEnd-1];
//    if (_detailLabel != nil) {
//        NSString *section;
//        if (kStringEqual(self.testType, @"口语")) {
//            section = [NSString stringWithFormat:@"Section %ld",(long)self.rememberPage+1];
//            _detailLabel.text = [NSString stringWithFormat:@"%@  %@",section,titles];
//
//        }else if (kStringEqual(self.testType, @"口语"))
//        {
//            section = [NSString stringWithFormat:@"Reading Passage %ld",(long)self.rememberPage+1];
//            _detailLabel.text = [NSString stringWithFormat:@"%@  %@",section,titles];
//
//        }else if (kStringEqual(self.testType, @"口语"))
//        {
//            _detailLabel.text = [NSString stringWithFormat:@"Writing Task %ld",(long)self.rememberPage+1];
//
//        }else if (kStringEqual(self.testType, @"口语"))
//        {
//            _detailLabel.text = [NSString stringWithFormat:@"Part %ld",(long)self.rememberPage+1];
//
//        }
//    }
    NSMutableArray *pageSegement = [[NSMutableArray alloc]initWithCapacity:pageList.count];
    fileNameArray = [[NSMutableArray alloc]initWithCapacity:pageList.count];
    pidArray = [[NSMutableArray alloc]initWithCapacity:pageList.count];
    readArray = [[NSMutableArray alloc]initWithCapacity:pageList.count];
//    speakArray = [[NSMutableArray alloc]initWithCapacity:pageList.count];
    for (int i=0; i< pageList.count; i++) {
        NSDictionary *pageDic = pageList[i];
        NSInteger begin = [[pageDic objectForKey:@"QNumberBegin"] integerValue];
        NSInteger end = [[pageDic objectForKey:@"QNumberEnd"] integerValue];
        
        NSArray *audioFiles = [pageDic objectForKey:@"AudioFiles"];
        if (audioFiles.count > 0) {
            //切换的时候停止
            [[AFSoundManager sharedManager]stop];
            self.audioString = audioFiles[0];
        }
        if (end - begin == 0) {  //没有得分点
//            if (kStringEqual(self.testType, @"口语")) {
//                NSString *speakFileName = [pageDic objectForKey:@"FileName"];
//                NSString  *domainPFolder = [self.dataDic objectForKey:@"domainPFolder"];
//                NSString *pathUrl = [NSString stringWithFormat:@"%@/%@",domainPFolder,speakFileName];
//                [speakArray addObject:pathUrl];
//            }
            if (kStringEqual(self.testType, @"阅读")) {
                NSString *fileName = [pageDic objectForKey:@"FileName"];
                NSString  *domainPFolder = [self.dataDic objectForKey:@"domainPFolder"];
                NSString *pathUrl = [NSString stringWithFormat:@"%@/%@",domainPFolder,fileName];
                [readArray addObject:pathUrl];
            }
        }else
        {

            NSString *segmentTitle = [NSString stringWithFormat:@"%ld-%ld",(long)begin,end-1];
            [pageSegement addObject:segmentTitle];
            //文件名字
            NSString *fileName = [pageDic objectForKey:@"FileName"];
            [fileNameArray addObject:fileName];
            //没个page的id
            NSString *pid = [[pageDic objectForKey:@"PID"] stringValue];
            [pidArray addObject:pid];
        }
    }
    //创建pageSegment
    if (pageSegement.count > 0) {
        [self segmentView:pageSegement];
    }
}

//创建侧边切换
- (void)segmentView:(NSArray *)titlArray
{
    //创建segment
    if (titlArray.count > 0) {
        if (self.segmentMenu == nil) {
            self.segmentMenu = [[XDFExaminSegement alloc] initWithTitles:titlArray
                                                                AndFrame:CGRectMake(0, 100,self.leftView.width,titlArray.count*60)];
            self.segmentMenu.backgroundColor = [UIColor clearColor];
            self.segmentMenu.cellTittleColor = [UIColor whiteColor];
            [self.leftView addSubview:self.segmentMenu];

            __block  XDFExerciseBaseViewController *this = self;
            self.segmentMenu.indexChangeBlock = ^(NSInteger index) {
                [this changeDate:index];
                NSIndexPath *ip = [NSIndexPath indexPathForRow:index inSection:0];
                this.selectIndexPath = ip;
            };
        }
        [self changeDate:0];
        NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
        self.selectIndexPath = ip;
        [self.segmentMenu selectRowAtIndexPath:self.selectIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}
//切换page
- (void)changeDate:(NSInteger)indexInt
{
    if (self.isChack) {
        if (self.explainWebView != nil) {
            self.explainWebView.hidden = YES;
            self.buttAction.enabled = YES;
        }
        if (self.listenWeb != nil) {
            self.listenWeb.hidden = NO;
        }
        if (self.webView != nil) {
            self.webView.hidden = NO;
        }
    }
    self.curenPage = indexInt;
    if (kStringEqual(self.testType, @"口语")) {
        if (self.isChack) {
            [self creatPlay]; //修改播放状态
        }else
        {
            [self stopRecorld];
        }
    }

    if (indexInt < fileNameArray.count && fileNameArray.count > 0) {
        NSString *fileName =  fileNameArray[indexInt];
        NSString *pid =  pidArray[indexInt];
        
        NSString *domainPFolder = [self.dataDic objectForKey:@"domainPFolder"];
        NSString *pathUrl = [NSString stringWithFormat:@"%@/%@",domainPFolder,fileName];
        self.urlString = pathUrl;
        
        //切换page
        [self changeSeciton:pid];
    }
}
- (void)creatPlay
{

}

//切换page
- (void)changeSeciton:(NSString *)newsPid
{
    if (self.curenPid.length > 0) {
        if (!self.isChack) {
            NSString *curentAnswer = [self doJs:@"getAnswers()"];
            if (self.curenPid != nil) {
                NSString *p_Id = [[self.dataDic objectForKey:@"P_ID"] stringValue];
                NSString *curPids = [NSString stringWithFormat:@"%@_%@",p_Id,self.curenPid];
                [[XDFAnswersManage shardedAnswersManage]removeAnswesData:curPids];  //移除上一次数据
                [[XDFAnswersManage shardedAnswersManage]insertSaveAnswersData:curentAnswer PageID:curPids]; //插入上一次的数据
                NDLog(@"segment%@",curentAnswer);
            }
        }
    }
    NDLog(@"%@",self.curenPid);
    self.curenPid = newsPid;   //修改这一次的页码
    NDLog(@"%@",self.curenPid);
}

- (void)setCurenPid:(NSString *)curenPid
{
    if (_curenPid != curenPid) {
        _curenPid = curenPid;
        if (kStringEqual(self.testType, @"口语")) {
            [self _creatRecload:curenPid];
        }
    }
}

- (void)_creatRecload:(NSString *)curePid
{

}


//请求解析。
- (void)requestAnalysis:(NSString *)qid
{
    /*
      1=听力材料  2=试题解析  3=写作范文
     */
//#warning mark - 查看解析:(查看听力原文，查看听力解析，查看写作范文)
    [[RusultManage shareRusultManage]lookQuestionDocs:qid
                                     targetController:nil
                                          SuccessData:^(NSDictionary *result) {
                                               NSLog(@"%@",result);
                                              NSArray *data = [result objectForKey:@"Data"];
                                              
                                              UIButton *button = (UIButton *)[_leftView viewWithTag:121];
                                              UIButton *button1 = (UIButton *)[_leftView viewWithTag:221];
                                              UIButton *button2 = (UIButton *)[_leftView viewWithTag:321];
                                              UIButton *button3 = (UIButton *)[_leftView viewWithTag:421];
                                              if (button != nil) {
                                                  [button removeFromSuperview];
                                                  button = nil;
                                              }
                                              
                                              if (button1 != nil) {
                                                  [button1 removeFromSuperview];
                                                  button1 = nil;
                                              }
                                              
                                              if (button2 != nil) {
                                                  [button2 removeFromSuperview];
                                                  button2 = nil;
                                              }
                                              
                                              if (button3 != nil) {
                                                  [button3 removeFromSuperview];
                                                  button3 = nil;
                                              }

                                              if (data.count > 0) {
                                                  self.explainArray = data;
                                              }
                                            } errorData:^(NSError *error) {
                                                NSLog(@"%@",error);
                                            }];
}


#pragma mark - InitLeftView
- (void)creatLeftView
{
    //创建左侧视图
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 20,kSecondLevelLeftWidth , kScreenHeight)];
    leftView.backgroundColor = TABBAR_BACKGROUND;
    [self.view addSubview:leftView];
    self.leftView = leftView;
    //返回按钮 93/2, 43/2
    CGFloat backW = 93*kScaleFloat;
    CGFloat backH = 43*kScaleFloat;
    
    UIButton *backButton = [ZCControl createButtonWithFrame:CGRectMake((kSecondLevelLeftWidth-backW)/2, 30, backW, backH) ImageName:@"" Target:self Action:@selector(backAction:) Title:@""];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    
    [leftView addSubview:backButton];
    
    //后退按钮
    CGFloat beforeW = 86*kScaleFloat;
    CGFloat beforeH = 86*kScaleFloat;
    
    UIButton *beforeButton = [ZCControl createButtonWithFrame:CGRectMake((kSecondLevelLeftWidth-beforeW)/2, kScreenHeight-beforeW*2-60, beforeW, beforeH)ImageName:@"" Target:self Action:@selector(leftAction:) Title:@""];
    [beforeButton setBackgroundImage:[UIImage imageNamed:@"arraw_Left.png"] forState:UIControlStateNormal];
    beforeButton.tag = 100;
    [leftView addSubview:beforeButton];
    
    //前进按钮
    UIButton *nextButton = [ZCControl createButtonWithFrame:CGRectMake((kSecondLevelLeftWidth-beforeW)/2, kScreenHeight- beforeW-40, beforeH, beforeH) ImageName:@"" Target:self Action:@selector(rightAction:) Title:@""];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"arraw_Right.png"] forState:UIControlStateNormal];
    nextButton.tag = 101;
    [leftView addSubview:nextButton];
    
    [self.view addSubview:leftView];
    
    //初始化不能点击
    beforeButton.enabled = NO;
    nextButton.enabled = NO;
}
#pragma mark - TimeManager
- (void)saveTime
{
    NSString *p_Id = [[self.dataDic objectForKey:@"P_ID"] stringValue];
    //保存时间
    [kUserDefaults setInteger:time_i forKey:userDefaulfKey(p_Id)];
    [kUserDefaults synchronize];
}

- (void)removeTime
{
    NSString *p_Id = [[self.dataDic objectForKey:@"P_ID"] stringValue];
    [kUserDefaults removeObjectForKey:userDefaulfKey(p_Id)];
    [kUserDefaults synchronize];
}

- (NSInteger)getThisTime
{
    NSString *p_Id = [[self.dataDic objectForKey:@"P_ID"] stringValue];
    return  [kUserDefaults integerForKey:userDefaulfKey(p_Id)];
}

#pragma mark - Action
//返回
- (void)backAction:(UIButton *)button
{
    [self.timer invalidate];
    self.timer = nil;
    //保存时间
    [self saveTime];
    //保存答案
    [self saveAnswer];

    if (self.isFromScore) {
        switch (self.controlType) {
            case ControlTypeDay:
            {
                [self.navigationController popToViewController:self.dayDetailController animated:YES];
            }
                break;
            case ControlTypeTypes:
            {
                [self.navigationController popToViewController:self.listController animated:YES];
            }
                break;

            case ControlTypeHome:
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
                break;

            case ControlTypeSchedule:
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
                break;
            default:
                break;
        }
            }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)speakAction:(UIButton *)button
{
    NSString *p_Id = [[self.dataDic objectForKey:@"P_ID"] stringValue];
    NSString *curPids = [NSString stringWithFormat:@"%@_%@",p_Id,self.curenPid];
    NSString *isRecording = [NSString stringWithFormat:@"isRecording_%@",curPids];
    if ([kUserDefaults boolForKey:isRecording]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"正在录音...是否进入下一题或者提交？"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"确定", nil];
        [alert show];
    }else
    {
        //判断左右
        if (self.isLeft) {
            [self before:button];
        }else if (self.isRight)
        {
            [self last:button];
        }
    }
}

//后退
- (void)leftAction:(UIButton *)button
{
    NDLog(@"后退");
    if (kStringEqual(self.testType, @"口语")) {
        if (self.isChack) {
            [self before:button];
        }else
        {
            self.isRight = NO;
            self.isLeft = YES;
            [self speakAction:button];
        }
    }else
    {
        [self before:button];
    }
}

- (void)before:(UIButton *)button
{
    if (self.curenSection == 0) {
        button.enabled = NO;
    }else
    {
        button.enabled = YES;
        NSInteger section = self.curenSection - 1;
        if (section == 0) {
            button.enabled = NO;
        }
        self.curenSection = section;
        [self saveAnswer]; //保存答案
        if (self.segmentMenu != nil) {
            [self.segmentMenu removeFromSuperview];
            self.segmentMenu = nil;
            [self _dealSegment];
        }
    }
}


//前进
- (void)rightAction:(UIButton *)button
{
    NDLog(@"前进");
    if (kStringEqual(self.testType, @"口语")) {
        if (self.isChack) {
            [self last:button];
        }else
        {
            self.isRight = YES;
            self.isLeft = NO;
            [self speakAction:button];
        }
    }else
    {
        [self last:button];
    }
}

- (void)last:(UIButton *)button
{
    if (self.curenSection == _sectionArray.count) {
        //提示退出练习
        if (!self.isChack) {
            [self tipEnter:@"确认结束练习"];
        }else
        {
            [self tipEnter:@"确认结束查看练习"];
        }
        
    }else
    {
        UIButton *before = (UIButton *)[self.view viewWithTag:100];
        before.enabled = YES;
        NSInteger section = self.curenSection + 1;
        if (section == _sectionArray.count) {
            if (section == 1) {
                before.enabled = NO;
            }
            //提示退出练习
            if (!self.isChack) {
                [self tipEnter:@"确认结束练习"];
            }else
            {
                [self tipEnter:@"确认结束查看练习"];
            }
        }else
        {
            self.curenSection = section;
            [self saveAnswer]; //保存答案
            
            if (self.segmentMenu != nil) {
                [self.segmentMenu removeFromSuperview];
                self.segmentMenu = nil;
                [self _dealSegment];
            }
        }
    }
}



- (void)tipEnter:(NSString *)tip
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示"
                                                   message:tip
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"确定", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }else
    {
        if (kStringEqual(self.testType, @"口语")) {
            [self stopRecorld];
        }
        //停止时间
        [self.timer invalidate];
        self.timer = nil;

        //销毁音频
//        [self destroyStreamer];
        //上传答案
        [self upLoadAnswer];
        //返回
        [self backAction:nil];
        
    }
}
//停止录音
- (void)stopRecorld
{

}

- (void)upLoadAnswer
{
    if (self.isChack) {
        return;
    }
    NSString *p_Id = [[self.dataDic objectForKey:@"P_ID"] stringValue];
    NSString *taskType = [[self.dataDic objectForKey:@"TaskType"] stringValue];
    NSString *st_ID;
    if (self.controlType == ControlTypeHome) {
        st_ID = self.st_ID;
    }else{
        st_ID = [[self.dataDic objectForKey:@"ST_ID"] stringValue];
    }
    if (p_Id.length > 0 && st_ID.length>0  && time_i > 0) {
        NSString *time = [NSString stringWithFormat:@"%ld",(long)time_i];
        [[RusultManage shareRusultManage]requestExamInfoid:p_Id
                                                  costTime:time
                                          targetController:self
                                                  taskType:taskType
                                               SuccessData:^(NSDictionary *result) {
                                                   if (![[result objectForKey:@"Data"] isKindOfClass:[NSNull class]]) {
                                                        NSString *examinfoId =  [[result objectForKey:@"Data"] stringValue];
                                                       //修改完成状态
                                                       [self changeStatus:examinfoId stID:st_ID];
                                                       //上传mp3答案
                                                       if (kStringEqual(self.testType, @"口语")) {
                                                            if (self.upDateMusicArray.count > 0) {
                                                               for (NSString *pid in self.upDateMusicArray) {
                                                                   NSString *p_Id = [[self.dataDic objectForKey:@"P_ID"] stringValue];
                                                                   NSString *curPids = [NSString stringWithFormat:@"%@_%@",p_Id,pid];
                                                                   NSString *answers = [[XDFAnswersManage shardedAnswersManage]getAnswersData:curPids];
                                                                   [self upLoadMp3:examinfoId pageID:p_Id stId:st_ID answer:answers pid:pid];
                                                               }
                                                           }
                                                       }else
                                                       {
                                                            if (self.upDateMusicArray.count > 0) {
                                                               NSMutableString *rusultAnswers = [[NSMutableString alloc]init];
                                                                
                                                                for (int i=0; i<self.upDateMusicArray.count; i++) {
                                                                    NSString *pid = self.upDateMusicArray[i];
                                                                    NSString *p_Id = [[self.dataDic objectForKey:@"P_ID"] stringValue];
                                                                    NSString *curPids = [NSString stringWithFormat:@"%@_%@",p_Id,pid];
                                                                    NSString *answers = [[XDFAnswersManage shardedAnswersManage]getAnswersData:curPids];
                                                                    [rusultAnswers appendFormat:@"%@",answers];
                                                                    if (i<self.upDateMusicArray.count-1) {
                                                                        [rusultAnswers appendFormat:@";"];
                                                                    }
                                                                }
                                                               //上传字符串答案
                                                               [self upload:p_Id stID:st_ID answer:rusultAnswers examinfoId:examinfoId];
                                                            }
                                                       }
                                                   }
                                                } errorData:^(NSError *error) {
                                                    
                                                }];
    }
}
- (void)upLoadMp3:(NSString *)examinfoId
           pageID:(NSString *)p_Id
             stId:(NSString *)st_ID
           answer:(NSString *)answer
              pid:(NSString *)pid
{

}
//修改状态，用于首页和
- (void)changeStatus:(NSString *)examinfoId stID:(NSString *)st_id
{
    [[RusultManage shareRusultManage]homeTaskController:nil
                                                  keyID:st_id
                                             examInfoId:examinfoId
                                            SuccessData:^(NSDictionary *result) {
                                            
                                            } errorData:^(NSError *error) {
                                            
                                            }];
}

- (void)upload:(NSString *)p_Id stID:(NSString *)st_ID answer:(NSString *)rusultAnswers examinfoId:(NSString *)examInfoid
{
    //上传答案
    [[RusultManage shareRusultManage]examiUpLoadController:nil
                                                   paperid:p_Id
                                                      stId:st_ID
                                            studentAnswers:rusultAnswers
                                                examInfoId:examInfoid
                                               SuccessData:^(NSDictionary *result) {
                                                   NDLog(@"练习上传答案成功");
                                                   if (![[result objectForKey:@"Result"]isKindOfClass:[NSNull class]]) {

                                                       if ([[result objectForKey:@"Result"]boolValue]) {
                                                           //答案提交成功
                                                           [self showHint:@"提交成功"];
                                                           
                                                           //移除保存本地的时间
                                                           [self removeTime];
                                                           //移除答案
                                                           [self removeAnswer];
                                                           
                                                           
                                                           
                                                       }else
                                                       {
                                                           if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]]) {
                                                               NSString *Infomation = [result objectForKey:@"Infomation"];
                                                               [[RusultManage shareRusultManage]tipAlert:Infomation viewController:self];
                                                           }
                                                       }
                                                   }
                                                   
                                               } errorData:^(NSError *error) {
                                                   //答案提交失败
                                                   [self showHint:@"提交失败"];
                                                   NDLog(@"练习上传答案失败");
                                               }];

}

//移除所有答案
- (void)removeAnswer
{
    for (NSString *pid in self.upDateMusicArray) {
        NSString *p_Id = [[self.dataDic objectForKey:@"P_ID"] stringValue];
        NSString *curPids = [NSString stringWithFormat:@"%@_%@",p_Id,pid];
        [[XDFAnswersManage shardedAnswersManage]removeAnswesData:curPids];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self saveAnswer];
    
//    [self destroyStreamer];//销毁音乐
    [[AFSoundManager sharedManager]stop];
    
    [self.timer invalidate];
    self.timer = nil;
    [self saveTime];
}


#pragma mark - 保存答案
- (void)saveAnswer
{
    if (self.isChack) {
        return;
    }
    NSString *p_Id = [[self.dataDic objectForKey:@"P_ID"] stringValue];
    NSString *curPids = [NSString stringWithFormat:@"%@_%@",p_Id,self.curenPid];
    
    NSString *curentAnswer = [self doJs:@"getAnswers()"];
    [[XDFAnswersManage shardedAnswersManage]removeAnswesData:curPids];  //移除本次数据
    [[XDFAnswersManage shardedAnswersManage]insertSaveAnswersData:curentAnswer PageID:curPids];//插入本次答案
}

#pragma mark - InitRightView
- (void)creatRightView
{
    //创建右侧视图
    rightView = [[UIView alloc]initWithFrame:CGRectMake(kSecondLevelLeftWidth, 20, kScreenWidth-kSecondLevelLeftWidth, kScreenHeight)];
    rightView.backgroundColor = rgb(230, 230, 230, 1);
    [self.view addSubview:rightView];
    
    //顶部视图
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, rightView.width, kTopViewHeight)];
    _topView.backgroundColor = [UIColor whiteColor];
    [rightView addSubview:_topView];
    
    
    //1.创建标题
    _titleLabel = [ZCControl createLabelWithFrame:CGRectMake(100, (_topView.height-40)/2, 300, 40) Font:24.0f Text:@""];
    _titleLabel.textColor =TABBAR_BACKGROUND_SELECTED;
    _titleLabel.font = [UIFont boldSystemFontOfSize:24.0f];
    [_topView addSubview:_titleLabel];
    //3.创建副标题
//    _detailLabel = [ZCControl createLabelWithFrame:CGRectMake(_titleLabel.left, _titleLabel.bottom-5, 300, 30) Font:18.0f Text:@""];
//    _detailLabel.textColor = [UIColor lightGrayColor];
//    [_topView addSubview:_detailLabel];
    
    
    //网页视图
    if (kStringEqual(self.testType, @"听力") ||
        kStringEqual(self.testType, @"写作") ||
        kStringEqual(self.testType, @"词汇") ||
        kStringEqual(self.testType, @"语法") ||
        kStringEqual(self.testType, @"综合"))
    {
        listenWeb = [[UIWebView alloc]init];
        listenWeb.frame = CGRectMake(5, _topView.bottom + 5, rightView.width-10, kScreenHeight-kTopViewHeight-10);
        listenWeb.backgroundColor = [UIColor clearColor];
        listenWeb.delegate = self;
        [rightView addSubview:listenWeb];
    }else if (kStringEqual(self.testType, @"阅读"))
    {
        //网页视图
        _webView = [[UIWebView alloc]init];
//        _webView.frame = CGRectMake(5, kTopViewHeight+5, (kScreenWidth-80)/2, kScreenHeight-kTopViewHeight-5);
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor clearColor];
        [rightView addSubview:_webView];
        
        //网页2
        listenWeb = [[UIWebView alloc]init];
        listenWeb.delegate = self;
        listenWeb.backgroundColor = [UIColor clearColor];
        [rightView addSubview:listenWeb];
        
        _webView.frame = CGRectMake(5, kTopViewHeight+5, (kScreenWidth-80)/2, kScreenHeight-kTopViewHeight-5);
        listenWeb.frame = CGRectMake(10+(kScreenWidth-80)/2, kTopViewHeight+5,(kScreenWidth-80-20)/2, kScreenHeight-kTopViewHeight-5);
        
    }
    else if (kStringEqual(self.testType, @"口语"))
    {
        //网页视图
        listenWeb = [[UIWebView alloc]init];
        listenWeb.frame = CGRectMake(5, _topView.bottom + 5, rightView.width-10, (kScreenHeight-kTopViewHeight-8)*0.8);
        listenWeb.backgroundColor = [UIColor clearColor];
//        listenWeb.hidden = YES;
        listenWeb.delegate = self;
        [rightView addSubview:listenWeb];
        
//        _webView = [[UIWebView alloc]init];
//        _webView.frame = CGRectMake(5, _topView.bottom + 5, rightView.width-10, (kScreenHeight-kTopViewHeight-8)*0.8);
//        _webView.delegate = self;
//        _webView.backgroundColor = [UIColor clearColor];
//        [rightView addSubview:_webView];
    }
    
    if (self.isChack) {
        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(5, _topView.bottom + 5, rightView.width-10, kScreenHeight-kTopViewHeight-10)];
        webView.delegate = self;
        webView.hidden = YES;
        webView.backgroundColor = [UIColor clearColor];
        [rightView addSubview:webView];
        self.explainWebView = webView;
    }
}

- (void)setExplainArray:(NSArray *)explainArray
{
    if (_explainArray != explainArray) {
        _explainArray = explainArray;
        [self _cretExplainArray:explainArray];
    }
}

- (void)_cretExplainArray:(NSArray *)explainArray
{
    /*
     1=听力材料  2=试题解析  3=写作范文
     */
    CGFloat beforeH = 70*kScaleFloat;
    _hasExplainArray = [[NSMutableArray alloc]initWithCapacity:explainArray.count];
    for (int i = 0; i< explainArray.count; i++) {
        NSDictionary *dic = explainArray[i];
        NSString *docType = [[dic objectForKey:@"DocType"] stringValue];
        UIButton *buttAction = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttAction setBackgroundImage:[ZCControl createImageWithColor:TABBAR_BACKGROUND] forState:UIControlStateDisabled];
        [buttAction setBackgroundImage:[ZCControl createImageWithColor:TABBAR_BACKGROUND_SELECTED] forState:UIControlStateDisabled];
        buttAction.frame = CGRectMake(0, kScreenHeight-beforeH*2-120-beforeH*(i+1), kSecondLevelLeftWidth, beforeH);
        [buttAction addTarget:self action:@selector(testExplain:) forControlEvents:UIControlEventTouchUpInside];
        [buttAction setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buttAction.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        if (kStringEqual(docType, @"1")) {
            NSString *body =  [dic objectForKey:@"body"];
            self.listenBody = body;
            if (![body isKindOfClass:[NSNull class]] && body.length > 0 && ![body isEqualToString:@""]) {
                [buttAction setTitle:@"听力材料" forState:UIControlStateNormal];
                 buttAction.tag = 121;
            }
        }else if (kStringEqual(docType, @"2"))
        {
            NSString *body =  [dic objectForKey:@"body"];
            self.testBody = body;
            if (![body isKindOfClass:[NSNull class]] && body.length > 0 && ![body isEqualToString:@""]) {
                [buttAction setTitle:@"试题解析" forState:UIControlStateNormal];
                buttAction.tag= 221;
            }
        }else if (kStringEqual(docType, @"3"))
        {
            NSString *body =  [dic objectForKey:@"body"];
            self.writeBody = body;
            if (![body isKindOfClass:[NSNull class]] && body.length > 0 && ![body isEqualToString:@""]) {
                [buttAction setTitle:@"写作范文" forState:UIControlStateNormal];
                buttAction.tag = 321;
            }
           
        }else if(kStringEqual(docType, @"4"))
        {
            NSString *body =  [dic objectForKey:@"body"];
            self.answerBody = body;
            if (![body isKindOfClass:[NSNull class]] && body.length > 0 && ![body isEqualToString:@""]) {
                [buttAction setTitle:@"参考答案" forState:UIControlStateNormal];
                buttAction.tag = 421;
            }
    }
         self.buttAction = buttAction;
        [_leftView addSubview:buttAction];
    }
}
//试题解析
- (void)testExplain:(UIButton *)button
{
    if (self.buttAction.tag != button.tag) {
        if (listenWeb != nil) {
            listenWeb.hidden = YES;
        }
        if (_webView != nil) {
            _webView.hidden = YES;
        }
        self.explainWebView.hidden = NO;
        [self seleExplainWeb:button.tag];
        
        self.buttAction.enabled = YES;
        button.enabled = NO;
        self.buttAction = button;
    }else
    {
        if (button.enabled) {
            if (listenWeb != nil) {
                listenWeb.hidden = YES;
            }
            if (_webView != nil) {
                _webView.hidden = YES;
            }
            self.explainWebView.hidden = NO;
        }else
        {
            if (listenWeb != nil) {
                listenWeb.hidden = NO;
            }
            if (_webView != nil) {
                _webView.hidden = NO;
            }
            self.explainWebView.hidden = YES;
        }
        button.enabled = !button.enabled;
        [self seleExplainWeb:button.tag];
    }
    [self.segmentMenu  deselectRowAtIndexPath:self.selectIndexPath animated:NO];

//    
//    if (self.buttAction.tag != button.tag) {
//        // 1.控制状态
//        self.buttAction.selected = NO;
//        button.selected = YES;
//        self.buttAction = button;
//        [self seleExplainWeb:button.tag];
//        
//        if (listenWeb != nil) {
//            listenWeb.hidden = YES;
//           
//        }
//        if (_webView != nil) {
//             _webView.hidden = YES;
//        }
//        self.explainWebView.hidden = NO;
//    }
//    else
//    {//2.取消状态
//        button.selected = !button.selected;
//        if (button.selected) {
//            [self seleExplainWeb:button.tag];
//            
//            if (listenWeb != nil) {
//                listenWeb.hidden = YES;
//            }
//            if (_webView != nil) {
//                _webView.hidden = YES;
//            }
//             self.explainWebView.hidden = NO;
//        }else
//        {
//            if (listenWeb != nil) {
//                listenWeb.hidden = NO;
//            }
//            if (_webView != nil) {
//                _webView.hidden = NO;
//            }
//            self.explainWebView.hidden = YES;
//        }
//    }
}

- (void)seleExplainWeb:(NSInteger)tags
{
    switch (tags) {
        case 121:
        {
            if (self.listenBody.length > 0) {
                [self explainWebView:self.listenBody];
            }
        }
            break;
        case 221:
        {
            if (self.testBody.length > 0) {
                [self explainWebView:self.testBody];
            }
        }
            break;
        case 321:
        {
            if (self.writeBody.length > 0) {
                [self explainWebView:self.writeBody];
            }
        }
            break;
        case 421:
        {
            if (self.answerBody.length > 0) {
                [self explainWebView:self.answerBody];
            }
        }
            break;
        default:
            break;
    }
}


- (void)explainWebView:(NSString *)body
{
    [self.explainWebView loadHTMLString:body baseURL:nil];
}


#pragma marK - 加载音频文件
- (void)setAudioString:(NSString *)audioString
{
//    if (self.isChack) {
//        return;
//    }
    if (_audioString != audioString) {
        _audioString = audioString;
        if (audioString.length > 0) {
            //销毁音频
            //4.创建播放按钮
            UIButton *audioButton = [ZCControl createButtonWithFrame:CGRectMake(kScreenWidth-200, (kTopViewHeight-49)/2, 49, 49) ImageName:@"" Target:self Action:@selector(playAudio:) Title:@""];
            [audioButton setImage:[UIImage imageNamed:@"btn_paly.png"] forState:UIControlStateNormal];
            [audioButton setImage:[UIImage imageNamed:@"btn_pause.png"]forState:UIControlStateSelected];
            [_topView addSubview:audioButton];
            self.audioButton = audioButton;
        }
    }
}
//播放音频文件
- (void)playAudio:(UIButton *)playButton
{
    playButton.selected = !playButton.selected;
    if (!playButton.selected) {
        [[AFSoundManager sharedManager]pause];
    }else{
        //创建音频
        if ([AFSoundManager sharedManager].player == nil) {
            [self createStreamer];
        }

        [[AFSoundManager sharedManager]resume];
    }
}
- (void)createStreamer
{
    NSString  *domainPFolder = [self.dataDic objectForKey:@"domainPFolder"];
    NSString *pathUrl = [NSString stringWithFormat:@"%@/%@",domainPFolder,_audioString];
//    NSString *pathUrl = @"http://testielts.staff.xdf.cn/IELTS/paperzip/TempPaper_9568/1427175626573406.mp3";
    if (pathUrl.length > 0 ) {  //防止为空
        [[AFSoundManager sharedManager]startStreamingRemoteAudioFromURL:pathUrl
                                                               andBlock:^(int percentage, CGFloat elapsedTime, CGFloat timeRemaining, NSError *error, BOOL finished) {
                                                                   if (!error) {
                                                                       if (finished) {//播放完成
                                                                           self.audioButton.selected = NO;
                                                                       }
                                                                   }else
                                                                   {
                                                                       NSLog(@"%@",[error description]);
                                                                       self.audioButton.selected = NO;
                                                                   }
                                                               }];
    }else
    {
        [[RusultManage shareRusultManage]tipAlert:@"音频文件不正确,请与管理员联系!"];
        self.audioButton.selected = NO;
    }
}
#pragma mark - 加载网页
- (void)setUrlString:(NSString *)urlString
{
    if (_urlString != urlString) {
        _urlString = urlString;
        [self reloadListenWeb:_urlString];
    }
}
- (void)reloadListenWeb:(NSString *)url
{
    if (url.length > 0) {
        if (listenWeb != nil) {
            NSURL *path = [NSURL URLWithString:url];
            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:path];
            [listenWeb loadRequest:request];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        }
        //加载阅读视图
        if (kStringEqual(self.testType, @"阅读")) {
            [self loadReadWeb];
        }
//        if (kStringEqual(self.testType, @"口语")) {
//            [self loadSpeakWeb];
//        }
    }
}
//加载口语
//- (void)loadSpeakWeb
//{
//    if (speakArray.count > self.curenPage ) {
//        NSString *path = speakArray[self.curenPage];
//        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:path]];
//        [_webView loadRequest:request];
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    }
//}
//
//加载阅读视图
- (void)loadReadWeb{
    if (readArray.count > 0 ) {
        NSString *path = readArray[0];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:path]];
        [_webView loadRequest:request];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
}

#define mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
     NSString *p_Id = [[self.dataDic objectForKey:@"P_ID"] stringValue];
    if (!self.isChack) {
        //获取这一次的答案
        NSString *curPids = [NSString stringWithFormat:@"%@_%@",p_Id,self.curenPid];
        NSString *answers = [[XDFAnswersManage shardedAnswersManage]getAnswersData:curPids];
        if (answers != nil) {
            //填充这一次的答案
            NSString *myAnswer = [NSString stringWithFormat:@"setMyAnswers(\'%@\')",answers];
            [self doJs:myAnswer];
        }
        
        //进入后台通知保存时间和答案
        [[NSNotificationCenter defaultCenter]removeObserver:kEnterBackSaveAnswers];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterBackAction:) name:kEnterBackSaveAnswers object:nil];
    }else
    {
        
        //禁用
        NSString *stopUser = [NSString stringWithFormat:@"disableAll()"];
        [self doJs:stopUser];
        //获取得分点
        NSString *myScorec = [NSString stringWithFormat:@"getScoreList()"];
        NSString *getScoreList =  [self doJs:myScorec];
        [[RusultManage shareRusultManage]requestMyAnswer:self
                                            ANswerQSCode:getScoreList
                                                 paperId:p_Id
                                             SuccessData:^(NSDictionary *result) {
                                                 NDLog(@"%@",result);
                                                 NSString *data = [result objectForKey:@"Data"];
                                                 if (data.length > 0) {
                                                     if (kStringEqual(self.testType, @"口语")) {
                                                         NSArray *speakArrays = [data componentsSeparatedByString:@"#:#"];
                                                         if (speakArrays.count > 1) {
                                                             NSString *url = speakArrays[1];
                                                             self.checkSpeakUrl = url;
                                                         }
                                                     }
                                                     NSString *myAnswers = [NSString stringWithFormat:@"setAnswers(\'%@\')",data];
                                                     [self doJs:myAnswers];
                                                 }
                                             } errorData:^(NSError *error) {
            
                                             }];
    }
}
#pragma mark - getJSAction
- (NSString *)doJs:(NSString *)js
{
    if (js == nil || [js length] == 0) {
        return nil;
    }
    NSLog(@"+++++ webview dojs ++++ = %@", js);
    NSString *jsString = [listenWeb stringByEvaluatingJavaScriptFromString:js];
    return jsString;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}
@end
