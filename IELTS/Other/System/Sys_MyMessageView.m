//
//  Sys_MyMessageView.m
//  IELTS
//
//  Created by melp on 14/11/17.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import "Sys_MyMessageView.h"
#import "MyMessageCell.h"
#import "MJRefresh.h"
#import "XDFNoReadMessageViewController.h"

@interface Sys_MyMessageView ()<MJRefreshBaseViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataMessage;
@property (nonatomic,strong) UIView *tipTitle ;

@end

@implementation Sys_MyMessageView
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_foot;
    int _page;
}
- (void)initView:(UIViewController *)parentView
{
    
    //请求数据
//    [self _requestData];
     
    if (_header != nil) {
        [_header beginRefreshing];
    }
    
    if(self.IsInited) return;
    
    [super initView:parentView];

    self.tbMessage.dataSource = self;
    self.tbMessage.delegate = self;
    self.tbMessage.backgroundColor = [UIColor clearColor];
    self.tbMessage.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tbMessage.showsHorizontalScrollIndicator = NO;
    self.tbMessage.showsVerticalScrollIndicator = NO;
    self.viewEditTable.top = 770;
    self.IsInited = YES;
    
    //创建未有消息页面
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(1, 55, self.width-2, self.height-55)];
    bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:bgView];
    
    UILabel *tipTitle = [[UILabel alloc]initWithFrame:CGRectMake((bgView.width-400)/2, (bgView.height-200)/2, 400, 60)];
    tipTitle.text = @"暂无消息!";
    tipTitle.backgroundColor = [UIColor clearColor];
    tipTitle.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:tipTitle];
    self.tipTitle = bgView;
    self.tipTitle.hidden = YES;
    
    //上拉，下拉加载数据
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tbMessage;
    header.delegate = self;
    _header = header;
    
    MJRefreshFooterView *foot = [MJRefreshFooterView footer];
    foot.scrollView = self.tbMessage;
    foot.delegate = self;
    _foot = foot;
    
    [_header beginRefreshing];
}



- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        _dataMessage = [[NSMutableArray alloc]init];
        _page = 1;
    }else
    {
        _page++;
    }
    NSString *page = [NSString stringWithFormat:@"%d",_page];
    NSDictionary *dicData = @{@"pageIndex":page,@"number":@"10"};
    
    [[RusultManage shareRusultManage]sysMyAllMessageController:self.viewController
                                                       dicData:dicData
                                                   SuccessData:^(NSDictionary *result) {
                                                       if ([[result objectForKey:@"Result"]boolValue]) {
                                                           NSDictionary *data = [result objectForKey:@"Data"];
                                                           NSArray *list = [data objectForKey:@"list"];
                                                           [_dataMessage addObjectsFromArray:list];
                                                           [self.tbMessage reloadData];
                                                       }else
                                                       {
                                                           if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]]) {
//                                                               [[RusultManage shareRusultManage]tipAlert:[result objectForKey:@"Infomation"]];
                                                           }
                                                       }
                                                       
                                                       [refreshView endRefreshing];
                                                       
                                                       // 1.根据数量判断是否需要隐藏上拉控件
                                                       if (![[result objectForKey:@"Data"] isKindOfClass:[NSNull class]]) {
                                                            NSDictionary *data = [result objectForKey:@"Data"];
                                                            NSInteger count = [[data objectForKey:@"totalCount"] integerValue];
                                                           
                                                           if (_dataMessage.count >= count) {
                                                               [_foot finishRefreshing];
                                                           }else
                                                           {
                                                               [_foot endRefreshing];
                                                           }
                                                       }
                                                       
                                                       //显示和隐藏无消息视图
                                                       if (_dataMessage.count > 0 ) {
                                                           self.tipTitle.hidden = YES;
                                                           self.editButton.enabled = YES;
                                                       }else
                                                       {
                                                           self.tipTitle.hidden = NO;
                                                           self.editButton.enabled = NO;
                                                       }
                                                       
//                                                       //恢复状态
//                                                       if ([self.editButton.titleLabel.text isEqual:@"取消"]) {
//                                                            [self endEnitingAction];
//                                                       }
                                                       
                                                   } errorData:^(NSError *error) {
                                                         [refreshView endRefreshing];
                                                   }];
}

//全选和取消全选。
- (IBAction)onSelectAll:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    if (button.selected) {
        if (_dataMessage.count > 0) {
            for (int i=0; i<_dataMessage.count; i++) {
                NSIndexPath *indexPaths = [NSIndexPath indexPathForRow:i inSection:0];
                [self.tbMessage selectRowAtIndexPath:indexPaths animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        }
    }else
    {
        if (_dataMessage.count > 0) {
            for (int i=0; i<_dataMessage.count; i++) {
                NSIndexPath *indexPaths = [NSIndexPath indexPathForRow:i inSection:0];
                [self.tbMessage deselectRowAtIndexPath:indexPaths animated:NO];
            }
        }
    }
}

- (IBAction)onGroupDelete:(id)sender {
    
    //获取选中的单元格索引
    NSArray *selectIndexPaths = self.tbMessage.indexPathsForSelectedRows;
    
    NSMutableArray *deleteArray = [NSMutableArray array];
    NSMutableString *messageId = [[NSMutableString alloc]init];
    //
    for (int i=0; i<selectIndexPaths.count; i++) {
        //取出要删除的数据
        NSIndexPath *indexPath = selectIndexPaths[i];
        NSDictionary *item = [_dataMessage objectAtIndex:indexPath.row];
        [deleteArray addObject:item];
        //取出要删除的id
        NSString *miID =  [[item objectForKey:@"MI_ID"] stringValue];
        [messageId appendFormat:@"%@",miID];
        if (i < selectIndexPaths.count-1) {
            [messageId appendFormat:@","];
        }
    }
    //调用删除
    [self deleteRuequset:messageId types:@"del"];
    //结束编辑
    [self endEnitingAction];
    
    //将deleteArray此数组中的对象从_data中删除
    [_dataMessage removeObjectsInArray:deleteArray];
    
    //删除选中的单元格对象
    [self.tbMessage deleteRowsAtIndexPaths:selectIndexPaths withRowAnimation:UITableViewRowAnimationTop];
    [self.tbMessage reloadData];
}

//编辑按钮
- (IBAction)onEdit:(id)sender
{
    UIButton *bt = (UIButton *)sender;
    if([bt.titleLabel.text isEqual:@"编辑"])
    {
        [self startEnitingAction];
    }
    else
    {
        [self endEnitingAction];
    }
}

//开始编辑
- (void)startEnitingAction
{
    
    [self.editButton setTitle:@"取消" forState:UIControlStateNormal];
    self.tbMessage.editing = YES;
    [UIView animateWithDuration:1 animations:nil];
    [UIView beginAnimations:@"" context:nil];
    self.viewEditTable.top = 689;
    self.tbMessage.height = self.tbMessage.height -75;
    [UIView commitAnimations];
}

//结束编辑
- (void)endEnitingAction
{
    if (self.onSelectAllBt.selected) {
        self.onSelectAllBt.selected = NO;
    }
    [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
    
    self.tbMessage.editing = NO;
    [UIView animateWithDuration:1 animations:nil];
    [UIView beginAnimations:@"" context:nil];
    self.viewEditTable.top = 770;
    self.tbMessage.height = self.tbMessage.height+ 75;
    [UIView commitAnimations];
}



#pragma mark - UITable Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataMessage.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 107;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"MyMessageCell";
    MyMessageCell *cell = (MyMessageCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyMessageCell" owner:self options:nil]lastObject];
        cell.backgroundColor = rgb(238, 238, 238, 1);
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (_dataMessage.count > 0) {        
        cell.dataDic = _dataMessage[indexPath.row];
    }
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if (tableView.editing) {
            tableView.editing = !tableView.editing;
        }
        [_dataMessage removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
#pragma mark -删除操作
- (void)deleteRuequset:(NSString *)messageId types:(NSString *)type
{
    if (messageId.length == 0) {
        return;
    }
    if (type.length == 0) {
        return;
    }
    //删除请求
    [[RusultManage shareRusultManage]sysMessageControll:self.viewController
                                              messageId:messageId
                                                   type:type
                                            SuccessData:^(NSDictionary *result) {
                                                NDLog(@"%@",result);
                                                [_header beginRefreshing];
                                                
                                                //通知刷新未读消息的条数
                                                [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateBage object:nil];
                                                
                                            } errorData:^(NSError *error) {
                                                NDLog(@"删除失败");
                                                
                                                
                                            }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NDLog(@"%ld",(long)indexPath.row);
    if (!tableView.editing) {
        NSDictionary *dic = _dataMessage[indexPath.row];
        NSString *miId = [[dic objectForKey:@"MI_ID"] stringValue];
        if ([[dic objectForKey:@"MR_ID"] isKindOfClass:[NSNull class]]) {
            //阅读
            [self deleteRuequset:miId types:@"read"];
        }
        
        XDFNoReadMessageViewController *noRead = [[XDFNoReadMessageViewController alloc]init];
        noRead.dataDic = dic;
        noRead.modalPresentationStyle = UIModalPresentationFormSheet;
        [self.viewController presentViewController:noRead animated:YES completion:nil];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

@end
