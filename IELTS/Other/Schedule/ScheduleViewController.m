//
//  ScheduleViewController.m
//  IELTS
//
//  Created by 李牛顿 on 14-11-12.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import "ScheduleViewController.h"
#import "XDFScheduleTableViewCell.h"

#import "SACalendar.h"
#import "DateUtil.h"

//日历1226   课表 560
#define kScheduleLeftViewWidth 613
#define kScheduleRowHeigh  160
@interface ScheduleViewController ()<UITableViewDataSource,UITableViewDelegate,SACalendarDelegate>

@property (nonatomic,strong) UILabel *dateLabel;   //右侧列表日期
@property (nonatomic,strong) UILabel  *weekLabel ;  //右侧星期
@property (nonatomic,strong) UILabel *monthAndYearLabel; //日历头部日期


@property (nonatomic,strong)UIView *leftViews;        //左边视图
@property (nonatomic,strong)UIView *rightViews;       //右边视图
@property (nonatomic,strong)UITableView *taskTabelView;  //列表
@property (nonatomic,strong)NSDictionary *taskData;  //列表数据
@property (nonatomic,strong)UIView *topView;//表的头部视图
@property (nonatomic,strong)UIView *topButtonView;//表的头部视图


@property (nonatomic,strong)SACalendar *calendar_;

@property (nonatomic,strong)NSArray *calendarArray; //日历数据
@property (nonatomic,strong)NSMutableArray *dayArry;//有数据的天数数组



@end

@implementation ScheduleViewController

@synthesize leftViews,rightViews;
@synthesize topView;
@synthesize topButtonView;
@synthesize dateLabel,weekLabel,monthAndYearLabel;
@synthesize calendar_;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _taskData = [[NSDictionary alloc]init];
    _calendarArray = [[NSArray alloc]init];
    
    [self _initLeftView];
    [self _initRightView];
}

#pragma mark -
#pragma mark - 左侧日历
- (void)_initLeftView
{
    leftViews = [ZCControl viewWithFrame:CGRectMake(12, 0, kScheduleLeftViewWidth, kScreenHeight)];
    leftViews.backgroundColor = [UIColor whiteColor];
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
    calendar_.calendarType = CalendarCellTypeClass;
    calendar_.backgroundColor = [UIColor clearColor];
    [leftViews addSubview:calendar_];
    
    [self.view addSubview:leftViews];
    
}

- (NSInteger)identifyMonth:(NSString *)moth
{
    NSArray *months = @[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月"];
    if ([months containsObject:moth]) {
         NSInteger index = [months indexOfObject:moth];
        return index;
    }
    NSArray *months2 = @[@"一月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"十二月"];
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


#pragma mark - SACalendarDelegate
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
            NSArray *dayArry =  [dayDic objectForKey:@"lessons"];
            NSArray *lxsqs =    [dayDic objectForKey:@"lxsqs"]; //留学申请时间
            NSArray *ksaps =    [dayDic objectForKey:@"ksaps"]; //考试安排日期
            _taskData = dayDic;
            
            CGFloat h = (dayArry.count+lxsqs.count+ksaps.count)*kScheduleRowHeigh;
            if (h > kScreenHeight-60) {
                h = kScreenHeight-60;
            }
            self.taskTabelView.height = h;
            //刷新数据
            [self.taskTabelView reloadData];
        }else
        {
            _taskData = 0;
            self.taskTabelView.height = 0;
            [self.taskTabelView reloadData];
        }
    }else
    {
        _taskData = 0;
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
    [self _reaquestCurrentData:dateString];

}

- (void)dealloc
{
    NDLog(@"%@",self);
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
        [[RusultManage shareRusultManage]scheduleClassRusult:dateString
                                              viewController:nil
                                                 successData:^(NSDictionary *result) {
                                                     
                                                     NSArray *dataArray = [result objectForKey:@"Data"];
                                                     
                                                     _calendarArray = dataArray;
                                                     [self _dealCalendarData];
                                                     calendar_.evenData = dataArray;
//                                                     if (dataArray.count > 0) {
//                                                     }else
//                                                     {
//                                                         NDLog(@"当月没有提醒");
//                                                     }
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
    
    UIButton *taskButton =[ZCControl createButtonWithFrame:CGRectMake(dateLabel.right+10, (topView.height-35)/2, 80, 35)
                                                 ImageName:@""
                                                    Target:self
                                                    Action:@selector(buttonAction:)
                                                     Title:@"查看任务"];
    [taskButton setBackgroundImage:[UIImage imageNamed:@"btn1_blank.png"] forState:UIControlStateNormal];
    [taskButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    taskButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [topView addSubview:taskButton];
    
    UILabel *line1 = [ZCControl createLabelLineFrame:CGRectMake(0, weekLabel.bottom, rightViews.width, 1)];
    [topView addSubview:line1];
    [rightViews addSubview:topView];
    
    
    _taskTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, topView.bottom+1, rightViews.width, 0) style:UITableViewStylePlain];
    _taskTabelView.delegate = self;
    _taskTabelView.dataSource = self;
    _taskTabelView.bounces = NO;
    _taskTabelView.rowHeight = kScheduleRowHeigh;
    _taskTabelView.tableFooterView = [[UIView alloc]init];
    [rightViews addSubview:_taskTabelView];
}

- (void)buttonAction:(UIButton *)button
{    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *dayArry =  [_taskData objectForKey:@"lessons"];
    NSArray *lxsqs =    [_taskData objectForKey:@"lxsqs"]; //留学申请时间
    NSArray *ksaps =    [_taskData objectForKey:@"ksaps"]; //考试安排日期

    return dayArry.count+lxsqs.count+ksaps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"taskIdentify";
    XDFScheduleTableViewCell *cell = (XDFScheduleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XDFScheduleTableViewCell" owner:self options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *ksLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, (kScheduleRowHeigh-40)/2-25, 280, 40)];
//        UILabel *ksLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 280, 30)];
        ksLabel.font = [UIFont systemFontOfSize:16.0f];
        ksLabel.tag = 2013;
        ksLabel.hidden = YES;
        [cell.contentView addSubview:ksLabel];
        
        UILabel *ksTime = [[UILabel alloc]initWithFrame:CGRectMake(30, (kScheduleRowHeigh-40)/2+15, 280, 40)];
//        UILabel *ksTime = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 280, 30)];
        ksTime.tag = 2014;
        ksTime.font = [UIFont systemFontOfSize:16.0f];
        ksTime.hidden = YES;
//        ksTime.top = ksLabel.bottom + 10;
        [cell.contentView addSubview:ksTime];
    }
    UILabel *ksLabel = (UILabel *)[cell.contentView viewWithTag:2013];
    UILabel *ksTime = (UILabel *)[cell.contentView viewWithTag:2014];
    
    NSArray *dayArry =  [_taskData objectForKey:@"lessons"];
    NSArray *lxsqs =    [_taskData objectForKey:@"lxsqs"]; //留学申请时间
    NSArray *ksaps =    [_taskData objectForKey:@"ksaps"]; //考试安排日期
    if (dayArry.count > 0) {  //课表大于0
        if (lxsqs.count == 0 && ksaps.count == 0) {
            NSDictionary *dic = dayArry[indexPath.row];
            NSString *nameBclass = [dic objectForKey:@"sNameBc"];
            NSString *nLessonNo =  [[dic objectForKey:@"nLessonNo"] isKindOfClass:[NSNull class]] ? @"": [[dic objectForKey:@"nLessonNo"] stringValue];
            NSString *classTIl;
            if (nLessonNo.length > 0) {
                classTIl = [NSString stringWithFormat:@"%@   课次:%@",nameBclass,nLessonNo];
            }else
            {
                classTIl = [NSString stringWithFormat:@"%@ ",nameBclass];
            }
            
            cell.classTitle.text = classTIl;
            if (![[dic objectForKey:@"sAddress"] isKindOfClass:[NSNull class]] &&![[dic objectForKey:@"sNameBr"] isKindOfClass:[NSNull class]]  ) {
                NSString *addres = [dic objectForKey:@"sAddress"];
                NSString *addres2 = [dic objectForKey:@"sNameBr"];
                NSString *address = [NSString stringWithFormat:@"%@%@",addres,addres2];
                cell.classAddress.text = address;
            }
            NSString *time1 = [ZCControl changeCreatSeconTime:[dic objectForKey:@"SectBegin"]];
            NSString *time2 = [ZCControl changeCreatSeconTime:[dic objectForKey:@"SectEnd"]];
            cell.classTimes.text = [NSString stringWithFormat:@"%@-%@",time1,time2];
            cell.timeImg.hidden = NO;
            cell.addressImg.hidden = NO;
            ksLabel.hidden = YES;
            ksTime.hidden = YES;
            /*
             {"sCode":"YA10113",
             "SectEnd":1422687600000,
             "sNameBr":"海淀展春园校区404教室(旧)",
             "sNameBc":"IELTS6分全日制基础强化走读班YA10113",
             "SectBegin":1422678600000,
             "sAddress":"中关村西四环中路283号",
             "nLessonNo":64
             }
             */
        }else if(lxsqs.count > 0)  //留学考试大于零
        {
            if (ksaps.count > 0) {
                if (indexPath.row == 0) {
                    NSDictionary *dic = lxsqs[indexPath.row];
                    NSString *time = [dic objectForKey:@"DestDate"];
                    ksLabel.text =  [dic objectForKey:@"Name"];
                    ksTime.text = time;
                    ksLabel.hidden = NO;
                    ksTime.hidden = NO;
                    
                    cell.timeImg.hidden = YES;
                    cell.addressImg.hidden = YES;

                }else if(indexPath.row < ksaps.count+lxsqs.count)
                {
                    NSDictionary *dic = ksaps[indexPath.row-ksaps.count];
                    NSString *time = [dic objectForKey:@"DestDate"];
                    ksLabel.text =  [dic objectForKey:@"Name"];
                    ksTime.text = time;
                    ksLabel.hidden = NO;
                    ksTime.hidden = NO;
                    cell.timeImg.hidden = YES;
                    cell.addressImg.hidden = YES;
                }else{
                
                    NSDictionary *dic = dayArry[indexPath.row-ksaps.count-lxsqs.count];
                    NSString *nameBclass = [dic objectForKey:@"sNameBc"];
                    NSString *nLessonNo =  [[dic objectForKey:@"nLessonNo"] isKindOfClass:[NSNull class]] ? @"": [[dic objectForKey:@"nLessonNo"] stringValue];
                    NSString *classTIl;
                    if (nLessonNo.length > 0) {
                        classTIl = [NSString stringWithFormat:@"%@   课次:%@",nameBclass,nLessonNo];
                    }else
                    {
                        classTIl = [NSString stringWithFormat:@"%@ ",nameBclass];
                    }
                    
                    cell.classTitle.text = classTIl;
                    
                    if (![[dic objectForKey:@"sAddress"] isKindOfClass:[NSNull class]] &&
                        ![[dic objectForKey:@"sNameBr"] isKindOfClass:[NSNull class]]) {
                        
                        NSString *addres = [dic objectForKey:@"sAddress"];
                        NSString *addres2 = [dic objectForKey:@"sNameBr"];
                        NSString *address = [NSString stringWithFormat:@"%@%@",addres,addres2];
                        cell.classAddress.text = address;
                    }
                    
                    NSString *time1 = [ZCControl changeCreatSeconTime:[dic objectForKey:@"SectBegin"]];
                    NSString *time2 = [ZCControl changeCreatSeconTime:[dic objectForKey:@"SectEnd"]];
                    cell.classTimes.text = [NSString stringWithFormat:@"%@-%@",time1,time2];
                    cell.timeImg.hidden = NO;
                    cell.addressImg.hidden = NO;
                    ksLabel.hidden = YES;
                    ksTime.hidden = YES;

                }
            }else
            {
                if (indexPath.row == 0) {
                    NSDictionary *dic = lxsqs[indexPath.row];
                    NSString *time = [dic objectForKey:@"DestDate"];
                    ksLabel.text =  [dic objectForKey:@"Name"];
                    ksTime.text = time;
                    ksLabel.hidden = NO;
                    ksTime.hidden = NO;
                    cell.timeImg.hidden = YES;
                    cell.addressImg.hidden = YES;
                }else
                {
                    NSDictionary *dic = dayArry[indexPath.row-lxsqs.count];
                    NSString *nameBclass = [dic objectForKey:@"sNameBc"];
                    NSString *nLessonNo =  [[dic objectForKey:@"nLessonNo"] isKindOfClass:[NSNull class]] ? @"": [[dic objectForKey:@"nLessonNo"] stringValue];
                    NSString *classTIl;
                    if (nLessonNo.length > 0) {
                        classTIl = [NSString stringWithFormat:@"%@   课次:%@",nameBclass,nLessonNo];
                    }else
                    {
                        classTIl = [NSString stringWithFormat:@"%@ ",nameBclass];
                    }
                    
                    cell.classTitle.text = classTIl;
                    
                    if (![[dic objectForKey:@"sAddress"] isKindOfClass:[NSNull class]] &&
                        ![[dic objectForKey:@"sNameBr"] isKindOfClass:[NSNull class]]) {
                        
                        NSString *addres = [dic objectForKey:@"sAddress"];
                        NSString *addres2 = [dic objectForKey:@"sNameBr"];
                        NSString *address = [NSString stringWithFormat:@"%@%@",addres,addres2];
                        cell.classAddress.text = address;
                    }
                    
                    NSString *time1 = [ZCControl changeCreatSeconTime:[dic objectForKey:@"SectBegin"]];
                    NSString *time2 = [ZCControl changeCreatSeconTime:[dic objectForKey:@"SectEnd"]];
                    cell.classTimes.text = [NSString stringWithFormat:@"%@-%@",time1,time2];
                    cell.timeImg.hidden = NO;
                    cell.addressImg.hidden = NO;
                    ksLabel.hidden = YES;
                    ksTime.hidden = YES;
                }
            }
        }else if(ksaps.count > 0)
        {
            if (indexPath.row < ksaps.count) {
                NSDictionary *dic = ksaps[indexPath.row];
                NSString *time = [dic objectForKey:@"DestDate"];
                ksLabel.text =  [dic objectForKey:@"Name"];
                ksTime.text = time;
                ksLabel.hidden = NO;
                ksTime.hidden = NO;
                cell.timeImg.hidden = YES;
                cell.addressImg.hidden = YES;
            }else
            {
                NSDictionary *dic = dayArry[indexPath.row-ksaps.count];
                NSString *nameBclass = [dic objectForKey:@"sNameBc"];
                NSString *nLessonNo =  [[dic objectForKey:@"nLessonNo"] isKindOfClass:[NSNull class]] ? @"": [[dic objectForKey:@"nLessonNo"] stringValue];
                NSString *classTIl;
                if (nLessonNo.length > 0) {
                    classTIl = [NSString stringWithFormat:@"%@   课次:%@",nameBclass,nLessonNo];
                }else
                {
                    classTIl = [NSString stringWithFormat:@"%@",nameBclass];
                }
                
                cell.classTitle.text = classTIl;
                
//                NSString *addres = [dic objectForKey:@"sAddress"];
//                NSString *addres2 = [dic objectForKey:@"sNameBr"];
//                NSString *address = [NSString stringWithFormat:@"%@%@",addres,addres2];
//                cell.classAddress.text = address;
                
                if (![[dic objectForKey:@"sAddress"] isKindOfClass:[NSNull class]] &&
                    ![[dic objectForKey:@"sNameBr"] isKindOfClass:[NSNull class]]) {
                    
                    NSString *addres = [dic objectForKey:@"sAddress"];
                    NSString *addres2 = [dic objectForKey:@"sNameBr"];
                    NSString *address = [NSString stringWithFormat:@"%@%@",addres,addres2];
                    cell.classAddress.text = address;
                }

                
                NSString *time1 = [ZCControl changeCreatSeconTime:[dic objectForKey:@"SectBegin"]];
                NSString *time2 = [ZCControl changeCreatSeconTime:[dic objectForKey:@"SectEnd"]];
                cell.classTimes.text = [NSString stringWithFormat:@"%@-%@",time1,time2];
                cell.timeImg.hidden = NO;
                cell.addressImg.hidden = NO;
                ksLabel.hidden = YES;
                ksTime.hidden = YES;

            }
        }
        
    }else if (dayArry.count == 0)
    {
        cell.timeImg.hidden = YES;
        cell.addressImg.hidden = YES;
        
        if (lxsqs.count > 0) {
            if (ksaps.count > 0) {
                if (indexPath.row == 0) {
                    NSDictionary *dic = lxsqs[indexPath.row];
                    NSString *time = [dic objectForKey:@"DestDate"];
                    ksLabel.text =  [dic objectForKey:@"Name"];
                    ksTime.text = time;
                    ksLabel.hidden = NO;
                    ksTime.hidden = NO;
                }else
                {
                    NSDictionary *dic = ksaps[indexPath.row-1];
                    NSString *time = [dic objectForKey:@"DestDate"];
                    ksLabel.text =  [dic objectForKey:@"Name"];
                    ksTime.text = time;
                    ksLabel.hidden = NO;
                    ksTime.hidden = NO;
                }

            }else
            {
                NSDictionary *dic = lxsqs[indexPath.row];
                NSString *time = [dic objectForKey:@"DestDate"];
                ksLabel.text =  [dic objectForKey:@"Name"];
                ksTime.text = time;
                ksLabel.hidden = NO;
                ksTime.hidden = NO;
            }
        }else
        {
            NSDictionary *dic = ksaps[indexPath.row];
            NSString *time = [dic objectForKey:@"DestDate"];
            ksLabel.text =  [dic objectForKey:@"Name"];
            ksTime.text = time;
            ksLabel.hidden = NO;
            ksTime.hidden = NO;
        }
    }
    return cell;
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        
    NSArray *dayArry =  [_taskData objectForKey:@"lessons"];
    NSArray *lxsqs =    [_taskData objectForKey:@"lxsqs"]; //留学申请时间
    NSArray *ksaps =    [_taskData objectForKey:@"ksaps"]; //考试安排日期
    if (dayArry.count > 0) {  //课表大于0
        if (lxsqs.count == 0 && ksaps.count == 0) {
            return 0;
        }else if(lxsqs.count > 0)  //留学考试大于零
        {
            if (ksaps.count > 0) {
                if (indexPath.row == 0) {
                    NSDictionary *dic = lxsqs[indexPath.row];
                    NSString *time = [dic objectForKey:@"DestDate"];
                    CGFloat ksTimeHeght = [self heightForText:time];
                    CGFloat ksLabelHeight = [self heightForText:[dic objectForKey:@"Name"]];
                    return  ksTimeHeght + ksLabelHeight + 20;
                    
                }else if(indexPath.row < ksaps.count+lxsqs.count)
                {
                    NSDictionary *dic = ksaps[indexPath.row-ksaps.count];
                    NSString *time = [dic objectForKey:@"DestDate"];
                    
                    CGFloat ksTimeHeght = [self heightForText:time];
                    CGFloat ksLabelHeight = [self heightForText:[dic objectForKey:@"Name"]];
                    return  ksTimeHeght + ksLabelHeight + 20;
                    
                }else{
                    return 0;
                }
            }else
            {
                if (indexPath.row == 0) {
                    NSDictionary *dic = lxsqs[indexPath.row];
                    NSString *time = [dic objectForKey:@"DestDate"];
                    CGFloat ksTimeHeght = [self heightForText:time];
                    CGFloat ksLabelHeight = [self heightForText:[dic objectForKey:@"Name"]];
                    return  ksTimeHeght + ksLabelHeight + 20;
                }else
                {
                    return 0;
                }
            }
        }else if(ksaps.count > 0)
        {
            if (indexPath.row < ksaps.count) {
                NSDictionary *dic = ksaps[indexPath.row];
                NSString *time = [dic objectForKey:@"DestDate"];
                CGFloat ksTimeHeght = [self heightForText:time];
                CGFloat ksLabelHeight = [self heightForText:[dic objectForKey:@"Name"]];
                return  ksTimeHeght + ksLabelHeight + 20;
            }else
            {
                return 0;
            }
        }
        
    }else if (dayArry.count == 0)
    {
        if (lxsqs.count > 0) {
            if (ksaps.count > 0) {
                if (indexPath.row == 0) {
                    NSDictionary *dic = lxsqs[indexPath.row];
                    NSString *time = [dic objectForKey:@"DestDate"];
                    CGFloat ksTimeHeght = [self heightForText:time];
                    CGFloat ksLabelHeight = [self heightForText:[dic objectForKey:@"Name"]];
                    return  ksTimeHeght + ksLabelHeight + 20;
                }else
                {
                    NSDictionary *dic = ksaps[indexPath.row-1];
                    NSString *time = [dic objectForKey:@"DestDate"];
                    CGFloat ksTimeHeght = [self heightForText:time];
                    CGFloat ksLabelHeight = [self heightForText:[dic objectForKey:@"Name"]];
                    return  ksTimeHeght + ksLabelHeight + 20;
                }
                
            }else
            {
                NSDictionary *dic = lxsqs[indexPath.row];
                NSString *time = [dic objectForKey:@"DestDate"];
                CGFloat ksTimeHeght = [self heightForText:time];
                CGFloat ksLabelHeight = [self heightForText:[dic objectForKey:@"Name"]];
                return  ksTimeHeght + ksLabelHeight + 20;
            }
        }else
        {
            NSDictionary *dic = ksaps[indexPath.row];
            NSString *time = [dic objectForKey:@"DestDate"];
            CGFloat ksTimeHeght = [self heightForText:time];
            CGFloat ksLabelHeight = [self heightForText:[dic objectForKey:@"Name"]];
            return  ksTimeHeght + ksLabelHeight + 20;
        }
    }
    return 0;
}



- (CGFloat)heightForText:(NSString *)text
{
    //设置计算文本时字体的大小,以什么标准来计算
    NSDictionary *attrbute = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]};
    return [text boundingRectWithSize:CGSizeMake(280, 1000)
                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                           attributes:attrbute context:nil].size.height;
}
 
 */

@end
