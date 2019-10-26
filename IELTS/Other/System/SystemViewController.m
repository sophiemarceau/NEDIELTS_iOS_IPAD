//
//  SystemViewController.m
//  IELTS
//
//  Created by 李牛顿 on 14-11-12.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import "SystemViewController.h"
#import "SMVerticalSegmentedControl.h"
#import "SegmentTableMenu.h"
#import "BaseSubView.h"

#define kSystemLeftViewWidth 200

@interface SystemViewController ()

@property (nonatomic,strong)UIView *systemLeftViews;
@property (nonatomic,strong)UIView *systemRightViews;

@property (nonatomic,strong) SMVerticalSegmentedControl *segmentedControl;
@property (nonatomic,strong) SegmentTableMenu *segmentedTableMenu;

@property (nonatomic,assign)UIView *currentSelectView;
@property (nonatomic,strong)NSMutableArray *leftViewList;
@property (nonatomic,strong)UIView *leftMenuMaskView;

@end

@implementation SystemViewController
@synthesize systemLeftViews,systemRightViews;
//@synthesize newsLabel,newsLabel2;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self _initLeftView];
    
    [self _initRightView];
    
//    [self _initSegmentView];

    [self _initLeftMenu];
}


#pragma mark -
#pragma mark - 选项
- (void)_initLeftView
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kUpdateBage object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(upDateBage:) name:kUpdateBage object:nil];
    
    systemLeftViews = [ZCControl viewWithFrame:CGRectMake(0, 0, kSystemLeftViewWidth, kScreenHeight)];
    systemLeftViews.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:systemLeftViews];
    
    UIView *vLine = [[UIView alloc] initWithFrame:CGRectMake(systemLeftViews.width, 0, 0.5, systemLeftViews.frame.size.height)];
    vLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:vLine];
}
#pragma mark -
#pragma mark - 内容
- (void)_initRightView
{
   // systemRightViews = [ZCControl viewWithFrame:CGRectMake(systemLeftViews.right+1,0, kScreenWidth-kSystemLeftViewWidth-DEFAULT_TAB_BAR_HEIGHT, kScreenHeight)];

    systemRightViews = [ZCControl viewWithFrame:CGRectMake(systemLeftViews.right+1,0,1024-kSystemLeftViewWidth-DEFAULT_TAB_BAR_HEIGHT, kScreenHeight)];
    
    systemRightViews.backgroundColor = [UIColor clearColor];
    [self.view addSubview:systemRightViews];
}

- (void)_initLeftMenu
{
    NSArray *titles = @[@"账号管理", @"绑定学员号", @"我的消息",@"我的目标",@"意见反馈",@"关于我们"];
    self.segmentedTableMenu = [[SegmentTableMenu alloc] initWithTitles:titles
                                                              AndFrame:CGRectMake(0, 20,
                                self.systemLeftViews.frame.size.width,
                                self.systemLeftViews.frame.size.height)];
    self.segmentedTableMenu.backgroundColor = [UIColor clearColor];
    self.segmentedTableMenu.cellTittleColor = rgb(72, 72, 72, 1.0);
    [systemLeftViews addSubview:self.segmentedTableMenu];
    
    
    __block SystemViewController *this = self;
    self.segmentedTableMenu.indexChangeBlock = ^(NSInteger index)
    {
        [this _initCreatView:index];
    };
    
    self.leftMenuMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 20,
                                                                     self.systemLeftViews.width,
                                                                     self.systemLeftViews.height)];
    
    [self.leftMenuMaskView setAlpha:0.3];
    self.leftMenuMaskView.backgroundColor = [UIColor grayColor];
    [self.leftMenuMaskView setHidden:YES];
    [systemLeftViews addSubview:self.leftMenuMaskView];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowLeftMaskView) name:@"ShowLeftMaskView" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onHideLeftMaskView) name:@"HideLeftMaskView" object:nil];
    
    _leftViewList = [NSMutableArray arrayWithCapacity:0];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Sys_AccountView" owner:self options:nil];
    [_leftViewList addObject:[nib objectAtIndex:0]];
    
    nib = [[NSBundle mainBundle] loadNibNamed:@"Sys_ClassNumberBindView" owner:self options:nil];
    [_leftViewList addObject:[nib objectAtIndex:0]];
    
    nib = [[NSBundle mainBundle] loadNibNamed:@"Sys_MyMessageView" owner:self options:nil];
    [_leftViewList addObject:[nib objectAtIndex:0]];
    
    nib = [[NSBundle mainBundle] loadNibNamed:@"Sys_MyTargetView" owner:self options:nil];
    [_leftViewList addObject:[nib objectAtIndex:0]];
    
    nib = [[NSBundle mainBundle] loadNibNamed:@"Sys_SuggestView" owner:self options:nil];
    [_leftViewList addObject:[nib objectAtIndex:0]];
    
    nib = [[NSBundle mainBundle] loadNibNamed:@"Sys_AboutView" owner:self options:nil];
    [_leftViewList addObject:[nib objectAtIndex:0]];
    

    [self _initCreatView:0];
    [self selectAction:0];
    
    
//    NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:1];
//    [self.segmentedTableMenu selectRowAtIndexPath:ip animated:NO scrollPosition:UITableViewScrollPositionNone];
    
}
- (void)selectAction:(NSInteger)select
{
    if (self.segmentedTableMenu != nil) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:select inSection:0];
        [self.segmentedTableMenu selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }

}


- (void)changeindexTabToNews
{
    [self selectAction:2];
    [self _initCreatView:2];
}

- (void)changeindexTabToTageter
{
    [self selectAction:3];
    [self _initCreatView:3];

}
- (void)changeindexTabToUsesInfo
{
    [self selectAction:0];
    [self _initCreatView:0];
}
//

- (void)upDateBage:(NSNotification *)notification
{
    //调用未读消息
    [self noReadMessage];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //请求未读消息
    [self noReadMessage];
}

- (void)noReadMessage
{
    [[RusultManage shareRusultManage]sysMyAllMessageCountController:nil
                                                        SuccessData:^(NSDictionary *result) {
                                                            NSDictionary *data = [result objectForKey:@"Data"];
                                                            if (data.count > 0) {
                                                                if (![[data objectForKey:@"noReadCount"] isKindOfClass:[NSNull class]]) {
                                                                    int noRead =  [[data objectForKey:@"noReadCount"] intValue];
                                                                    [self.segmentedTableMenu updateBage:2 Number:noRead];
                                                                    [self.segmentedTableMenu reloadData];
                                                                }
                                                            }
                                                        } errorData:^(NSError *error) {
                                                            
                                                        }];
}


- (void)onShowLeftMaskView
{
    [self.leftMenuMaskView setHidden:NO];
}

-(void)onHideLeftMaskView
{
    [self.leftMenuMaskView setHidden:YES];
}

- (void)_initCreatView:(NSInteger)select
{
    
    if(_currentSelectView != nil)
    {
        [_currentSelectView removeFromSuperview];
    }
    
    _currentSelectView = [_leftViewList objectAtIndex:select];
    
    [((BaseSubView *)_currentSelectView) initView:self];
    [((BaseSubView *)_currentSelectView) onDisplayView];
   
    _currentSelectView.frame = CGRectMake(0, 0,
                                          self.systemRightViews.width,
                                          self.systemRightViews.height);
    [self.systemRightViews addSubview:_currentSelectView];
}


@end
