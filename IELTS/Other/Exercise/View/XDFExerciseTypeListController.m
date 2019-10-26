//
//  XDFExerciseTypeListController.m
//  IELTS
//
//  Created by 李牛顿 on 14-12-30.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFExerciseTypeListController.h"
#import "XDFExerciseDetailTableViewCell.h"
#import "XDFGetScoreViewController.h"

#import "XDFExerciseListentController.h"
#import "XDFExerciseSpeakController.h"
#import "XDFExerciseReadController.h"
#import "XDFExerciseWriteController.h"
#import "XDFExerciseVacabulaerController.h"
#import "XDFExerciseGrammarViewController.h"
#import "XDFExerciseSyntheticViewController.h"

#define  kScaleFloat 0.7
#define kTopViewHeight 100
@interface XDFExerciseTypeListController ()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,strong)UIView *leftView_;
@property (nonatomic,strong)UIView *rightType_;

@property (nonatomic,strong)UILabel *tipTitle;   //顶部主标题
@property (nonatomic,strong)UILabel *detailTitle;//顶部副标题
@property (nonatomic,strong)UIImageView *imageViews; //顶部图像


@property (nonatomic,strong)NSArray *dataArray; //列表数据
@property (nonatomic,strong)UITableView *exerciseTableView_;//表视图


@end

@implementation XDFExerciseTypeListController
@synthesize leftView_,rightType_;
@synthesize tipTitle,detailTitle,imageViews,exerciseTableView_;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    //左侧
    [self _typeLeft];
    //右侧
    [self _typeRight];
}
#pragma mark -Left
- (void)_typeLeft
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
    
    //后退按钮
    CGFloat beforeW = 86*kScaleFloat;
    CGFloat beforeH = 86*kScaleFloat;
    
    UIButton *beforeButton = [ZCControl createButtonWithFrame:CGRectMake((kSecondLevelLeftWidth-beforeW)/2, kScreenHeight-beforeW*2-60, beforeW, beforeH)ImageName:@"" Target:self Action:@selector(leftAction:) Title:@""];
    [beforeButton setBackgroundImage:[UIImage imageNamed:@"arraw_Left.png"] forState:UIControlStateNormal];
    beforeButton.tag = 100;
    [leftView_ addSubview:beforeButton];
    
    //前进按钮
    UIButton *nextButton = [ZCControl createButtonWithFrame:CGRectMake((kSecondLevelLeftWidth-beforeW)/2, kScreenHeight- beforeW-40, beforeH, beforeH) ImageName:@"" Target:self Action:@selector(rightAction:) Title:@""];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"arraw_Right.png"] forState:UIControlStateNormal];
    nextButton.tag = 101;
    [leftView_ addSubview:nextButton];
    
    [self.view addSubview:leftView_];
    
    if ([self.typeString isEqualToString:@"1"]) {
        beforeButton.enabled = NO;
    }else if ([self.typeString isEqualToString:@"7"]){
        nextButton.enabled = NO;
    }
}

//返回
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
//后退
- (void)leftAction:(UIButton *)button
{
    NDLog(@"后退");
    
    UIButton *nextButton = (UIButton *)[super.view viewWithTag:101];
    if ([self.typeString isEqualToString:@"1"]) {
        button.enabled = NO;
    }else
    {
        button.enabled = YES;
        nextButton.enabled = YES;
        
        NSString *stringType = [NSString stringWithFormat:@"%d",[self.typeString intValue]-1];
        if ([stringType isEqualToString:@"1"]) {
            button.enabled = NO;
        }
         self.typeString = stringType;
    
        [self _initRequestData:_typeString];
    }
}
//前进
- (void)rightAction:(UIButton *)button
{
    UIButton *beforeButton = (UIButton *)[super.view viewWithTag:100];
    if ([self.typeString isEqualToString:@"7"]) {
        button.enabled = NO;
    }else
    {
        button.enabled = YES;
        beforeButton.enabled = YES;
        NSString *stringType = [NSString stringWithFormat:@"%d",[self.typeString intValue]+1];
        if ([stringType isEqualToString:@"7"]) {
            button.enabled = NO;
        }
        self.typeString = stringType;
        [self _initRequestData:_typeString];
    }
}

#pragma mark - Right
- (void)_typeRight
{
    _dataArray = [[NSArray alloc]init];
    
    rightType_ = [[UIView alloc]initWithFrame:CGRectMake(kSecondLevelLeftWidth, 20, kScreenWidth-kSecondLevelLeftWidth, kScreenHeight)];
    rightType_.backgroundColor = rgb(230, 230, 230, 1.0);
    [self.view addSubview:rightType_];
    //1.创建顶部标题
    [self _initTopArea];
    //2.创建页面列表
    [self _initList];
}

#pragma mark-创建顶部标题
- (void)_initTopArea
{
    UIView *bgTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-kSecondLevelLeftWidth, kTopViewHeight)];
    bgTop.backgroundColor = [UIColor whiteColor];
    [rightType_ addSubview:bgTop];
    //主标题
    tipTitle = [ZCControl createLabelWithFrame:CGRectMake((bgTop.width-200)/2+50, 20, 200, 40) Font:30.0f Text:@""];
    tipTitle.textColor = TABBAR_BACKGROUND_SELECTED;
    [bgTop addSubview:tipTitle];
    //副标题
    detailTitle = [ZCControl createLabelWithFrame:CGRectMake((bgTop.width-200)/2+50, tipTitle.bottom-5, 300, 30) Font:20.0f Text:@""];
    detailTitle.textColor = [UIColor darkGrayColor];
    [bgTop addSubview:detailTitle];
    
    //头像
    imageViews = [[UIImageView alloc]initWithImage:[ZCControl createImageWithColor:[UIColor lightGrayColor]]];
    imageViews.frame = CGRectMake((bgTop.width-200)/2-40, (bgTop.height-60)/2, 60, 60);
    //    [ZCControl circleImage:imageViews];
    [bgTop addSubview:imageViews];
    
}
#pragma mark-创建页面列表
- (void)_initList
{
    exerciseTableView_ = [[UITableView alloc]initWithFrame:CGRectMake(100, kTopViewHeight, kScreenWidth-kSecondLevelLeftWidth-200, kScreenHeight-kTopViewHeight) style:UITableViewStylePlain];
    exerciseTableView_.delegate = self;
    exerciseTableView_.dataSource = self;
    exerciseTableView_.rowHeight = 90;
    exerciseTableView_.showsVerticalScrollIndicator = NO;
    exerciseTableView_.showsHorizontalScrollIndicator = NO;
    exerciseTableView_.backgroundColor = [UIColor clearColor];
    exerciseTableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    [rightType_ addSubview:exerciseTableView_];
    
}
#pragma mark-请求数据
- (void)_initRequestData:(NSString *)types
{
#pragma mark -设置顶部图标以及标题
    NSString *titleString;
    NSString *imgString;
    
    if ([types isEqualToString:@"1"]) {
        titleString= @"Listening";
        imgString = @"120_listen.png";
    }else if ([types isEqualToString:@"2"])
    {
        titleString= @"Speaking";
        imgString = @"120_speak.png";
    }else if ([types isEqualToString:@"3"])
    {
        titleString= @"Reading";
        imgString = @"120_read.png";
    }else if ([types isEqualToString:@"4"])
    {
        titleString= @"Writing";
        imgString = @"120_write.png";
    }else if ([types isEqualToString:@"5"])
    {
        titleString= @"Vocabulary";
        imgString = @"120_Vocabular.png";
    }else if ([types isEqualToString:@"6"])
    {
        titleString= @"Grammar";
        imgString = @"120_grammar.png";
    }else if([types isEqualToString:@"7"])
    {
        titleString= @"Synthetic";
        imgString =  @"120_synthetic.png";
    }
    tipTitle.text = titleString;
    imageViews.image = [UIImage imageNamed:imgString];
    [[RusultManage shareRusultManage]exerciseTypeRuslt:types
                                            Controller:self
                                           successData:^(NSDictionary *result) {
//                                               NDLog(@"%@",result);
                                               [self _dealData:types resultData:result];
                                           }];
}

- (void)_dealData:(NSString *)type resultData:(NSDictionary *)result
{
    //设置标题
    NSDictionary *resultData =  [result objectForKey:@"Data"];
    //个数数据处理
    NSString *allOneTypeLx = [[resultData objectForKey:@"allOneTypeLx"]stringValue];
    NSString *finishOneTypeLx = [[resultData objectForKey:@"finishOneTypeLx"]stringValue];
    detailTitle.text = [NSString stringWithFormat:@"任务完成度:   %@/%@",finishOneTypeLx,allOneTypeLx];
    
    //具体内容
    NSArray *mapListData = [resultData objectForKey:@"mapList"];
    _dataArray = mapListData;
    [exerciseTableView_ reloadData];
}


- (void)setTypeString:(NSString *)typeString
{
    if (_typeString != typeString) {
        _typeString = typeString;
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self _initRequestData:_typeString];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indetify = @"cellIndetifyDetail";
    XDFExerciseDetailTableViewCell *cell = (XDFExerciseDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:indetify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XDFExerciseDetailTableViewCell" owner:self options:nil]lastObject];
        cell.height = 90;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    cell.exerType = ExerciseCellType;
    cell.dataDic = _dataArray[indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray.count > 0) {
        NSDictionary *dataDic = _dataArray[indexPath.row];
        NSString *lcName = [dataDic objectForKey:@"lcName"];
        [self intoController:lcName data:dataDic];
    }
}
#pragma mark -进入练习
- (void)intoController:(NSString *)path  data:(NSDictionary *)dataDic
{
    NSString *p_id = [[dataDic objectForKey:@"P_ID"]stringValue];
    
    
    NSString *ST_ID = [[dataDic objectForKey:@"ST_ID"]stringValue];
    BOOL st_IdStatus = [[dataDic objectForKey:@"Status"] boolValue];
    
    NSString *status = [NSString stringWithFormat:@"%@finish",p_id];
    BOOL isMark = [kUserDefaults boolForKey:status];
    
    if (kStringEqual(path, @"听力")) {
        if (!isMark) {
            
            NSString *domainPFolder = [dataDic objectForKey:@"domainPFolder"];
            NSString * lastPath = [domainPFolder lastPathComponent];
            if ([lastPath isEqualToString:@"null"]) {
                [[RusultManage shareRusultManage]tipAlert:@"试卷获取失败,请于管理员联系"viewController:self];
                return;
            }
            
            if (!st_IdStatus) {
                [[RusultManage shareRusultManage]tellServerTaskSTID:ST_ID];
            }

            XDFExerciseListentController *exListent = [[XDFExerciseListentController alloc]init];
            exListent.dataDic = dataDic;
            exListent.testType = path;
            exListent.isChack = NO;
            [self.navigationController pushViewController:exListent animated:YES];
        }else
        {
             //进入评分页面
            XDFGetScoreViewController *getScore = [[XDFGetScoreViewController alloc]init];
            getScore.dataDic = dataDic;
            getScore.testType = path;
            getScore.listController = self;
            getScore.dayType = DayOrTypeTypes;
            [self.navigationController pushViewController:getScore animated:YES];
        }
    }else if(kStringEqual(path, @"阅读"))
    {
        if (!isMark) {
            
            NSString *domainPFolder = [dataDic objectForKey:@"domainPFolder"];
            NSString * lastPath = [domainPFolder lastPathComponent];
            if ([lastPath isEqualToString:@"null"]) {
                [[RusultManage shareRusultManage]tipAlert:@"试卷获取失败,请于管理员联系"viewController:self];
                return;
            }
            
            if (!st_IdStatus) {
                [[RusultManage shareRusultManage]tellServerTaskSTID:ST_ID];
            }
            
            XDFExerciseReadController *speak = [[XDFExerciseReadController alloc]init];
            speak.dataDic = dataDic;
            speak.testType = path;
            speak.isChack = NO;
            [self.navigationController pushViewController:speak animated:YES];
        }else
        {
            //进入评分页面
            XDFGetScoreViewController *getScore = [[XDFGetScoreViewController alloc]init];
            getScore.dataDic = dataDic;
            getScore.testType = path;
            getScore.listController = self;
            getScore.dayType = DayOrTypeTypes;
            [self.navigationController pushViewController:getScore animated:YES];
        }
    
    }else if(kStringEqual(path, @"口语"))
    {
        if (!isMark) {
            
            NSString *domainPFolder = [dataDic objectForKey:@"domainPFolder"];
            NSString * lastPath = [domainPFolder lastPathComponent];
            if ([lastPath isEqualToString:@"null"]) {
                [[RusultManage shareRusultManage]tipAlert:@"试卷获取失败,请于管理员联系"viewController:self];
                return;
            }

            if (!st_IdStatus) {
                [[RusultManage shareRusultManage]tellServerTaskSTID:ST_ID];
            }

            XDFExerciseSpeakController *speak = [[XDFExerciseSpeakController alloc]init];
            speak.dataDic = dataDic;
            speak.testType = path;
            speak.isChack = NO;
            [self.navigationController pushViewController:speak animated:YES];
        }else
        {
            //进入评分页面
            XDFGetScoreViewController *getScore = [[XDFGetScoreViewController alloc]init];
            getScore.dataDic = dataDic;
            getScore.testType = path;
            getScore.listController = self;
            getScore.dayType = DayOrTypeTypes;
            [self.navigationController pushViewController:getScore animated:YES];
        }
    }else if(kStringEqual(path, @"写作"))
    {
        if (!isMark) {
            NSString *domainPFolder = [dataDic objectForKey:@"domainPFolder"];
            NSString * lastPath = [domainPFolder lastPathComponent];
            if ([lastPath isEqualToString:@"null"]) {
                [[RusultManage shareRusultManage]tipAlert:@"试卷获取失败,请于管理员联系"viewController:self];
                return;
            }
            
            if (!st_IdStatus) {
                [[RusultManage shareRusultManage]tellServerTaskSTID:ST_ID];
            }


            XDFExerciseWriteController *speak = [[XDFExerciseWriteController alloc]init];
            speak.dataDic = dataDic;
            speak.testType = path;
            speak.isChack = NO;
            [self.navigationController pushViewController:speak animated:YES];
        }else
        {
            //进入评分页面
            XDFGetScoreViewController *getScore = [[XDFGetScoreViewController alloc]init];
            getScore.dataDic = dataDic;
            getScore.testType = path;
            getScore.listController = self;
            getScore.dayType = DayOrTypeTypes;
            [self.navigationController pushViewController:getScore animated:YES];
        }
        
    }else if(kStringEqual(path, @"词汇"))
    {
        if (!isMark) {
            
            NSString *domainPFolder = [dataDic objectForKey:@"domainPFolder"];
            NSString * lastPath = [domainPFolder lastPathComponent];
            if ([lastPath isEqualToString:@"null"]) {
                [[RusultManage shareRusultManage]tipAlert:@"试卷获取失败,请于管理员联系"viewController:self];
                return;
            }
            
            if (!st_IdStatus) {
                [[RusultManage shareRusultManage]tellServerTaskSTID:ST_ID];
            }


            XDFExerciseVacabulaerController *speak = [[XDFExerciseVacabulaerController alloc]init];
            speak.dataDic = dataDic;
            speak.testType = path;
            speak.isChack = NO;
            [self.navigationController pushViewController:speak animated:YES];
        }else
        {
            //进入评分页面
            XDFGetScoreViewController *getScore = [[XDFGetScoreViewController alloc]init];
            getScore.dataDic = dataDic;
            getScore.testType = path;
            getScore.listController = self;
            getScore.dayType = DayOrTypeTypes;
            [self.navigationController pushViewController:getScore animated:YES];
        }
        
    }else if(kStringEqual(path, @"语法"))
    {
        if (!isMark) {
            NSString *domainPFolder = [dataDic objectForKey:@"domainPFolder"];
            NSString * lastPath = [domainPFolder lastPathComponent];
            if ([lastPath isEqualToString:@"null"]) {
                [[RusultManage shareRusultManage]tipAlert:@"试卷获取失败,请于管理员联系"viewController:self];
                return;
            }
            if (!st_IdStatus) {
                [[RusultManage shareRusultManage]tellServerTaskSTID:ST_ID];
            }
            
            XDFExerciseGrammarViewController *speak = [[XDFExerciseGrammarViewController alloc]init];
            speak.dataDic = dataDic;
            speak.testType = path;
            speak.isChack = NO;
            [self.navigationController pushViewController:speak animated:YES];
        }else
        {
            //进入评分页面
            XDFGetScoreViewController *getScore = [[XDFGetScoreViewController alloc]init];
            getScore.dataDic = dataDic;
            getScore.testType = path;
            getScore.listController = self;
            getScore.dayType = DayOrTypeTypes;
            [self.navigationController pushViewController:getScore animated:YES];
        }
    }else if(kStringEqual(path, @"综合"))
    {
        if (!isMark) {
            NSString *domainPFolder = [dataDic objectForKey:@"domainPFolder"];
            NSString * lastPath = [domainPFolder lastPathComponent];
            if ([lastPath isEqualToString:@"null"]) {
                [[RusultManage shareRusultManage]tipAlert:@"试卷获取失败,请于管理员联系" viewController:self];
                return;
            }
            
            if (!st_IdStatus) {
                [[RusultManage shareRusultManage]tellServerTaskSTID:ST_ID];
            }


            XDFExerciseSyntheticViewController *speak = [[XDFExerciseSyntheticViewController alloc]init];
            speak.dataDic = dataDic;
            speak.testType = path;
            speak.isChack = NO;
            [self.navigationController pushViewController:speak animated:YES];
        }else
        {
            //进入评分页面
            XDFGetScoreViewController *getScore = [[XDFGetScoreViewController alloc]init];
            getScore.dataDic = dataDic;
            getScore.testType = path;
            getScore.listController = self;
            getScore.dayType = DayOrTypeTypes;
            [self.navigationController pushViewController:getScore animated:YES];
        }
    }
}

- (void)dealloc
{
    NDLog(@"%@",self);
}


@end
