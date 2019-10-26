//
//  XDFExaminaSpeakViewController.m
//  IELTS
//
//  Created by 李牛顿 on 14-12-22.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFExaminaSpeakViewController.h"
#import "Mp3RecordWriter.h"
#import "MLAudioRecorder.h"
#import "MLAudioMeterObserver.h"
//#import "AudioStreamer.h"
#import "AFSoundManager.h"


#define kTopView_ 100
@interface XDFExaminaSpeakViewController ()<UIWebViewDelegate,UIAlertViewDelegate>
//{
//    AudioStreamer *_streamer;
//}
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong)UIWebView *readWeb;
@property (nonatomic,assign)NSInteger curenSegment;
@property (nonatomic,assign)NSInteger curenSection;
@property (nonatomic,strong)NSString *pageId;


@property (nonatomic,strong)Mp3RecordWriter *mp3Writer;
@property (nonatomic, strong) MLAudioMeterObserver *meterObserver;
@property (nonatomic, strong) MLAudioRecorder *recorder;

@property (nonatomic, strong) NSString *filePath;//路径
@property (nonatomic,strong) UIButton *recordButton; //录音按钮

@property (nonatomic,strong) NSString *recordURL;

@property (nonatomic,strong) NSString *playUrl;

@end

@implementation XDFExaminaSpeakViewController
@synthesize readWeb;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建录音视图
    UIView *recordBgView = [[UIView alloc]initWithFrame:CGRectMake(5, kTopView_+10+(kScreenHeight-kTopView_-5)*2/3, kScreenWidth-80-10, (kScreenHeight-kTopView_-5)/3-5)];
    recordBgView.backgroundColor = [UIColor whiteColor];
    [self.rigthView_ addSubview:recordBgView];
    
    UIButton *recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    recordButton.frame = CGRectMake((recordBgView.width-251)/2, (recordBgView.height-50)/2, 251, 50);
    [recordButton setTitleColor:TABBAR_BACKGROUND_SELECTED forState:UIControlStateNormal];
    [recordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [recordButton setBackgroundImage:[UIImage imageNamed:@"bg.png"] forState:UIControlStateNormal];
    [recordButton setBackgroundImage:[UIImage imageNamed:@"btn2_blank.png"] forState:UIControlStateSelected];

    [recordBgView addSubview:recordButton];
    
    if (self.isCheck) {
        [recordButton setTitle:@"开始播放" forState:UIControlStateNormal];
        [recordButton setTitle:@"停止播放" forState:UIControlStateSelected];
        [recordButton addTarget:self action:@selector(playStart:) forControlEvents:UIControlEventTouchUpInside];
    }else
    {
        [recordButton setTitle:@"开始录音" forState:UIControlStateNormal];
        [recordButton setTitle:@"结束录音" forState:UIControlStateSelected];
        [recordButton addTarget:self action:@selector(recordStart:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}
#pragma mark - 查看题目播放录音
//切换sec的时候调用清楚口语链接，改变状态
- (void)creatPlay
{
    [[AFSoundManager sharedManager]stop];
    self.recordButton.selected = NO;
}
//
- (void)playSpeak:(NSString *)url
{
    self.playUrl = url;
}
- (void)createStreamer
{
    if (self.playUrl.length > 5) {
        [[AFSoundManager sharedManager]startStreamingRemoteAudioFromURL:self.playUrl
                                                               andBlock:^(int percentage, CGFloat elapsedTime, CGFloat timeRemaining, NSError *error, BOOL finished) {
                                                                   if (!error) {
                                                                       if (finished) {
                                                                           self.recordButton.selected = NO;
                                                                       }
                                                                   }else
                                                                   {
                                                                       NSLog(@"%@",[error description]);
                                                                   }
                                                               }];

    }else
    {
        self.recordButton.selected = NO;
        [[RusultManage shareRusultManage]tipAlert:@"没有录音文件!"];
    }
}

- (void)playStart:(UIButton *)button
{
    button.selected = !button.selected;
    self.recordButton = button;
    if (!button.selected) {
        [[AFSoundManager sharedManager]stop];
    }else{
        [self createStreamer];
    }
}


#pragma mark - 做题录音
//创建
- (void)creatRecrod:(NSString *)pageID
{
    [self _creatRecord:pageID];
}

- (void)_creatRecord:(NSString *)fileName
{

    //加载mp3
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    Mp3RecordWriter *mp3Writer = [[Mp3RecordWriter alloc]init];
//    mp3Writer.maxSecondCount = 60;
//    mp3Writer.maxFileSize = 1024*1024;
    self.mp3Writer = mp3Writer;
    
    NSString *vodioUrl = [NSString stringWithFormat:@"%@_%@.mp3",self.pId,fileName];
    self.recordURL = vodioUrl;  //用于记录是否录制过
    mp3Writer.filePath = [[DownLoadManage getDocumentPath] stringByAppendingPathComponent:vodioUrl];

    MLAudioMeterObserver *meterObserver = [[MLAudioMeterObserver alloc]init];
//    meterObserver.actionBlock = ^(NSArray *levelMeterStates,MLAudioMeterObserver *meterObserver){
//        //跳动音频
////        [self detectionVoice:[MLAudioMeterObserver volumeForLevelMeterStates:levelMeterStates]];
//    };
    //错误
    meterObserver.errorBlock = ^(NSError *error,MLAudioMeterObserver *meterObserver){
        [[[UIAlertView alloc]initWithTitle:@"错误" message:error.userInfo[NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil]show];
    };
    self.meterObserver = meterObserver;
    
    MLAudioRecorder *recorder = [[MLAudioRecorder alloc]init];
    __weak __typeof(self)weakSelf = self;
    recorder.receiveStoppedBlock = ^{
        weakSelf.meterObserver.audioQueue = nil;
    };
    recorder.receiveErrorBlock = ^(NSError *error){
        weakSelf.meterObserver.audioQueue = nil;
        [[[UIAlertView alloc]initWithTitle:@"错误" message:error.userInfo[NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil]show];
    };
//    recorder.bufferDurationSeconds = 0.04;
    recorder.fileWriterDelegate = mp3Writer;
    self.filePath = mp3Writer.filePath;
    
    self.recorder = recorder;

}
//开始录制
- (void)recordStart:(UIButton *)button
{
//    [kUserDefaults setBool:NO forKey:self.recordURL];
//    [kUserDefaults synchronize];
    
    if (self.recordURL == nil) {
        [self showHint:@"试卷出现未知错误,请与老师联系!"];
        return;
    }
    
    if (![kUserDefaults boolForKey:self.recordURL]) {
        //改变状态
        button.selected = !button.selected;
        if (self.recorder.isRecording) {
            [kUserDefaults setBool:YES forKey:self.recordURL];
            
            [kUserDefaults setBool:NO forKey:@"isRecording_"];  //录音完成
            [kUserDefaults synchronize];
            //取消录音
            [self.recorder stopRecording];
        }else{
            
            [kUserDefaults setBool:YES forKey:@"isRecording_"];  //正在录音
            [kUserDefaults synchronize];
            //开始录音
            [self.recorder startRecording];
             self.meterObserver.audioQueue = self.recorder->_audioQueue;
        }
        self.recordButton = button;
    }else
    {
        [[RusultManage shareRusultManage]tipAlert:@"已经录制过,不可再次录入"];
    }
}

- (void)dealloc
{
    
//    [self destroyStreamer];
    //音谱检测关联着录音类，录音类要停止了。所以要设置其audioQueue为nil
    self.meterObserver.audioQueue = nil;
    [self.recorder stopRecording];
}
- (void)recodeingAction
{
    [self.recorder stopRecording];
    self.recordButton.selected = NO;
    
     [kUserDefaults setBool:YES forKey:self.recordURL];//录制完成
    
}





@end
