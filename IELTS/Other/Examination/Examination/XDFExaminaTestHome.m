//
//  XDFExaminaTestHome.m
//  IELTS
//
//  Created by 李牛顿 on 14-12-20.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFExaminaTestHome.h"
#import "XDFExaminaTestButton.h"
#import "XDFExaminaListenViewController.h"
#import "XDFExaminaReadViewController.h"
#import "XDFExaminaWriteViewController.h"
#import "XDFExaminaSpeakViewController.h"
#import "XDFTryRecordViewController.h"
#import "FileUploadHelper.h"
#import "XDFAnswersManage.h"
#import "XDFUpDataAnswers.h"

#define  kXDFPath_EvaluateThePaperSpeak @"PaperInfo/EvaluateThePaperSpeak"  //上传pm3



#define kTopView_Height 100
@interface XDFExaminaTestHome ()<XDFBaseExaminaTestDelegate,XDFTryRecordViewControllerDelegate>

@property (nonatomic,strong) UIView *bgView;  //背景视图
@property (nonatomic,strong) UIView *topView_;  //顶部视图
@property (nonatomic,strong) UIView *contentView_; //内容视图
@property (nonatomic,strong) UIButton *selectButton_;  //记录选择button

@property (nonatomic,strong) NSArray *listenPage_;
@property (nonatomic,strong) NSArray *speakPage_;
@property (nonatomic,strong) NSArray *readPage_;
@property (nonatomic,strong) NSArray *writerPage_;

@property (nonatomic,assign) NSInteger testSection;
@property (nonatomic,assign) NSInteger testPage;

@property (nonatomic,strong) UILabel *titlLable;
@property (nonatomic,assign) NSInteger finishSection;
@property (nonatomic,strong) NSString *domainPFolder;

@property (nonatomic,strong) NSString *lastAnser;
@property (nonatomic,strong) NSString *lastTimes;

@property (nonatomic,strong) UIButton *startButtons;

@end

@implementation XDFExaminaTestHome
@synthesize topView_,contentView_,selectButton_;
@synthesize listenPage_,speakPage_,readPage_,writerPage_;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
//创建头部视图
-(void)_topView
 {
     topView_ = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kTopView_Height)];
     topView_.backgroundColor = TABBAR_BACKGROUNDLight;//[UIColor whiteColor];
     [_bgView addSubview:topView_];
     //创建返回按钮
     UIButton *button = [ZCControl createButtonWithFrame:CGRectMake(20, (topView_.height-26)/2, 56, 26) ImageName:@"btn_back.png" Target:self Action:@selector(backAc:) Title:@""];
     [topView_ addSubview:button];
     
     //创建标题
     _titlLable = [ZCControl createLabelWithFrame:CGRectMake((topView_.width-200)/2, (topView_.height-30)/2, 200, 30) Font:24.0f Text:self.testTitles];
     _titlLable.textColor = [UIColor whiteColor];
     _titlLable.textAlignment = NSTextAlignmentCenter;
     [topView_ addSubview:_titlLable];
 }
//创建内容视图
-(void)_contentView
{
    contentView_ = [[UIView alloc]initWithFrame:CGRectMake(10, kTopView_Height+5, kScreenWidth-20, kScreenHeight-kTopView_Height-10)];
    contentView_.backgroundColor = [UIColor whiteColor];
    [_bgView addSubview:contentView_];
    
    //创建label
    UILabel *detaiLabel = [ZCControl createLabelWithFrame:CGRectMake((contentView_.width-700)/2, 300, 700, 30)
                                                     Font:18
                                                     Text:@""];
    detaiLabel.textAlignment = NSTextAlignmentCenter;
    detaiLabel.textColor = [UIColor lightGrayColor];
    detaiLabel.tag = 201314;
    [contentView_ addSubview:detaiLabel];
    //创建开始按钮  261*50
    UIButton *starButton = [ZCControl createButtonWithFrame:CGRectMake((contentView_.width-261)/2, 400, 261, 50) ImageName:@"btn2_1.png" Target:self Action:@selector(startAction:) Title:@""];
    [contentView_ addSubview:starButton];
    self.startButtons = starButton;
    //创建听说读写目录
    NSArray *titleArray = @[@"Listening",@"Reading",@"Writing",@"Speaking"];
    NSArray *imgHLArray= @[@"mater_hl_01.png",@"mater_hl_03.png",@"mater_hl_04.png",@"mater_hl_02.png"];
    NSArray *imgNorArray = @[@"mater_normal_01.png",@"mater_normal_03.png",@"mater_normal_04.png",@"mater_normal_02.png"];
    for (int i=0; i<4; i++) {
        NSString *title = titleArray[i];
        NSString *imgNor = imgNorArray[i];
        NSString *imgHL = imgHLArray[i];
        XDFExaminaTestButton *button = [[XDFExaminaTestButton alloc]initWithTitle:title imgView:imgNor imgHlView:imgHL Target:self frame:CGRectMake((contentView_.width-450-75)/2+150*i, 150, 75, 75/0.7)];
        button.tag = i+1;
        [contentView_ addSubview:button];
        //默认选中第一个
        if (i == 0) {
            [self testAction:button];
        }
    }
}

#pragma mark - 改变图片状态
- (void)testAction:(UIButton *)button
{
    UILabel *detailLabel =  (UILabel *)[contentView_ viewWithTag:201314];
    switch (self.startuInte) {
        case 1:
        {
            detailLabel.text = @"This test consists of four sections,each with ten questions.";
        }
            break;
        case 2:
        {
            detailLabel.text = @"This test consists of three sections with 40 questions.";
        }
            break;
            
        case 3:
        {
            detailLabel.text = @"This test consists of two tasks.";
        }
            break;
            
        case 4:
        {
            detailLabel.text = @"This test consists of three parts.";
        }
            break;
        default:
            break;
    }
    
    selectButton_.enabled = YES;
    button.enabled = NO;
    selectButton_ = button;
    NSLog(@"%ld",(long)button.tag);
}

#pragma mark - 处理数据
- (void)setPId:(NSString *)pId
{
    if (_pId != pId) {
        _pId = pId;
        //非模考
        if (!self.isChack) {
            NSInteger current = [kUserDefaults integerForKey:kCSection(self.pId)];
            if (current > 0 && current < 5) {
                self.startuInte = current;
            }else
            {
                self.startuInte = 1;
                //设置默认的section
                [kUserDefaults setInteger:1 forKey:kCSection(self.pId)];
                [kUserDefaults synchronize];
            }
        }
    }
}

- (void)setTestTitles:(NSString *)testTitles
{
    if (_testTitles != testTitles) {
        _testTitles = testTitles;
        
        //初始化视图
        [self _initView];
        //处理数据
        [self _dealData];
        
        [self _dealTite];
    }
}
//初始化视图
- (void)_initView
{
    //创建背景视图
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = rgb(230, 230, 230, 1);
    _bgView.frame = CGRectMake(0, 20, kScreenWidth, kScreenHeight);
    [self.view addSubview:_bgView];

    //创建头部视图
    [self _topView];
    [self _contentView];
}

- (void)_dealTite
{
        //如果有数据，获取当前状态
        if (self.isChack) {
            self.startuInte = 1;
            self.testPage = 0;
            self.testSection = 0;
            self.finishSection = 0;
            UIButton *button =  (UIButton *)[contentView_ viewWithTag:self.startuInte];
            self.startButtons.enabled = NO;
            [self testAction:button];
            [self performSelector:@selector(startAction:) withObject:button afterDelay:1.0];
        }else
        {
            NSDictionary *dataDic = [[XDFAnswersManage shardedAnswersManage]getStatus:self.pId];
            if (dataDic.count > 0 ) {
                NSString *type = [dataDic objectForKey:@"type"];
                NSString *section = [dataDic objectForKey:@"section"];
                NSString *page = [dataDic objectForKey:@"page"];
                NSString *finishSection = [dataDic objectForKey:@"finishSection"];
                self.startuInte = [type integerValue];
                self.testPage =[page integerValue] ;
                self.testSection = [section integerValue];
                self.finishSection = [finishSection integerValue];
                
                NSInteger currentSection =  [kUserDefaults integerForKey:kCSection(self.pId)];
                if (self.startuInte < currentSection) {
                    self.startuInte = currentSection;
                    UIButton *button =  (UIButton *)[contentView_ viewWithTag:self.startuInte];
                    [self testAction:button];
                }else
                {
                    UIButton *button =  (UIButton *)[contentView_ viewWithTag:self.startuInte];
                    [self testAction:button];
                    //自定跳转到对应的页。
                    [self performSelector:@selector(startAction:) withObject:button afterDelay:0.5];
                }
            }else
            {
                self.startuInte = 1;
                self.testPage = 0;
                self.testSection = 0;
                self.finishSection = 0;
                UIButton *button =  (UIButton *)[contentView_ viewWithTag:self.startuInte];
                [self testAction:button];
            }
        }
    //This test consists of four sections,each with ten questions.
    //This test consists of three sections with 40 questions.
    //This test consists of two tasks.
    //This test consists of three parts.
     _titlLable.text = _testTitles;
}

- (void)_dealData
{
    if (!self.isChack) {
        NSString *fileForld = [[DownLoadManage ShardedDownLoadManage]useIDSelect:_pId];
        NSString *savZipFloderPath =  [NSString stringWithFormat:@"%@/%@",[DownLoadManage getDocumentPath],fileForld];
        NSString *configPath = [savZipFloderPath stringByAppendingPathComponent:@"config.json"];  //文件夹下面的配置文件
        id json;
        NSError *error;
        NSData *data1 = [NSData dataWithContentsOfFile:configPath];
        if (data1.length > 0) {
            json = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:&error];
            NDLog(@"解析json数据:%@",json);
            [self _dealExaminaRusult:json];
        }
    }else
    {
        if (![[self.dicData objectForKey:@"domainPFolder"] isKindOfClass:[NSNull class]]) {
            NSString *domainPFolder = [self.dicData objectForKey:@"domainPFolder"];
            self.domainPFolder = domainPFolder;
            NSString *path = [domainPFolder stringByAppendingPathComponent:@"config.json"];
            [[RusultManage shareRusultManage] ruquestServerConfig:self path:path SuccessData:^(NSDictionary *result) {
                //处理数据
                [self _dealExaminaRusult:result];
            } errorData:^(NSError *error) {
                
            }];
        };
    }
}

- (void)_dealExaminaRusult:(NSDictionary *)dic
{
    NDLog(@"%@",dic);
    listenPage_ = [[NSArray alloc]init]; //听
    speakPage_ = [[NSArray alloc]init];  //说
    readPage_ = [[NSArray alloc]init]; //读
    writerPage_ = [[NSArray alloc]init]; //写

    NSArray *paperCatagoryList =[dic objectForKey:@"PaperCatagoryList"];  //目录列表
    //    NSString *paperNumber =  [json objectForKey:@"PaperNumber"]; //试卷编号
    //    NSString *paperName =[json objectForKey:@"PaperName"];    //试卷的标题
    
    //将听、说、读、写、数据分离
    for (NSDictionary *paperSection in paperCatagoryList) {
        NSString *name = [paperSection objectForKey:@"Name"];
        if ([name isEqualToString:@"听力"]) {
            listenPage_ = [paperSection objectForKey:@"paperSectionList"];
        }else if ([name isEqualToString:@"口语"])
        {
            speakPage_ = [paperSection objectForKey:@"paperSectionList"];
        }else if ([name isEqualToString:@"阅读"])
        {
            readPage_ = [paperSection objectForKey:@"paperSectionList"];
            
        }else if ([name isEqualToString:@"写作"])
        {
            writerPage_ = [paperSection objectForKey:@"paperSectionList"];
        }
    }
}


- (void)dealloc
{
    NDLog(@"dealloc%@",self);
}

#pragma mark - 开始按钮测试
- (void)startAction:(UIButton *)button
{
    switch (self.startuInte) {
        case 1:
        {
            if (listenPage_.count>0) {
                XDFExaminaListenViewController *exmTest = [[XDFExaminaListenViewController alloc]init];
                exmTest.isCheck = self.isChack;
                exmTest.domainPFolder = self.domainPFolder;
                exmTest.dataArray = listenPage_;
                exmTest.pId = self.pId;
                exmTest.currentType = self.startuInte;
                exmTest.rememberPage = self.testPage;
                exmTest.rememberSection = self.testSection;
                exmTest.delegate = self;
                exmTest.finishSection = self.finishSection;
                [self.navigationController pushViewController:exmTest animated:YES];
            }
        }
            break;
        case 2:
        {
            if (readPage_.count>0) {
                XDFExaminaReadViewController *exmTest = [[XDFExaminaReadViewController alloc]init];
                exmTest.isCheck = self.isChack;
                exmTest.dataArray = readPage_;
                exmTest.domainPFolder = self.domainPFolder;
                exmTest.pId = self.pId;
                exmTest.currentType = self.startuInte;
                exmTest.rememberPage = self.testPage;
                exmTest.rememberSection = self.testSection;
                exmTest.delegate = self;
                exmTest.finishSection = self.finishSection;
                
                [self.navigationController pushViewController:exmTest animated:YES];
            }
        }
            break;
        case 3:
        {
            
            if (writerPage_.count>0) {
                XDFExaminaWriteViewController *exmTest = [[XDFExaminaWriteViewController alloc]init];
                exmTest.isCheck = self.isChack;
                exmTest.domainPFolder = self.domainPFolder;
                exmTest.dataArray = writerPage_;
                exmTest.pId = self.pId;
                exmTest.currentType = self.startuInte;
                exmTest.rememberPage = self.testPage;
                exmTest.rememberSection = self.testSection;
                exmTest.delegate = self;
                exmTest.finishSection = self.finishSection;
                
                [self.navigationController pushViewController:exmTest animated:YES];
            }

        }
            break;
        case 4:
        {
            if (speakPage_.count>0) {
                if (self.isChack) {
                    //创建新的视图
                    XDFExaminaSpeakViewController *exmTest = [[XDFExaminaSpeakViewController alloc]init];
                    exmTest.isCheck = self.isChack;
                    exmTest.resultView = self.resultView;
                    exmTest.domainPFolder = self.domainPFolder;
                    exmTest.dataArray = speakPage_;
                    exmTest.pId = self.pId;
                    exmTest.currentType = self.startuInte;
                    exmTest.rememberPage = self.testPage;
                    exmTest.rememberSection = self.testSection;
                    exmTest.delegate = self;
                    exmTest.finishSection = self.finishSection;
                    [self.navigationController pushViewController:exmTest animated:YES];
                }else
                {
                    XDFTryRecordViewController *exmTest = [[XDFTryRecordViewController alloc]initWithNibName:@"XDFTryRecordViewController" bundle:nil];
                    exmTest.isCheck = self.isChack;
                    exmTest.dataArray = speakPage_;
                    exmTest.pId = self.pId;
                    exmTest.currentType = self.startuInte;
                    exmTest.rememberPage = self.testPage;
                    exmTest.rememberSection = self.testSection;
                    exmTest.delegate = self;
                    exmTest.finishSection = self.finishSection;
                    [self.navigationController pushViewController:exmTest animated:YES];
                }
            }
        }
            break;
        default:
            break;
    }
   
}
#pragma mark - 完成模块试卷
- (void)examinaFinishs:(NSInteger)pageIndex
{
    if (self.isChack) {
        UIButton *button =  (UIButton *)[contentView_ viewWithTag:pageIndex+1];
        self.startuInte = pageIndex+1;
        [self testAction:button];
        [self performSelector:@selector(startAction:) withObject:button afterDelay:1.0];
    }else
    {
        NSInteger currentSection =  [kUserDefaults integerForKey:kCSection(self.pId)];//[userDefalets objectForKey:kCurrentSection];
        if (currentSection == pageIndex && pageIndex != 4) {
            
            [[NSUserDefaults standardUserDefaults]setInteger:pageIndex+1 forKey:kCSection(self.pId)];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            UIButton *button =  (UIButton *)[contentView_ viewWithTag:pageIndex+1];
            self.startuInte = pageIndex+1;
            [self testAction:button];
            
        }else
        {
            //整套试卷完成
            
        }
    }
}

#pragma mark - 上传答案
//开始上传答案
- (void)speakFinish
{
    XDFUpDataAnswers *upData = [XDFUpDataAnswers shareUpDataAnswers];
    upData.listenPage_ = listenPage_;
    upData.speakPage_ = speakPage_;
    upData.readPage_ = readPage_;
    upData.writerPage_ = writerPage_;
    upData.pId = self.pId;
    upData.stId = self.stId;
    upData.taskType = self.taskType;
    [upData finishUpLoadAnswer];
}

#pragma mark -返回按钮
- (void)backAc:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
