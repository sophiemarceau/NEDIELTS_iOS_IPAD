//
//  ExerciseViewController.m
//  IELTS
//
//  Created by 李牛顿 on 14-11-12.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import "ExerciseViewController.h"
#import "AMProgressView.h"
#import "XDFExerciseTabelView.h"
//#import "XDFExerciseTaskButton.h"
#import "XDFExercisesTaskButton.h"


#define kExerciseViewTopHeight 171
#define kExerciseViewMiddleHeight 200
#define kExerciseViewBottomHeight  (kScreenHeight-kExerciseViewTopHeight-kExerciseViewMiddleHeight-20)

#define kExerciseViewWidth  (kScreenWidth-DEFAULT_TAB_BAR_HEIGHT-20)

@interface ExerciseViewController ()<XDFExerciseTabelViewDelegate>

@property (nonatomic,strong)UILabel *exeNumberLabel;
@property (nonatomic,strong)AMProgressView *pv3 ;  //顶部

@property (nonatomic,strong)XDFExerciseTabelView *posterTable2; //中部

@property (nonatomic,strong)UIView *bottomView;  //底部

@property (nonatomic,assign)BOOL isShowPage;

@end

@implementation ExerciseViewController
@synthesize exeNumberLabel,pv3,posterTable2;

- (void)viewDidLoad {
    [super viewDidLoad];
   //1.创建顶部视图
    [self _initTopView];
   //2.创建中部视图
    [self _initMiddleView];
    //3.创建底部视图
    [self _initBottomView];
    
    _isShowPage = YES;
    //4.请求数据
//    [self _requestData];
}

//网络请求
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //4.请求数据
    if (_isShowPage) {
        [self _requestData];
    }
}

- (void)_requestData
{
    [[RusultManage shareRusultManage]exerciseRusultController:self successData:^(NSDictionary *result) {
       NSDictionary *dicData = [result objectForKey:@"Data"];
       NSDictionary *lxAllProgress  = [dicData objectForKey:@"lxAllProgress"];    //顶部完成进度
       NSArray *rwDayProgressList  =  [dicData objectForKey:@"rwDayProgressList"];//中部练习进度表
       NSArray *rwSimpleType  =  [dicData objectForKey:@"rwSimpleTypeList"];     //下面种类
#pragma mark -刷新数据
        //-------顶部--------
        NSInteger com = [[lxAllProgress objectForKey:@"allLx"] integerValue];
        NSInteger sums = [[lxAllProgress objectForKey:@"finishLx"] integerValue];
        NSInteger complete =  com > 0 ? com : 0;
        NSInteger sum = sums > 0 ? sums : 0;
        pv3.progress =(CGFloat)sum/complete;
        
        NSString *textNumber = [NSString stringWithFormat:@"%ld/%ld",(long)sum,(long)complete];
        exeNumberLabel.text = textNumber;
        
        //-------中部--------
        NSMutableArray *data = [[NSMutableArray alloc]init];
        [data addObject:@"更多"];
        if (rwDayProgressList.count > 0) {
            [data addObjectsFromArray:rwDayProgressList];
        }
        posterTable2.rwDayProgressList = rwDayProgressList;
        posterTable2.data = data;
        [posterTable2 reloadData];
        //开始让table滑到最后一个
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(data.count-1) inSection:0];
        [posterTable2 scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        
        //-------底部--------
        [self _dealBottomData:rwSimpleType];
    }];
}
- (void)_dealBottomData:(NSArray *)data
{
    
    for (int i=0; i< 7; i++){
        XDFExercisesTaskButton *taskView2 = (XDFExercisesTaskButton *)[_bottomView viewWithTag:i+1];
        NSString *taTag = [NSString stringWithFormat:@"%d",i+1];
        if ([[[data[i] objectForKey:@"type"]stringValue] isEqualToString:taTag]) {
            taskView2.nums = [data[i] objectForKey:@"num"];
        }
    }
    
//    NSArray *titles = @[@"Listening",
//                        @"Speaking",
//                        @"Reading",
//                        @"Writing",
//                        @"Vocabulary",
//                        @"Grammar",
//                        @"Synthetic"];
//    
//    NSArray *imgName = @[@"iconExercise_150_01.png",
//                         @"iconExercise_150_02.png",
//                         @"iconExercise_150_03.png",
//                         @"iconExercise_150_04.png",
//                         @"iconExercise_150_05.png",
//                         @"iconExercise_150_06.png",
//                         @"iconExercise_150_07.png"];
//    
//    int a=0,b=0;
//    for (int i=0; i< titles.count; i++){
//        if (i%5==0 && i!= 0) {
//            b++;
//            a = 0;
//        }
//        
//        XDFExercisesTaskButton *taskView2 =  [[XDFExercisesTaskButton alloc]init];
//        taskView2.frame = CGRectMake(50+a*170, 40/*黑线的高度*/+40+140*b, 85, 105);
//        taskView2.tag = i+1;
//        NSString *taTag = [NSString stringWithFormat:@"%d",i+1];
//
//        if ([[[data[i] objectForKey:@"type"]stringValue] isEqualToString:taTag]) {
//            taskView2.nums = [data[i] objectForKey:@"num"];
//        }
//        taskView2.titleName = titles[i];
//        taskView2.imgName = imgName[i];
//        [_bottomView addSubview:taskView2];
//        a++;
//    }
}

#pragma mark - 初始化视图
//1.创建顶部视图
-(void)_initTopView
{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kExerciseViewWidth, kExerciseViewTopHeight)];
    topView.backgroundColor = [UIColor whiteColor];
    //1创建标题
    UILabel *titleLabel = [ZCControl createLabelWithFrame:CGRectMake(30, 30, 200, 30) Font:18.0f Text:@"练习总进度:"];
    titleLabel.font = [UIFont systemFontOfSize:20.0f];
    titleLabel.textColor = rgb(36, 36, 57, 1.0);
    [topView addSubview:titleLabel];
    
    //2创建进度
//    NSLog(@"%f", (topView.width-30)/2);
    // Instantiate: red to yellow with slow animation for value changes
    pv3 = [[AMProgressView alloc] initWithFrame:CGRectMake(30, 90, topView.width-30*2-150, 20)
                                              andGradientColors:[NSArray arrayWithObjects:rgb(191, 207, 255, 1), rgb(126, 188, 255, 1), rgb(115, 115, 255, 1), nil]
                                               andOutsideBorder:NO
                                                    andVertical:NO];
    // Configure
    pv3.layer.cornerRadius = 10;
    pv3.layer.masksToBounds = YES;
    pv3.emptyPartAlpha = 1;
    pv3.progressAnimationDuration = 2.0f;
    // Display
    [topView addSubview:pv3];
    //3.创建个数
    exeNumberLabel = [ZCControl createLabelWithFrame:CGRectMake(pv3.right+20, pv3.top, 100, 20) Font:14.0f Text:@""];
    [topView addSubview:exeNumberLabel];
    [self.view addSubview:topView];
}

//2.创建中部视图
-(void)_initMiddleView
{
    UIView *middle = [[UIView alloc]initWithFrame:CGRectMake(5, kExerciseViewTopHeight+5, kExerciseViewWidth, kExerciseViewMiddleHeight)];
    middle.backgroundColor = [UIColor clearColor];

    posterTable2 =[[XDFExerciseTabelView alloc]initWithFrame:CGRectMake(0, 5, middle.width, middle.height) style:UITableViewStylePlain];
    posterTable2.rowHeight = 190;
    posterTable2.backgroundColor = [UIColor clearColor];
    posterTable2.exerciseDelegate = self;
    [middle addSubview:posterTable2];
    
    [self.view addSubview:middle];

}

#pragma mark-点击更多 跳转页面
- (void)exerciseSelectIndexRow
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(exerciseToPage:)]) {
        [self.delegate exerciseToPage:1];
    }
}

//3.创建底部视图
-(void)_initBottomView
{
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(10, kExerciseViewTopHeight+kExerciseViewMiddleHeight, kExerciseViewWidth, kExerciseViewBottomHeight)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    
    //1.添加title
    UILabel *taskTitle = [ZCControl createLabelWithFrame:CGRectMake(30, 0, 100, 50) Font:18.0f Text:@"单项任务"];
    taskTitle.font = [UIFont systemFontOfSize:20.0f];
    [_bottomView addSubview:taskTitle];
    
    //2.添加分割线
    UILabel *lineLabel = [ZCControl createLabelLineFrame:CGRectMake(30, 50, _bottomView.width-60, 1)];
    [_bottomView addSubview:lineLabel];
    
    //3.添加按钮
    NSArray *titles = @[@"Listening",
                        @"Speaking",
                        @"Reading",
                        @"Writing",
                        @"Vocabulary",
                        @"Grammar",
                        @"Synthetic"];
    
    NSArray *imgName = @[@"iconExercise_150_01.png",
                         @"iconExercise_150_02.png",
                         @"iconExercise_150_03.png",
                         @"iconExercise_150_04.png",
                         @"iconExercise_150_05.png",
                         @"iconExercise_150_06.png",
                         @"iconExercise_150_07.png"];
    
    int a=0,b=0;
    for (int i=0; i< titles.count; i++){
        if (i%5==0 && i!= 0) {
            b++;
            a = 0;
        }
        XDFExercisesTaskButton *taskView2 =  [[XDFExercisesTaskButton alloc]init];
        taskView2.frame = CGRectMake(50+a*170, 40/*黑线的高度*/+40+140*b, 85, 105);
        taskView2.tag = i+1;
        taskView2.titleName = titles[i];
        taskView2.imgName = imgName[i];
        [_bottomView addSubview:taskView2];
        a++;
    }

    [self.view addSubview:_bottomView];
}
@end
