//
//  XDFExerciseSpeakController.m
//  IELTS
//
//  Created by 李牛顿 on 15-1-4.
//  Copyright (c) 2015年 Newton. All rights reserved.
//

#import "XDFExerciseSpeakController.h"
#import "Mp3RecordWriter.h"
#import "MLAudioRecorder.h"
#import "MLAudioMeterObserver.h"
#import "FileUploadHelper.h"
//#import "AudioStreamer.h"
#import "AFSoundManager.h"

#define  kXDFPath_EvaluateThePaperSpeak @"PaperInfo/EvaluateThePaperSpeak"  //上传pm3

@interface XDFExerciseSpeakController ()


@property (nonatomic,strong) Mp3RecordWriter *mp3Writer;
@property (nonatomic, strong) MLAudioMeterObserver *meterObserver;
@property (nonatomic, strong) MLAudioRecorder *recorder;

@property (nonatomic, strong) NSString *filePath;//路径
@property (nonatomic,strong) UIButton *recordButton; //录音按钮
@property (nonatomic,strong) NSString *recordURL;

@property (nonatomic,strong) NSString  *playUrl;

@end

@implementation XDFExerciseSpeakController


- (void)viewDidLoad {
    [super viewDidLoad];
    //1.创建图像
    UIImageView *imgView  =[[UIImageView alloc]initWithFrame:CGRectMake(30,(self.topView.height-60)/2, 60, 60)];
    imgView.image = [UIImage imageNamed:@"120_speak.png"];
    [self.topView addSubview:imgView];
    
    //创建录音视图
    UIView *recordBgView = [[UIView alloc]initWithFrame:CGRectMake(5, self.listenWeb.bottom +5, kScreenWidth-80-10, (kScreenHeight-kTopViewHeight-10)*0.2-5)];
    recordBgView.backgroundColor = [UIColor whiteColor];
    [self.rightView addSubview:recordBgView];
    
    UIButton *recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    recordButton.frame = CGRectMake((recordBgView.width-251)/2, (recordBgView.height-50)/2, 251, 50);
    [recordButton setTitleColor:TABBAR_BACKGROUND_SELECTED forState:UIControlStateNormal];
    [recordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [recordButton setBackgroundImage:[UIImage imageNamed:@"bg.png"] forState:UIControlStateNormal];
    [recordButton setBackgroundImage:[UIImage imageNamed:@"btn2_blank.png"] forState:UIControlStateSelected];
    [recordBgView addSubview:recordButton];
    
    if (self.isChack) {
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
#pragma mark - 播放口语
//切换sec的时候调用清楚口语链接，改变状态
- (void)creatPlay
{
    [[AFSoundManager sharedManager]stop];
    self.recordButton.selected = NO;
}
- (void)createStreamer
{
    if (self.checkSpeakUrl.length > 5 ) {  //防止为空
        [[AFSoundManager sharedManager]startStreamingRemoteAudioFromURL:self.checkSpeakUrl
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

#pragma mark - 口语练习
- (void)_creatRecload:(NSString *)curePid
{
   [self _creatRecord:curePid];
}

- (void)_creatRecord:(NSString *)fileName
{
    
    //加载mp3
    Mp3RecordWriter *mp3Writer = [[Mp3RecordWriter alloc]init];
//    mp3Writer.maxSecondCount = 60;
//    mp3Writer.maxFileSize = 1024*1024;
    self.mp3Writer = mp3Writer;
    
    NSString *p_Id = [[self.dataDic objectForKey:@"P_ID"] stringValue];
    NSString *vodioUrl = [NSString stringWithFormat:@"%@_%@.mp3",p_Id,fileName];
    self.recordURL = vodioUrl;  //用于记录是否录制过
    mp3Writer.filePath = [[DownLoadManage getDocumentPath] stringByAppendingPathComponent:vodioUrl];
    
    
    MLAudioMeterObserver *meterObserver = [[MLAudioMeterObserver alloc]init];
//    meterObserver.actionBlock = ^(NSArray *levelMeterStates,MLAudioMeterObserver *meterObserver){
//        //跳动音频
//        [self detectionVoice:[MLAudioMeterObserver volumeForLevelMeterStates:levelMeterStates]];
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
    
    recorder.fileWriterDelegate = mp3Writer;
    self.filePath = mp3Writer.filePath;
    self.recorder = recorder;
    
}

//开始录制
- (void)recordStart:(UIButton *)button
{
    if (self.recordURL == nil) {
        [self showHint:@"试卷出现未知错误,请与老师联系!"];
        return;
    }
    if (![kUserDefaults boolForKey:self.recordURL]) {
        //改变状态
        button.selected = !button.selected;
        NSString *p_Id = [[self.dataDic objectForKey:@"P_ID"] stringValue];
        NSString *curPids = [NSString stringWithFormat:@"%@_%@",p_Id,self.curenPid];
        NSString *isRecording = [NSString stringWithFormat:@"isRecording_%@",curPids];
        if (self.recorder.isRecording) {
            [kUserDefaults setBool:YES forKey:self.recordURL];
            
            [kUserDefaults setBool:NO forKey:isRecording];  //录音完成
            [kUserDefaults synchronize];
            //取消录音
            [self.recorder stopRecording];
        }else{
            
            [kUserDefaults setBool:YES forKey:isRecording];  //正在录音
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
    NSString *p_Id = [[self.dataDic objectForKey:@"P_ID"] stringValue];
    NSString *curPids = [NSString stringWithFormat:@"%@_%@",p_Id,self.curenPid];
    NSString *isRecording = [NSString stringWithFormat:@"isRecording_%@",curPids];
    [kUserDefaults setBool:NO forKey:isRecording];  //录音完成
    [kUserDefaults synchronize];
    //音谱检测关联着录音类，录音类要停止了。所以要设置其audioQueue为nil
    self.meterObserver.audioQueue = nil;
    [self.recorder stopRecording];
}
//左右切换停止录音
- (void)stopRecorld
{
    NSString *p_Id = [[self.dataDic objectForKey:@"P_ID"] stringValue];
    NSString *curPids = [NSString stringWithFormat:@"%@_%@",p_Id,self.curenPid];
    NSString *isRecording = [NSString stringWithFormat:@"isRecording_%@",curPids];
    [kUserDefaults setBool:NO forKey:isRecording];  //录音完成
    [kUserDefaults synchronize];
    
    self.recordButton.selected = NO;
    self.meterObserver.audioQueue = nil;
    [self.recorder stopRecording];

}

- (void)upLoadMp3:(NSString *)examinfoId
           pageID:(NSString *)p_Id
             stId:(NSString *)st_ID
           answer:(NSString *)answer
              pid:(NSString *)pid{
    /*
     /api/PaperInfo/EvaluateThePaperSpeak
     paperId=[考试试卷的主键ID]&examinfoId=[该次考试信息主键ID]&qsCode=[学生答案的code]& stid = [任务主键id]
     */
    NSString *qsCode = [[answer componentsSeparatedByString:@"|"]firstObject];
    if (qsCode.length > 0) {
        NSString *path = [NSString stringWithFormat:@"%@/PaperInfo/EvaluateThePaperSpeak?paperId=%@&examinfoId=%@&qsCode=%@&stId=%@",BaseURLString,p_Id,examinfoId,qsCode,st_ID];
        NSString *vodioUrl = [NSString stringWithFormat:@"%@_%@.mp3",p_Id,pid];
        NSString *localFile = [[DownLoadManage getDocumentPath] stringByAppendingPathComponent:vodioUrl];
        NSString *fileName = vodioUrl;
        NSLog(@"%@",vodioUrl);
        if (fileName.length > 0) {
            [FileUploadHelper fileUploadMp3WithUrl:path FilePath:localFile FileName:fileName Success:^(NSDictionary *result){
                [kUserDefaults setBool:NO forKey:vodioUrl];  //录音完成
                [kUserDefaults synchronize];
                
                NSError *error;
                [[NSFileManager defaultManager]removeItemAtPath:localFile error:&error];
                NSLog(@"练习录音移除:%@",error);
            }];
        }
    }
}


@end
