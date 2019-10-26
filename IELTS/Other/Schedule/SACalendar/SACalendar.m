//
//  SACalendar.m
//  SACalendarExample
//
//  Created by Nop Shusang on 7/10/14.
//  Copyright (c) 2014 SyncoApp. All rights reserved.
//
//  Distributed under MIT License

#import "SACalendar.h"
#import "SACalendarCell.h"
#import "DMLazyScrollView.h"
#import "DateUtil.h"

#define kPointWith 6
@interface SACalendar () <UICollectionViewDataSource, UICollectionViewDelegate,DMLazyScrollViewDelegate>{
    DMLazyScrollView* scrollView;
    NSMutableDictionary *controllers;
    NSMutableDictionary *calendars;
    NSMutableDictionary *monthLabels;
    
    int year, month;
    int prev_year, prev_month;
    int next_year, next_month;
    int current_date, current_month, current_year;
    
    int state, scroll_state;
    int previousIndex;
    BOOL scrollLeft;
    
    int firstDay;
    NSArray *daysInWeeks;
    CGSize cellSize;
    
    int selectedRow;
    int headerSize;
}

@property (nonatomic,strong) UICollectionView *calendar_;
@property (nonatomic,strong) NSMutableArray *dateStringArray;

@property (nonatomic,assign) NSInteger selectDate;
//@property (nonatomic,assign) NSInteger indexCalend;

@end

@implementation SACalendar
@synthesize calendar_;

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame month:0 year:0 scrollDirection:ScrollDirectionHorizontal pagingEnabled:YES];
}

- (id)initWithFrame:(CGRect)frame month:(int)m year:(int)y
{
    return [self initWithFrame:frame month:m year:y scrollDirection:ScrollDirectionHorizontal pagingEnabled:YES];
}

-(id)initWithFrame:(CGRect)frame
   scrollDirection:(scrollDirection)direction
     pagingEnabled:(BOOL)paging
{
    return [self initWithFrame:frame month:0 year:0 scrollDirection:direction pagingEnabled:paging];
}

-(id)initWithFrame:(CGRect)frame
             month:(int)m
              year:(int)y
   scrollDirection:(scrollDirection)direction
     pagingEnabled:(BOOL)paging
{
    self = [super initWithFrame:frame];
    if (self) {
        _evenData = [[NSArray alloc]init];
        controllers = [NSMutableDictionary dictionary];
        calendars = [NSMutableDictionary dictionary];
        monthLabels = [NSMutableDictionary dictionary];
        
        daysInWeeks = [[NSArray alloc]initWithObjects:@"Monday",@"Tuesday",
                       @"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday", nil];
        
        state = LOADSTATESTART;
        scroll_state = SCROLLSTATE_120;
        selectedRow = -1;
        
        current_date = [[DateUtil getCurrentDate]intValue];
        current_month = [[DateUtil getCurrentMonth]intValue];
        current_year = [[DateUtil getCurrentYear]intValue];
        
        self.selectDate = current_date;
        
        if (m == 0 && y == 0) {
            month = current_month;
            year = current_year;
        }
        else{
            month = m;
            year = y;
        }
        
        CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        scrollView = [[DMLazyScrollView alloc] initWithFrameAndDirection:rect
                                                               direction:direction
                                                          circularScroll:YES
                                                                  paging:paging];
        scrollView.controlDelegate = self;
        self.backgroundColor = viewBackgroundColor;
        
        [self addObserver:self forKeyPath:@"delegate" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    __weak __typeof(&*self)weakSelf = self;
    scrollView.dataSource = ^(NSUInteger index) {
        return [weakSelf controllerAtIndex:index];
    };
    scrollView.numberOfPages = 3;
    [self addSubview:scrollView];
    
    return self;
    
}
#warning mark - 修改
- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"delegate"];
}

- (void) observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    if (nil != _delegate && [_delegate respondsToSelector:@selector(SACalendar:didDisplayCalendarForMonth:year:)]) {
        [_delegate SACalendar:self didDisplayCalendarForMonth:month year:year];
    }
}

#pragma mark - DMLazyScrollViewDelegate
- (void)lazyScrollViewWillBeginDecelerating:(DMLazyScrollView *)pagingView
{
    NDLog(@"%d,%d",month,year);
    if (self.delegate && [self.delegate respondsToSelector:@selector(SACalendar:ScrollViewDidEndDeceleratingMonth:year:)]) {
        [self.delegate SACalendar:self ScrollViewDidEndDeceleratingMonth:month year:year];
    }
}
- (void)lazyScrollViewWillBeginDragging:(DMLazyScrollView *)pagingView
{
    NDLog(@"%d,%d",month,year);

}


#pragma SCROLL VIEW DELEGATE

- (UIViewController *) controllerAtIndex:(NSInteger) index {
    /*
     * Handle right scroll
     */
    if (index == previousIndex && state == LOADSTATEPREVIOUS) {
        if (++month > MAX_MONTH) {
            month = MIN_MONTH;
            year ++;
        }
        scrollLeft = NO;
        selectedRow = DESELECT_ROW;
    }
    
    /*
     * Handle left scroll
     */
    else if(state == LOADSTATEPREVIOUS){
        if (--month < MIN_MONTH) {
            month = MAX_MONTH;
            year--;
        }
        scrollLeft = YES;
        selectedRow = DESELECT_ROW;
    }
    
    previousIndex = (int)index;
    
    UIViewController *contr = [[UIViewController alloc] init];
    contr.view.backgroundColor = scrollViewBackgroundColor;
    
    if (state  <= LOADSTATEPREVIOUS ) {
        state = LOADSTATENEXT;
    }
    else if(state == LOADSTATENEXT){
        prev_month = month - 1;
        prev_year = year;
        if (prev_month <= MIN_MONTH) {
            prev_month = MAX_MONTH;
            prev_year--;
        }
        state = LOADSTATECURRENT;
    }
    else{
        next_month = month + 1;
        next_year = year;
        if (next_month > MAX_MONTH) {
            next_month = MIN_MONTH;
            next_year++;
        }
        
        if (scrollLeft) {
            if (--scroll_state < SCROLLSTATE_120) {
                scroll_state = SCROLLSTATE_012;
            }
        }
        else{
            scroll_state++;
            if (scroll_state > SCROLLSTATE_012) {
                scroll_state = SCROLLSTATE_120;
            }
        }
        state = LOADSTATEPREVIOUS;
        
        if (nil != _delegate && [_delegate respondsToSelector:@selector(SACalendar:didDisplayCalendarForMonth:year:)]) {
            [_delegate SACalendar:self didDisplayCalendarForMonth:month year:year];
        }
    }
    
    /*
     * if already exists, reload the calendar with new values
     */
    calendar_ = [calendars objectForKey:[NSString stringWithFormat:@"%li",(long)index]];
    [calendar_ reloadData];
    
    /*
     * create new view controller and add it to a dictionary for caching
     */
    if (![controllers objectForKey:[NSString stringWithFormat:@"%li",(long)index]]) {
        UIViewController *contr = [[UIViewController alloc] init];
        contr.view.backgroundColor = scrollViewBackgroundColor;
        
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
//        flowLayout.itemSize = CGSizeMake(320/7, 200);//self.frame.size;
//        flowLayout.sectionInset = UIEdgeInsetsMake(1, 100, 100, 100);
        flowLayout.minimumInteritemSpacing = 1;
        flowLayout.minimumLineSpacing = 1;
        headerSize = 0;//self.frame.size.height / calendarToHeaderRatio;
        
        CGRect rect = CGRectMake(0, headerSize, self.frame.size.width, self.frame.size.height - headerSize);
        calendar_ = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:flowLayout];
        calendar_.dataSource = self;
        calendar_.delegate = self;
        calendar_.scrollEnabled = NO;
        [calendar_ registerClass:[SACalendarCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        [calendar_ setBackgroundColor:calendarBackgroundColor];
        calendar_.tag = index;
        
        NSString *string = @"STRING";
        CGSize size = [string sizeWithAttributes:
                       @{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
        float pointsPerPixel = 12.0 / size.height;
        float desiredFontSize = headerSize * pointsPerPixel;
        
        UILabel *monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, headerSize)];
        monthLabel.font = [UIFont systemFontOfSize: desiredFontSize * headerFontRatio];
        monthLabel.textAlignment = NSTextAlignmentCenter;
        monthLabel.text = [NSString stringWithFormat:@"%@ %04i",[DateUtil getMonthString:month],year];
        monthLabel.textColor = headerTextColor;
        
        [contr.view addSubview:monthLabel];
        [contr.view addSubview:calendar_];
        
        [calendars setObject:calendar_ forKey:[NSString stringWithFormat:@"%li",(long)index]];
        [controllers setObject:contr forKey:[NSString stringWithFormat:@"%li",(long)index]];
        [monthLabels setObject:monthLabel forKey:[NSString stringWithFormat:@"%li",(long)index]];
        
        
        return contr;
    }
    else{
        return [controllers objectForKey:[NSString stringWithFormat:@"%li",(long)index]];
    }
    
}

/**
 *  Get the month corresponding to the collection view
 *
 *  @param tag of the collection view
 *
 *  @return month that the collection view should load
 */
-(int)monthToLoad:(int)tag
{
    if (scroll_state == SCROLLSTATE_120) {
        if (tag == 0) return next_month;
        else if(tag == 1) return prev_month;
        else return month;
    }
    else if(scroll_state == SCROLLSTATE_201){
        if (tag == 0) return month;
        else if(tag == 1) return next_month;
        else return prev_month;
    }
    else{
        if (tag == 0) return prev_month;
        else if(tag == 1) return month;
        else return next_month;
    }
}

/**
 *  Get the year corresponding to the collection view
 *
 *  @param tag of the collection view
 *
 *  @return year that the collection view should load
 */
-(int)yearToLoad:(int)tag
{
    if (scroll_state == SCROLLSTATE_120) {
        if (tag == 0) return next_year;
        else if(tag == 1) return prev_year;
        else return year;
    }
    else if(scroll_state == SCROLLSTATE_201){
        if (tag == 0) return year;
        else if(tag == 1) return next_year;
        else return prev_year;
    }
    else{
        if (tag == 0) return prev_year;
        else if(tag == 1) return year;
        else return next_year;
    }
}

#pragma mark - 设置访问数据
- (void)setEvenData:(NSArray *)evenData
{
    if (_evenData != evenData) {
        _evenData = evenData;
        _dateStringArray  = [[NSMutableArray alloc]initWithCapacity:_evenData.count];
        for (NSDictionary *dic in _evenData) {
            NSString *date =  [[dic allKeys]firstObject];
            [_dateStringArray addObject:date];
        }
        
//        calendar_ = [calendars objectForKey:[NSString stringWithFormat:@"%i",previousIndex-1]];
//        NDLog(@"%i",previousIndex);
//        if (calendar_ == nil) {
//             calendar_ = [calendars objectForKey:[NSString stringWithFormat:@"%i",2]];
//        }
//        if (calendar_ != nil) {
//            int monthToLoad = [self monthToLoad:(int)calendar_.tag];
//            int yearToLoad = [self yearToLoad:(int)calendar_.tag];
//            firstDay = (int)[daysInWeeks indexOfObject:[DateUtil getDayOfDate:1 month:monthToLoad year:yearToLoad]];
//            
//            NSIndexPath *index = [NSIndexPath indexPathForRow:self.selectDate+firstDay-1 inSection:0];
//            [self collectionView:calendar_ didSelectItemAtIndexPath:index];
//            [calendar_ reloadData];
//        }
    }
    calendar_ = [calendars objectForKey:[NSString stringWithFormat:@"%i",previousIndex-1]];
    NDLog(@"%i",previousIndex);
    if (calendar_ == nil) {
        calendar_ = [calendars objectForKey:[NSString stringWithFormat:@"%i",2]];
    }
    if (calendar_ != nil) {
        int monthToLoad = [self monthToLoad:(int)calendar_.tag];
        int yearToLoad = [self yearToLoad:(int)calendar_.tag];
        firstDay = (int)[daysInWeeks indexOfObject:[DateUtil getDayOfDate:1 month:monthToLoad year:yearToLoad]];
        
        NSIndexPath *index = [NSIndexPath indexPathForRow:self.selectDate+firstDay-1 inSection:0];
        [self collectionView:calendar_ didSelectItemAtIndexPath:index];
        [calendar_ reloadData];
    }

}

#pragma COLLECTION VIEW DELEGATE

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    int monthToLoad = [self monthToLoad:(int)collectionView.tag];
    int yearToLoad = [self yearToLoad:(int)collectionView.tag];
    firstDay = (int)[daysInWeeks indexOfObject:[DateUtil getDayOfDate:1 month:monthToLoad year:yearToLoad]];
    
    UILabel *monthLabel = [monthLabels objectForKey:[NSString stringWithFormat:@"%li",(long)collectionView.tag]];
    monthLabel.text = [NSString stringWithFormat:@"%@ %04i",[DateUtil getMonthString:monthToLoad],yearToLoad];
    
    return MAX_CELL;
}

/**
 *  Controls what gets displayed in each cell
 *  Edit this function for customized calendar logic
 */

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SACalendarCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    int monthToLoad = [self monthToLoad:(int)collectionView.tag];
    int yearToLoad = [self yearToLoad:(int)collectionView.tag];
    // number of days in the month we are loading
    int daysInMonth = (int)[DateUtil getDaysInMonth:monthToLoad year:yearToLoad];
    
    NSString *dateString = [NSString stringWithFormat:@"%d-%02d-%02d",year,month,(int)indexPath.row - firstDay + 1];
     if ([_dateStringArray containsObject:dateString]) {

        NSUInteger uninte = [_dateStringArray indexOfObject:dateString];
        //获取当天的数据
        NSDictionary *dateData = _evenData[uninte];
        NSDictionary *specificData = [dateData objectForKey:dateString]; //具体莫一天的数据
        //区分任务和日历
        switch (self.calendarType) {
            case CalendarCellTypeTask:
            {
                cell.cellType = CellTypeTask;
               //任务
               NSDictionary *resMaterial = [specificData objectForKey:@"ResMaterial"];   //资料 3
               NSDictionary *resPaperLx = [specificData objectForKey:@"ResPaperLx"];     //练习 2
               NSDictionary *resPaperMk = [specificData objectForKey:@"ResPaperMk"];     //模考 1
               NSMutableArray *cellArray = [[NSMutableArray alloc]initWithCapacity:3];

                //遍历视图
                if (resMaterial.count > 0) {
                    [cellArray addObject:resMaterial];
                }
                if (resPaperLx.count > 0) {
                    [cellArray addObject:resPaperLx];
                }
                if (resPaperMk.count > 0) {
                    [cellArray addObject:resPaperMk];
                }

                cell.viewPoint1.hidden = YES;
                cell.viewPoint2.hidden = YES;
                cell.viewPoint3.hidden = YES;
                for (int i = 0; i < cellArray.count; i++) {
                    NSDictionary *dic = cellArray[i];
                    //创建视图
                    NSString *ifComp = [dic objectForKey:@"ifComp"];
                    NSString *taskType = [[dic objectForKey:@"TaskType"] stringValue];
                    if ([taskType isEqualToString:@"1"]) {
                        //判断是否完成
                        if ([ifComp isEqualToString:@"1"]) { //1是已完成，0是未完成
                            cell.viewPoint3.hidden = YES;
                        }else{
                            cell.viewPoint3.hidden = NO;
                        }

                    }else if ([taskType isEqualToString:@"2"]) {
                        //判断是否完成
                        if ([ifComp isEqualToString:@"1"]) { //1是已完成，0是未完成
                            cell.viewPoint2.hidden = YES;
                        }else{
                            cell.viewPoint2.hidden = NO;
                        }
                    }else if ([taskType isEqualToString:@"3"]) {
                        
                        //判断是否完成
                        if ([ifComp isEqualToString:@"1"]) { //1是已完成，0是未完成
                            cell.viewPoint1.hidden = YES;
                        }else{
                            cell.viewPoint1.hidden = NO;
                        }
                    }
                }
                
                //调整UI
                if (cellArray.count == 1) {
                    //一类
                    cell.contentLabel1.top = cell.size.height-20;
                    cell.contentLabel2.top = cell.size.height-20;
                    cell.contentLabel3.top = cell.size.height-20;
                    
                    //创建视图
                    if (resMaterial.count > 0) {
                        cell.contentLabel1.hidden = NO;
                        cell.contentLabel2.hidden = YES;
                        cell.contentLabel3.hidden = YES;
                    }
                    if (resPaperLx.count > 0) {
                        cell.contentLabel1.hidden = YES;
                        cell.contentLabel2.hidden = NO;
                        cell.contentLabel3.hidden = YES;
                    }
                    
                    if (resPaperMk.count > 0) {
                        cell.contentLabel1.hidden = YES;
                        cell.contentLabel2.hidden = YES;
                        cell.contentLabel3.hidden = NO;
                    }
                }else if (cellArray.count == 2)
                {
                        //两类
                        if (resMaterial.count == 0) {
                            cell.contentLabel3.top = cell.size.height-20*2;
                            cell.contentLabel2.top = cell.contentLabel3.bottom;
                            cell.contentLabel3.hidden = NO;
                            cell.contentLabel2.hidden = NO;
                            cell.contentLabel1.hidden = YES;
                        }else if (resPaperLx.count == 0)
                        {
                            cell.contentLabel3.top = cell.size.height-20*2;
                            cell.contentLabel1.top = cell.contentLabel3.bottom;
                            cell.contentLabel3.hidden = NO;
                            cell.contentLabel2.hidden = YES;
                            cell.contentLabel1.hidden = NO;
                        }else
                        {
                            cell.contentLabel2.top = cell.size.height-20*2;
                            cell.contentLabel1.top = cell.contentLabel2.bottom;
                            cell.contentLabel3.hidden = YES;
                            cell.contentLabel2.hidden = NO;
                            cell.contentLabel1.hidden = NO;
                        }
        
                }else{
                    //三类
                    cell.contentLabel3.top = cell.size.height-20*3;
                    cell.contentLabel2.top = cell.contentLabel3.bottom;
                    cell.contentLabel1.top = cell.contentLabel2.bottom;
                    cell.contentLabel3.hidden = NO;
                    cell.contentLabel2.hidden = NO;
                    cell.contentLabel1.hidden = NO;
                }
                
                cell.viewPoint3.top = cell.contentLabel3.top+ (20-kPointWith)/2;
                cell.viewPoint2.top = cell.contentLabel2.top+ (20-kPointWith)/2;
                cell.viewPoint1.top = cell.contentLabel1.top+ (20-kPointWith)/2;
            }
                break;
            case CalendarCellTypeClass:
            {
                cell.cellType =CellTypeClass;
                NSArray *lessons = [specificData objectForKey:@"lessons"];   //课程
                NSArray *lxsqs = [specificData objectForKey:@"lxsqs"]; //留学申请时间
                NSArray *ksaps = [specificData objectForKey:@"ksaps"]; //考试安排日期
                if (lessons.count > 0 || lxsqs.count > 0 || ksaps.count > 0) {
                    NSInteger cout = lessons.count + lxsqs.count + ksaps.count;
                    if (cout == 2) {
                        cell.contentLabel4.hidden = NO;
                        cell.contentLabel5.hidden = NO;
                        cell.contentLabel6.hidden = YES;
                        cell.viewPoint4.hidden = NO;
                        cell.viewPoint5.hidden = NO;
                        cell.viewPoint6.hidden = YES;

                        
                        if (lessons.count == 2) {
                            NSDictionary *firstDic = [lessons objectAtIndex:0];
                            cell.contentLabel4.text =  [firstDic objectForKey:@"sNameBc"];
                            NSDictionary *secondDic = [lessons objectAtIndex:1];
                            cell.contentLabel5.text = [secondDic objectForKey:@"sNameBc"];
                        }else if (lessons.count == 1)
                        {
                            NSDictionary *firstDic = [lessons objectAtIndex:0];
                            cell.contentLabel4.text =  [firstDic objectForKey:@"sNameBc"];
                            
                            if (lxsqs.count > 0) {
                               NSDictionary *secondDic = [lxsqs objectAtIndex:0];
                               cell.contentLabel5.text = [secondDic objectForKey:@"Name"];
                            }else{
                                 NSDictionary *seconDic = [ksaps objectAtIndex:0];
                                 cell.contentLabel5.text = [seconDic objectForKey:@"Name"];
                            }
                        }else if (lessons.count == 0)
                        {
                            if (lxsqs.count > 0) {
                                NSDictionary *secondDic = [lxsqs objectAtIndex:0];
                                cell.contentLabel4.text = [secondDic objectForKey:@"Name"];
                                NSDictionary *seconDic = [ksaps objectAtIndex:0];
                                cell.contentLabel5.text = [seconDic objectForKey:@"Name"];
                            }else
                            {
                                NSDictionary *firstDic = [ksaps objectAtIndex:0];
                                cell.contentLabel4.text = [firstDic objectForKey:@"Name"];
                                NSDictionary *seconDic = [ksaps objectAtIndex:0];
                                cell.contentLabel5.text = [seconDic objectForKey:@"Name"];
                            }
                        }
                    }else if(cout == 3)
                    {
                        cell.contentLabel4.hidden = NO;
                        cell.contentLabel5.hidden = NO;
                        cell.contentLabel6.hidden = NO;
                        cell.viewPoint4.hidden = NO;
                        cell.viewPoint5.hidden = NO;
                        cell.viewPoint6.hidden = NO;

                        
                        if (lxsqs.count > 0) {  //有留学日期
                            NSDictionary *firstDic = [lxsqs objectAtIndex:0];
                            cell.contentLabel4.text = [firstDic objectForKey:@"Name"];
                            if (ksaps.count > 0 && lessons.count > 0) { //有考试日期
                                NSDictionary *twoDic = [ksaps objectAtIndex:0];
                                cell.contentLabel5.text = [twoDic objectForKey:@"Name"];
                                NSDictionary *threeDic = [lessons objectAtIndex:0];
                                cell.contentLabel6.text = [threeDic objectForKey:@"sNameBc"];
                            }else if(lessons.count == 0) //没有课表
                            {
                                NSDictionary *twoDic = [ksaps objectAtIndex:0];
                                cell.contentLabel5.text = [twoDic objectForKey:@"Name"];
                                NSDictionary *threeDic = [ksaps objectAtIndex:1];
                                cell.contentLabel6.text = [threeDic objectForKey:@"Name"];
                            }else //没有考试日期
                            {
                                NSDictionary *twoDic = [lessons objectAtIndex:0];
                                NSDictionary *threeDic = [lessons objectAtIndex:1];
                                cell.contentLabel5.text = [twoDic objectForKey:@"sNameBc"];
                                cell.contentLabel6.text = [threeDic objectForKey:@"sNameBc"];
                            }
                        }else
                        {
                            if (ksaps.count > 0) {
                                if (lessons.count == 0) {  //没有课表，没有留学日期
                                    NSDictionary *firstDic = [ksaps objectAtIndex:0];
                                    NSDictionary *twoDic = [ksaps objectAtIndex:1];
                                    NSDictionary *threeDic = [ksaps objectAtIndex:2];
                                    
                                    cell.contentLabel4.text = [firstDic objectForKey:@"Name"];
                                    cell.contentLabel5.text = [twoDic objectForKey:@"Name"];
                                    cell.contentLabel6.text = [threeDic objectForKey:@"Name"];
                                }else if(lessons.count == 1)
                                {
                                    NSDictionary *firstDic = [lessons objectAtIndex:0];
                                    cell.contentLabel4.text = [firstDic objectForKey:@"sNameBc"];
                                    NSDictionary *twoDic = [ksaps objectAtIndex:0];
                                    NSDictionary *threeDic = [ksaps objectAtIndex:1];
                                    cell.contentLabel5.text = [twoDic objectForKey:@"Name"];
                                    cell.contentLabel6.text = [threeDic objectForKey:@"Name"];
                                }else if(lessons.count == 2)
                                {
                                    NSDictionary *firstDic = [ksaps objectAtIndex:0];
                                    cell.contentLabel4.text = [firstDic objectForKey:@"Name"];
                                    NSDictionary *twoDic = [lessons objectAtIndex:0];
                                    NSDictionary *threeDic = [lessons objectAtIndex:1];
                                    cell.contentLabel5.text = [twoDic objectForKey:@"sNameBc"];
                                    cell.contentLabel6.text = [threeDic objectForKey:@"sNameBc"];
                                }
                            }else
                            {
                                NSDictionary *firstDic = [lessons objectAtIndex:0];
                                NSDictionary *twoDic = [lessons objectAtIndex:1];
                                NSDictionary *threeDic = [lessons objectAtIndex:2];
                                
                                cell.contentLabel4.text = [firstDic objectForKey:@"sNameBc"];
                                cell.contentLabel5.text = [twoDic objectForKey:@"sNameBc"];
                                cell.contentLabel6.text = [threeDic objectForKey:@"sNameBc"];
                            }
                        }
                        
                    }else if (cout > 3)
                    {
                        NSDictionary *firstDic = [lessons objectAtIndex:0];
                        NSDictionary *twoDic = [lessons objectAtIndex:1];
                        
                        cell.contentLabel5.text = [firstDic objectForKey:@"sNameBc"];
                        cell.contentLabel6.text = [twoDic objectForKey:@"sNameBc"];
                        
                        NSString *lessonString = [NSString stringWithFormat:@"总共:%lu",(unsigned long)(lessons.count+lxsqs.count+ksaps.count)];
                        cell.contentLabel4.text = lessonString;
                        cell.viewPoint4.hidden = YES;
                        
                        cell.contentLabel4.hidden = NO;
                        cell.contentLabel5.hidden = NO;
                        cell.contentLabel6.hidden = NO;
                        
                        cell.viewPoint4.hidden = NO;
                        cell.viewPoint5.hidden = NO;
                        cell.viewPoint6.hidden = NO;

                    }
                    else
                    {
                        if (lessons.count == 1) {
                            NSDictionary *firstDic = [lessons objectAtIndex:0];
                            cell.contentLabel4.text =  [firstDic objectForKey:@"sNameBc"];
                        }else
                        {
                            if (lxsqs.count > 0) {
                                NSDictionary *firstDic = [lxsqs objectAtIndex:0];
                                cell.contentLabel4.text =  [firstDic objectForKey:@"Name"];
                            }else
                            {
                                NSDictionary *firstDic = [ksaps objectAtIndex:0];
                                cell.contentLabel4.text =  [firstDic objectForKey:@"Name"];
                            }
                        
                        }
                        cell.contentLabel4.hidden = NO;
                        cell.contentLabel5.hidden = YES;
                        cell.contentLabel6.hidden = YES;
                        cell.viewPoint4.hidden = NO;
                        cell.viewPoint5.hidden = YES;
                        cell.viewPoint6.hidden = YES;

                    }
                    
                   cell.viewPoint4.frame = CGRectMake(5,cell.contentLabel4.top + (20-kPointWith)/2, kPointWith, kPointWith);
                   cell.viewPoint5.frame =  CGRectMake(5,cell.contentLabel5.top + (20-kPointWith)/2, kPointWith, kPointWith);
                   cell.viewPoint6.frame =  CGRectMake(5,cell.contentLabel6.top + (20-kPointWith)/2, kPointWith, kPointWith);
                }
            }
                break;
            default:
                break;
        }
    }else
    {
        cell.viewPoint1.hidden = YES;
        cell.viewPoint2.hidden = YES;
        cell.viewPoint3.hidden = YES;
        cell.viewPoint4.hidden = YES;
        cell.viewPoint5.hidden = YES;
        cell.viewPoint6.hidden = YES;


        
        cell.contentLabel1.hidden = YES;
        cell.contentLabel2.hidden = YES;
        cell.contentLabel3.hidden = YES;
        cell.contentLabel4.hidden = YES;
        cell.contentLabel5.hidden = YES;
        cell.contentLabel6.hidden = YES;
    }
    // if cell is out of the month, do not show
    if (indexPath.row < firstDay || indexPath.row >= firstDay + daysInMonth) {
        cell.dateLabel.hidden = cell.circleView.hidden = cell.selectedView.hidden = YES;
    }
    else{
        cell.bottomLineView.hidden = cell.topLineView.hidden = cell.dateLabel.hidden = NO;
        cell.circleView.hidden = YES;
        
        // get appropriate font size
        NSString *string = @"STRING";
        
        CGSize size = [string sizeWithAttributes:
                       @{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
        float pointsPerPixel = 12.0 / size.height;
        float desiredFontSize = cellSize.height * pointsPerPixel;
        
//        UIFont *font = cellFont;
//        UIFont *boldFont = cellBoldFont;
        
        // if the cell is the current date, display the red circle
        BOOL isToday = NO;
        if (indexPath.row - firstDay + 1 == current_date
            && monthToLoad == current_month
            && yearToLoad == current_year)
        {
            cell.circleView.hidden = NO;
            
            cell.dateLabel.textColor = currentDateTextColor;
            
//            cell.dateLabel.font = font;
            
//            selectedRow = indexPath.row;
            
            isToday = YES;
        }
        else{
//            cell.dateLabel.font = font;
            cell.dateLabel.textColor = dateTextColor;
            
//            selectedRow = DESELECT_ROW;
        }

        
        // if the cell is selected, display the black circle
        if (indexPath.row == selectedRow) {
            cell.selectedView.hidden = NO;
//            cell.dateLabel.textColor = selectedDateTextColor;
//            cell.dateLabel.font = font;
        }
        else{
            cell.selectedView.hidden = YES;
            if (!isToday) {
//                cell.dateLabel.font = font;
                cell.dateLabel.textColor = dateTextColor;
            }
        }
        
        // set the appropriate date for the cell
        cell.dateLabel.text = [NSString stringWithFormat:@"%i",(int)indexPath.row - firstDay + 1];
    }
    
    return cell;
}

/*
 * Scale the collection view size to fit the frame
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    int width = self.frame.size.width;
    int height = self.frame.size.height - headerSize;
    cellSize = CGSizeMake(width/DAYS_IN_WEEKS, height / MAX_WEEK);
    return CGSizeMake(width/DAYS_IN_WEEKS, height / MAX_WEEK);
}

/*
 * Set all spaces between the cells to zero
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

/*
 * If the width of the calendar cannot be divided by 7, add offset to each side to fit the calendar in
 */
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    int width = self.frame.size.width;
    int offset = (width % DAYS_IN_WEEKS) / 4;
    // top, left, bottom, right
    return UIEdgeInsetsMake(offset,0.5,offset,0.5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    int daysInMonth = (int)[DateUtil getDaysInMonth:[self monthToLoad:(int)collectionView.tag] year:[self yearToLoad:(int)collectionView.tag]];
    if (!(indexPath.row < firstDay || indexPath.row >= firstDay + daysInMonth)) {
        
        int dateSelected = (int)indexPath.row - firstDay + 1;
        
        if (nil != _delegate && [_delegate respondsToSelector:@selector(SACalendar:didSelectDate:month:year:)]) {
            self.selectDate = dateSelected;
            [_delegate SACalendar:self didSelectDate:dateSelected month:month year:year];
        }
        
        selectedRow = (int)indexPath.row;
    }
    else{
        selectedRow = DESELECT_ROW;
    }
    [collectionView reloadData];
}




@end
