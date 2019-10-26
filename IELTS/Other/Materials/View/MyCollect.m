//
//  MyCollect.m
//  IELTS
//
//  Created by 李牛顿 on 14-11-14.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import "MyCollect.h"
//#import "MaterialContentViewController.h"
#import "MaterialTableViewCell.h"

#import "XDFCCAndGouKuaiViewController.h"
@interface MyCollect()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,MaterialTableViewCellDelegate,XDFCCAndGouKuaiDelegate>
{
    MJRefreshFooterView *_footer;
    int _page;
}

@property (nonatomic,strong)UITableView *tableView ;

@property (nonatomic,strong)NSMutableArray *classCollectData;  //收藏数据


@end

@implementation MyCollect

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
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self addSubview:_tableView];
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = _tableView;
    header.delegate = self;
    _header = header;
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = _tableView;
    footer.delegate = self;
    _footer = footer;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_header beginRefreshing];
    
}
#pragma mark - MJRefreshBaseViewDelegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        _classCollectData = [[NSMutableArray alloc]init];
        _page = 1;

    }else
    {
        _page++;
    }
    //获取 我的收藏列表
    [[RusultManage shareRusultManage]studyGetCollectRusult:_page
                                            viewController:nil
                                               successData:^(NSDictionary *result) {
                                                NSArray *classCollectData = [result objectForKey:@"Data"];
                                                [_classCollectData addObjectsFromArray:classCollectData];
                                                
                                                [_tableView reloadData];
                                                [refreshView endRefreshing];
                                                // 1.根据数量判断是否需要隐藏上拉控件
                                                if (classCollectData.count < 20 || classCollectData.count ==0) {
                                                    [_footer finishRefreshing];
                                                }
                                            }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _classCollectData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"indentify";
    MaterialTableViewCell *cell = (MaterialTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[MaterialTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    if (_classCollectData.count > 0) {
        cell.dicData = _classCollectData[indexPath.row];
    }
  
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dic = _classCollectData[indexPath.row];
    if (![[dic objectForKey:@"Url"] isKindOfClass:[NSNull class]]) {
        NSString *url =  [dic objectForKey:@"Url"];
        if (url.length > 0) {
            
            XDFCCAndGouKuaiViewController *ccAndGoukuai = [[XDFCCAndGouKuaiViewController alloc]init];
            ccAndGoukuai.urlPath = url;
            ccAndGoukuai.listData = _classCollectData;
            ccAndGoukuai.indexPathRow = indexPath.row;
            ccAndGoukuai.taskType = WhereTaskTypeMaterials;
            ccAndGoukuai.delegate = self;
            [self.viewController.parentViewController.parentViewController.navigationController pushViewController:ccAndGoukuai animated:YES];
        }else
        {
            NDLog(@"链接不存在");
        }
    }else{
        NDLog(@"无效链接");
    }

}
#pragma mark -MaterialTableViewCellDelegate
- (void)cancelCollent
{
    [_header beginRefreshing];
}
#pragma mark -XDFCCAndGouKuaiDelegate
- (void)ccAndGouKuaiCancal
{
    [_header beginRefreshing];
}



@end
