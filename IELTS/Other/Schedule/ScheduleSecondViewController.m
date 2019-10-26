//
//  ScheduleSecondViewController.m
//  IELTS
//
//  Created by 李牛顿 on 14-11-14.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import "ScheduleSecondViewController.h"
#import "XDFCCAndGouKuaiViewController.h"

#import "SACalendar.h"
#import "DateUtil.h"

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

#import "ScheduleViewController.h"


#define kScheduleLeftViewWidth 613

@interface ScheduleSecondViewController ()<UITableViewDataSource,UITableViewDelegate,SACalendarDelegate>

@property (nonatomic,strong) UILabel *dateLabel;   //右侧列表日期
@property (nonatomic,strong) UILabel  *weekLabel ;  //右侧星期
@property (nonatomic,strong) UILabel *monthAndYearLabel; //日历头部日期


@property (nonatomic,strong)UIView *leftViews;        //左边视图
@property (nonatomic,strong)UIView *rightViews;       //右边视图
@property (nonatomic,strong)UITableView *taskTabelView;  //列表
//@property (nonatomic,strong)NSArray *taskData;  //列表
@property (nonatomic,strong)UIView *topView;//表的头部视图
@property (nonatomic,strong)UIView *topButtonView;//表的头部视图

@property (nonatomic,strong)SACalendar *calendar_;

@property (nonatomic,strong)NSArray *calendarArray; //日历数据
@property (nonatomic,strong)NSMutableArray *dayArry;//有数据的天数数组
@property (nonatomic,strong)NSMutableArray *dataDic;  //列表数据

@property (nonatomic,strong)NSArray *resMaArry;
@property (nonatomic,strong)NSArray *resLXArray;
@property (nonatomic,strong)NSArray *resMKArray;
@property (nonatomic,strong)ScheduleViewController *scheduleCtr;

@property (nonatomic,strong)NSString *cureDateTime;

@property (nonatomic,assign)BOOL hasNetWork;

@end

@implementation ScheduleSecondViewController

@synthesize leftViews,rightViews;
@synthesize topView;
@synthesize topButtonView;
@synthesize dateLabel,weekLabel,monthAndYearLabel;
@synthesize calendar_;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.hasNetWork = NO;
//    _taskData = [[NSArray alloc]init];
    
    //    self.dicData
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNoNewtWork_ object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(curentNoNetWork) name:kNoNewtWork_ object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kHasNewtWork_ object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(curentHasNetWork) name:kHasNewtWork_ object:nil];
    [self _initLeftView];
    [self _initRightView];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];;
}

- (void)curentNoNetWork
{
    self.hasNetWork = NO;
}
- (void)curentHasNetWork
{
    self.hasNetWork = YES;
}


#pragma mark -
#pragma mark - 左侧日历
- (void)_initLeftView
{
    leftViews = [ZCControl viewWithFrame:CGRectMake(12, 0, kScheduleLeftViewWidth, kScreenHeight)];
    leftViews.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:leftViews];

    
    //日历头部视图
    //1.日期
    UIView *calenDarTopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScheduleLeftViewWidth, 60)];
    calenDarTopView.backgroundColor = TABBAR_BACKGROUNDLight;
    
    monthAndYearLabel = [ZCControl createLabelWithFrame:CGRectMake((kScheduleLeftViewWidth-200)/2, 0, 200, 40) Font:20.0f Text:@""];
    monthAndYearLabel.textAlignment = NSTextAlignmentCenter;
    monthAndYearLabel.textColor = [UIColor whiteColor];
    monthAndYearLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    
    [calenDarTopView addSubview:monthAndYearLabel];
    [leftViews addSubview:calenDarTopView];
    
    //2.星期
    NSArray *arrayData = @[@"MON",@"TUE",@"WED",@"THU",@"FRI",@"SAT",@"SUN"];
    for (int i=0; i<arrayData.count; i++) {
        NSString *week  = arrayData[i];
        UILabel *weeks = [ZCControl createLabelWithFrame:CGRectMake(i*(kScheduleLeftViewWidth-6)/7, 30, (kScheduleLeftViewWidth-6)/7, 30) Font:15.0f Text:week];
        weeks.textColor = [UIColor whiteColor];
        weeks.textAlignment = NSTextAlignmentCenter;
        [calenDarTopView addSubview:weeks];
    }
    
    //日历视图
    calendar_ = [[SACalendar alloc]initWithFrame:CGRectMake(0, 60, kScheduleLeftViewWidth, kScreenHeight-60)
                                 scrollDirection:ScrollDirectionVertical
                                   pagingEnabled:YES];
    
    
    
    calendar_.delegate = self;
    calendar_.calendarType = CalendarCellTypeTask;
    calendar_.backgroundColor = [UIColor clearColor];
    [leftViews addSubview:calendar_];
    

}
- (NSInteger)identifyMonth:(NSString *)moth
{
    NSArray *months2 = @[@"一月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"十二月"];
    NSArray *months = @[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月"];
    if ([months containsObject:moth]) {
        NSInteger index = [months indexOfObject:moth];
        return index;
    }
    if ([months2 containsObject:moth]) {
        NSInteger index = [months2 indexOfObject:moth];
        return index;
    }
    return 13;
}

- (NSInteger)identifyWeek:(NSString *)moth
{
    NSArray *months = @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"];
    if ([months containsObject:moth]) {
        NSInteger index = [months indexOfObject:moth];
        return index;
    }
    return 8;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (calendar_ != nil) {
        if (self.cureDateTime.length > 0) {
            [self  _reaquestCurrentData:self.cureDateTime];
        }
    }
}

#pragma mark - SACalendarDelegate
//
//+(NSString*)getCurrentDate:(NSDate *)date
//{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    [formatter setCalendar:gregorianCalendar];
//    [formatter setDateFormat:@"dd"];
//    return [formatter stringFromDate:[NSDate date]];
//}
/**
 *  Delegate method : get called when a date is selected
 */
-(void) SACalendar:(SACalendar*)calendar didSelectDate:(int)day month:(int)month year:(int)year
{
    //    NSLog(@"Date Selected : %02i/%02i/%04i",day,month,year);
    NSString *stringDate = [NSString stringWithFormat:@"%04i-%02i-%02i",year,month,day];
    NSDate *datestring = [self _dealDate:stringDate];
    NSString *months = [ZCControl stringFromDate:datestring formate:@"MMM"];
    NSString *days = [ZCControl stringFromDate:datestring formate:@"dd"];
    NSString *years = [ZCControl stringFromDate:datestring formate:@"yyyy"];
    NSInteger index = [self identifyMonth:months];
    if (index == 13) {
        dateLabel.text = [NSString stringWithFormat:@"%@ %@, %@",months,days,years];
    }else
    {
        NSString *mth = [DateUtil get2MonthString:index];
        dateLabel.text = [NSString stringWithFormat:@"%@ %@, %@",mth,days,years];
    }
    NSString *week = [ZCControl stringFromDate:datestring formate:@"EEEE"];
    NSInteger windex = [self identifyWeek:week];
    if (windex == 8) {
        weekLabel.text = week;
    }else
    {
        weekLabel.text = [DateUtil get2DayString:windex];
    }

    //选择每一天的请求数据
    if (_calendarArray.count>0) {
        if ([_dayArry containsObject:stringDate]) {
            NSUInteger index =  [_dayArry indexOfObject:stringDate];
            NSDictionary *dic = _calendarArray[index];
            NSDictionary *dayDic = [dic objectForKey:stringDate];
//            NSArray *dayArry = [dayDic objectForKey:@"lessons"];
            
            NSDictionary *resMaterial = [dayDic objectForKey:@"ResMaterial"];
            NSDictionary *resPaperLx = [dayDic objectForKey:@"ResPaperLx"];
            NSDictionary *resPaperMk = [dayDic objectForKey:@"ResPaperMk"];
            
            
            
            if (_dataDic != nil) {
                _dataDic = nil;
            }
            _dataDic = [[NSMutableArray alloc]init];
            
            _resLXArray = [[NSArray alloc]init];
            _resMaArry = [[NSArray alloc]init];
            _resMKArray = [[NSArray alloc]init];
            
            
            NSMutableArray *dataArray = [[NSMutableArray alloc]init];
             int i = 0;
            if (resMaterial.count > 0) {
                i = i+1;
                NSArray *resMaArry = [resMaterial objectForKey:@"info"];
                self.resMaArry = resMaArry;
                NSDictionary *dic1 = @{@"name":@"学习",
                                       @"list":resMaArry};
                [_dataDic addObject:dic1];
                [dataArray addObjectsFromArray:resMaArry];
            }
            if (resPaperLx.count > 0 ) {
                i = i+1;
                 NSArray *resLXArray = [resPaperLx objectForKey:@"info"];
                self.resLXArray = resLXArray;
                NSDictionary *dic1 = @{@"name":@"练习",
                                       @"list":resLXArray};
                [_dataDic addObject:dic1];
                [dataArray addObjectsFromArray:resLXArray];
            }
            if (resPaperMk.count > 0) {
                i = i+1;
                NSArray *resMKArray = [resPaperMk objectForKey:@"info"];
                self.resMKArray = resMKArray;
                NSDictionary *dic1 = @{@"name":@"模考",
                                       @"list":resMKArray};
                [_dataDic addObject:dic1];
                [dataArray addObjectsFromArray:resMKArray];
            }
            
//            _taskData = array;
            CGFloat h = dataArray.count*60 + 30*i;
            if (h > kScreenHeight-60) {
                h = kScreenHeight-60;
            }
            self.taskTabelView.height = h;
            //刷新数据
            [self.taskTabelView reloadData];
        }else
        {
            _dataDic = 0;
            self.taskTabelView.height = 0;
            [self.taskTabelView reloadData];
        }
    }else
    {
        _dataDic = 0;
        self.taskTabelView.height = 0;
        [self.taskTabelView reloadData];
    }

}

/**
 *  Delegate method : get called user has scroll to a new month
 */
-(void) SACalendar:(SACalendar *)calendar didDisplayCalendarForMonth:(int)month year:(int)year{
    //    NSLog(@"Displaying : %@ %04i",[DateUtil getMonthString:month],year);
    monthAndYearLabel.text = [NSString stringWithFormat:@"%@ %04i",[DateUtil getMonthString:month],year];
    
    NSString *dateString = [NSString stringWithFormat:@"%04i-%02i-01",year,month];
    self.cureDateTime = dateString;
    [self _reaquestCurrentData:dateString];
    //
}

- (NSDate *)_dealDate:(NSString *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *datestring = [dateFormatter dateFromString:date];
    return datestring;
}

- (void)_reaquestCurrentData:(NSString *)dateString
{
    if (dateString.length > 0) {
        
        [[RusultManage shareRusultManage]scheduleTaskRusult:dateString
                                             viewController:nil
                                                successData:^(NSDictionary *result){
                                                    NSArray *dataArray = [result objectForKey:@"Data"];
                                                    
                                                    _calendarArray = dataArray;
                                                    [self _dealCalendarData];
                                                    calendar_.evenData = dataArray;
                                                }];
    }
}

//处理日历数据
- (void)_dealCalendarData
{
    _dayArry = [[NSMutableArray alloc]initWithCapacity:_calendarArray.count];
    for (NSDictionary *dic in _calendarArray) {
        NSString *day = [[dic allKeys]firstObject];
        [_dayArry addObject:day];
    }
}



#pragma mark -
#pragma mark - 日历具体内容显示
- (void)_initRightView
{
    rightViews = [ZCControl viewWithFrame:CGRectMake(12+leftViews.right, 0, kScreenWidth-kScheduleLeftViewWidth-DEFAULT_TAB_BAR_HEIGHT-20, kScreenHeight)];
    rightViews.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:rightViews];
    
#pragma mark - 顶部
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, rightViews.width, 70)];
    topView.backgroundColor = [UIColor whiteColor];
    
//    int month =[[DateUtil getCurrentMonth] integerValue];
//    int day = [[DateUtil getCurrentDay] integerValue];
//    NSString *weekdays =  [DateUtil get2DayString:day];
//    NSString *months =  [DateUtil get2MonthString:month];
//    NSString *dateString = [NSString stringWithFormat:@"%@ %d",months,day];
    
    dateLabel = [ZCControl createLabelWithFrame:CGRectMake(10, 10, 150, 35)
                                                     Font:20.0f
                                                     Text:@""];
    dateLabel.textColor = [UIColor redColor];
    dateLabel.font = [UIFont boldSystemFontOfSize:20.f];
    [topView addSubview:dateLabel];
    
    weekLabel = [ZCControl createLabelWithFrame:CGRectMake(10, dateLabel.bottom-10, leftViews.width-100, 35)
                                                     Font:16.0f
                                                     Text:@""];
    [topView addSubview:weekLabel];
    
    UIButton *taskButton2 =[ZCControl createButtonWithFrame:CGRectMake(dateLabel.right+10, (topView.height-35)/2, 80, 35)
                                                  ImageName:@""
                                                     Target:self
                                                     Action:@selector(buttonAction:)
                                                      Title:@"查看课表"];
    [taskButton2 setBackgroundImage:[UIImage imageNamed:@"btn1_blank.png"] forState:UIControlStateNormal];
    [taskButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    taskButton2.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [topView addSubview:taskButton2];
    
    UILabel *line1 = [ZCControl createLabelLineFrame:CGRectMake(0, weekLabel.bottom, rightViews.width, 0.5)];
    [topView addSubview:line1];
    
    [rightViews addSubview:topView];
    
    
    _taskTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, topView.bottom+1, rightViews.width, 0) style:UITableViewStylePlain];
    _taskTabelView.delegate = self;
    _taskTabelView.dataSource = self;
    _taskTabelView.bounces = NO;
    _taskTabelView.rowHeight = 60;
    [rightViews addSubview:_taskTabelView];
}

- (void)buttonAction:(UIButton *)button
{
    _scheduleCtr= [[ScheduleViewController alloc]init];
    [self.navigationController pushViewController:_scheduleCtr animated:YES];
}

#pragma mark - UITableViewDataSource
#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.resMKArray.count > 0 && self.resMaArry.count> 0   && self.resLXArray.count > 0) {
        return 3;
    }else if (self.resMKArray.count == 0 && self.resMaArry.count == 0 && self.resLXArray.count == 0)
    {
        return 0;
    }else if ((self.resMKArray.count == 0 && self.resMaArry.count == 0) ||
              (self.resMKArray.count == 0 && self.resLXArray.count == 0) ||
              (self.resMaArry.count == 0 && self.resLXArray.count == 0))
    {
        return 1;
        
    }else if ((self.resMKArray.count>0 && self.resMaArry.count>0) ||
              (self.resMKArray.count >0 && self.resLXArray.count>0) ||
              (self.resMaArry.count>0 && self.resLXArray.count>0))
    {
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataDic.count > 0 && section < _dataDic.count) {
        return [[[_dataDic objectAtIndex:section]objectForKey:@"list"] count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"taskIdentify";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
        cell.imageView.frame = CGRectMake(0, 0, 40, 40);
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, (62-45)/2, 45, 45)];
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 45, 45)];
        [view addSubview:imgView];
        imgView.tag = 10;
        [cell.contentView addSubview:view];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(55+10, (62-30)/2, 200, 30)];
        titleLabel.tag = 11;
        [cell.contentView addSubview:titleLabel];
        
    }
    UIImageView *imagView = (UIImageView *)[cell.contentView viewWithTag:10];
    UILabel *titleLabe = (UILabel *)[cell.contentView viewWithTag:11];
    
    if (_dataDic.count > 0) {
        NSArray *listArray =[[_dataDic objectAtIndex:indexPath.section] objectForKey:@"list"];
        NSString *name = [[_dataDic objectAtIndex:indexPath.section]objectForKey:@"name"];
        NSDictionary *refData = listArray[indexPath.row];
        
        NSString *textName = [refData objectForKey:@"Name"];
        titleLabe.text = textName;

        //完成状态
        NSString *p_id = [[refData objectForKey:@"P_ID"] stringValue];
        NSString *finishPID = [NSString stringWithFormat:@"%@finish",p_id];

        if ([[refData objectForKey:@"TF_ID"] isKindOfClass:[NSNull class]]) {
            titleLabe.textColor = [UIColor darkGrayColor];
            [kUserDefaults setBool:NO forKey:finishPID];
            [kUserDefaults synchronize];

        }else
        {
            titleLabe.textColor = [UIColor lightGrayColor];
            [kUserDefaults setBool:YES forKey:finishPID];
            [kUserDefaults synchronize];

        }
        //    //图标
        if (kStringEqual(name, @"学习")) {
            if (![[listArray[indexPath.row] objectForKey:@"StorePoint"] isKindOfClass:[NSNull class]] && listArray.count > 0) {
                NSString *storePoint = [[refData objectForKey:@"StorePoint"] stringValue];
                if (kStringEqual(storePoint, @"1")) {
                    NSString *fileType = [refData objectForKey:@"FileType"];
                    if ([fileType isEqualToString:@"docx"] || [fileType isEqualToString:@"doc"]) {
                        imagView.image = [UIImage imageNamed:@"icon_world.png"];
                    }else if ([fileType isEqualToString:@"ppt"] || [fileType isEqualToString:@"pptx"])
                    {
                        imagView.image = [UIImage imageNamed:@"icon_ppt.png"];
                    }else if ([fileType isEqualToString:@"pdf"])
                    {
                        imagView.image = [UIImage imageNamed:@"icon_pdf.png"];
                    }else if ([fileType isEqualToString:@"xlsx"] || [fileType isEqualToString:@"xls"])
                    {
                        imagView.image = [UIImage imageNamed:@"icon_excel.png"];
                    }
                }else if (kStringEqual(storePoint, @"2"))
                {
                    imagView.image = [UIImage imageNamed:@"icon_video.png"];
                }
                }
        }else if (kStringEqual(name, @"练习"))
        {
            NSString *lcName =  [refData objectForKey:@"lcName"];
            NSString *imageName = [ZCControl imgTypeCatagory:lcName];
            imagView.image = [UIImage imageNamed:imageName];
            
        }else if (kStringEqual(name, @"模考"))
        {
            imagView.image = [UIImage imageNamed:@"120_ExainaView.png"];
        }
       }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *name = [[_dataDic objectAtIndex:indexPath.section]objectForKey:@"name"];
    NSArray *listArray =[[_dataDic objectAtIndex:indexPath.section] objectForKey:@"list"];
    if(listArray.count > 0 ) {
        NSDictionary *dataDic = listArray[indexPath.row];
        
        NSString *p_id = [[dataDic objectForKey:@"P_ID"]stringValue];
        NSString *st_id = [[dataDic objectForKey:@"ST_ID"]stringValue];
        BOOL  st_idStatus = [[dataDic objectForKey:@"Status"] boolValue];
        
        NSString *status = [NSString stringWithFormat:@"%@finish",p_id];
        BOOL isMark = [kUserDefaults boolForKey:status];
        
        if (!self.hasNetWork) {
            [self.parentViewController.parentViewController.view makeToast:@"当前网络不可用,请检测网络!" duration:2.0 position:@"bottom"];
            return;
        }
        if ([name isEqualToString:@"学习"]) {
            if (![[dataDic objectForKey:@"Url"] isKindOfClass:[NSNull class]]) {
                NSString *url = [dataDic objectForKey:@"Url"];
                if (url.length > 0) {
                    
                    if (!st_idStatus) {
                        [[RusultManage shareRusultManage]tellServerTaskSTID:st_id];
                    }
                    
                    XDFCCAndGouKuaiViewController *ccandGoukuai = [[XDFCCAndGouKuaiViewController alloc]init];
                    ccandGoukuai.urlPath = url;
                    ccandGoukuai.listData = listArray;
                    ccandGoukuai.indexPathRow = indexPath.row;
                    ccandGoukuai.taskType = WhereTaskTypeSchedul;
                    [self.parentViewController.parentViewController.navigationController pushViewController:ccandGoukuai animated:YES];
                }
            }
        }else if([name isEqualToString:@"练习"])
        {
            if (![[dataDic objectForKey:@"lcName"] isKindOfClass:[NSNull class]]) {
                NSString *path =  [dataDic objectForKey:@"lcName"];
                if (kStringEqual(path, @"听力")) {
                    if (!isMark) {
                        NSString *domainPFolder = [dataDic objectForKey:@"domainPFolder"];
                        NSString * lastPath = [domainPFolder lastPathComponent];
                        if ([lastPath isEqualToString:@"null"]) {
                            [[RusultManage shareRusultManage]tipAlert:@"试卷获取失败,请于管理员联系"viewController:self];
                            return;
                        }
                        
                        if (!st_idStatus) {
                            [[RusultManage shareRusultManage]tellServerTaskSTID:st_id];
                        }

                        XDFExerciseListentController *exListent = [[XDFExerciseListentController alloc]init];
                        exListent.dataDic = dataDic;
                        exListent.testType = path;
                        exListent.isChack = NO;
                        [self.parentViewController.parentViewController.navigationController pushViewController:exListent animated:YES];
                    }else
                    {
                        //进入评分页面
                        XDFGetScoreViewController *getScore = [[XDFGetScoreViewController alloc]init];
                        getScore.dataDic = dataDic;
                        getScore.testType = path;
                        getScore.dayType = DayOrTypeSchedule;
                        [self.parentViewController.parentViewController.navigationController pushViewController:getScore animated:YES];
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
                        
                        if (!st_idStatus) {
                            [[RusultManage shareRusultManage]tellServerTaskSTID:st_id];
                        }

                        
                        XDFExerciseReadController *speak = [[XDFExerciseReadController alloc]init];
                        speak.dataDic = dataDic;
                        speak.testType = path;
                        speak.isChack = NO;
                        [self.parentViewController.parentViewController.navigationController pushViewController:speak animated:YES];
                    }else
                    {
                        //进入评分页面
                        XDFGetScoreViewController *getScore = [[XDFGetScoreViewController alloc]init];
                        getScore.dataDic = dataDic;
                        getScore.testType = path;
                        getScore.dayType = DayOrTypeSchedule;
                        [self.parentViewController.parentViewController.navigationController pushViewController:getScore animated:YES];
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
                        
                        if (!st_idStatus) {
                            [[RusultManage shareRusultManage]tellServerTaskSTID:st_id];
                        }

                        
                        XDFExerciseSpeakController *speak = [[XDFExerciseSpeakController alloc]init];
                        speak.dataDic = dataDic;
                        speak.testType = path;
                        speak.isChack = NO;
                        [self.parentViewController.parentViewController.navigationController pushViewController:speak animated:YES];
                    }else
                    {
                        //进入评分页面
                        XDFGetScoreViewController *getScore = [[XDFGetScoreViewController alloc]init];
                        getScore.dataDic = dataDic;
                        getScore.testType = path;
                        getScore.dayType = DayOrTypeSchedule;
                        [self.parentViewController.parentViewController.navigationController pushViewController:getScore animated:YES];
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
                        if (!st_idStatus) {
                            [[RusultManage shareRusultManage]tellServerTaskSTID:st_id];
                        }

                        
                        XDFExerciseWriteController *speak = [[XDFExerciseWriteController alloc]init];
                        speak.dataDic = dataDic;
                        speak.testType = path;
                        speak.isChack = NO;
                        [self.parentViewController.parentViewController.navigationController pushViewController:speak animated:YES];
                    }else
                    {
                        //进入评分页面
                        XDFGetScoreViewController *getScore = [[XDFGetScoreViewController alloc]init];
                        getScore.dataDic = dataDic;
                        getScore.testType = path;
                        getScore.dayType = DayOrTypeSchedule;
                        [self.parentViewController.parentViewController.navigationController pushViewController:getScore animated:YES];
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

                        if (!st_idStatus) {
                            [[RusultManage shareRusultManage]tellServerTaskSTID:st_id];
                        }

                        XDFExerciseVacabulaerController *speak = [[XDFExerciseVacabulaerController alloc]init];
                        speak.dataDic = dataDic;
                        speak.testType = path;
                        speak.isChack = NO;
                        [self.parentViewController.parentViewController.navigationController pushViewController:speak animated:YES];
                    }else
                    {
                        //进入评分页面
                        XDFGetScoreViewController *getScore = [[XDFGetScoreViewController alloc]init];
                        getScore.dataDic = dataDic;
                        getScore.testType = path;
                        getScore.dayType = DayOrTypeSchedule;
                        [self.parentViewController.parentViewController.navigationController pushViewController:getScore animated:YES];
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
                        
                        if (!st_idStatus) {
                            [[RusultManage shareRusultManage]tellServerTaskSTID:st_id];
                        }


                        XDFExerciseGrammarViewController *speak = [[XDFExerciseGrammarViewController alloc]init];
                        speak.dataDic = dataDic;
                        speak.testType = path;
                        speak.isChack = NO;
                        [self.parentViewController.parentViewController.navigationController pushViewController:speak animated:YES];
                    }else
                    {
                        //进入评分页面
                        XDFGetScoreViewController *getScore = [[XDFGetScoreViewController alloc]init];
                        getScore.dataDic = dataDic;
                        getScore.testType = path;
                        getScore.dayType = DayOrTypeSchedule;
                        [self.parentViewController.parentViewController.navigationController pushViewController:getScore animated:YES];
                    }
                }else if(kStringEqual(path, @"综合"))
                {
                    if (!isMark) {
                        NSString *domainPFolder = [dataDic objectForKey:@"domainPFolder"];
                        NSString * lastPath = [domainPFolder lastPathComponent];
                        if ([lastPath isEqualToString:@"null"]) {
                            [[RusultManage shareRusultManage]tipAlert:@"试卷获取失败,请于管理员联系"viewController:self];
                            return;
                        }
                        
                        //20150420
                        if (!st_idStatus) {
                            [[RusultManage shareRusultManage]tellServerTaskSTID:st_id];
                        }


                        XDFExerciseSyntheticViewController *speak = [[XDFExerciseSyntheticViewController alloc]init];
                        speak.dataDic = dataDic;
                        speak.testType = path;
                        speak.isChack = NO;
                        [self.parentViewController.parentViewController.navigationController pushViewController:speak animated:YES];
                    }else
                    {
                        //进入评分页面
                        XDFGetScoreViewController *getScore = [[XDFGetScoreViewController alloc]init];
                        getScore.dataDic = dataDic;
                        getScore.testType = path;
                        getScore.dayType = DayOrTypeSchedule;
                        [self.parentViewController.parentViewController.navigationController pushViewController:getScore animated:YES];
                    }
                }
            }
        }else if([name isEqualToString:@"模考"])
        {
            
//            NSString *pid = [[dataDic objectForKey:@"P_ID"] stringValue];
//            NSString *stid = [[dataDic objectForKey:@"ST_ID"] stringValue];
            NSString *taskType =[[dataDic objectForKey:@"TaskType"]stringValue];
            //判断是否完成
            NSString *finishPID = [NSString stringWithFormat:@"%@finish",p_id];
            if (![kUserDefaults boolForKey:finishPID]) { //未完成
                NSString *zipFloderPath = [[DownLoadManage ShardedDownLoadManage]useIDSelect:p_id];  //文件夹
                if (zipFloderPath.length > 0) {
                    
                    //20150420
//                    [self _dataNotifiServer:stid];
                    if (!st_idStatus) {
                        [[RusultManage shareRusultManage]tellServerTaskSTID:st_id];
                    }

                    
                    XDFExaminaTestHome *testController = [[XDFExaminaTestHome alloc]init];
                    testController.view.frame = CGRectMake(0, 20, kScreenWidth, kScreenHeight);
                    testController.pId = p_id;  //试卷id
                    testController.stId = st_id;
                    testController.taskType = taskType;
                    testController.testTitles =  [dataDic objectForKey:@"Name"];
                    [self.parentViewController.parentViewController.navigationController pushViewController:testController animated:NO];
                }else
                {
                    [[RusultManage shareRusultManage]tipAlert:@"正在下载模考试卷,请稍后再试!" viewController:self];
                    return;
                }
            }else //完成
            {
                XDFResultViewController *result = [[XDFResultViewController alloc]init];
                result.dataDic = dataDic;
                [self.parentViewController.parentViewController.navigationController pushViewController:result animated:YES];
            }
        }
    }
}


- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    view.backgroundColor = rgb(249, 250, 251, 1);
    
    if (_dataDic.count > 0) {
        UILabel *label = [ZCControl createLabelWithFrame:CGRectMake(20, 0, tableView.frame.size.width, 30) Font:15.0f Text:[[_dataDic objectAtIndex:section]objectForKey:@"name"]];
        [view addSubview:label];
        label.textColor = rgb(79, 88, 122, 1);

    }
    return view;
}


@end
