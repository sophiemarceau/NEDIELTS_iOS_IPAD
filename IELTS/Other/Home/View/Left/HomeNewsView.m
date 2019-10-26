///
//  HomeNewsView.m
//  IELTS
//
//  Created by 李牛顿 on 14-11-13.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import "HomeNewsView.h"
#import "HomeNewsTableViewCell.h"
#import "MJRefresh.h"
#import "XDFScheduleTableViewCell.h"
@interface HomeNewsView()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_foot;
    int _page;
    UITableView *tableViews;
    NSMutableArray *_classResourceData;
    UIView *viewTop;
    UILabel *labelTitle;//标题
    UIImageView *arrowImageView;//背景圆
}
@property (nonatomic,strong) NSArray *listLesson;  //课程
@property (nonatomic,strong) NSArray *listKssjTime; //考试时间
@property (nonatomic,strong) NSArray *listLxsqTime; //留学申请时间
@property (nonatomic,strong) NSArray *listMaterialsTasks; //资料
@property (nonatomic,strong) NSArray *listMessage; //系统消息

@property (nonatomic,assign)BOOL isFinishNews;

@end

@implementation HomeNewsView
@synthesize isFinishNews;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
    }
    return self;
}
- (void)_initView
{
    isFinishNews = NO;
    
    tableViews = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableViews.dataSource = self;
    tableViews.delegate = self;
    tableViews.showsHorizontalScrollIndicator = NO;
    tableViews.showsVerticalScrollIndicator = NO;
    tableViews.tableFooterView = [[UIView alloc]init];
    tableViews.backgroundColor = [UIColor clearColor];
    [self addSubview:tableViews];
    
    //上拉，下拉加载数据
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = tableViews;
    header.delegate = self;
    _header = header;
    
    MJRefreshFooterView *foot = [MJRefreshFooterView footer];
    foot.scrollView = tableViews;
    foot.delegate = self;
    _foot = foot;
    
    
    viewTop = [[UIView alloc]initWithFrame:CGRectZero];
    viewTop.backgroundColor = TABBAR_BACKGROUNDLight;
    
    labelTitle = [ZCControl createLabelWithFrame:CGRectZero Font:20.0f Text:@"最新消息"];
    labelTitle.textColor = [UIColor whiteColor];
    [viewTop addSubview:labelTitle];
    
    arrowImageView = [[UIImageView alloc]initWithFrame:CGRectZero];

    
    UIImage *image = [ZCControl createImageWithColor:TABBAR_BACKGROUND_SELECTED];
    arrowImageView.image = image;
    arrowImageView.backgroundColor = TABBAR_BACKGROUND_SELECTED;
    
    UILabel *labelNew = [ZCControl createLabelWithFrame:CGRectZero Font:18.0f Text:@""];
    labelNew.textColor = [UIColor whiteColor];
    labelNew.textAlignment = NSTextAlignmentCenter;
    labelNew.tag = 2001;
    [arrowImageView addSubview:labelNew];
    [viewTop addSubview:arrowImageView];
    
    [self addSubview:viewTop];
}
#pragma mark - 开始刷新
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    isFinishNews = YES;
    
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        _classResourceData = [[NSMutableArray alloc]init];
        _page = 1;
    }else
    {
        _page++;
    }
    NSString *page = [NSString stringWithFormat:@"%d",_page];
    NSDictionary *dic = @{@"pageIndex":page,
                          @"number":@"20"};
    [[RusultManage shareRusultManage]myMessageListRusult:dic viewController:self.viewController successData:^(NSDictionary *result) {
        
        isFinishNews = NO;
        
        if ([[result objectForKey:@"Result"]boolValue]) {
            NSDictionary *classLesson = [result objectForKey:@"Data"];
            
            _listLesson = [[NSArray alloc]init];
            _listKssjTime = [[NSArray alloc]init];
            _listLxsqTime = [[NSArray alloc]init];
            _listMaterialsTasks = [[NSArray alloc]init];
            _listMessage = [[NSArray alloc]init];
            
            NSArray *listLesson = [classLesson objectForKey:@"listLesson"];  //课程
            NSArray *listKssjTime = [classLesson objectForKey:@"listKssjTime"]; //考试时间
            NSArray *listLxsqTime =[classLesson objectForKey:@"listLxsqTime"]; //留学申请时间
            NSArray *listMaterialsTasks = [classLesson objectForKey:@"listMaterialsTasks"]; //资料
            NSArray *listMessage = [classLesson objectForKey:@"listMessage"]; //系统消息
            
            _listLesson = listLesson;
            _listKssjTime = listKssjTime;
            _listLxsqTime = listLxsqTime;
            _listMaterialsTasks = listMaterialsTasks;
            _listMessage = listMessage;
            
            if (listLesson.count > 0) {
                  [_classResourceData addObjectsFromArray:listLesson];
            }
            if (listKssjTime.count > 0) {
                [_classResourceData addObjectsFromArray:listKssjTime];
            }
            if (listLxsqTime.count > 0) {
                [_classResourceData addObjectsFromArray:listLxsqTime];
            }
            if (listMaterialsTasks.count > 0) {
                [_classResourceData addObjectsFromArray:listMaterialsTasks];
            }
            if (listMessage.count > 0) {
                [_classResourceData addObjectsFromArray:listMessage];
            }
            
            [tableViews reloadData];
            
            [refreshView endRefreshing];
            
            // 1.根据数量判断是否需要隐藏上拉控件
            if (![[classLesson objectForKey:@"count"] isKindOfClass:[NSNull class]]) {
                NSInteger count = [[classLesson objectForKey:@"count"] integerValue];
                UILabel *labelNew =  (UILabel *)[viewTop viewWithTag:2001];
                labelNew.text = [NSString stringWithFormat:@"%ld",(long)count];
                
                if (_classResourceData.count >= count) {
                    [_foot finishRefreshing];
                }else
                {
                    [_foot endRefreshing];
                }
            }
            
        }else
        {
            [refreshView endRefreshing];
            if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]]) {
//                [[RusultManage shareRusultManage]tipAlert:[result objectForKey:@"Infomation"] viewController:self.viewController];
            }
        }
    } errorData:^(NSError *error) {
        
        isFinishNews = NO;
         [refreshView endRefreshing];
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    tableViews.frame = CGRectMake(0, 44, self.width, self.height-44);
    viewTop.frame = CGRectMake(0, 0, self.width, 44);
    
    UILabel *labelNew =  (UILabel *)[viewTop viewWithTag:2001];
    labelNew.frame = CGRectMake(0, 0, 30, 30);
    arrowImageView.frame = CGRectMake(self.width-50, (44-30)/2, 30, 30);
    [ZCControl circleImage:arrowImageView];
    
    labelTitle.frame = CGRectMake(18, (44-35)/2, self.width/2, 35);
    
  
}
- (void)startReloadData
{
    if (!isFinishNews) {
      [_header beginRefreshing];
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _classResourceData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger listlesson = _listLesson.count;
    NSInteger listKssjTime = _listKssjTime.count;
    NSInteger listLxsqTime = _listLxsqTime.count;
    NSInteger listMaterialsTasks = _listMaterialsTasks.count;
    NSInteger listMessage = _listMessage.count;
    
    if (indexPath.row <= listlesson-1 && listlesson > 0) { //课程
        /*
         {
         SectBegin = 1419582600000;
         SectEnd = 1419589800000;
         nLessonNo = 40;
         sAddress = "\U4e2d\U5173\U6751\U897f\U56db\U73af\U4e2d\U8def283\U53f7";
         sCode = YA1049;
         sNameBc = "IELTS6\U5206\U5168\U65e5\U5236\U57fa\U7840\U8d70\U8bfb\U73edYA1049";
         sNameBr = "\U6d77\U6dc0\U5c55\U6625\U56ed\U6821\U533a404\U6559\U5ba4(\U65e7)";
         }
         */
        static NSString *identify = @"listlesson";
        XDFScheduleTableViewCell *cell = (XDFScheduleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
//            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
            cell = [[[NSBundle mainBundle]loadNibNamed:@"XDFScheduleTableViewCell" owner:self options:nil]lastObject];
        }
        if (_classResourceData.count > 0) {
            cell.classTitle.text = [_classResourceData[indexPath.row] objectForKey:@"sNameBc"];
            if (![[_classResourceData[indexPath.row] objectForKey:@"sNameBr"] isKindOfClass:[NSNull class]]) {
                cell.classAddress.text = [_classResourceData[indexPath.row] objectForKey:@"sNameBr"];
            }
            
            NSString *time1 = [ZCControl changeCreatSeconTime:[_classResourceData[indexPath.row] objectForKey:@"SectBegin"]];
            NSString *time2 = [ZCControl changeCreatSeconTime:[_classResourceData[indexPath.row] objectForKey:@"SectEnd"]];
            cell.classTimes.text = [NSString stringWithFormat:@"%@-%@",time1,time2];

            cell.backgroundColor = [UIColor clearColor];
        }
        return cell;
        
    }else if (indexPath.row >listlesson-1 &&
              indexPath.row <= (listlesson + listKssjTime)-1 &&
              listKssjTime > 0)//考试时间
    {
      /*
       {
       DestDate = "2014-12-26";
       }
       */
        static NSString *identify = @"listKssjTime";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
        }
        if (_classResourceData.count>0) {
            cell.textLabel.text = [NSString stringWithFormat:@"最新考试时间: %@",[_classResourceData[indexPath.row] objectForKey:@"DestDate"]];
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.imageView.image = [UIImage imageNamed:@"Icon3.png"];
        }
        return cell;
    
    }else if (indexPath.row >(listlesson + listKssjTime)-1 &&
              indexPath.row <= (listlesson + listKssjTime+listLxsqTime)-1 &&
              listLxsqTime > 0)  //留学申请时间
    {
        /*
         {
         DestDate = "2014-12-26";
         }
         */
        static NSString *identify = @"listLxsqTime";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
        }
        if (_classResourceData.count > 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"留学申请时间: %@",[_classResourceData[indexPath.row] objectForKey:@"DestDate"]];
            cell.backgroundColor = [UIColor clearColor];
            cell.imageView.image = [UIImage imageNamed:@"Icon3.png"];
            cell.textLabel.textColor = [UIColor darkGrayColor];

        }
        return cell;
    
    }else if (indexPath.row >(listlesson + listKssjTime+listLxsqTime)-1 &&
              indexPath.row <= (listlesson + listKssjTime+listLxsqTime+listMaterialsTasks)-1 &&
              listMaterialsTasks > 0)  //资料
    {
        /*
         {
         CreateTime = 1419327427000;
         FileType = mp4;
         IsPublic = "<null>";
         "Mate_ID" = 2081;
         Name = "VID_20141018_124435";
         NickName = Admin1;
         ReadCount = "<null>";
         RoleID = 1;
         "TF_ID" = "<null>";
         TaskType = 3;
         UID = 6;
         Url = "<null>";
         }
         */
        static NSString *identify = @"listMaterialsTasks";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
        }
        if (_classResourceData.count > 0) {
            cell.textLabel.text = [_classResourceData[indexPath.row] objectForKey:@"Name"];
//            cell.detailTextLabel.text = [_classResourceData[indexPath.row] objectForKey:@"FileType"];
            cell.backgroundColor = [UIColor clearColor];
            cell.imageView.image = [UIImage imageNamed:@"Icon4.png"];
            cell.textLabel.textColor = [UIColor darkGrayColor];
        }
        return cell;
    }else if(indexPath.row > (listlesson + listKssjTime+listLxsqTime+listMaterialsTasks)-1 &&
             indexPath.row <= _classResourceData.count-1 &&
             listMessage > 0)  //系统消息
    {
        /*
         {
         Account = admin1;
         AssignRoleID = 3;
         Body = " \U52b3\U8d44\U90e8\U5206       ";
         CreateTime = 1417855100000;
         "MI_ID" = 7;
         "MR_ID" = "<null>";
         Title = "\U8981\U8c03\U8bfe\U55bd";
         }
         */
        static NSString *identify = @"listMessage";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
        }
        if (_classResourceData.count > 0 ) {
            cell.textLabel.text = [_classResourceData[indexPath.row] objectForKey:@"Title"];
            cell.imageView.image = [UIImage imageNamed:@"Icon1.png"];
            cell.textLabel.textColor = [UIColor darkGrayColor];
        }
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger listlesson = _listLesson.count;
//    NSInteger listKssjTime = _listKssjTime.count;
//    NSInteger listLxsqTime = _listLxsqTime.count;
//    NSInteger listMaterialsTasks = _listMaterialsTasks.count;
//    NSInteger listMessage = _listMessage.count;
    
    if (indexPath.row <= listlesson-1 && listlesson > 0) { //课程
        /*
         {
         SectBegin = 1419582600000;
         SectEnd = 1419589800000;
         nLessonNo = 40;
         sAddress = "\U4e2d\U5173\U6751\U897f\U56db\U73af\U4e2d\U8def283\U53f7";
         sCode = YA1049;
         sNameBc = "IELTS6\U5206\U5168\U65e5\U5236\U57fa\U7840\U8d70\U8bfb\U73edYA1049";
         sNameBr = "\U6d77\U6dc0\U5c55\U6625\U56ed\U6821\U533a404\U6559\U5ba4(\U65e7)";
         }
         */
        return 160;
    }
//    else if (indexPath.row >listlesson-1 &&
//              indexPath.row <= (listlesson + listKssjTime)-1 &&
//              listKssjTime > 0)//考试时间
//    {
//        /*
//         {
//         DestDate = "2014-12-26";
//         }
//         */
//        
//    }else if (indexPath.row >(listlesson + listKssjTime)-1 &&
//              indexPath.row <= (listlesson + listKssjTime+listLxsqTime)-1 &&
//              listLxsqTime > 0)  //留学申请时间
//    {
//        /*
//         {
//         DestDate = "2014-12-26";
//         }
//         */
//        
//    }else if (indexPath.row >(listlesson + listKssjTime+listLxsqTime)-1 &&
//              indexPath.row <= (listlesson + listKssjTime+listLxsqTime+listMaterialsTasks)-1 &&
//              listMaterialsTasks > 0)  //资料
//    {
//        /*
//         {
//         CreateTime = 1419327427000;
//         FileType = mp4;
//         IsPublic = "<null>";
//         "Mate_ID" = 2081;
//         Name = "VID_20141018_124435";
//         NickName = Admin1;
//         ReadCount = "<null>";
//         RoleID = 1;
//         "TF_ID" = "<null>";
//         TaskType = 3;
//         UID = 6;
//         Url = "<null>";
//         }
//         */
//    }else if(indexPath.row > (listlesson + listKssjTime+listLxsqTime+listMaterialsTasks)-1 &&
//             indexPath.row <= _classResourceData.count-1 &&
//             listMessage > 0)  //系统消息
//    {
//        /*
//         {
//         Account = admin1;
//         AssignRoleID = 3;
//         Body = " \U52b3\U8d44\U90e8\U5206       ";
//         CreateTime = 1417855100000;
//         "MI_ID" = 7;
//         "MR_ID" = "<null>";
//         Title = "\U8981\U8c03\U8bfe\U55bd";
//         }
//         */
//    
//    }

  
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NDLog(@"%ld",(long)indexPath.row);
    if (_classResourceData.count > 0) {
        NSDictionary *messDic = [_classResourceData objectAtIndex:indexPath.row];
        NSString *messType = [[messDic objectForKey:@"mesTypeParam"] stringValue];
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectMessageType:)]) {
            [self.delegate selectMessageType:messType];
        }
    }
//    if (kStringEqual(messType, @"1") || kStringEqual(messType, @"2") || kStringEqual(messType, @"3")) {
//        
//        
//    }
}


@end
