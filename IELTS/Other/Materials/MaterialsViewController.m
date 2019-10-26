//
//  MaterialsViewController.m
//  IELTS
//
//  Created by 李牛顿 on 14-11-12.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import "MaterialsViewController.h"
#import "MyCollect.h"
#import "ClassMaterView.h"

#import "SegmentTableMenu.h"

#define kMaterialsLeftViewWidth 170

@interface MaterialsViewController ()

@property (nonatomic,strong)UIView *masterLeftViews;
@property (nonatomic,strong)UIView *masterRightViews;

@property (nonatomic,strong)NSArray *classData;      //保存班级请求数据

@property (nonatomic,strong) SegmentTableMenu *segmentedControl;
@property (nonatomic,strong) ClassMaterView *classMaterView;
@property (nonatomic,strong) MyCollect *collectView;

@property (nonatomic,strong)NSIndexPath *selectIndexPath;
@property (nonatomic,strong)UIButton *collectButton ;
@end

@implementation MaterialsViewController

@synthesize masterLeftViews,masterRightViews,collectButton;


- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化班级数据
    _classData = [[NSArray alloc]init];
  
    //数据请求
    [self _initRequestData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (_collectView!=nil) {
        [_collectView.header beginRefreshing];
    }
    
    if (_classMaterView !=nil) {
        [_classMaterView.header beginRefreshing];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self hideHud];
}


- (void)_initRequestData
{
    //得到班级信息
//    [self showHintNoHide:@"正在加载..."];
    [[RusultManage shareRusultManage]studyGetClassRusult:self successData:^(NSDictionary *result) {
//        [self hideHud];
        if (![[result objectForKey:@"Data"] isKindOfClass:[NSNull class]]) {
            NSArray *dataArray =  [result objectForKey:@"Data"];
            self.classData = dataArray;
            if (dataArray.count > 0) {
                //侧边收藏
                [self _initLeftView];
                //右侧
                [self _initRightView];
                //侧边分栏控制
                [self _initSegmentView];
            }
        }else
        {
            [[RusultManage shareRusultManage]tipAlert:@"无班级信息，请检测是否绑定学员号！" viewController:self];
        }
    }errorData:^(NSError *error) {
//        [self hideHud];
    }];
}


- (void)_initSegmentView
{
    UILabel *label = [ZCControl createLabelWithFrame:CGRectMake(0, 0, kMaterialsLeftViewWidth, 30) Font:18.0f Text:@"班级列表"];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor =[UIColor whiteColor];
    label.backgroundColor = rgb(158, 174, 217, 1);
    [masterLeftViews addSubview:label];
    
    NSMutableArray *titlesArray = [[NSMutableArray alloc]initWithCapacity:self.classData.count];
    for (NSDictionary *classDIC in self.classData) {
         NSString *title = [classDIC objectForKey:@"sName"];
        [titlesArray addObject:title];
    }
    self.segmentedControl = [[SegmentTableMenu alloc] initWithTitles:titlesArray
                                                            AndFrame:CGRectMake(10, 50,self.masterLeftViews.width-20,self.masterLeftViews.height)];
    self.segmentedControl.backgroundColor = [UIColor clearColor];
    self.segmentedControl.cellTittleColor = rgb(72, 72, 72, 1.0);
    self.segmentedControl.rowHeight = 70;
    [masterLeftViews addSubview:self.segmentedControl];
    
    __block  MaterialsViewController *this = self;
    self.segmentedControl.indexChangeBlock = ^(NSInteger index) {
        [this _initCreatView:index data:this.classData[index]];
    };
    
    //班级资料
    _classMaterView = [[ClassMaterView alloc]initWithFrame:CGRectMake(0, 0, masterRightViews.width, masterRightViews.height)];
    _classMaterView.dicData = self.classData[0];
    [masterRightViews addSubview:_classMaterView];
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
    self.selectIndexPath = ip;
    [self.segmentedControl selectRowAtIndexPath:ip animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)_initCreatView:(NSInteger)select  data:(NSDictionary *)dic
{
    collectButton.selected = NO;//取消收藏的选择
    NSIndexPath *ip = [NSIndexPath indexPathForRow:select inSection:0];   //标记选中班级
    self.selectIndexPath = ip;
    
    if (_collectView != nil) {
        [_collectView removeFromSuperview];
        _collectView = nil;
    }
    //班级
    if (_classMaterView == nil) {
        _classMaterView = [[ClassMaterView alloc]initWithFrame:CGRectMake(0, 0, masterRightViews.width, masterRightViews.height)];
        [masterRightViews addSubview:_classMaterView];
    }
    _classMaterView.dicData = dic;
}

#pragma mark -
#pragma mark - 左侧班级
- (void)_initLeftView
{
    masterLeftViews = [ZCControl viewWithFrame:CGRectMake(0, 0,kMaterialsLeftViewWidth, kScreenHeight)];
    masterLeftViews.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [ZCControl createLabelLineFrame:CGRectMake(0, kScreenHeight-70, masterLeftViews.width, 0.5)];
    [masterLeftViews addSubview:label];

    
    collectButton = [ZCControl createButtonWithFrame:CGRectMake(0, kScreenHeight-70, masterLeftViews.width, 70) ImageName:@"" Target:self Action:@selector(collectButtonAction:) Title:@""];
    
    [collectButton setBackgroundImage:[ZCControl createImageWithColor:rgb(238, 238, 238, 1)] forState:UIControlStateSelected];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"star.png"]];
    imageView.frame = CGRectMake((masterLeftViews.width-23-80)/2,(70-24)/2, 24, 23);
    [collectButton addSubview:imageView];
    
    UILabel *collectLabel = [ZCControl createLabelWithFrame:CGRectMake(imageView.right, (70-30)/2, 80, 30)
                                                       Font:15.0f
                                                       Text:@"我的收藏"];
    [collectButton addSubview:collectLabel];
    [masterLeftViews addSubview:collectButton];
    
    UIView *vLine = [[UIView alloc] initWithFrame:CGRectMake(masterLeftViews.width, 0, 0.5, masterLeftViews.height)];
    vLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:vLine];

    [self.view addSubview:masterLeftViews];
    
}

#pragma mark -收藏列表
- (void)collectButtonAction:(UIButton *)button
{
    [self.segmentedControl deselectRowAtIndexPath:self.selectIndexPath animated:NO];
    
    if (_classMaterView != nil) {
        [_classMaterView removeFromSuperview];
        _classMaterView = nil;
    }
    //班级
    if (_collectView == nil) {
        _collectView = [[MyCollect alloc]initWithFrame:CGRectMake(0, 0, masterRightViews.width, masterRightViews.height)];
        [masterRightViews addSubview:_collectView];
    }
    button.selected = !button.selected;
}


#pragma mark -
#pragma mark - 右侧资料视图
- (void)_initRightView
{
    masterRightViews = [ZCControl viewWithFrame:CGRectMake(masterLeftViews.right+5, 0, kScreenWidth-kMaterialsLeftViewWidth-DEFAULT_TAB_BAR_HEIGHT-5, kScreenHeight)];
    masterRightViews.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:masterRightViews];
}




@end
