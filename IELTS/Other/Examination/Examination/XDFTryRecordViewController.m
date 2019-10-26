//
//  XDFTryRecordViewController.m
//  IELTS
//
//  Created by 李牛顿 on 14-12-24.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFTryRecordViewController.h"
#import "Mp3RecordWriter.h"
#import "MLAudioRecorder.h"
#import "MLAudioMeterObserver.h"
#import <AVFoundation/AVFoundation.h>

#import "XDFExaminaSpeakViewController.h"

@interface XDFTryRecordViewController ()<AVAudioPlayerDelegate,XDFBaseExaminaTestDelegate>

@property (nonatomic,strong)Mp3RecordWriter *mp3Writer;
@property (nonatomic, strong) MLAudioMeterObserver *meterObserver;
@property (nonatomic, strong) MLAudioRecorder *recorder;

@property (nonatomic, strong) NSString *filePath;//路径

@property (nonatomic,strong) UIButton *recordButton; //录音按钮
@property (nonatomic, strong) AVAudioPlayer *player;//播放

@end

@implementation XDFTryRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.tryRecordBgView.frame = CGRectMake(0, 20, kScreenWidth, kScreenHeight);
    self.tryRecordBgView.backgroundColor = [UIColor whiteColor];
    //创建下面音频文件。
    [self _creatReloadAudio];
}
//创建录音
- (void)_creatReloadAudio
{
    //加载图片
    [self updateImage];
    
    //加载mp3
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    Mp3RecordWriter *mp3Writer = [[Mp3RecordWriter alloc]init];
    mp3Writer.filePath = [path stringByAppendingPathComponent:@"record.mp3"];
    mp3Writer.maxSecondCount = 60;
    mp3Writer.maxFileSize = 1024*256;
    self.mp3Writer = mp3Writer;
    
    MLAudioMeterObserver *meterObserver = [[MLAudioMeterObserver alloc]init];
    meterObserver.actionBlock = ^(NSArray *levelMeterStates,MLAudioMeterObserver *meterObserver){
        //跳动音频
        [self detectionVoice:[MLAudioMeterObserver volumeForLevelMeterStates:levelMeterStates]];
    };
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

- (void)detectionVoice:(float)lowPassResults
{
    //最大50  0
    //图片 小-》大
    if (0<lowPassResults<=0.06) {
        [self.recordImg setImage:[UIImage imageNamed:@"record_animate_01.png"]];
    }else if (0.06<lowPassResults<=0.13) {
        [self.recordImg setImage:[UIImage imageNamed:@"record_animate_02.png"]];
    }else if (0.13<lowPassResults<=0.20) {
        [self.recordImg setImage:[UIImage imageNamed:@"record_animate_03.png"]];
    }else if (0.20<lowPassResults<=0.27) {
        [self.recordImg setImage:[UIImage imageNamed:@"record_animate_04.png"]];
    }else if (0.27<lowPassResults<=0.34) {
        [self.recordImg setImage:[UIImage imageNamed:@"record_animate_05.png"]];
    }else if (0.34<lowPassResults<=0.41) {
        [self.recordImg setImage:[UIImage imageNamed:@"record_animate_06.png"]];
    }else if (0.41<lowPassResults<=0.48) {
        [self.recordImg setImage:[UIImage imageNamed:@"record_animate_07.png"]];
    }else if (0.48<lowPassResults<=0.55) {
        [self.recordImg setImage:[UIImage imageNamed:@"record_animate_08.png"]];
    }else if (0.55<lowPassResults<=0.62) {
        [self.recordImg setImage:[UIImage imageNamed:@"record_animate_09.png"]];
    }else if (0.62<lowPassResults<=0.69) {
        [self.recordImg setImage:[UIImage imageNamed:@"record_animate_10.png"]];
    }else if (0.69<lowPassResults<=0.76) {
        [self.recordImg setImage:[UIImage imageNamed:@"record_animate_11.png"]];
    }else if (0.76<lowPassResults<=0.83) {
        [self.recordImg setImage:[UIImage imageNamed:@"record_animate_12.png"]];
    }else if (0.83<lowPassResults<=0.9) {
        [self.recordImg setImage:[UIImage imageNamed:@"record_animate_13.png"]];
    }else {
        [self.recordImg setImage:[UIImage imageNamed:@"record_animate_14.png"]];
    }
}
//初始化图片
- (void) updateImage
{
    [self.recordImg setImage:[UIImage imageNamed:@"record_animate_01.png"]];
}

#pragma mark - 试音按钮
- (IBAction)startAction:(UIButton *)sender {
    
    UIButton *recordButton = (UIButton*)sender;
    
    if (self.recorder.isRecording) {
        //取消录音
        [self.recorder stopRecording];
    }else{
        //开始录音
        [self.recorder startRecording];
        self.meterObserver.audioQueue = self.recorder->_audioQueue;
    }
    recordButton.selected = !recordButton.selected;
    self.recordButton = recordButton;
}
- (IBAction)playAction:(UIButton *)sender {
    
    if (self.recorder.isRecording) {
        NDLog(@"正在录音……");
        return;
    }
    
    if ([_player isPlaying]) {
        [_player stop];
        _player = nil;
    }else
    {
        NSError *error;
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:self.filePath] error:&error];
        _player.delegate = self;
        [_player play];
        NDLog(@"%@",error);
    }
    sender.selected = !sender.selected;
}
//播放完成。
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (_player == player && flag == YES) {
        self.playButton.selected = NO;
    }
}

#pragma mark - 开始答题
- (IBAction)continueButton:(UIButton *)sender {
    if ([_player isPlaying]) {
        [_player stop];
        _player = nil;
        self.playButton.selected = NO;
    }
    //创建新的视图
    XDFExaminaSpeakViewController *exmTest = [[XDFExaminaSpeakViewController alloc]init];
    exmTest.isCheck = self.isCheck;
    exmTest.dataArray = self.dataArray;
    exmTest.pId = self.pId;
    exmTest.currentType = self.currentType;
    exmTest.rememberPage = self.rememberPage;
    exmTest.rememberSection = self.rememberSection;
    exmTest.delegate = self;
    exmTest.finishSection = self.finishSection;
    
    [self.navigationController pushViewController:exmTest animated:YES];
}
//全部完成
- (void)finishAll
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(speakFinish)]) {
        [self.delegate speakFinish];
    }
}

- (void)dealloc
{
    //音谱检测关联着录音类，录音类要停止了。所以要设置其audioQueue为nil
    self.meterObserver.audioQueue = nil;
    [self.recorder stopRecording];
}


@end
