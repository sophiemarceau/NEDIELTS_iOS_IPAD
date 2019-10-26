//
//  XDFBaseExaminaViewController.h
//  IELTS
//
//  Created by 李牛顿 on 14-12-22.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDFResultViewController.h"
@protocol XDFBaseExaminaTestDelegate<NSObject>
@optional
- (void)examinaFinishs:(NSInteger)pageIndex;  //完成type
- (void)finishAll;//全部完成
@end

@interface XDFBaseExaminaViewController : UIViewController

@property (nonatomic,unsafe_unretained)id<XDFBaseExaminaTestDelegate>delegate;  //完成代理
@property (nonatomic,strong) NSString *audioFiles;  //声音链接地址
@property (nonatomic,strong) UILabel  *detailLabel; //听力下面的副标题
@property (nonatomic,strong) NSArray  *segmentTitle; //侧边的segent
@property (nonatomic,assign) NSInteger rememberPage;  //记录前后退的页面
@property (nonatomic,assign) NSInteger rememberSection; //section当前的页面
@property (nonatomic,assign) NSInteger currentType; //当前的听说读写的标示
@property (nonatomic,strong) NSString *pId;  //试卷ID
@property (nonatomic,strong) NSArray  *dataArray;  //section数据
@property (nonatomic,assign) NSInteger finishSection;
@property (nonatomic,strong) UIView     *rigthView_;//右侧视图
@property (nonatomic,strong) UIView     *topView_; //顶部视图
@property (nonatomic,strong) NSString   *readFileName;

@property (nonatomic,strong) NSString *checkSpeakUrl; //查看口语链接
- (void)recodeingAction;//正在录音，需要停止
- (void)creatRecrod:(NSString *)pageID;


@property (nonatomic,assign) BOOL isCheck;

@property (nonatomic,strong) NSString *domainPFolder;

@property (nonatomic,strong) XDFResultViewController *resultView;

- (void)playSpeak:(NSString *)url;

- (void)creatPlay;


@end
