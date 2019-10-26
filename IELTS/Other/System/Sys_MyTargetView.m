//
//  Sys_MyTargetView.m
//  IELTS
//
//  Created by melp on 14/11/17.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import "Sys_MyTargetView.h"
#import "Dlg_MyScoreSetupViewController.h"
#import "Dlg_AddExamTimeViewController.h"
#import "ZCControl.h"
#import "RusultManage.h"

@interface Sys_MyTargetView ()<Dlg_MyScoreSetupViewControllerDelegate,Dlg_AddExamTimeViewControllerDelegate>

@property (nonatomic,strong)UIButton *selectButton;
@property (nonatomic,strong)NSMutableArray *kssjList;         //考试时间

@property (nonatomic,strong)NSString *tDate_ID;

@property (nonatomic,strong)Dlg_AddExamTimeViewController *changeTime;
@property (nonatomic,strong)Dlg_MyScoreSetupViewController *changeMyscore;
@property (nonatomic,strong) UIControl *maskControlView; //控制收起搜索框搜索框

@end

@implementation Sys_MyTargetView


- (void)initView:(UIViewController *)parentView
{
    if(self.IsInited) return;
    
    [super initView:parentView];
    self.tDate_ID = @"";
    //默认目标成绩
    self.targetValue1.text = @"0";
    self.targetValue2.text = @"0";
    self.targetValue3.text = @"0";
    self.targetValue4.text = @"0";
//    CGFloat submitValue = ([self.targetValue1.text floatValue]+[self.targetValue2.text floatValue]+[self.targetValue3.text floatValue]+[self.targetValue4.text floatValue])/4.0;
    self.targetSubmitValue.text = @"0";//[NSString stringWithFormat:@"%.2f",submitValue];
    
    //默认目前成绩
    self.curentSubmitValue.text = @"0";
    self.curentValue1.text = @"0";
    self.curentValue2.text = @"0";
    self.curentValue3.text = @"0";
    self.curentValue4.text = @"0";
    
    //留学申请日期
    self.abroadTimeLabel.text = @"";
    
    self.tbExamTimes.dataSource = self;
    self.tbExamTimes.delegate = self;
    self.tbExamTimes.showsHorizontalScrollIndicator = NO;
    self.tbExamTimes.showsVerticalScrollIndicator = NO;
    self.tbExamTimes.rowHeight = 50;
    self.tbExamTimes.tableFooterView = [[UIView alloc]init];
    
    
    //讲view加入scorellView

    [self.BgScrollView addSubview:self.targetBgView];
    [self.BgScrollView addSubview:self.currentBgView];
    [self.BgScrollView addSubview:self.typeBgView];
    [self.BgScrollView addSubview:self.dateTimeBgView];
    [self.BgScrollView addSubview:self.abortTimeView];
    
    self.targetBgView.top = 0;
    self.currentBgView.top = self.targetBgView.bottom + 5;
    self.typeBgView.top = self.currentBgView.bottom + 5;
    self.abortTimeView.top = self.typeBgView.bottom + 5;
    self.dateTimeBgView.top = self.abortTimeView.bottom + 5;
    
    self.BgScrollView.showsHorizontalScrollIndicator = NO;
    self.BgScrollView.showsVerticalScrollIndicator = NO;
    
    self.tbExamTimes.frame = CGRectMake(0, 52, self.typeBgView.width, 50);
    [self setScrollViewContentSize];
    
    self.IsInited =YES;

}

- (void)setScrollViewContentSize
{
    CGFloat h = self.targetBgView.height +
    self.currentBgView.height +
    self.typeBgView.height +
    self.abortTimeView.height +
    self.dateTimeBgView.height + 30;
    self.BgScrollView.contentSize = CGSizeMake(self.width, h);
}


//获取我的目标所有数据
- (void)onDisplayView
{
    [[RusultManage shareRusultManage] LoadStudentSettingRusult:nil viewController:self.ParentViewControll successData:^(NSDictionary *result)
    {
        NSDictionary *dataDic = [result objectForKey:@"Data"];
        //处理数据
        [self _dealData:dataDic];
    }];
}

//处理请求的数据
- (void)_dealData:(NSDictionary *)dataDic
{
    //成绩
    NSDictionary *scoreAndTypeMap =[dataDic objectForKey:@"scoreAndTypeMap"];
//    //目前成绩
    float rListen = [[scoreAndTypeMap objectForKey:@"RListen"] floatValue];
    float rSpeak = [[scoreAndTypeMap objectForKey:@"RSpeak"] floatValue];
    float rRead = [[scoreAndTypeMap objectForKey:@"RRead"] floatValue];
    float rWrite = [[scoreAndTypeMap objectForKey:@"RWrite"] floatValue];
    float rTotalScore = [[scoreAndTypeMap objectForKey:@"RTotalScore"] isKindOfClass:[NSNull class]] ? 0.0 : [[scoreAndTypeMap objectForKey:@"RTotalScore"] floatValue];
    
    NSString *listen = [NSString stringWithFormat:@"%.1f",rListen];
    NSString *Read = [NSString stringWithFormat:@"%.1f",rRead];
    NSString *Write = [NSString stringWithFormat:@"%.1f",rWrite];
    NSString *Speak = [NSString stringWithFormat:@"%.1f",rSpeak];
    NSString *TotalScore = [NSString stringWithFormat:@"%.1f",rTotalScore];
    
    //默认目前成绩
    self.curentSubmitValue.text = TotalScore;
    self.curentValue1.text = listen;
    self.curentValue2.text = Read;
    self.curentValue3.text = Write;
    self.curentValue4.text = Speak;

    
    //目标成绩
    float yListen = [[scoreAndTypeMap objectForKey:@"MyListen"] floatValue];
    float ySpeak =  [[scoreAndTypeMap objectForKey:@"MySpeak"] floatValue];
    float yRead =   [[scoreAndTypeMap objectForKey:@"MyRead"] floatValue];
    float yWrite =  [[scoreAndTypeMap objectForKey:@"MyWrite"] floatValue];
    float yTotalScore = [[scoreAndTypeMap objectForKey:@"MyTotalScore"] isKindOfClass:[NSNull class]] ? 0.0 : [[scoreAndTypeMap objectForKey:@"MyTotalScore"] floatValue];

    //默认目标成绩
    NSString *myListen = [NSString stringWithFormat:@"%.1f",yListen];
    NSString *myRead = [NSString stringWithFormat:@"%.1f",yRead];
    NSString *myWrite = [NSString stringWithFormat:@"%.1f",yWrite];
    NSString *mySpeak = [NSString stringWithFormat:@"%.1f",ySpeak];
    NSString *myTotalScore = [NSString stringWithFormat:@"%.1f",yTotalScore];

    
    self.targetValue1.text = myListen;
    self.targetValue2.text = myRead;
    self.targetValue3.text = myWrite;
    self.targetValue4.text = mySpeak;
    self.targetSubmitValue.text = myTotalScore;
    
    
    
    //设置考试类别
    if ([[scoreAndTypeMap objectForKey:@"ExamType"] isKindOfClass:[NSNull class]]) {
        self.TypeAButtons.enabled = NO;
        self.typeBButton.enabled = NO;
        
    }else if ([[[scoreAndTypeMap objectForKey:@"ExamType"] stringValue] isEqualToString:@"1"])
    {
        self.typeBButton.enabled = YES;
        self.TypeAButtons.enabled = NO;
        
    }else if ([[[scoreAndTypeMap objectForKey:@"ExamType"] stringValue] isEqualToString:@"2"])
    {
        self.TypeAButtons.enabled = YES;
        self.typeBButton.enabled = NO;

    }else
    {
        self.TypeAButtons.enabled = NO;
        self.typeBButton.enabled = NO;
    }
    
    //考试日期列表
    NSArray *kssjList = [dataDic objectForKey:@"kssjList"];
    if ( kssjList.count > 0) {
         NSArray *kssjList = [dataDic objectForKey:@"kssjList"];
        _kssjList = [[NSMutableArray alloc]init];
        [_kssjList addObjectsFromArray:kssjList];
        self.tbExamTimes.height = _kssjList.count * 50;
        self.dateTimeBgView.height = (_kssjList.count+1)* 50;
        [self setScrollViewContentSize];
        [self.tbExamTimes reloadData];
    }
   
    //留学申请日期
    NSDictionary *lxsqMap = [dataDic objectForKey:@"lxsqMap"];
    if (lxsqMap.count > 0) {
        NSString *destDate =[lxsqMap objectForKey:@"DestDate"];
        NSString *tDate_ID =[[lxsqMap objectForKey:@"TDate_ID"] stringValue];
        self.abroadTimeLabel.text = destDate;
        self.tDate_ID = tDate_ID;
        [self.abroadButtonState setTitle:@"编辑" forState:UIControlStateNormal];
    }else
    {
        [self.abroadButtonState setTitle:@"添加" forState:UIControlStateNormal];
    }
}


//设置分数
- (IBAction)onSetMyScore:(id)sender
{
    Dlg_MyScoreSetupViewController *myScoreSetup = [[Dlg_MyScoreSetupViewController alloc] initWithNibName:@"Dlg_MyScoreSetupViewController" bundle:nil];
    myScoreSetup.delegate = self;

    float lesson = self.targetValue1.text != nil ? [self.targetValue1.text floatValue] : 0.0;
    float myRead = self.targetValue2.text != nil ? [self.targetValue2.text floatValue] : 0.0;
    float myWrite = self.targetValue3.text != nil ? [self.targetValue3.text floatValue] : 0.0;
    float mySpeak = self.targetValue4.text != nil ? [self.targetValue4.text floatValue] : 0.0;
    float myTotalScore = self.targetSubmitValue.text != nil ? [self.targetSubmitValue.text floatValue] : 0.0;
    
    myScoreSetup.listens = lesson;
    myScoreSetup.speaks = mySpeak;
    myScoreSetup.reads = myRead;
    myScoreSetup.writes = myWrite;
    myScoreSetup.subValues = myTotalScore;
    
    CGFloat with =  myScoreSetup.view.frame.size.width;
    CGFloat heigt = myScoreSetup.view.frame.size.height;
    
    myScoreSetup.view.frame = CGRectMake((1024-with)/2, self.viewController.view.frame.size.height,with, heigt);
    [UIView animateWithDuration:0.35 animations:^{
        myScoreSetup.view.frame = CGRectMake((1024-with)/2, (768-heigt)/2, with, heigt);
    }];
    [self _initMask:myScoreSetup.view];
    
    [self.viewController.parentViewController.parentViewController.view addSubview:myScoreSetup.view];
    self.changeMyscore = myScoreSetup;

//    [ZCControl presentModalFromController:self.ParentViewControll toController:myScoreSetup isHiddenNav:YES Width:480 Height:320];
}
#pragma mark - Dlg_MyScoreSetupViewControllerDelegate
- (void)myScoreSetupRusult:(NSDictionary *)rusultDic
{
    self.targetSubmitValue.text  =  [rusultDic objectForKey:@"floatTotalScore"];
    self.targetValue1.text = [rusultDic objectForKey:@"lisent"];
    self.targetValue4.text = [rusultDic objectForKey:@"speak"];
    self.targetValue2.text = [rusultDic objectForKey:@"read"];
    self.targetValue3.text = [rusultDic objectForKey:@"wright"];
}
#pragma mark - 添加时间
//添加时间
- (IBAction)onAddExamTime:(id)sender
{
    Dlg_AddExamTimeViewController *addExamTime = [[Dlg_AddExamTimeViewController alloc] initWithNibName:@"Dlg_AddExamTimeViewController" bundle:nil];
    addExamTime.delegate = self;
    addExamTime.typeTime =TypeTimeTestDate;
    
    CGFloat with =  addExamTime.view.frame.size.width;
    CGFloat heigt = addExamTime.view.frame.size.height;
    
    addExamTime.view.frame = CGRectMake((1024-with)/2, self.viewController.view.frame.size.height,with, heigt);
    [UIView animateWithDuration:0.35 animations:^{
        addExamTime.view.frame = CGRectMake((1024-with)/2, (768-heigt)/2, with, heigt);
    }];
    [self _initMask:addExamTime.view];
    
    [self.viewController.parentViewController.parentViewController.view addSubview:addExamTime.view];
    self.changeTime = addExamTime;

//    [ZCControl presentModalFromController:self.ParentViewControll toController:addExamTime isHiddenNav:YES Width:480 Height:320];
}

//设置留学日期
- (IBAction)abroadButton:(UIButton *)sender {
    
    Dlg_AddExamTimeViewController *addExamTime = [[Dlg_AddExamTimeViewController alloc] initWithNibName:@"Dlg_AddExamTimeViewController" bundle:nil];
    addExamTime.delegate = self;
    addExamTime.typeTime = TypeTimeAboadDate;
    addExamTime.tDate_ID = self.tDate_ID;
    NSString *abroadTime =  self.abroadTimeLabel.text.length > 0 ?self.abroadTimeLabel.text:@"";
    addExamTime.abroadTimes = abroadTime;
    
    
    CGFloat with =  addExamTime.view.frame.size.width;
    CGFloat heigt = addExamTime.view.frame.size.height;
    
    addExamTime.view.frame = CGRectMake((1024-with)/2, self.viewController.view.frame.size.height,with, heigt);
    [UIView animateWithDuration:0.35 animations:^{
        addExamTime.view.frame = CGRectMake((1024-with)/2, (768-heigt)/2, with, heigt);
    }];
    [self _initMask:addExamTime.view];
    
    [self.viewController.parentViewController.parentViewController.view addSubview:addExamTime.view];
    self.changeTime = addExamTime;

//    [ZCControl presentModalFromController:self.ParentViewControll toController:addExamTime isHiddenNav:YES Width:480 Height:320];
}

#pragma mark -Dlg_AddExamTimeViewControllerDelegate
- (void)shutAddExamTimeView
{
    [self maskControlView:nil];
}
- (void)shutMyScoreView
{
    [self maskControlView:nil];
}

#pragma mark - 实现点击键盘以外都收起键盘
- (void)_initMask:(UIView *)textView
{
    //创建点击视图
    if (_maskControlView == nil) {
        _maskControlView = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, 1024 , 768)];
        [_maskControlView addTarget:self action:@selector(maskControlView:) forControlEvents:UIControlEventTouchUpInside];
        _maskControlView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self.viewController.parentViewController.parentViewController.view insertSubview:_maskControlView belowSubview:textView];
    }
}
//隐藏alert
- (void)maskControlView:(UIControl *)maskView
{
    if (self.changeTime != nil) {
        [self actionForView:self.changeTime];
    }else if (self.changeMyscore != nil)
    {
        [self actionForView:self.changeMyscore];
    }
}

- (void)actionForView:(UIViewController *)contrl
{
    CGFloat with =  contrl.view.frame.size.width;
    CGFloat heigt = contrl.view.frame.size.height;
    contrl.view.frame = CGRectMake((1024-with)/2, (768-heigt)/2, with, heigt);
    
    [UIView animateWithDuration:0.35 animations:^{
        contrl.view.frame = CGRectMake((1024-with)/2, self.viewController.view.frame.size.height,with, heigt);
        [_maskControlView removeFromSuperview];
        _maskControlView = nil;
    } completion:^(BOOL finished) {
        
        [contrl.view removeFromSuperview];
        contrl.view = nil;
        
        [contrl removeFromParentViewController];
        self.changeMyscore = nil;
        self.changeTime = nil;
    }];
}


#pragma mark - Dlg_AddExamTimeViewControllerDelegate
- (void)typeDate:(NSString *)string typeTime:(TypeTimes)type resultDic:(NSDictionary *)resultDic
{
    //刷新所有数据
    [self onDisplayView];
}

#pragma mark - UITable Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _kssjList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"Cells";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    
    cell.textLabel.text = [_kssjList[indexPath.row] objectForKey:@"DestDate"];  //@"2014年 12月 1日";
    cell.textLabel.textColor = [UIColor darkGrayColor];
    return cell;

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
         NSString *tDate_ID = [_kssjList[indexPath.row] objectForKey:@"TDate_ID"];
        //删除时间
        [[RusultManage shareRusultManage]sysDelTestDateController:self.viewController.parentViewController.parentViewController tDateId:tDate_ID SuccessData:^(NSDictionary *result) {
            NDLog(@"删除时间,%@",result);
            
            [_kssjList removeObjectAtIndex:indexPath.row];
            
            self.dateTimeBgView.height = (_kssjList.count +1) * 50;
            self.tbExamTimes.height = _kssjList.count * 50;
            [self setScrollViewContentSize];

            [tableView reloadData];
        }];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


#pragma mark - 设置类别
- (IBAction)typeAButtonAction:(UIButton *)sender {
    
    // 1.控制状态
//    _selectButton.enabled = YES;
//    sender.enabled = NO;
//    _selectButton = sender;
    self.typeBButton.enabled = YES;
    self.TypeAButtons.enabled = NO;

    NSString *buttonTag = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    [self _requestType:buttonTag];
}

- (IBAction)typeBButtonsAction:(UIButton *)sender {
    
    // 1.控制状态
//    _selectButton.enabled = YES;
//    sender.enabled = NO;
//    _selectButton = sender;
    
    self.typeBButton.enabled = NO;
    self.TypeAButtons.enabled = YES;


    NSString *buttonTag = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    [self _requestType:buttonTag];
   
}

- (void)_requestType:(NSString *)examType
{
    //设置考试类别
    [[RusultManage shareRusultManage]sysTargetController:nil examType:examType SuccessData:^(NSDictionary *result) {
        NDLog(@"类别设置%@",result);
    }];
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
}


@end
