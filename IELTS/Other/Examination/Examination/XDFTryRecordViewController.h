//
//  XDFTryRecordViewController.h
//  IELTS
//
//  Created by 李牛顿 on 14-12-24.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XDFTryRecordViewControllerDelegate <NSObject>

- (void)speakFinish;

@end

@interface XDFTryRecordViewController : UIViewController

#pragma mark - 创建试音界面

@property (weak, nonatomic) IBOutlet UIView *tryRecordBgView;


@property (weak, nonatomic) IBOutlet UIImageView *recordImg;

@property (weak, nonatomic) IBOutlet UIButton *startButton;
- (IBAction)startAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *playButton;
- (IBAction)playAction:(UIButton *)sender;


- (IBAction)continueButton:(UIButton *)sender;

#pragma mark - 传到做题界面

@property (nonatomic,strong) NSString *pId;  //试卷ID
@property (nonatomic,strong) NSArray  *dataArray;  //section数据
@property (nonatomic,assign) NSInteger rememberPage;  //记录前后退的页面
@property (nonatomic,assign) NSInteger rememberSection; //section当前的页面
@property (nonatomic,assign) NSInteger currentType; //当前的听说读写的标示
@property (nonatomic,assign) NSInteger finishSection;
@property (nonatomic,assign) BOOL isCheck;

@property (nonatomic,unsafe_unretained)id<XDFTryRecordViewControllerDelegate>delegate;


@end
