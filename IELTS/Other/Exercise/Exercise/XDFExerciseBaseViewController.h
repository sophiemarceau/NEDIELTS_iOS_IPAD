//
//  XDFExerciseBaseViewController.h
//  IELTS
//
//  Created by 李牛顿 on 15-1-5.
//  Copyright (c) 2015年 Newton. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "XDFExerciseTypeListController.h"
//#import "XDFExerciseTableDetailController.h"

#define kScaleFloat 0.7
#define kTopViewHeight 100
@class XDFExerciseTypeListController;
@class XDFExerciseTableDetailController;

typedef enum
{
    ControlTypeNone,
    ControlTypeDay,  //每日任务进入
    ControlTypeTypes, //类型进入
    ControlTypeHome,
    ControlTypeSchedule
}ControlType;
@interface XDFExerciseBaseViewController : UIViewController

@property (nonatomic,assign) ControlType controlType;
@property (nonatomic,strong) NSDictionary *dataDic;
@property (nonatomic,assign) BOOL isFromScore;
@property (nonatomic,strong) XDFExerciseTypeListController *listController;
@property (nonatomic,strong) XDFExerciseTableDetailController *dayDetailController; //每日
@property (nonatomic,strong) NSString *testType;  //判断练习类型
@property (nonatomic,strong) NSString *taskType; //判断类型
@property (nonatomic,strong) UIView *topView;  //内容头部视图
@property (nonatomic,strong) UIView *rightView;//内容视图
@property (nonatomic,strong) UIWebView *listenWeb;  //网页
//@property (nonatomic,strong) NSString *mp3Html;  //mp3Html
@property (nonatomic,assign) BOOL isChack;
@property (nonatomic,strong) NSString *st_ID;       //暂时只从首页传过来。
@property (nonatomic,strong) NSString *curenPid;     //当前页面的pid

- (void)upLoadMp3:(NSString *)examinfoId pageID:(NSString *)p_Id stId:(NSString *)st_ID answer:(NSString *)answer               pid:(NSString *)pid;
- (void)stopRecorld; //停止录音
- (void)_creatRecload:(NSString *)curePid;
- (void) creatPlay;//播放口语

@property (nonatomic,strong) NSString  *checkSpeakUrl;

@end


