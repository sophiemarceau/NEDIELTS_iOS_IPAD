//
//  Sys_MyTargetView.h
//  IELTS
//
//  Created by melp on 14/11/17.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSubView.h"

@interface Sys_MyTargetView : BaseSubView <UITableViewDataSource,UITableViewDelegate>

- (IBAction)onSetMyScore:(id)sender;
- (IBAction)onAddExamTime:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tbExamTimes;
@property (weak, nonatomic) IBOutlet UIScrollView *BgScrollView;


@property (weak, nonatomic) IBOutlet UIView *targetBgView;
//目标分
@property (weak, nonatomic) IBOutlet UILabel *targetSubmitValue;

@property (weak, nonatomic) IBOutlet UILabel *targetValue1;
@property (weak, nonatomic) IBOutlet UILabel *targetValue2;
@property (weak, nonatomic) IBOutlet UILabel *targetValue3;
@property (weak, nonatomic) IBOutlet UILabel *targetValue4;


@property (weak, nonatomic) IBOutlet UIView *currentBgView;
//目前分
@property (weak, nonatomic) IBOutlet UILabel *curentSubmitValue;

@property (weak, nonatomic) IBOutlet UILabel *curentValue1;
@property (weak, nonatomic) IBOutlet UILabel *curentValue2;
@property (weak, nonatomic) IBOutlet UILabel *curentValue3;
@property (weak, nonatomic) IBOutlet UILabel *curentValue4;

@property (weak, nonatomic) IBOutlet UIView *typeBgView;
//考试类别
- (IBAction)typeAButtonAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *TypeAButtons;

- (IBAction)typeBButtonsAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *typeBButton;



@property (weak, nonatomic) IBOutlet UIView *abortTimeView;

@property (weak, nonatomic) IBOutlet UIView *dateTimeBgView;

//类型

//留学申请日期
- (IBAction)abroadButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *abroadButtonState;
@property (weak, nonatomic) IBOutlet UILabel *abroadTimeLabel;





@end
