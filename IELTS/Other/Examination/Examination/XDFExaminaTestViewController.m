//
//  XDFExaminaTestViewController.m
//  IELTS
//
//  Created by 李牛顿 on 14-12-5.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFExaminaTestViewController.h"
#import "XDFExaminaDetailViewController.h"
#import "XDFExaminSegement.h"

@interface XDFExaminaTestViewController ()<XDFExaminaDetailViewDelegate>

@property (nonatomic,strong)XDFExaminaDetailViewController *examinaDetailViewController;

@property (nonatomic,assign)NSInteger rememberPage;  //记录前后退的页面

@property (nonatomic,strong)XDFExaminSegement *segmentMenu;
//@property (nonatomic,strong)NSMutableArray *pageArray;

@property (nonatomic,strong)NSIndexPath *selectIndexPath;//选中效果
@property (nonatomic,assign)NSInteger selectRow;

@end
@implementation XDFExaminaTestViewController
@synthesize examinaDetailViewController;


- (void)viewDidLoad {
    [super viewDidLoad];
    //隐藏星星按钮
    self.starButton.hidden = YES;
    
    //创建视图，每个seciton分了多个segment
    NSMutableArray *titlesArray = [[NSMutableArray alloc]initWithCapacity:_dataArray.count];
    for (NSDictionary *dic in _dataArray) {
        NSString *qNumberBegin =  [dic objectForKey:@"QNumberBegin"];
        NSString *qNumberEnd  = [dic objectForKey:@"QNumberEnd"];
        NSString *titles = [NSString stringWithFormat:@"%@—%@",qNumberBegin,qNumberEnd];
        [titlesArray addObject:titles];
    }
    //创建segment
    self.segmentMenu = [[XDFExaminSegement alloc] initWithTitles:titlesArray
                                                       AndFrame:CGRectMake(0, 100,self.leftView_.width,titlesArray.count*60)];
    self.segmentMenu.backgroundColor = [UIColor clearColor];
    self.segmentMenu.cellTittleColor = [UIColor whiteColor];
    [self.leftView_ addSubview:self.segmentMenu];
    
    __block  XDFExaminaTestViewController *this = self;
    self.segmentMenu.indexChangeBlock = ^(NSInteger index) {
        [this changeDate:index];
    };
    
    //默认选择的Row
    self.selectRow = 0;
    //默认选择第一个cell
    NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
    self.selectIndexPath = ip;
    [self.segmentMenu selectRowAtIndexPath:ip animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    //默认为第一页,前后页的标记
    self.rememberPage = 0;
    
    //禁用按钮
    UIButton *nextButton = (UIButton *)[super.view viewWithTag:101];
    UIButton *beforeButton = (UIButton *)[super.view viewWithTag:100];
    
    //当前pageList有多少页
    NSArray *currentPageList = [_dataArray[0] objectForKey:@"QuestionPageList"];
    if (self.rememberPage == 0 ) {
        
        beforeButton.enabled = NO;
        
    }else if (self.rememberPage == currentPageList.count-1)
    {
        nextButton.enabled = NO;
    }
    
    //创建内容标签
    examinaDetailViewController = [[XDFExaminaDetailViewController alloc]init];
    examinaDetailViewController.delegate = self;
    examinaDetailViewController.curentSections = self.currentSeciton;
    [self addContentViewController:examinaDetailViewController];

}

//切换左侧题目
- (void)changeDate:(NSInteger)select
{
    //保存选中的row
    self.selectRow = select;
     //标记选中班级
    NSIndexPath *ip = [NSIndexPath indexPathForRow:select inSection:0];
    self.selectIndexPath = ip;
    //取出PageList的字典选择的数据
    NSDictionary *selectData = _dataArray[select];
    
    NSString *savZipFloderPath = [[DownLoadManage ShardedDownLoadManage]useIDSelect:self.pId];
    NSArray *questionPageList = [selectData objectForKey:@"QuestionPageList"];
    if (questionPageList.count > 0) {
        NSDictionary *pageList =  questionPageList[0];
        NSArray *audioArray = [pageList objectForKey:@"AudioFiles"];
        if (audioArray.count > 0) {
            NSString *audioString = audioArray[0];
            examinaDetailViewController.audioFiles = [NSString stringWithFormat:@"%@/%@",savZipFloderPath,audioString];
        }
        
        NSString *FileName = [pageList objectForKey:@"FileName"];
        //获取第一个pagelist的第一页
        NSString *textPath = [NSString stringWithFormat:@"%@/%@",savZipFloderPath,FileName];
        examinaDetailViewController.urlPath = textPath;
    }
}


//前后切换当前segement下的pagelist
- (void)_dealSectionList:(NSInteger)intege
{
    if (intege >= _dataArray.count) { //防住数组越界
        return;
    }
    self.rememberPage = intege;
    //试卷解压后得文件夹路径
    NSString *savZipFloderPath = [[DownLoadManage ShardedDownLoadManage]useIDSelect:self.pId];
    NSArray *pageList =  [_dataArray[self.selectRow] objectForKey:@"QuestionPageList"]; //每个section下面的页数
    NSDictionary *curentPageDic = pageList[intege];
//
    NSArray *audioFiles =  [curentPageDic objectForKey:@"AudioFiles"];
    if (audioFiles.count > 0) {
        NSString *audioFilePath = [NSString stringWithFormat:@"%@/%@",savZipFloderPath,audioFiles[0]];
        examinaDetailViewController.audioFiles = audioFilePath;
    }
    NSString *fileName = [curentPageDic objectForKey:@"FileName"];
    NSString *urlPath = [NSString stringWithFormat:@"%@/%@",savZipFloderPath,fileName];
    examinaDetailViewController.urlPath = urlPath;
}

#pragma mark - 前进后退 控制页数和点击事件
//后退
- (void)leftAction:(UIButton *)button
{

    UIButton *nextButton = (UIButton *)[super.view viewWithTag:101];
    if (self.rememberPage == 0) {
        button.enabled = NO;
    }else
    {
        button.enabled = YES;
        nextButton.enabled = YES;
        
        NSInteger curentPage = self.rememberPage-1;
        if (curentPage == 0) {
            button.enabled = NO;
            self.rememberPage = curentPage;
        }else
        {
            self.rememberPage = curentPage;
            [self _dealSectionList:self.rememberPage];
        }
    }
}
//前进
- (void)rightAction:(UIButton *)button
{
    UIButton *beforeButton = (UIButton *)[super.view viewWithTag:100];
    
    NSArray  *currentPageList = [_dataArray[self.selectRow] objectForKey:@"QuestionPageList"];
    if (self.rememberPage == currentPageList.count-1) {
        button.enabled = NO;
    }else
    {
        button.enabled = YES;
        beforeButton.enabled = YES;
        
        NSInteger curentPage = self.rememberPage+1;
        if (curentPage == currentPageList.count-1) {
            button.enabled = NO;
            self.rememberPage = curentPage;
        }else
        {
            self.rememberPage = curentPage;
            [self _dealSectionList:self.rememberPage];
        }
    }
    
}

//完成之后
- (void)examinaDetailFinishs:(NSInteger)pageIndex
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(examinaFinishs:)]) {
        [self.delegate examinaFinishs:pageIndex];
    }
}




@end
