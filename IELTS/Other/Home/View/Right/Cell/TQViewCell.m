//
//  TQViewCell.m
//  TQMultistageTableViewDemo
//
//  Created by ChinaSoft-Developer-01 on 14/11/20.
//  Copyright (c) 2014年 fuqiang. All rights reserved.
//

#import "TQViewCell.h"
#import "XDFCCAndGouKuaiViewController.h"

#import "XDFGetScoreViewController.h"
#import "XDFExerciseListentController.h"
#import "XDFExerciseSpeakController.h"
#import "XDFExerciseReadController.h"
#import "XDFExerciseWriteController.h"
#import "XDFExerciseVacabulaerController.h"
#import "XDFExerciseGrammarViewController.h"
#import "XDFExerciseSyntheticViewController.h"

#import "XDFResultViewController.h"
#import "XDFExaminaTestHome.h"

@interface TQViewCell()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *celltabelView;
@property (nonatomic,strong)NSMutableArray *dataDic;
@property (nonatomic,assign)BOOL hasNetWork;

@end

@implementation TQViewCell
- (id)init
{
    self = [super init];
    if (self) {
        [self _initArray];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initArray];
    }
    return self;
}

- (void)_initArray
{
    
//    self.hasNetWork = NO;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNoNewtWork_ object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(curentHomeNoNetWork) name:kNoNewtWork_ object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kHasNewtWork_ object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(curentHomeHasNetWork) name:kHasNewtWork_ object:nil];
    
    _resourceArray = [[NSArray alloc]init];
    _exerciseArray = [[NSArray alloc]init];
    _testArray = [[NSArray alloc]init];
    _dataDic = [[NSMutableArray alloc]init];
    
    _celltabelView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _celltabelView.delegate = self;
    _celltabelView.dataSource = self;
    _celltabelView.sectionHeaderHeight = 30;
    _celltabelView.rowHeight = 62;
    _celltabelView.bounces = NO;
    _celltabelView.separatorColor = [UIColor lightGrayColor];
    
    [self addSubview:_celltabelView];

}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)curentHomeNoNetWork
{
    self.hasNetWork = YES;
}
- (void)curentHomeHasNetWork
{
    self.hasNetWork = NO;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    _celltabelView.frame = CGRectMake(0, 0, self.width, self.height);
}

- (void)setResourceArray:(NSArray *)resourceArray
{
    if (_resourceArray != resourceArray) {
        _resourceArray = resourceArray;
        if (_resourceArray.count > 0) {
            NSDictionary *dic1 = @{@"name":@"学习",
                                   @"list":_resourceArray};
            [_dataDic addObject:dic1];
        }
        
        if (_exerciseArray.count > 0) {
            NSDictionary *dic2 = @{@"name":@"练习",
                                   @"list":_exerciseArray};
            [_dataDic addObject:dic2];
        }
        
        if (_testArray.count > 0) {
            NSDictionary *dic3 = @{@"name":@"模考",
                                   @"list":_testArray};
            [_dataDic addObject:dic3];
        }
        [_celltabelView reloadData];
    }
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_resourceArray.count > 0 && _exerciseArray.count> 0   && _testArray.count > 0) {
        return 3;
    }else if (_resourceArray.count == 0 && _exerciseArray.count == 0 && _testArray.count == 0)
    {
        return 0;
    }else if ((_resourceArray.count == 0 && _exerciseArray.count == 0) ||
              (_resourceArray.count == 0 && _testArray.count == 0) ||
              (_exerciseArray.count == 0 && _testArray.count == 0))
    {
        return 1;
        
    }else if ((_resourceArray.count>0 && _exerciseArray.count>0) ||
              (_resourceArray.count >0 && _testArray.count>0) ||
              (_exerciseArray.count>0 && _testArray.count>0))
    {
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[_dataDic objectAtIndex:section]objectForKey:@"list"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"identifyCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.imageView.frame = CGRectMake(0, 0, 40, 40);
        
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, (62-45)/2, 45, 45)];
//        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 45, 45)];
//        [view addSubview:imgView];
//        imgView.tag = 10;
//        [cell.contentView addSubview:view];
        
//        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(55+10, (62-30)/2, 300, 30)];
//        titleLabel.tag = 11;
//        [cell.contentView addSubview:titleLabel];
    }

//    UIImageView *imagView = (UIImageView *)[cell.contentView viewWithTag:10];
//    UILabel *titleLabe = (UILabel *)[cell.contentView viewWithTag:11];
     NSArray *listArray =[[_dataDic objectAtIndex:indexPath.section] objectForKey:@"list"];
     NSString *name = [[_dataDic objectAtIndex:indexPath.section]objectForKey:@"name"];
    if (![[listArray[indexPath.row] objectForKey:@"RefData"] isKindOfClass:[NSNull class]]) {
        
        //标题
        NSDictionary *refData = [listArray[indexPath.row] objectForKey:@"RefData"];
//        titleLabe.text = [refData objectForKey:@"Name"];
        cell.textLabel.text = [refData objectForKey:@"Name"];
        
        //完成状态
        NSString *p_id = [[refData objectForKey:@"P_ID"] stringValue];
        NSString *finishPID = [NSString stringWithFormat:@"%@finish",p_id];

        if ([[listArray[indexPath.row] objectForKey:@"TF_ID"] isKindOfClass:[NSNull class]]) {
//            titleLabe.textColor = [UIColor blackColor];
            cell.textLabel.textColor = [UIColor darkGrayColor];
            [kUserDefaults setBool:NO forKey:finishPID];
            [kUserDefaults synchronize];

        }else
        {
//            titleLabe.textColor = [UIColor lightGrayColor];
            cell.textLabel.textColor = [UIColor lightGrayColor];
            
            [kUserDefaults setBool:YES forKey:finishPID];
            [kUserDefaults synchronize];
        }
        
        //图标
        if (kStringEqual(name, @"学习")) {
            if (![[refData objectForKey:@"StorePoint"] isKindOfClass:[NSNull class]]) {
                NSString *storePoint = [[refData objectForKey:@"StorePoint"] stringValue];
                if (kStringEqual(storePoint, @"1")) {
                    NSString *fileType = [refData objectForKey:@"FileType"];
                    if ([fileType isEqualToString:@"docx"] || [fileType isEqualToString:@"doc"]) {
//                        imagView.image = [UIImage imageNamed:@"icon_world.png"];
                        cell.imageView.image = [UIImage imageNamed:@"icon_world.png"];
                        
                    }else if ([fileType isEqualToString:@"ppt"] || [fileType isEqualToString:@"pptx"])
                    {
//                        imagView.image = [UIImage imageNamed:@"icon_ppt.png"];
                        cell.imageView.image = [UIImage imageNamed:@"icon_ppt.png"];
                    }else if ([fileType isEqualToString:@"pdf"])
                    {
//                        imagView.image = [UIImage imageNamed:@"icon_pdf.png"];
                        cell.imageView.image = [UIImage imageNamed:@"icon_pdf.png"];
                    }else if ([fileType isEqualToString:@"xlsx"] || [fileType isEqualToString:@"xls"])
                    {
//                       imagView.image = [UIImage imageNamed:@"icon_excel.png"];
                        cell.imageView.image = [UIImage imageNamed:@"icon_excel.png"];
                    }

                }else if (kStringEqual(storePoint, @"2"))
                {
//                    imagView.image = [UIImage imageNamed:@"icon_video.png"];
                    cell.imageView.image = [UIImage imageNamed:@"icon_video.png"];
                }
                }
        }else if (kStringEqual(name, @"练习"))
        {
            if (![[refData objectForKey:@"lcName"] isKindOfClass:[NSNull class]]) {                
                NSString *lcName =  [refData objectForKey:@"lcName"];
                NSString *imageName = [ZCControl imgTypeCatagory:lcName];
                //            imagView.image = [UIImage imageNamed:imageName];
                cell.imageView.image = [UIImage imageNamed:imageName];
            }

        }else if (kStringEqual(name, @"模考"))
        {
//            imagView.image = [UIImage imageNamed:@"120_ExainaView.png"];
            cell.imageView.image = [UIImage imageNamed:@"mater_hl_08.png"];//@"120_ExainaView.png"];
        }

    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    view.backgroundColor = rgb(249, 250, 251, 1);
    
    UILabel *label = [ZCControl createLabelWithFrame:CGRectMake(20, 0, tableView.frame.size.width, 30) Font:20.0f Text:[[_dataDic objectAtIndex:section]objectForKey:@"name"]];
    [view addSubview:label];
    label.textColor = rgb(79, 88, 122, 1);
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = [[_dataDic objectAtIndex:indexPath.section]objectForKey:@"name"];
    NSArray *listArray =[[_dataDic objectAtIndex:indexPath.section] objectForKey:@"list"];
    NSDictionary *allDic = listArray[indexPath.row];
    if(  ![[allDic objectForKey:@"RefData"] isKindOfClass:[NSNull class]] && listArray.count > 0 ) {
        
        NSDictionary *dataDic = [allDic objectForKey:@"RefData"];
        NSString *st_id = [[allDic objectForKey:@"ST_ID"]stringValue];
        BOOL  st_idStatus = [[allDic objectForKey:@"Status"] boolValue];
        NSString *p_id = [[dataDic objectForKey:@"P_ID"]stringValue];
        NSString *status = [NSString stringWithFormat:@"%@finish",p_id];
        BOOL isMark = [kUserDefaults boolForKey:status];
        
        if (self.hasNetWork) {
            [self.viewController.parentViewController.parentViewController.view makeToast:@"当前网络不可用,请检测网络!" duration:2.0 position:@"bottom"];
            return;
        }

        if ([name isEqualToString:@"学习"]) {
           NSString *url = [dataDic objectForKey:@"Url"];
            if (url.length > 0) {
                //20150420
                if (!st_idStatus) {
                    [[RusultManage shareRusultManage]tellServerTaskSTID:st_id];
                }
                
                XDFCCAndGouKuaiViewController *ccandGoukuai = [[XDFCCAndGouKuaiViewController alloc]init];
                ccandGoukuai.urlPath = url;
                ccandGoukuai.listData = listArray;
                ccandGoukuai.indexPathRow = indexPath.row;
                ccandGoukuai.taskType = WhereTaskTypeHome;
                [self.viewController.parentViewController.parentViewController.navigationController pushViewController:ccandGoukuai animated:YES];
            }
        }else if([name isEqualToString:@"练习"]){
                if (![[dataDic objectForKey:@"lcName"] isKindOfClass:[NSNull class]]) {
                    NSString *path =  [dataDic objectForKey:@"lcName"];
                    if (kStringEqual(path, @"听力")) {
                        if (!isMark) {
                            NSString *domainPFolder = [dataDic objectForKey:@"domainPFolder"];
                            NSString * lastPath = [domainPFolder lastPathComponent];
                            if ([lastPath isEqualToString:@"null"]) {
                                [[RusultManage shareRusultManage]tipAlert:@"试卷获取失败,请于管理员联系"];
                                return;
                            }
                            
                            //2050420
                            if (!st_idStatus) {
                                [[RusultManage shareRusultManage]tellServerTaskSTID:st_id];
                            }
                            XDFExerciseListentController *exListent = [[XDFExerciseListentController alloc]init];
                            exListent.dataDic = dataDic;
                            exListent.testType = path;
                            exListent.st_ID = st_id;
                            exListent.controlType = ControlTypeHome;
                            exListent.isChack = NO;
                            [self.viewController.parentViewController.parentViewController.navigationController pushViewController:exListent animated:YES];
                        }else
                        {
                            //进入评分页面
                            XDFGetScoreViewController *getScore = [[XDFGetScoreViewController alloc]init];
                            getScore.dataDic = dataDic;
                            getScore.testType = path;
                            getScore.st_Id = st_id;
                            getScore.dayType = DayOrTypeHome;
                            [self.viewController.parentViewController.parentViewController.navigationController pushViewController:getScore animated:YES];
                        }
                    }else if(kStringEqual(path, @"阅读"))
                    {
                        if (!isMark) {
                            NSString *domainPFolder = [dataDic objectForKey:@"domainPFolder"];
                            NSString * lastPath = [domainPFolder lastPathComponent];
                            if ([lastPath isEqualToString:@"null"]) {
                                [[RusultManage shareRusultManage]tipAlert:@"试卷获取失败,请于管理员联系"];
                                return;
                            }
                            
                            if (!st_idStatus) {
                                [[RusultManage shareRusultManage]tellServerTaskSTID:st_id];
                            }

                            XDFExerciseReadController *speak = [[XDFExerciseReadController alloc]init];
                            speak.dataDic = dataDic;
                            speak.testType = path;
                            speak.isChack = NO;
                            speak.st_ID = st_id;
                            speak.controlType = ControlTypeHome;
                            [self.viewController.parentViewController.parentViewController.navigationController pushViewController:speak animated:YES];
                        }else
                        {
                            //进入评分页面
                            XDFGetScoreViewController *getScore = [[XDFGetScoreViewController alloc]init];
                            getScore.dataDic = dataDic;
                            getScore.testType = path;
                            getScore.st_Id = st_id;
                            getScore.dayType = DayOrTypeHome;
                            [self.viewController.parentViewController.parentViewController.navigationController pushViewController:getScore animated:YES];
                        }
                        
                    }else if(kStringEqual(path, @"口语"))
                    {
                        if (!isMark) {
                            NSString *domainPFolder = [dataDic objectForKey:@"domainPFolder"];
                            NSString * lastPath = [domainPFolder lastPathComponent];
                            if ([lastPath isEqualToString:@"null"]) {
                                [[RusultManage shareRusultManage]tipAlert:@"试卷获取失败,请于管理员联系"];
                                return;
                            }
                            
                            //2050420
                            if (!st_idStatus) {
                                [[RusultManage shareRusultManage]tellServerTaskSTID:st_id];
                            }


                            XDFExerciseSpeakController *speak = [[XDFExerciseSpeakController alloc]init];
                            speak.dataDic = dataDic;
                            speak.testType = path;
                            speak.isChack = NO;
                            speak.st_ID = st_id;
                            speak.controlType = ControlTypeHome;
                            [self.viewController.parentViewController.parentViewController.navigationController pushViewController:speak animated:YES];
                        }else
                        {
                            //进入评分页面
                            XDFGetScoreViewController *getScore = [[XDFGetScoreViewController alloc]init];
                            getScore.dataDic = dataDic;
                            getScore.testType = path;
                            getScore.st_Id = st_id;
                            getScore.dayType = DayOrTypeHome;
                            [self.viewController.parentViewController.parentViewController.navigationController pushViewController:getScore animated:YES];                    }
                        
                    }else if(kStringEqual(path, @"写作"))
                    {
                        if (!isMark) {
                            NSString *domainPFolder = [dataDic objectForKey:@"domainPFolder"];
                            NSString * lastPath = [domainPFolder lastPathComponent];
                            if ([lastPath isEqualToString:@"null"]) {
                                [[RusultManage shareRusultManage]tipAlert:@"试卷获取失败,请于管理员联系"];
                                return;
                            }
                            
                            //2050420
                            if (!st_idStatus) {
                                [[RusultManage shareRusultManage]tellServerTaskSTID:st_id];
                            }


                            XDFExerciseWriteController *speak = [[XDFExerciseWriteController alloc]init];
                            speak.dataDic = dataDic;
                            speak.testType = path;
                            speak.isChack = NO;
                            speak.st_ID = st_id;
                            speak.controlType = ControlTypeHome;
                            [self.viewController.parentViewController.parentViewController.navigationController pushViewController:speak animated:YES];
                        }else
                        {
                            //进入评分页面
                            XDFGetScoreViewController *getScore = [[XDFGetScoreViewController alloc]init];
                            getScore.dataDic = dataDic;
                            getScore.testType = path;
                            getScore.st_Id = st_id;
                            getScore.dayType = DayOrTypeHome;
                            [self.viewController.parentViewController.parentViewController.navigationController pushViewController:getScore animated:YES];                    }
                        
                    }else if(kStringEqual(path, @"词汇"))
                    {
                        if (!isMark) {
                            NSString *domainPFolder = [dataDic objectForKey:@"domainPFolder"];
                            NSString * lastPath = [domainPFolder lastPathComponent];
                            if ([lastPath isEqualToString:@"null"]) {
                                [[RusultManage shareRusultManage]tipAlert:@"试卷获取失败,请于管理员联系"];
                                return;
                            }
                            
                            //2050420
                            if (!st_idStatus) {
                                [[RusultManage shareRusultManage]tellServerTaskSTID:st_id];
                            }


                            XDFExerciseVacabulaerController *speak = [[XDFExerciseVacabulaerController alloc]init];
                            speak.dataDic = dataDic;
                            speak.testType = path;
                            speak.isChack = NO;
                            speak.st_ID = st_id;
                            speak.controlType = ControlTypeHome;
                            [self.viewController.parentViewController.parentViewController.navigationController pushViewController:speak animated:YES];
                        }else
                        {
                            //进入评分页面
                            XDFGetScoreViewController *getScore = [[XDFGetScoreViewController alloc]init];
                            getScore.dataDic = dataDic;
                            getScore.testType = path;
                            getScore.st_Id = st_id;
                            getScore.dayType = DayOrTypeHome;
                            [self.viewController.parentViewController.parentViewController.navigationController pushViewController:getScore animated:YES];
                        }
                    }else if(kStringEqual(path, @"语法"))
                    {
                        if (!isMark) {
                            NSString *domainPFolder = [dataDic objectForKey:@"domainPFolder"];
                            NSString * lastPath = [domainPFolder lastPathComponent];
                            if ([lastPath isEqualToString:@"null"]) {
                                [[RusultManage shareRusultManage]tipAlert:@"试卷获取失败,请于管理员联系"];
                                return;
                            }
                            
                            //2050420
                            if (!st_idStatus) {
                                [[RusultManage shareRusultManage]tellServerTaskSTID:st_id];
                            }

                            

                            XDFExerciseGrammarViewController *speak = [[XDFExerciseGrammarViewController alloc]init];
                            speak.dataDic = dataDic;
                            speak.testType = path;
                            speak.isChack = NO;
                            speak.st_ID = st_id;
                            speak.controlType = ControlTypeHome;
                            [self.viewController.parentViewController.parentViewController.navigationController pushViewController:speak animated:YES];
                        }else
                        {
                            //进入评分页面
                            XDFGetScoreViewController *getScore = [[XDFGetScoreViewController alloc]init];
                            getScore.dataDic = dataDic;
                            getScore.testType = path;
                            getScore.st_Id = st_id;
                            getScore.dayType = DayOrTypeHome;
                            [self.viewController.parentViewController.parentViewController.navigationController pushViewController:getScore animated:YES];
                        }
                    }else if(kStringEqual(path, @"综合"))
                    {
                        if (!isMark) {
                            NSString *domainPFolder = [dataDic objectForKey:@"domainPFolder"];
                            NSString * lastPath = [domainPFolder lastPathComponent];
                            if ([lastPath isEqualToString:@"null"]) {
                                [[RusultManage shareRusultManage]tipAlert:@"试卷获取失败,请于管理员联系"];
                                return;
                            }
                            
                            //2050420
                            if (!st_idStatus) {
                                [[RusultManage shareRusultManage]tellServerTaskSTID:st_id];
                            }

                            
                            XDFExerciseSyntheticViewController *speak = [[XDFExerciseSyntheticViewController alloc]init];
                            speak.dataDic = dataDic;
                            speak.testType = path;
                            speak.isChack = NO;
                            speak.st_ID = st_id;
                            speak.controlType = ControlTypeHome;
                            [self.viewController.parentViewController.parentViewController.navigationController pushViewController:speak animated:YES];
                        }else
                        {
                            //进入评分页面
                            XDFGetScoreViewController *getScore = [[XDFGetScoreViewController alloc]init];
                            getScore.dataDic = dataDic;
                            getScore.testType = path;
                            getScore.st_Id = st_id;
                            getScore.dayType = DayOrTypeHome;
                            [self.viewController.parentViewController.parentViewController.navigationController pushViewController:getScore animated:YES];
                        }
                    }
                }
            }else if([name isEqualToString:@"模考"])
            {
                
                NSString *pid = [[dataDic objectForKey:@"P_ID"] stringValue];
                NSString *taskType = [[dataDic objectForKey:@"TaskType"]stringValue];
                //判断是否完成
                NSString *finishPID = [NSString stringWithFormat:@"%@finish",pid];
                if (![kUserDefaults boolForKey:finishPID]) { //未完成
                    NSString *zipFloderPath = [[DownLoadManage ShardedDownLoadManage]useIDSelect:pid];  //文件夹
                    if (zipFloderPath.length > 0) {
                        
                        //2050420
//                        [self _dataNotifiServer:stid];
                        if (!st_idStatus) {
                            [[RusultManage shareRusultManage]tellServerTaskSTID:st_id];
                        }
                        
                        XDFExaminaTestHome *testController = [[XDFExaminaTestHome alloc]init];
                        testController.view.frame = CGRectMake(0, 20, kScreenWidth, kScreenHeight);
                        testController.pId = pid;  //试卷id
                        testController.stId = st_id;
                        testController.taskType = taskType;
                        testController.testTitles =  [dataDic objectForKey:@"Name"];
                        [self.viewController.parentViewController.parentViewController.navigationController pushViewController:testController animated:NO];
                    }else
                    {
                        [[RusultManage shareRusultManage]tipAlert:@"正在下载模考试卷,请稍后再试!" viewController:self.viewController];
                        return;
                    }
                  
                }else //完成
                {
                    XDFResultViewController *result = [[XDFResultViewController alloc]init];
//                    result.isMKRuset = YES;
                    result.dataDic = dataDic;
                    [self.viewController.parentViewController.parentViewController.navigationController pushViewController:result animated:YES];
                }
            }

        }
}

@end
