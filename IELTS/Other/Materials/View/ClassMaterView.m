//
//  ClassMaterView.m
//  IELTS
//
//  Created by 李牛顿 on 14-11-14.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import "ClassMaterView.h"
#import "MaterialContentViewController.h"
#import "MaterialTableViewCell.h"
#import "IListTabelView.h"



#import "XDFCCAndGouKuaiViewController.h"

#define kClassTopHeight 305/2
#define kClassSelectHeight 104/2
#define kClassOtherHeight (305-104)/2
#define kClassButtonWidth 41

@interface ClassMaterView()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MJRefreshBaseViewDelegate,IListTabelViewDelegate,XDFCCAndGouKuaiDelegate,MaterialTableViewCellDelegate>
{
    MJRefreshFooterView *_foot;
    int _page;
}
@property (nonatomic,strong) UITableView *tableView;  //列表
@property (nonatomic,strong) UIButton *button;       //7类科目

@property (nonatomic,strong) UITextField  *searchTextField;  //搜索框
@property (nonatomic,strong) IListTabelView *list;    //课次选择
@property (nonatomic,strong) UILabel *classNameLabel;  //课次标题

@property (nonatomic,strong) UIControl *maskControlView; //控制收起搜索框搜索框

@property (nonatomic,strong) UILabel *lineLabel1;
@property (nonatomic,strong) UILabel *lineLabel2;

@property (nonatomic,strong)NSMutableArray *classResourceData; //资料列表
@property (nonatomic,strong)NSArray  *classCodeData;     //课次数据
@property (nonatomic,strong)NSString *ccId;             //课次选择
@property (nonatomic,strong)NSString *courseType;       //课类型

@property (nonatomic,assign)NSInteger enabledString;  //记录按钮当前状态

@end

@implementation ClassMaterView

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

    
    self.ccId = @"";
    self.courseType = @"";
    
    _searchTextField = [[UITextField alloc]initWithFrame:CGRectZero];
    _searchTextField.placeholder = @"搜索";
    _searchTextField.returnKeyType = UIReturnKeySearch;
    _searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    _searchTextField.delegate = self;
    [self addSubview:_searchTextField];
    
    //课次搜索区域   104/2
//    _classNameLabel = [ZCControl createLabelWithFrame:CGRectZero Font:18 Text:@"课次"];
//    _classNameLabel.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:_classNameLabel];
    
    
    _list = [[IListTabelView alloc]initWithFrame:CGRectZero];
    _list.delegate = self;
    [self addSubview:_list];
    
    _lineLabel1 = [ZCControl createLabelLineFrame:CGRectZero];
    [_list addSubview:_lineLabel1];
    
    _lineLabel2 = [ZCControl createLabelLineFrame:CGRectZero];
    [_list addSubview:_lineLabel2];

    
    //下面表示图
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self addSubview:_tableView];
  
    //上拉，下拉加载数据
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = _tableView;
    header.delegate = self;
    _header = header;
    
    MJRefreshFooterView *foot = [MJRefreshFooterView footer];
    foot.scrollView = _tableView;
    foot.delegate = self;
    _foot = foot;

}
/*
 {
 "sCode" : "G0633",
 "sName" : "GRE笔试高强班",
 "id" : 341,
 }
 */
- (void)setDicData:(NSDictionary *)dicData
{
    if (_dicData != dicData) {
        _dicData = dicData;
        [_header  beginRefreshing];
    }
}
- (void)setCcId:(NSString *)ccId
{
    if (_ccId != ccId) {
        _ccId = ccId;
        [_header beginRefreshing];
    }
}
- (void)setCourseType:(NSString *)courseType
{
    if (_courseType != courseType) {
        _courseType = courseType;
        [_header beginRefreshing];
    }
}

#pragma mark -刷新数据
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        _classResourceData = [[NSMutableArray alloc]init];
        _page = 1;
        
        /*
         根据班级Code查出课次
         [Get] + Auth
         /api/User/lessonListByClassID?sCode=[班级Code]
         */
        NSDictionary *codeDic = @{@"sClassId":[_dicData objectForKey:@"sClassId"]};
        //只有第一次进行查询课次
        [[RusultManage shareRusultManage]studyGetLessonRusult:codeDic viewController:nil successData:^(NSDictionary *result) {
            NSArray *classLesson = [result objectForKey:@"Data"];
            if ([self.classCodeData isEqualToArray:classLesson]) {
                return;
            }
            self.classCodeData = classLesson;
            _list.classCount = classLesson;
//            [refreshView endRefreshing];
        } errorData:^(NSError *error) {
            [refreshView endRefreshing];
        }];

        
    }else
    {
        _page++;
    }
    //获取班级的资料列表
    /*
     cId=[班级号]&
     courseType=[资料类别(1听、2说、3读、4写、5词、6语、7综)]&
     mateName=[资料名称]&
     ccId=[课次]&
     pageIndex=[第几页(从1开始)]
     */
//    NSLog(@"%@",_ccId);
//    NSLog(@"%@",_courseType);
//    NSLog(@"%@",_searchTextField.text);
    NSString *string = [NSString stringWithFormat:@"%ld",(long)_page];
    NSDictionary *dic = @{@"cId":[_dicData objectForKey:@"id"],
                          @"courseType":_courseType,
                          @"mateName":_searchTextField.text,
                          @"ccId":_ccId,
                          @"pageIndex":string};
    
    [[RusultManage shareRusultManage]studyGetClassResourecRusult:dic viewController:nil successData:^(NSDictionary *result) {
        
        if ([[result objectForKey:@"Result"]boolValue]) {
            NSArray *classLesson = [result objectForKey:@"Data"];
            [_classResourceData addObjectsFromArray:classLesson];
            
            [_tableView reloadData];
            [refreshView endRefreshing];
            
            // 1.根据数量判断是否需要隐藏上拉控件
            if (classLesson.count < 20 || classLesson.count ==0 ) {
                [_foot finishRefreshing];
            }else
            {
                [_foot endRefreshing];
            }
        }else
        {
            [refreshView endRefreshing];
            [[RusultManage shareRusultManage]tipAlert:[result objectForKey:@"Infomation"] viewController:self.viewController];
        }
    } errorData:^(NSError *errors) {
        [refreshView endRefreshing];
    }];

}

//对text编码、解码
//- (NSString *)encodeToPercentEscapeString: (NSString *) input
//{
//    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                                                           (CFStringRef)input,
//                                                                           NULL,
//                                                                           CFSTR("!*'();:@&=+$,/?%#[]"),
//                                                                           kCFStringEncodingUTF8));
//
//    return result;
//}
//
//- (NSString *)decodeFromPercentEscapeString: (NSString *) input
//{
//    NSMutableString *outputStr = [NSMutableString stringWithString:input];
//    [outputStr replaceOccurrencesOfString:@"+"
//                               withString:@" "
//                                  options:NSLiteralSearch
//                                    range:NSMakeRange(0, [outputStr length])];
//    
//    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//}

#pragma mark -IListTabelViewDelegate
- (void)selectIndexRow:(NSString *)index
{
    self.ccId = index;
}

#pragma mark -布局layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    //七中类型的按钮  (305-104)/2   41*41
    NSArray *normalArray = @[@"mater_normal_01.png",
                             @"mater_normal_02.png",
                             @"mater_normal_03.png",
                             @"mater_normal_04.png",
                             @"mater_normal_05.png",
                             @"mater_normal_06.png",
                             @"mater_normal_07.png",
                             @"study abroad_gray.png"];
    
        NSArray *hlArray = @[@"mater_hl_01.png",
                             @"mater_hl_02.png",
                             @"mater_hl_03.png",
                             @"mater_hl_04.png",
                             @"mater_hl_05.png",
                             @"mater_hl_06.png",
                             @"mater_hl_07.png",
                             @"study_abroad.png"];
    
    NSArray *titleArray = @[@"听力",@"口语",@"阅读",@"写作",@"词汇",@"语法",@"综合",@"留学"];

    for (int i=0; i<8; i++) {
        _button  =[UIButton buttonWithType:UIButtonTypeCustom];
        
        NSString *normalImg = normalArray[i];
        NSString *hlImg = hlArray[i];
        NSString *title = titleArray[i];
        
        _button.frame = CGRectMake(30+i*(kClassButtonWidth+20), (100-kClassButtonWidth)/2, kClassButtonWidth, kClassButtonWidth);
        [_button setBackgroundImage:[UIImage imageNamed:normalImg] forState:UIControlStateNormal];
        [_button setBackgroundImage:[UIImage imageNamed:hlImg] forState:UIControlStateSelected];
        
        _button.tag = i+1;
        [_button addTarget:self action:@selector(typeSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30+i*(kClassButtonWidth+20), _button.bottom, _button.width, 20)];
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.text = title;
        [self addSubview:label];
    }

    _searchTextField.frame = CGRectMake(100+7*51+70, (100-30)/2,self.width-(100+7*51+70)-30, 30);
    
    _list.frame = CGRectMake(0, kClassOtherHeight, self.width, kClassSelectHeight);
    _lineLabel1.frame = CGRectMake(0, 0, self.width, 0.5);
    _lineLabel2.frame = CGRectMake(0, kClassSelectHeight-1, self.width, 0.5);
    
    _tableView.frame = CGRectMake(0, kClassTopHeight, self.width, self.height-kClassTopHeight);
    
    _classNameLabel.frame = CGRectMake(10, 70, 50, 30);
    
}
//选择7种类型
- (void)typeSelectAction:(UIButton *)button
{
    NSLog(@"%ld",(long)button.tag);
    if (_button.tag != button.tag) {
        // 1.控制状态
        _button.selected = NO;
         button.selected = YES;
        _button = button;
        self.courseType = [NSString stringWithFormat:@"%ld",(long)button.tag];
    }else
    {//2.取消状态
        _button.selected = !_button.selected;
        if (_button.selected) {
            self.courseType = [NSString stringWithFormat:@"%ld",(long)button.tag];
        }else
        {
            self.courseType = @"";
        }
    }
}
#pragma mark - 收藏代理
- (void)cancelCollent
{
    [_header beginRefreshing];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _classResourceData.count;
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
    if (_classResourceData.count > 0) {
        cell.dicData = _classResourceData[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_classResourceData.count > 0) {
        NSDictionary *dic = _classResourceData[indexPath.row];
        if (![[dic objectForKey:@"Url"] isKindOfClass:[NSNull class]]) {
            NSString *url =  [dic objectForKey:@"Url"];
            if (url.length > 0) {
                
                BOOL st_idStatus = [[dic objectForKey:@"Status"] boolValue];
                NSString *st_Id = [[dic objectForKey:@"ST_ID"]stringValue];
                if (!st_idStatus) {
                    [[RusultManage shareRusultManage]tellServerTaskSTID:st_Id];
                }
                
                XDFCCAndGouKuaiViewController *ccAndGoukuai = [[XDFCCAndGouKuaiViewController alloc]init];
                ccAndGoukuai.urlPath = url;
                ccAndGoukuai.listData = _classResourceData;
                ccAndGoukuai.indexPathRow = indexPath.row;
                ccAndGoukuai.taskType = WhereTaskTypeMaterials;
                ccAndGoukuai.delegate = self;
                [self.viewController.parentViewController.parentViewController.navigationController pushViewController:ccAndGoukuai animated:YES];
            }else
            {
                NDLog(@"链接不存在");
                [[RusultManage shareRusultManage]tipAlert:@"链接无效,请与管理员联系！" viewController:self.viewController.parentViewController.parentViewController];
            }
        }else{
            NDLog(@"无效链接");
            [[RusultManage shareRusultManage]tipAlert:@"链接无效,请与管理员联系！" viewController:self.viewController.parentViewController.parentViewController];
        }
    }
}
#pragma mark -XDFCCAndGouKuaiViewControllerDelegate
- (void)ccAndGouKuaiCancal
{
   [_header beginRefreshing];
}

#pragma mark -
#pragma mark - UITextFieldDelegate
//开始编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self _initMask:textField];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self maskControlView:_maskControlView];
    //进行搜索
//    NSLog(@"%@",_searchTextField.text);
    if (_searchTextField.text.length > 0) {
        [_header beginRefreshing];
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self maskControlView:_maskControlView];
    return YES;
}

#pragma mark - 实现点击键盘以外都收起键盘
- (void)_initMask:(UITextField *)textField
{
    //创建点击视图
    if (_maskControlView == nil) {
        _maskControlView = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [_maskControlView addTarget:self action:@selector(maskControlView:) forControlEvents:UIControlEventTouchUpInside];
        _maskControlView.backgroundColor = [UIColor clearColor];
        
        [self.viewController.view insertSubview:_maskControlView belowSubview:textField];
    }
}
//隐藏alert
- (void)maskControlView:(UIControl *)maskView
{
    [_maskControlView removeFromSuperview];
    _maskControlView = nil;
    [_searchTextField resignFirstResponder];
}


@end
