//
//  HomeDayPlanView.m
//  IELTS
//
//  Created by 李牛顿 on 14-11-13.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import "HomeDayPlanView.h"
#import "Cell1.h"
#import "Cell2.h"
#import "TQViewCell.h"

@interface  HomeDayPlanView()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataList;
}

@property (assign)BOOL isOpen;
@property (nonatomic,retain) NSIndexPath *selectIndex;
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) NSInteger cellSection;

@property (nonatomic,assign) CGFloat heightHeards;
@property (nonatomic,strong) NSMutableArray *resourceArray;
@property (nonatomic,strong) NSMutableArray *exerciseArray;
@property (nonatomic,strong) NSMutableArray *testArray;

@property (nonatomic,strong) UIView *finish;
@property (nonatomic,strong) UILabel *finishLabel;

@property (nonatomic,assign) BOOL isSelctone;

@end


@implementation HomeDayPlanView

@synthesize isOpen,selectIndex;
@synthesize resourceArray,exerciseArray,testArray;
@synthesize finishLabel,finish;


- (id)init
{
    if (self = [super init]) {
        [self _initFinish];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self _initFinish];
    }
    return self;
}

- (void)_initFinish  //今天没有任务视图
{
    _isSelctone = NO;
    
    finish = [[UIView alloc]initWithFrame:CGRectZero];
    finish.backgroundColor = [UIColor clearColor];
    
    finishLabel = [ZCControl createLabelWithFrame:CGRectZero Font:18 Text:@""];
    
    finishLabel.textAlignment = NSTextAlignmentCenter;

    [finish addSubview:finishLabel];
    
    [self addSubview:finish];
    
    finish.hidden = YES; //默认隐藏
    
    //表示图
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 200;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.bounces = NO;
    _tableView.tableFooterView = finish;
    _tableView.separatorColor = [UIColor lightGrayColor];
    

}


- (void)layoutSubviews
{
    [super layoutSubviews];
    _tableView.frame = CGRectMake(0, 0 , self.width, kScreenHeight-18);
    
    finish.frame = CGRectMake(0, 0, self.width, 200);
    finishLabel.frame = CGRectMake(0, 0, finish.width, finish.height);
    finishLabel.text = @"亲,今天没有任务~！";

     self.isOpen = NO;  //默认关闭
    [self addSubview:_tableView];
    
}

- (void)setTaskData:(NSDictionary *)taskData
{
    if (_taskData != taskData) {
        NSArray *threeDayTask = [taskData objectForKey:@"day3"];
        NSArray *twoDayTask = [taskData objectForKey:@"day2"];
        NSArray *oneDayTask = [taskData objectForKey:@"day1"];
        NSArray *todayTask  =   [taskData objectForKey:@"today"];
        
        _dataList = [[NSMutableArray alloc]init];  //数据列表
        if (threeDayTask.count > 0) {
            NSDictionary *dic4 = @{@"name":@"三天前",
                                  @"list":threeDayTask,
                                   @"count":@[@"123"]};
            [_dataList addObject:dic4];
        }
        
        if (twoDayTask.count > 0) {
            NSDictionary *dic3 = @{@"name":@"前天",
                                   @"list":twoDayTask,
                                   @"count":@[@"123"]};
            [_dataList addObject:dic3];
        }

        if (oneDayTask.count > 0) {
            NSDictionary *dic2 = @{@"name":@"昨天",
                                   @"list":oneDayTask,
                                   @"count":@[@"123"]};
            [_dataList addObject:dic2];
        }
        
        if (todayTask.count > 0) {
            NSDictionary *dic1 = @{@"name":@"今天",
                                   @"list":todayTask,
                                   @"count":@[@"123"]};
            [_dataList addObject:dic1];
            finish.hidden = YES;  //隐藏完成视图
        }else
        {
            finish.hidden = NO;   //显示完成视图
            NSDictionary *dic1_1 = @{@"name":@"今天",
                                     @"list":[[NSArray alloc]init],
                                     @"count":@[@"123"]};
            [_dataList addObject:dic1_1];
        }
        
        
        [_tableView reloadData];
        if (!_isSelctone) {
            NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:0 inSection:_dataList.count -1];
            [self tableView:_tableView didSelectRowAtIndexPath:indexPath];
            _isSelctone = YES;
        }
    }
}


- (void)manageData:(NSIndexPath *)indexPath
{
    NSUInteger count = [[[_dataList objectAtIndex:indexPath.section] objectForKey:@"list"] count];
    resourceArray = [[NSMutableArray alloc]init];
    exerciseArray = [[NSMutableArray alloc]init];
    testArray = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dic in [[_dataList objectAtIndex:indexPath.section] objectForKey:@"list"]) {
        NSString *idString = [[dic objectForKey:@"TaskType"]stringValue];
        if ([idString isEqualToString:@"1"]) { //模考
            [testArray addObject:dic];
        }
        if ([idString isEqualToString:@"2"]) { //练习
            [exerciseArray addObject:dic];
        }
        if ([idString isEqualToString:@"3"]) { //资料
            
            [resourceArray addObject:dic];
        }
    }
    CGFloat heightHeard;
    if (resourceArray.count > 0 && exerciseArray.count> 0   && testArray.count > 0) {
        heightHeard = 3*30;
    }else if (resourceArray.count == 0 && exerciseArray.count == 0 && testArray.count == 0)
    {
        heightHeard = 0;
        
    }else if ((resourceArray.count == 0 && exerciseArray.count == 0) ||
              (resourceArray.count == 0 && testArray.count == 0) ||
              (exerciseArray.count == 0 && testArray.count == 0))
    {
        heightHeard = 1*30;
        
    }else if ((resourceArray.count>0 && exerciseArray.count>0) ||
              (resourceArray.count >0 && testArray.count>0) ||
              (exerciseArray.count>0 && testArray.count>0))
    {
        heightHeard = 2*30;
    }
    self.heightHeards = heightHeard;
    self.cellSection = count;
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isOpen) {
        if (self.selectIndex.section == section) {
            return  [[[_dataList objectAtIndex:section] objectForKey:@"count"] count]+1;
        }
    }
    return 1;
}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isOpen&&self.selectIndex.section == indexPath.section&&indexPath.row!=0)
    {
        [self manageData:indexPath];
        return self.cellSection*62+self.heightHeards;
    }else
    {
        return 44;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isOpen&&self.selectIndex.section == indexPath.section&&indexPath.row!=0) {
        
        Cell2 *cell = [[[NSBundle mainBundle] loadNibNamed:@"Cell2" owner:self options:nil] objectAtIndex:0];
        cell.height = self.cellSection*44+self.heightHeards;
        cell.exerciseArray = exerciseArray;
        cell.resourceArray = resourceArray;
        cell.testArray = testArray;
        cell.isToday = [[_dataList objectAtIndex:indexPath.section] objectForKey:@"name"];
        return cell;

    }else
    {
        Cell1 *cell = [[[NSBundle mainBundle] loadNibNamed:@"Cell1" owner:self options:nil]lastObject];
        NSString *name = [[_dataList objectAtIndex:indexPath.section] objectForKey:@"name"];
        NSArray *listNum = [[_dataList objectAtIndex:indexPath.section] objectForKey:@"list"];
        cell.numLie =[NSString stringWithFormat:@"%lu",(unsigned long)listNum.count];
        cell.titleLabel.text = name;
        [cell changeArrowWithUp:([self.selectIndex isEqual:indexPath]?YES:NO)];
        return cell;
    }
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        if ([indexPath isEqual:self.selectIndex]) {
            self.isOpen = NO;
            [self didSelectCellRowFirstDo:NO nextDo:NO];
            self.selectIndex = nil;
            
        }else
        {
            if (!self.selectIndex) {
                self.selectIndex = indexPath;
                [self didSelectCellRowFirstDo:YES nextDo:NO];
            }else
            {
                NDLog(@"%ld",(long)self.selectIndex.row);
                NDLog(@"%ld",(long)self.selectIndex.section);
                [self didSelectCellRowFirstDo:NO nextDo:YES];
            }
        }
    }else
    {
        NSDictionary *dic = [_dataList objectAtIndex:indexPath.section];
        NSArray *list = [dic objectForKey:@"list"];
        NSString *item = [list objectAtIndex:indexPath.row-1];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:item message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
        [alert show];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    self.isOpen = firstDoInsert;
    Cell1 *cell = (Cell1 *)[_tableView cellForRowAtIndexPath:self.selectIndex];
    [cell changeArrowWithUp:firstDoInsert];

    
    [_tableView beginUpdates];
    NSInteger section = self.selectIndex.section;
    NSInteger contentCount = [[[_dataList objectAtIndex:section] objectForKey:@"count"] count];
    NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
    for (NSUInteger i = 1; i < contentCount + 1; i++) {
        NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
        [rowToInsert addObject:indexPathToInsert];
    }
    
    if (firstDoInsert)
    {
        [_tableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationMiddle];
    }else
    {
        [_tableView deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationMiddle];
    }
    [_tableView endUpdates];
    
    if (nextDoInsert) {
        self.isOpen = YES;
        self.selectIndex = [_tableView indexPathForSelectedRow];
        NDLog(@"%ld",(long)self.selectIndex.row);
        NDLog(@"%ld",(long)self.selectIndex.section);
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
    
    if (self.isOpen) [_tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
}



@end
