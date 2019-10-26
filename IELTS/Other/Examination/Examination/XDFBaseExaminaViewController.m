//
//  XDFBaseExaminaViewController.m
//  IELTS
//
//  Created by 李牛顿 on 14-12-22.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFBaseExaminaViewController.h"
#import "XDFExaminSegement.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AFSoundManager.h"

#define  kScaleFloat 0.7
#define  kTopView_ 100

@interface XDFBaseExaminaViewController ()<AVAudioPlayerDelegate,UIAlertViewDelegate,UIWebViewDelegate>

@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong)UIWebView *readWeb;
@property (nonatomic,strong)UIWebView *explainWebView;
@property (nonatomic,strong)NSMutableArray *hasExplainArray;

@property (nonatomic,strong) NSString *listenBody;
@property (nonatomic,strong) NSString *testBody;
@property (nonatomic,strong) NSString *writeBody;
@property (nonatomic,strong) UIButton *buttAction;

//@property (nonatomic,assign)NSInteger curenSegment;
//@property (nonatomic,assign)NSInteger curenSection;
@property (nonatomic,strong)NSString *pageId;


@property (nonatomic,strong)XDFExaminSegement *segmentMenu;
//@property (nonatomic,strong)NSMutableArray *pageArray;

@property (nonatomic,strong)NSIndexPath *selectIndexPath;//选中效果
@property (nonatomic,assign)NSInteger selectRow;

//音乐
@property (nonatomic,strong)AVAudioPlayer *audioPlayer;
@property (nonatomic,strong)UIView *leftView_;//左侧视图


@property (nonatomic,strong)NSMutableArray *fileNameArray;  //试卷的数组
@property (nonatomic,strong)NSMutableArray *readFileNameArray; //阅读材料
@property (nonatomic,strong)NSMutableArray *pagePidArray;
//@property (nonatomic,strong) NSMutableArray *spearkArray; //口语材料

@property (nonatomic,assign) BOOL isRecording_;  //正在录音
@property (nonatomic,assign) BOOL isLesson_;  //听力
@property (nonatomic,assign) BOOL isLeftButton_;
@property (nonatomic,assign) BOOL isRightButton_;

//@property (nonatomic,strong)NSString *currentAudioPath;
@property (nonatomic,strong) NSString   *speakFileName; //口语链接

@property (nonatomic,strong) NSTimer *timerLesson;//定时器
@property (nonatomic,strong) NSTimer *timerRead;
@property (nonatomic,strong) NSTimer *timerWrite;
@property (nonatomic,strong) NSTimer *timerSpeak;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,assign) BOOL isStart_; //开始

@property (nonatomic,assign) NSInteger lessT;
@property (nonatomic,assign) NSInteger writeT;
@property (nonatomic,assign) NSInteger speakT;
@property (nonatomic,assign) NSInteger readT;

@property (nonatomic,strong) UIButton *audioButton;

@end

@implementation XDFBaseExaminaViewController
@synthesize leftView_,rigthView_,topView_,fileNameArray,readFileNameArray;//,spearkArray;
@synthesize isRecording_,isLeftButton_,isRightButton_;
@synthesize isLesson_;
@synthesize isStart_;
@synthesize readWeb;
@synthesize listenBody,testBody,writeBody;
- (void)viewDidLoad {
    [super viewDidLoad];

    //进入后台通知保存时间和答案
    [[NSNotificationCenter defaultCenter]removeObserver:kEnterBackSaveAnswers];
    [[NSNotificationCenter defaultCenter]removeObserver:k_HeadphonesAudio];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(HeadphonesAudio) name:k_HeadphonesAudio object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterBackSaveAction:) name:kEnterBackSaveAnswers object:nil];
    self.view.backgroundColor = [UIColor blackColor];
    //默认为第一个section
//    self.rememberPage = 0;
    
    //1.创建右边视图
    [self _initRightView];
    
    //2.创建左边视图
    [self _initLeftView];
}

- (void)setCurrentType:(NSInteger)currentType
{
    if (_currentType != currentType) {
        _currentType = currentType;
        if (!self.isCheck) {
          [self startTime_];
        }
    }
}

- (void)HeadphonesAudio
{
    if (self.audioButton != nil) {
        self.audioButton.selected = NO;
    }
}

//开启定时器
- (void)startTime_
{
    NSString *saveTimeId = [NSString stringWithFormat:@"%@and%ld",self.pId,(long)_currentType];
    switch (_currentType) {
        case 1:
        {
            if (self.timerLesson == nil) {
                NSInteger time = [[XDFAnswersManage shardedAnswersManage]getTimerId:saveTimeId];
                if (time != 0) {
                    self.lessT = time;
                }else
                {
                    self.lessT = 40*60;
                }
                [self.timerLesson invalidate];
                self.timerLesson = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startLes:) userInfo:nil repeats:YES];
            }
        }
            break;
        case 2:
        {
            if (self.timerRead == nil) {
                NSInteger time = [[XDFAnswersManage shardedAnswersManage]getTimerId:saveTimeId];
                if (time != 0) {
                    self.readT = time;
                }else
                {
                    self.readT = 60*60;
                }
                [self.timerRead invalidate];
                self.timerRead = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startLes:) userInfo:nil repeats:YES];
            }
        }
            break;

        case 3:
        {
            if (self.timerWrite == nil) {
                
                NSInteger time = [[XDFAnswersManage shardedAnswersManage]getTimerId:saveTimeId];
                if (time != 0) {
                    self.writeT = time;
                }else
                {
                    self.writeT = 60*60;
                }
                
                [self.timerWrite invalidate];
                self.timerWrite = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startLes:) userInfo:nil repeats:YES];
            }
        }
            break;

        case 4:
        {
            if (self.timerSpeak == nil) {
                NSInteger time = [[XDFAnswersManage shardedAnswersManage]getTimerId:saveTimeId];
                if (time != 0) {
                    self.speakT = time;
                }else
                {
                    self.speakT = 14*60;
                }
                [self.timerSpeak invalidate];
                self.timerSpeak = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startLes:) userInfo:nil repeats:YES];
            }
        }
            break;
        default:
            break;
    }
}


#pragma mark-初始化视图
- (void)_initLeftView
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
    //创建segment
    
    [self _creatSegment];
    //后退按钮
    CGFloat beforeW = 86*kScaleFloat;
    CGFloat beforeH = 86*kScaleFloat;
    
    UIButton *beforeButton = [ZCControl createButtonWithFrame:CGRectMake((kSecondLevelLeftWidth-beforeW)/2, kScreenHeight-beforeW*2-60, beforeW, beforeH)ImageName:@"" Target:self Action:@selector(leftAction:) Title:@""];
    [beforeButton setBackgroundImage:[UIImage imageNamed:@"arraw_Left.png"] forState:UIControlStateNormal];
    beforeButton.tag = 1000;
    [leftView_ addSubview:beforeButton];
    
    //前进按钮
    UIButton *nextButton = [ZCControl createButtonWithFrame:CGRectMake((kSecondLevelLeftWidth-beforeW)/2, kScreenHeight- beforeW-40, beforeH, beforeH) ImageName:@"" Target:self Action:@selector(rightAction:) Title:@""];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"arraw_Right.png"] forState:UIControlStateNormal];
    nextButton.tag = 1001;
    [leftView_ addSubview:nextButton];
    
    [self.view addSubview:leftView_];
    
    //控制按钮
    if (self.rememberPage == 0 ) {
        nextButton.enabled = YES;
        beforeButton.enabled = NO;
        
    }else
    {
        beforeButton.enabled = YES;
        nextButton.enabled = YES;
    }
}

- (void)_creatSegment
{
    //创建视图，每个seciton分了多个segment
    if (_dataArray.count > self.rememberPage) {
        NSDictionary *sectionData = _dataArray[self.rememberPage];
        if (self.isCheck) {
            NSString *qid = [sectionData objectForKey:@"QID"];
            [self requestAnalysis:qid];
        }
        NSArray *pageList =  [sectionData objectForKey:@"QuestionPageList"];
        NSMutableArray *titlesArray = [[NSMutableArray alloc]initWithCapacity:_dataArray.count];
        fileNameArray = [[NSMutableArray alloc]initWithCapacity:_dataArray.count];
        readFileNameArray = [[NSMutableArray alloc]initWithCapacity:_dataArray.count];
//        spearkArray = [[NSMutableArray alloc]initWithCapacity:_dataArray.count];
        
        _pagePidArray = [[NSMutableArray alloc]initWithCapacity:_dataArray.count];
        for (int i=0 ;i < pageList.count ; i++) {
            NSInteger qNumberBegin =  [[pageList[i] objectForKey:@"QNumberBegin"] integerValue];
            NSInteger qNumberEnd  = [[pageList[i] objectForKey:@"QNumberEnd"] integerValue];
            //获取每张试卷的PID
            //        NDLog(@"%@",[pageList[i] objectForKey:@"PID"]);
            NSString *pagePId = [[pageList[i] objectForKey:@"PID"] stringValue];
            
            if (qNumberEnd - qNumberBegin == 0) {
                NSArray *audioFiles = [pageList[i] objectForKey:@"AudioFiles"];
                if (audioFiles.count > 0) {
                    self.audioFiles = audioFiles[0];
                }
                //阅读双屏处理
                if (_currentType == 2) {
                    NSString *fileName = [pageList[i] objectForKey:@"FileName"];
                    if (self.isCheck) {
                        NSString *pathUrl = [NSString stringWithFormat:@"%@/%@",self.domainPFolder,fileName];
                        [readFileNameArray addObject:pathUrl];
                    }else
                    {
                        NSString *fileForld = [[DownLoadManage ShardedDownLoadManage]useIDSelect:self.pId];
                        NSString *savePath =  [NSString stringWithFormat:@"%@/%@",[DownLoadManage getDocumentPath],fileForld];
                        NSString *file = [NSString stringWithFormat:@"%@/%@",savePath,fileName];
                        [readFileNameArray addObject:file];
                    }
                }
                
                //口语部分的处理
//                if (_currentType == 4) {
//                    NSString *fileName = [pageList[i] objectForKey:@"FileName"];
//                    if (self.isCheck) {
//                        NSString *pathUrl = [NSString stringWithFormat:@"%@/%@",self.domainPFolder,fileName];
//                        [spearkArray addObject:pathUrl];
//                    }else
//                    {
//                        NSString *fileForld = [[DownLoadManage ShardedDownLoadManage]useIDSelect:self.pId];
//                        NSString *savePath =  [NSString stringWithFormat:@"%@/%@",[DownLoadManage getDocumentPath],fileForld];
//                        NSString *file = [NSString stringWithFormat:@"%@/%@",savePath,fileName];
//                        [spearkArray addObject:file];
//                    }
//                }
                
            }else
            {
                //segment的标题
                NSString *titles = [NSString stringWithFormat:@"%ld—%ld",(long)qNumberBegin,(long)qNumberEnd-1];;
                [titlesArray addObject:titles];
                //文件的链接
                NSString *fileName = [pageList[i] objectForKey:@"FileName"];
                if (self.isCheck) {
                    NSString *pathUrl = [NSString stringWithFormat:@"%@/%@",self.domainPFolder,fileName];
                    [fileNameArray addObject:pathUrl];
                }else
                {
                    NSString *fileForld = [[DownLoadManage ShardedDownLoadManage]useIDSelect:self.pId];
                    NSString *savePath =  [NSString stringWithFormat:@"%@/%@",[DownLoadManage getDocumentPath],fileForld];
                    NSString *file = [NSString stringWithFormat:@"%@/%@",savePath,fileName];
                    [fileNameArray addObject:file];
                }
                [_pagePidArray addObject:pagePId];
                
                
            }
        }
        NSInteger numberBegin = [[sectionData objectForKey:@"QNumberBegin"]integerValue];
        NSInteger numberEnd = [[sectionData objectForKey:@"QNumberEnd"]integerValue];
        NSString *titles = [NSString stringWithFormat:@"Questions %ld—%ld",(long)numberBegin,(long)numberEnd-1];
        if (_detailLabel != nil) {
            NSString *section;
            switch (_currentType) {
                case 1:
                {
                    section = [NSString stringWithFormat:@"Section %ld",(long)self.rememberPage+1];
                    _detailLabel.text = [NSString stringWithFormat:@"%@  %@",section,titles];
                }
                    break;
                case 2:
                {
                    section = [NSString stringWithFormat:@"Reading Passage %ld",(long)self.rememberPage+1];
                    _detailLabel.text = [NSString stringWithFormat:@"%@  %@",section,titles];
                }
                    break;
                case 3:
                {
                    _detailLabel.text = [NSString stringWithFormat:@"Writing Task %ld",(long)self.rememberPage+1];
                }
                    break;
                case 4:
                {
                    _detailLabel.text = [NSString stringWithFormat:@"Part %ld",(long)self.rememberPage+1];
                }
                    break;
                default:
                    break;
            }
        }
        //固定只有听力，阅读才有segment
//        if (_currentType == 1 || _currentType == 2) {
            //创建segment
            if (self.segmentMenu == nil) {
                self.segmentMenu = [[XDFExaminSegement alloc] initWithTitles:titlesArray
                                                                    AndFrame:CGRectMake(0, 100,self.leftView_.width,titlesArray.count*60)];
                self.segmentMenu.backgroundColor = [UIColor clearColor];
                self.segmentMenu.cellTittleColor = [UIColor whiteColor];
                [self.leftView_ addSubview:self.segmentMenu];
                
                __block  XDFBaseExaminaViewController *this = self;
                self.segmentMenu.indexChangeBlock = ^(NSInteger index) {
                    [this changeDate:index];
                    
                    NSIndexPath *ip = [NSIndexPath indexPathForRow:index inSection:0];
                    this.selectIndexPath = ip;
                };
            }
//        }
        
//        if (self.rememberSection <= titlesArray.count-1) {
//            
//            [self changeDate:0];
//            //默认选择第一个cell
//            NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
//            self.selectIndexPath = ip;
//            
//        }else
        if(self.rememberSection <= titlesArray.count-1 && self.rememberSection >= 0)
        {
            [self changeDate:self.rememberSection];
            //默认选择第一个cell
            NSIndexPath *ip = [NSIndexPath indexPathForRow:self.rememberSection inSection:0];
            self.selectIndexPath = ip;

        }else
        {
            [self changeDate:0];
            //默认选择第一个cell
            NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
            self.selectIndexPath = ip;
        }
        [self.segmentMenu selectRowAtIndexPath:self.selectIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}
- (void)setAudioFiles:(NSString *)audioFiles
{
    if (_audioFiles != audioFiles) {
        _audioFiles =audioFiles;
        
        //如果是查看题目，不能听听力
        if (self.isCheck) {
            if (audioFiles.length > 0) {
                //销毁音频
//                [self destroyStreamer];
                //4.创建播放按钮
                UIButton *audioButton = [ZCControl createButtonWithFrame:CGRectMake(kScreenWidth-200, (kTopView_-49)/2, 49, 49) ImageName:@"" Target:self Action:@selector(playAudio:) Title:@""];
                [audioButton setImage:[UIImage imageNamed:@"btn_paly.png"] forState:UIControlStateNormal];
                [audioButton setImage:[UIImage imageNamed:@"btn_pause.png"]forState:UIControlStateSelected];
                [topView_ addSubview:audioButton];
                self.audioButton = audioButton;
            }
        }else
        {
            if (audioFiles.length > 0) {
                //4.创建播放按钮
                UIButton *audioButton = [ZCControl createButtonWithFrame:CGRectMake(kScreenWidth-200, (kTopView_-49)/2, 49, 49) ImageName:@"" Target:self Action:@selector(playAudio:) Title:@""];
                [audioButton setImage:[UIImage imageNamed:@"btn_paly.png"] forState:UIControlStateNormal];
                [audioButton setImage:[UIImage imageNamed:@"btn_pause.png"]forState:UIControlStateDisabled];
                [topView_ addSubview:audioButton];
                self.audioButton = audioButton;
                
                NSString *fileForld = [[DownLoadManage ShardedDownLoadManage]useIDSelect:self.pId];
                NSString *savePath =  [NSString stringWithFormat:@"%@/%@",[DownLoadManage getDocumentPath],fileForld];
                NSString *audioPath = [NSString stringWithFormat:@"%@/%@",savePath,audioFiles];
                NSError *readingError;
                if (_audioPlayer != nil && [_audioPlayer isPlaying]) {
                    //                [self tipAlert:@"听力未完成,进入一下级听力将无法回播！"];
                    [_audioPlayer stop];
                    _audioPlayer = nil;
                }
                _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:audioPath] error:&readingError];
                _audioPlayer.volume= 0.5;
                _audioPlayer.delegate = self;
                NDLog(@"%@",readingError);
            }
        }
    }
}


#pragma mark -改变segment
- (void)changeDate:(NSInteger)index
{
     if (self.isCheck) {
        if (self.explainWebView != nil) {
            self.explainWebView.hidden = YES;
            self.buttAction.enabled = YES;
        }
        if (self.readWeb != nil) {
            self.readWeb.hidden = NO;
        }
        if (self.webView != nil) {
            self.webView.hidden = NO;
        }
         [[AFSoundManager sharedManager]stop];
         
    }

    if (_currentType == 2) {
        if (readFileNameArray.count > 0) {
            self.readFileName = readFileNameArray[0];
        }
    }
//    if (_currentType == 4) {
//        if (spearkArray.count > 0) {
//            self.speakFileName = spearkArray[0];
//        }
//    }
    
    if (index < fileNameArray.count) {   //防止数组越界
//        self.rememberSection = index;
        NSString *fileName = fileNameArray[index];
        NSString *pagePid =  _pagePidArray[index];
        [self changeSegment:fileName cureentSegment:index curentPagePid:pagePid];
    }
}

- (void)_initRightView
{
    //顶部视图
    rigthView_ = [[UIView alloc]initWithFrame:CGRectMake(kSecondLevelLeftWidth, 20, kScreenWidth-kSecondLevelLeftWidth, kScreenHeight)];
    rigthView_.backgroundColor = rgb(230, 230, 230, 1.0);
    [self.view addSubview:rigthView_];
    
    topView_ = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-80,kTopView_)];
    topView_.backgroundColor = [UIColor whiteColor];
    [rigthView_ addSubview:topView_];
    
    //1.创建图标
    NSString *titleString;
    NSString *imgString;
    switch (_currentType) {
        case 1:  //听力
        {
            titleString= @"Listening";
            imgString = @"120_listen.png";
            
//            self.rememberSection = 0;
            //初始化网页视图
            _webView = [[UIWebView alloc]init];
            _webView.delegate = self;
            _webView.frame = CGRectMake(5, kTopView_+5, kScreenWidth-80-10, kScreenHeight-kTopView_-5);
            _webView.scalesPageToFit = YES;
            _webView.backgroundColor = [UIColor clearColor];
            [self.rigthView_ addSubview:_webView];
        }
            break;
        case 2:  //阅读
        {
  
            titleString= @"Reading";
            imgString = @"120_read.png";

            //网页1
            readWeb = [[UIWebView alloc]initWithFrame:CGRectMake(5, kTopView_+5, (kScreenWidth-80)/2, kScreenHeight-kTopView_-5)];
            readWeb.delegate = self;
//            readWeb.scalesPageToFit = YES;
            readWeb.backgroundColor = [UIColor clearColor];
            [self.rigthView_ addSubview:readWeb];
            
            //网页2
            _webView = [[UIWebView alloc]init];
            _webView.delegate = self;
            _webView.frame = CGRectMake(10+(kScreenWidth-80)/2, kTopView_+5,(kScreenWidth-80-20)/2, kScreenHeight-kTopView_-5);
//            _webView.scalesPageToFit = YES;
            _webView.backgroundColor = [UIColor clearColor];
            [self.rigthView_ addSubview:_webView];

        }
            break;
            
        case 3:  //写作
        {
            titleString= @"Writing";
            imgString = @"120_write.png";
            
            //初始化网页视图
            _webView = [[UIWebView alloc]init];
            _webView.delegate = self;
            _webView.frame = CGRectMake(5, kTopView_+5, kScreenWidth-80-10, kScreenHeight-kTopView_-5);
            _webView.scalesPageToFit = YES;
            _webView.backgroundColor = [UIColor clearColor];
            [self.rigthView_ addSubview:_webView];

        }
            break;
        case 4:  //口语
        {

            titleString= @"Speaking";
            imgString = @"120_speak.png";
            
            //初始化网页视图
//            readWeb = [[UIWebView alloc]init];
//            readWeb.delegate = self;
//            readWeb.frame = CGRectMake(5, kTopView_+5, kScreenWidth-80-10, (kScreenHeight-kTopView_-3)*2/3);
//            readWeb.backgroundColor = [UIColor clearColor];
//            [self.rigthView_ addSubview:readWeb];
            
            //网页1
            _webView= [[UIWebView alloc]initWithFrame:CGRectMake(5, kTopView_+5, kScreenWidth-80-10, (kScreenHeight-kTopView_-5)*2/3)];
            _webView.delegate = self;
//             _webView.hidden = YES;
             _webView.backgroundColor = [UIColor clearColor];
            [self.rigthView_ addSubview:_webView];

        }
            break;
        default:
            break;
    }
    
    //查看解析
    if (self.isCheck) {
        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(5, kTopView_+5, kScreenWidth-80-10, kScreenHeight-kTopView_-5)];
        webView.backgroundColor = [UIColor clearColor];
        [self.rigthView_ addSubview:webView];
        self.explainWebView = webView;
    }
    
    UIImageView *imgView  =[[UIImageView alloc]initWithFrame:CGRectMake(30,(topView_.height-60)/2, 60, 60)];
    imgView.image = [UIImage imageNamed:imgString];
    [topView_ addSubview:imgView];
    //2.创建标题
    UILabel *titleLabel = [ZCControl createLabelWithFrame:CGRectMake(imgView.right+10, imgView.top, 300, 40) Font:24.0f Text:titleString];
    titleLabel.textColor =TABBAR_BACKGROUND_SELECTED;
    titleLabel.font = [UIFont boldSystemFontOfSize:24.0f];
    [topView_ addSubview:titleLabel];
    //3.创建副标题
    _detailLabel = [ZCControl createLabelWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom-8, 300, 30) Font:17.0f Text:@""];
    _detailLabel.textColor = [UIColor lightGrayColor];
    [topView_ addSubview:_detailLabel];
    
    //4.创建计数器
    if (!self.isCheck) {
        UILabel *timeLabel = [ZCControl createLabelWithFrame:CGRectMake(400, (topView_.height-30)/2, 200, 30) Font:18.0f Text:@"00:00:00"];
        [topView_ addSubview:timeLabel];
        self.timeLabel = timeLabel;
    }
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
                                              
                                              UIButton *button = (UIButton *)[self.leftView_ viewWithTag:1211];
                                              UIButton *button1 = (UIButton *)[self.leftView_ viewWithTag:2211];
                                              UIButton *button2 = (UIButton *)[self.leftView_ viewWithTag:3211];
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
                                              if (data.count > 0) {
                                                  [self _cretExplainArray:data];
                                              }
                                          } errorData:^(NSError *error) {
                                              NSLog(@"%@",error);
                                          }];
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
        buttAction.titleLabel.font = [UIFont systemFontOfSize:16.0];
        if (kStringEqual(docType, @"1")) {
            NSString *body =  [dic objectForKey:@"body"];
            self.listenBody = body;
            if (![body isKindOfClass:[NSNull class]]) {
                if (body.length > 0 && ![body isEqualToString:@""]) {
                    [buttAction setTitle:@"听力材料" forState:UIControlStateNormal];
                    buttAction.tag = 1211;
                }
            }
        }else if (kStringEqual(docType, @"2"))
        {
            NSString *body =  [dic objectForKey:@"body"];
            self.testBody = body;
            [buttAction setTitle:@"试题解析" forState:UIControlStateNormal];
            buttAction.tag= 2211;
        }else if (kStringEqual(docType, @"3"))
        {
            NSString *body =  [dic objectForKey:@"body"];
            self.writeBody = body;
            [buttAction setTitle:@"写作范文" forState:UIControlStateNormal];
            buttAction.tag = 3211;
        }
        self.buttAction = buttAction;
        [self.leftView_ addSubview:buttAction];
    }
}
//试题解析
- (void)testExplain:(UIButton *)button
{
//    if (button.enabled) {
    
    if (self.buttAction.tag != button.tag) {
        if (readWeb != nil) {
            readWeb.hidden = YES;
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
            if (readWeb != nil) {
                readWeb.hidden = YES;
            }
            if (_webView != nil) {
                _webView.hidden = YES;
            }
            self.explainWebView.hidden = NO;
        }else
        {
            if (readWeb != nil) {
                readWeb.hidden = NO;
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
//    button.enabled = !button.enabled;
    
    
//    if (self.buttAction.tag != button.tag) {
//        // 1.控制状态
//        self.buttAction.selected = NO;
//        button.selected = YES;
//        self.buttAction = button;
//        [self seleExplainWeb:button.tag];
//        
//        if (readWeb != nil) {
//            readWeb.hidden = YES;
//        }
//        if (_webView != nil) {
//            _webView.hidden = YES;
//        }
//        self.explainWebView.hidden = NO;
//    }
//    else{//2.取消状态
//        button.selected = !button.selected;
//        if (button.selected) {
//            [self seleExplainWeb:button.tag];
//            
//            if (readWeb != nil) {
//                readWeb.hidden = YES;
//            }
//            if (_webView != nil) {
//                _webView.hidden = YES;
//            }
//            self.explainWebView.hidden = NO;
//        }else
//        {
//            if (readWeb != nil) {
//                readWeb.hidden = NO;
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
        case 1211:
        {
            CHECK_DATA_IS_NSNULL(self.writeBody, NSString);
            if (self.listenBody.length > 0) {
                [self explainWebView:self.listenBody];
            }
        }
            break;
        case 2211:
        {
            CHECK_DATA_IS_NSNULL(self.writeBody, NSString);
            if (self.testBody.length > 0) {
                [self explainWebView:self.testBody];
            }
            
        }
            break;
        case 3211:
        {
            CHECK_DATA_IS_NSNULL(self.writeBody, NSString);
            if (self.writeBody.length > 0) {
                [self explainWebView:self.writeBody];
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


#pragma mark - webView
//加载阅读视图
- (void)loadReadWeb
{
    if (self.isCheck) {
        if (self.readFileName.length > 0) {
            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.readFileName]];
            [readWeb loadRequest:request];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        }
    }else
    {
        if (self.readFileName.length > 0) {
            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL fileURLWithPath:self.readFileName]];
            [readWeb loadRequest:request];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        }
    }
}

//- (void)loadSpeakWeb
//{
//    if (self.isCheck) {
//        if (self.speakFileName.length > 0) {
//            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.speakFileName]];
//            [readWeb loadRequest:request];
//            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        }
//    }else
//    {
//        if (self.speakFileName.length > 0) {
//            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL fileURLWithPath:self.speakFileName]];
//            [readWeb loadRequest:request];
//            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        }
//    }
//}

//加载网页
- (void)loadWebView:(NSString *)url
{
    
    self.title = @"载入中...";
    //    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://115.28.129.210:8082/IELTS/materials/selectVideoMaterialsById?mId=1051"]];
    if (url.length > 0) {
        if (self.isCheck) {
            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
            [_webView loadRequest:request];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

        }else
        {
            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL fileURLWithPath:url]];
            [_webView loadRequest:request];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        }
    }
    if (_currentType == 2) {
        [self loadReadWeb];
    }
//    if (_currentType == 4) {
//        [self loadSpeakWeb];
//    }
}


#pragma mark - Actions
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = title;
    
    if (self.isCheck) {
        //禁用
        NSString *stopUser = [NSString stringWithFormat:@"disableAll()"];
        [self doJs:stopUser];
        
        NSString *myScorec = [NSString stringWithFormat:@"getScoreList()"];
        NSString *getScoreList =  [self doJs:myScorec];
        [[RusultManage shareRusultManage]requestMyAnswer:self
                                            ANswerQSCode:getScoreList
                                                 paperId:self.pId
                                             SuccessData:^(NSDictionary *result) {
                                                 NDLog(@"%@",result);
                                                 NSString *data = [result objectForKey:@"Data"];
                                                 if (data.length > 0) {
                                                     if (self.currentType == 4) {
                                                        NSArray *speakArray = [data componentsSeparatedByString:@"#:#"];
                                                         if (speakArray.count > 1) {
                                                             NSString *url = speakArray[1];
                                                             self.checkSpeakUrl = url;
                                                         }
                                                     }
                                                     NSString *myAnswers = [NSString stringWithFormat:@"setAnswers(\'%@\')",data];
                                                     [self doJs:myAnswers];
                                                 }
                                             } errorData:^(NSError *error) {
                                                 
                                             }];
    }else
    {
        //获取这一次的答案
        NSString *string = [NSString stringWithFormat:@"exami%@_%@",self.pId,self.pageId];
        NSString *answers = [[XDFAnswersManage shardedAnswersManage]getAnswersData:string];
        if (answers != nil) {
            //填充这一次的答案
            NSString *myAnswer = [NSString stringWithFormat:@"setMyAnswers(\'%@\')",answers];
            [self doJs:myAnswer];
        }
    }
}

- (void)setCheckSpeakUrl:(NSString *)checkSpeakUrl
{
    if (_checkSpeakUrl != checkSpeakUrl) {
        _checkSpeakUrl = checkSpeakUrl;
        [self playSpeak:checkSpeakUrl];
    }
}

- (void)playSpeak:(NSString *)url
{

}

#pragma mark - getJSAction
- (NSString *)doJs:(NSString *)js
{
    if (js == nil || [js length] == 0) {
        return nil;
    }
    NSLog(@"+++++ webview dojs ++++ = %@", js);
    NSString *jsString = [_webView stringByEvaluatingJavaScriptFromString:js];
    return jsString;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    
}
#pragma mark - 在线听
- (void)createStreamer
{
    NSString *pathUrl = [NSString stringWithFormat:@"%@/%@",self.domainPFolder,_audioFiles];
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
#pragma mark - 开始播放
- (void)playAudio:(UIButton *)button
{
    NDLog(@"开始播放听力");
    if (self.audioFiles.length>0) {
        NSString *audioFilePid = [NSString stringWithFormat:@"%@%@",self.audioFiles,self.pId];
        if (self.isCheck) {
            button.selected = !button.selected;
            if (!button.selected) {
                [[AFSoundManager sharedManager]pause];
            }else{
               
                if ([AFSoundManager sharedManager].player == nil) {
                    [self createStreamer];
                }
                [[AFSoundManager sharedManager]resume];
            }
        }else
        {
            if (![kUserDefaults boolForKey:audioFilePid]) {  //没有放过，继续放
                [kUserDefaults setBool:YES forKey:audioFilePid];
                [kUserDefaults synchronize];
                if (_audioPlayer == nil) {
                    [[RusultManage shareRusultManage]tipAlert:@"出现未知错误,未找到播放文件" viewController:self];
                    return;
                }
                [_audioPlayer play];
                button.enabled = !button.enabled;
                
            }else  //放过，提示不可以再次播放
            {
                [[RusultManage shareRusultManage]tipAlert:@"不可以再次播放"];
                return;
            }
        }
    }
}
- (void)startLes:(NSTimer *)time
{
    NSString *times;
    switch (_currentType) {
        case 1:
        {
            self.lessT--;
            times = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",self.lessT/(60*60),self.lessT/60,self.lessT%60];
            if (self.lessT == 0) {
                [self enterNextType];
            }
        }
            break;
        case 2:
        {
            self.readT--;
            times = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",self.readT/(60*60),self.readT/60,self.readT%60];
            if (self.readT == 0) {
                [self enterNextType];
            }

        }
            break;
        case 3:
        {
            self.writeT--;
            times = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",self.writeT/(60*60),self.writeT/60,self.writeT%60];
            if (self.writeT == 0) {
                [self enterNextType];
            }
        }
            break;
        case 4:
        {
            self.speakT--;
            times = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",self.speakT/(60*60),self.speakT/60,self.speakT%60];
            if (self.speakT == 0) {
                [self enterNextType];
            }
        }
            break;
        default:
            break;
    }
    self.timeLabel.text = times;
}


//强制退出
- (void)enterNextType
{
    //移除定时器
    [self removeNSTime];
    
    //移除在线听
//    [self destroyStreamer];
    
    if (_audioPlayer != nil) {
        [_audioPlayer stop];
        _audioPlayer = nil;
    }
    
    //停止加载
    if (self.webView != nil) {
        [self.webView stopLoading];
    }
    if (readWeb != nil) {
        [readWeb stopLoading];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //保存当前状态
    [self saveAnswerAndCurrentStatus];
    //
    [self finishTest];
}


#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (_audioPlayer == player && flag == YES) {
        //记录当前完成的section个数，控制前进后退
        self.audioButton.selected = NO;
         NDLog(@"播放完成");
//
    }
}
#pragma mark -Actions
- (void)removeNSTime
{
    if (self.timerLesson != nil) {
        [self.timerLesson invalidate];
        self.timerLesson = nil;
    }
    
    if (self.timerRead != nil) {
        [self.timerRead invalidate];
        self.timerRead = nil;
    }
    
    if (self.timerSpeak != nil) {
        [self.timerSpeak invalidate];
        self.timerSpeak = nil;
    }
    
    if (self.timerWrite != nil) {
        [self.timerWrite invalidate];
        self.timerWrite = nil;
    }
}


//将要消失的时候，网页停止加载
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //移除定时器
    [self removeNSTime];
    
    if (_audioPlayer != nil) {
        [_audioPlayer stop];
        _audioPlayer = nil;
    }
    
    //停止加载
    if (self.webView != nil) {
        [self.webView stopLoading];
    }
    if (readWeb != nil) {
        [readWeb stopLoading];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //保存状态和答案
    [self saveAnswerAndCurrentStatus];
}

#pragma mark - 进入后台保存答案
-(void)enterBackSaveAction:(NSNotification *)ntf
{
    //保存状态和答案
    [self saveAnswerAndCurrentStatus];
}


- (void)saveAnswerAndCurrentStatus
{
//     [self destroyStreamer];
    if (self.isCheck) {
        [[AFSoundManager sharedManager]stop];
    }else
    {
        //获取当前的数据已经做过的答案
        NSString *curPag = [NSString stringWithFormat:@"%ld",(long)self.rememberPage];
        NSString *curSec = [NSString stringWithFormat:@"%ld",(long)self.rememberSection];
        NSString *curTyp = [NSString stringWithFormat:@"%ld",(long)_currentType];
        NSString *finishSection = [NSString stringWithFormat:@"%ld",(long)self.finishSection];
        //保存状态
        NSString *curentAnswer = [self doJs:@"getAnswers()"];
        NDLog(@"%@",curentAnswer);
        //保存当前页面的答案
        NSString *string = [NSString stringWithFormat:@"exami%@_%@",self.pId,self.pageId];
        [[XDFAnswersManage shardedAnswersManage]removeAnswesData:string];
        [[XDFAnswersManage shardedAnswersManage]insertSaveAnswersData:curentAnswer PageID:string];
        //保存当前状态
//        NSString *starts = [NSString stringWithFormat:@"%@_%@starts",];
        [[XDFAnswersManage shardedAnswersManage]removeLastStatus:self.pId];
        [[XDFAnswersManage shardedAnswersManage]saveStatus:self.pId
                                                examinType:curTyp
                                             examinSection:curSec
                                                examinPage:curPag
                                             finishSection:finishSection
         ];
        NSLog(@"%@",curSec);
        NSLog(@"%@",curTyp);
        NSLog(@"%@",curPag);
        NSString *saveTimeId = [NSString stringWithFormat:@"%@and%ld",self.pId,(long)_currentType];
        switch (_currentType) {
            case 1:
            {
                [[XDFAnswersManage shardedAnswersManage]savTimerId:saveTimeId usetime:self.lessT];
            }
                break;
            case 2:
            {
                [[XDFAnswersManage shardedAnswersManage]savTimerId:saveTimeId usetime:self.readT];
            }
                break;
            case 3:
            {
                [[XDFAnswersManage shardedAnswersManage]savTimerId:saveTimeId usetime:self.writeT];
            }
                break;
            case 4:
            {
                [[XDFAnswersManage shardedAnswersManage]savTimerId:saveTimeId usetime:self.speakT];
            }
                break;
                
            default:
                break;
        }
    }
}

//返回
- (void)backAction:(UIButton *)button
{
    //返回保存数据
    [self saveAnswerAndCurrentStatus];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//后退
- (void)leftAction:(UIButton *)button
{
    NDLog(@"后退");
    if (_currentType == 4) {
        isRecording_ = YES;
        if ([kUserDefaults boolForKey:@"isRecording_"]) {
            isRecording_ = YES;
            isLesson_ = NO;
            
            isLeftButton_ = YES;
            isRightButton_ = NO;
            [self tipStopRecordingAction];
        }else
        {
//            isRecording_ = NO;
//            isLesson_ = NO;
            [self leftButtonAction];
        }
    }else
    {
        if ([_audioPlayer isPlaying]) {
            
            isRightButton_ = NO;
            isLeftButton_ = YES;
            isLesson_ = YES;
            isRecording_ = NO;
            [self tipStopLessoningAction];
        }else
        {
            [self leftButtonAction];
        }
    }
}

- (void)leftButtonAction
{
    isRecording_ = NO;
    isLesson_ = NO;

    
    UIButton *button = (UIButton *)[super.view viewWithTag:1000];
    NSInteger curentPage = self.rememberPage-1;
    if (curentPage == 0) {
        button.enabled = NO;
        self.rememberPage = curentPage;
    }else
    {
        self.rememberPage = curentPage;
        button.enabled = YES;
    }
    //防止重复创建
    if (curentPage == self.rememberPage) {
        //        [self isRecordingAction];
        [[AFSoundManager sharedManager]stop];
        //获取答案
        [self getAnswers:self.rememberPage];
        
        if (self.segmentMenu != nil) {
            [self.segmentMenu removeFromSuperview];
            self.segmentMenu = nil;
        }
         self.rememberSection = 0;
        [self _creatSegment];
    }
}


//前进
- (void)rightAction:(UIButton *)button
{
    NDLog(@"前进");
    if (_currentType == 4) {  //口语
        if ([kUserDefaults boolForKey:@"isRecording_"]) {
            isRecording_ = YES;
            isLesson_ = NO;
            
            isRightButton_ = YES;
            isLeftButton_ = NO;
            [self tipStopRecordingAction];
        }else
        {
//             isRecording_ = NO;
//            isLesson_ = NO;
            [self rightActions];

        }
    }else
    {
        if ([_audioPlayer isPlaying]) {
            isRightButton_ = YES;
            isLeftButton_ = NO;
            
//            isLesson_ = YES;
//            isRecording_ = NO;
            [self tipStopLessoningAction];
        }else
        {
            [self rightActions];
        }
    }
}

- (void)rightActions
{
    isLesson_ = NO;
    isRecording_ = NO;

    UIButton *beforeButton = (UIButton *)[super.view viewWithTag:1000];
    beforeButton.enabled = YES;
    if (self.rememberPage <= _dataArray.count-1) {
        NSInteger curentPage = self.rememberPage+1;
        if (curentPage == _dataArray.count) {
            self.rememberPage = curentPage - 1;
            [self tipAction:_currentType];
            return;
        }else
        {
            self.rememberPage = curentPage;
        }
        
        //防止重复创建
        if (curentPage == self.rememberPage) {
            
            [[AFSoundManager sharedManager]stop];
            //获取答案
            [self getAnswers:self.rememberPage];
            
            if (self.segmentMenu != nil) {
                [self.segmentMenu removeFromSuperview];
                self.segmentMenu = nil;
            }
             self.rememberSection = 0;
            [self _creatSegment];
        }
    }
}

- (void)tipAction:(NSInteger)curentSection
{
    if (self.isCheck) {
        switch (_currentType) {
            case 1:
            {
                [self tipAlert:@"结束听力部分的查看!"];
            }
                break;
            case 2:
            {
                [self tipAlert:@"结束阅读部分的查看!"];
            }
                break;
                
            case 3:
            {
                [self tipAlert:@"结束写作部分的查看!"];
            }
                break;
            case 4:
            {
                [self tipAlert:@"结束口语部分的查看!"];
            }
                break;
            default:
                break;
        }
    }else
    {
        switch (_currentType) {
            case 1:
            {
                [self tipAlert:@"退出听力将无法再次进入!"];
            }
                break;
            case 2:
            {
                [self tipAlert:@"退出阅读将无法再次进入!"];
            }
                break;
                
            case 3:
            {
                [self tipAlert:@"退出写作将无法再次进入!"];
            }
                break;
            case 4:
            {
                [self tipAlert:@"退出口语将无法再次进入!"];
            }
                break;
            default:
                break;
        }
    }
  
}

#pragma mark -
#pragma mark - 完成section操作
- (void)tipAlert:(NSString *)results
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:results
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"确定",nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NDLog(@"取消");
        
    }else
    {
        NDLog(@"确定");
        if (isRecording_) {
            [kUserDefaults setBool:NO forKey:@"isRecording_"];
            [kUserDefaults synchronize];
            
            [self recodeingAction];
            
            if (isLeftButton_) {
                [self leftButtonAction];
//                [self leftAction:nil];
            }else if(isRightButton_)
            {
                [self rightActions];
//                [self rightAction:nil];
            }
        }else if(isLesson_)
        {
            isLesson_ = NO;
            if (isLeftButton_) {
                [self leftButtonAction];
            }else if(isRightButton_)
            {
                [self rightActions];
            }
        }else
        {
            //调用完成
            [self  finishTest];
        }
    }
}
#pragma mark - 录音
//取消录音
- (void)tipStopRecordingAction
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                   message:@"正在录音,跳过无法再次重新录制"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)tipStopLessoningAction
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                   message:@"正在听听力,跳过无法再次重新播放"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"确定", nil];
    [alert show];
}


- (void)recodeingAction
{
    
}


//完成时候调用
- (void)finishTest
{
    
    if (_currentType == 4){
        //清除定时器
        if (self.isCheck) {
            if (self.resultView != nil) {
               [self.navigationController popToViewController:self.resultView animated:YES];
            }
        }else
        {
            if (self.timerSpeak != nil) {
                [self.timerSpeak invalidate];
                self.timerSpeak = nil;
            }
            NSString *saveTimeId = [NSString stringWithFormat:@"%@and%ld",self.pId,(long)_currentType];
            [[XDFAnswersManage shardedAnswersManage]savTimerId:saveTimeId usetime:self.speakT];
            //完成
            NDLog(@"试卷全部完成");
            if (self.delegate && [self.delegate respondsToSelector:@selector(finishAll)]) {
                [self.delegate finishAll];
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
    }else
    {
        //清除定时器
        if (_currentType == 1) {
            if (self.timerLesson != nil) {
                [self.timerLesson invalidate];
                self.timerLesson = nil;
            }
        }
        
        if (_currentType == 2) {
            if (self.timerRead != nil) {
                [self.timerRead invalidate];
                self.timerRead = nil;
            }
        }
        
        if (_currentType == 3) {
            if (self.timerWrite != nil) {
                [self.timerWrite invalidate];
                self.timerWrite = nil;
            }
        }
        
        self.rememberSection = 0;
        self.rememberPage = 0;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(examinaFinishs:)]) {
            [self.delegate examinaFinishs:_currentType];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
//每一个类型完成都要存储当前的页面数据
//- (void)everFinish
//{
//    //获取当前的数据已经做过的答案
//    NSString *curSeg = [NSString stringWithFormat:@"%ld",(long)self.curenSegment];
//    NSString *curSec = [NSString stringWithFormat:@"%ld",(long)self.curenSection];
//    NSString *curTyp = [NSString stringWithFormat:@"%ld",(long)_currentType+1];
//    NSString *finishSection = [NSString stringWithFormat:@"%ld",(long)self.finishSection];
//    //保存当前状态
//    [[XDFAnswersManage shardedAnswersManage]saveStatus:self.pId
//                                            examinType:curTyp
//                                         examinSection:curSec
//                                            examinPage:curSeg
//                                         finishSection:finishSection
//     ];
//
//    NSString *curentAnswer = [self doJs:@"getAnswers()"];
//    [[XDFAnswersManage shardedAnswersManage]removeAnswesData:self.pageId];  //移除本次数据
//    //保存当前页面的答案
//    [[XDFAnswersManage shardedAnswersManage]insertSaveAnswersData:curentAnswer PageID:self.pageId];
//}

#pragma mark
//改变题目
- (void)changeSegment:(NSString *)changeInde  cureentSegment:(NSInteger)index  curentPagePid:(NSString *)pagePid
{
    //当前的sement
    NSString *curentAnswer = [self doJs:@"getAnswers()"];
    if (self.pageId != nil) {
        NSString *string = [NSString stringWithFormat:@"exami%@_%@",self.pId,self.pageId];
        [[XDFAnswersManage shardedAnswersManage]removeAnswesData:string];  //移除上一次数据
        [[XDFAnswersManage shardedAnswersManage]insertSaveAnswersData:curentAnswer PageID:string]; //插入上一次的数据
        NDLog(@"segment%@",curentAnswer);
    }
    self.pageId = pagePid;  //求改这一次的页码
    //之后的segment
    self.rememberSection = index;
    
    if (_currentType == 4) {
        if (self.isCheck) {
          [self creatPlay];
        }else
        {
          [self creatRecrod:pagePid];
        }
    }
    [self performSelector:@selector(loadWebView:) withObject:changeInde afterDelay:0.35];
    
}
//获取答案
- (void)getAnswers:(NSInteger)answer
{
    if (self.isCheck) {
        return;
    }
//    self.rememberSection = answer;
    
    //保存状态
    NSString *curentAnswer = [self doJs:@"getAnswers()"];
    NSString *string = [NSString stringWithFormat:@"exami%@_%@",self.pId,self.pageId];
    [[XDFAnswersManage shardedAnswersManage]removeAnswesData:string];  //移除本次数据
    [[XDFAnswersManage shardedAnswersManage]insertSaveAnswersData:curentAnswer PageID:string];//插入本次答案

    NDLog(@"%@",curentAnswer);
}


- (void)creatRecrod:(NSString *)pageID
{

}

- (void)creatPlay
{

}





@end
