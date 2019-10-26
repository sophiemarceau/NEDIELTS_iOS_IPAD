//
//  XDFCCAndGouKuaiViewController.m
//  IELTS
//
//  Created by 李牛顿 on 14-12-29.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFCCAndGouKuaiViewController.h"

#define  kScaleFloat 0.7
@interface XDFCCAndGouKuaiViewController ()<UIWebViewDelegate>

@property (nonatomic,strong)UIWebView *webView;

@property (nonatomic,strong)UIView *leftView_;
@property (nonatomic,strong)UIButton *starButton ; //星星按钮


@end

@implementation XDFCCAndGouKuaiViewController
@synthesize leftView_,starButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    //创建左侧
    [self leftCC];
    //创建右侧
    [self rightCC];
}

- (void)leftCC
{

    //左边   btn_back.png 93 × 43   arraw_Left.png 86*86 arraw_Right.png
    leftView_ = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kSecondLevelLeftWidth, kScreenHeight)];
    leftView_.backgroundColor = TABBAR_BACKGROUND;
    
    //返回按钮 93/2, 43/2
    CGFloat backW = 93*kScaleFloat;
    CGFloat backH = 43*kScaleFloat;
    
    UIButton *backButton = [ZCControl createButtonWithFrame:CGRectMake((kSecondLevelLeftWidth-backW)/2, 30, backW, backH) ImageName:@"" Target:self Action:@selector(backAction:) Title:@""];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    
    [leftView_ addSubview:backButton];
    
    
    //后退按钮
    CGFloat beforeW = 86*kScaleFloat;
    CGFloat beforeH = 86*kScaleFloat;
    
    UIButton *beforeButton = [ZCControl createButtonWithFrame:CGRectMake((kSecondLevelLeftWidth-beforeW)/2, kScreenHeight-beforeW*2-60, beforeW, beforeH)ImageName:@"" Target:self Action:@selector(leftAction:) Title:@""];
    [beforeButton setBackgroundImage:[UIImage imageNamed:@"arraw_Left.png"] forState:UIControlStateNormal];
    beforeButton.tag = 100;
    [leftView_ addSubview:beforeButton];
    
    //前进按钮
    UIButton *nextButton = [ZCControl createButtonWithFrame:CGRectMake((kSecondLevelLeftWidth-beforeW)/2, kScreenHeight- beforeW-40, beforeH, beforeH) ImageName:@"" Target:self Action:@selector(rightAction:) Title:@""];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"arraw_Right.png"] forState:UIControlStateNormal];
    nextButton.tag = 101;
    [leftView_ addSubview:nextButton];
    
    //收藏按钮 star.png 47*44
    CGFloat starW = 47*kScaleFloat;
    CGFloat starH = 44*kScaleFloat;
    
    starButton = [ZCControl createButtonWithFrame:CGRectMake((kSecondLevelLeftWidth-starW)/2, kScreenHeight-beforeW*3-60, starW, starH)ImageName:@"" Target:self Action:@selector(starAction:) Title:@""];
    [starButton setBackgroundImage:[UIImage imageNamed:@"star-1.png"] forState:UIControlStateNormal];
    [starButton setBackgroundImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateSelected];
    [leftView_ addSubview:starButton];
    
    [self.view addSubview:leftView_];
    
     NDLog(@"%d",self.indexPathRow);
    if (self.indexPathRow == 0 && self.indexPathRow == self.listData.count-1)  {
        beforeButton.enabled = NO;
        nextButton.enabled = NO;
    }else if(self.indexPathRow == self.listData.count-1)
    {
        beforeButton.enabled = YES;
        nextButton.enabled = NO;
        
    }else if (self.indexPathRow == 0 )
    {
        beforeButton.enabled = NO;
        nextButton.enabled = YES;
    }
    
    
    NSDictionary *refData;
    switch (self.taskType) {
        case WhereTaskTypeHome:
        {
            refData = [self.listData[self.indexPathRow] objectForKey:@"RefData"];
        }
            break;
        case WhereTaskTypeMaterials:
        case WhereTaskTypeSchedul:
        {
            refData = self.listData[self.indexPathRow];
        }
            break;
        default:
            break;
    }
    
    NSString *collentMF = [[refData objectForKey:@"MF_ID"] isKindOfClass:[NSNull class]] ?@"": [[refData objectForKey:@"MF_ID"] stringValue];
    if (collentMF.length > 0) {
        starButton.selected = YES;
    }else
    {
        starButton.selected = NO;
    }

}
#pragma mark -leftAction
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
//后退
- (void)leftAction:(UIButton *)button
{
    NDLog(@"后退");
    UIButton *nextButton = (UIButton *)[super.view viewWithTag:101];
    if (self.indexPathRow == 0) {
        button.enabled = NO;
    }else
    {
        button.enabled = YES;
        nextButton.enabled = YES;

        NSInteger indexRow = self.indexPathRow - 1;
        if (indexRow == 0) {
            button.enabled = NO;
        }
        self.indexPathRow = indexRow;

        [self _initRequseData:indexRow];
    }
}
//前进
- (void)rightAction:(UIButton *)button
{
    UIButton *beforeButton = (UIButton *)[super.view viewWithTag:100];
    if (self.indexPathRow == self.listData.count - 1) {
        button.enabled = NO;
    }else
    {
        button.enabled = YES;
        beforeButton.enabled = YES;
        NSInteger indexRow = self.indexPathRow + 1;
        if (indexRow == self.listData.count - 1) {
            button.enabled = NO;
        }
        self.indexPathRow = indexRow;
        
        [self _initRequseData:indexRow];
    }
}

//左右切换刷新数据
- (void)_initRequseData:(NSInteger)index
{
    
    if (index < self.listData.count) {
        //停止web的加载
        [self.webView stopLoading];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //收藏按钮
        NSDictionary *refData;
        //加载新的链接
        NSString *url;
        switch (self.taskType) {
            case WhereTaskTypeHome:
            {
//                url = [[self.listData[index] objectForKey:@"RefData"] objectForKey:@"Url"];
                refData = [self.listData[index] objectForKey:@"RefData"];
                url = [refData objectForKey:@"Url"];
                 NSString *collentMF = [[refData objectForKey:@"MF_ID"] isKindOfClass:[NSNull class]] ? @"": [[refData objectForKey:@"MF_ID"] stringValue];
//                NSString *collentMF = [refData objectForKey:@"MF_ID"];
                if (collentMF.length > 0) {
                    starButton.selected = YES;
                }else
                {
                    starButton.selected = NO;
                }
            }
                break;
            case WhereTaskTypeMaterials:
            {
                refData = self.listData[index];
                url = [refData objectForKey:@"Url"];
//                NSString *collentMF = [refData objectForKey:@"MF_ID"];
                 NSString *collentMF = [[refData objectForKey:@"MF_ID"] isKindOfClass:[NSNull class]] ?@"": [[refData objectForKey:@"MF_ID"] stringValue];
                if (collentMF.length > 0) {
                    starButton.selected = YES;
                }else
                {
                    starButton.selected = NO;
                }
            }
                break;
            case WhereTaskTypeSchedul:
            {
                refData = self.listData[index];
                url = [refData objectForKey:@"Url"];
//                NSString *collentMF = [refData objectForKey:@"MF_ID"];
                 NSString *collentMF = [[refData objectForKey:@"MF_ID"] isKindOfClass:[NSNull class]] ?@"": [[refData objectForKey:@"MF_ID"] stringValue];
                if (collentMF.length > 0) {
                    starButton.selected = YES;
                }else
                {
                    starButton.selected = NO;
                }
            }
                break;

            default:
                break;
        }
        self.urlPath = url;
        [self _loadData];
    }
}


//收藏操作
- (void)starAction:(UIButton *)button
{
    NSNumber *num = [NSNumber numberWithBool:!button.selected];
    NSDictionary *requestDic;
    switch (self.taskType) {
        case WhereTaskTypeHome:
        {
            NSDictionary *refData = [self.listData[self.indexPathRow] objectForKey:@"RefData"];
            requestDic = @{@"mateId":[refData objectForKey:@"Mate_ID"],
                          @"optType":num};
        }
            break;
        case WhereTaskTypeMaterials:
        case WhereTaskTypeSchedul:
        {
            NSDictionary *refData = self.listData[self.indexPathRow];
            requestDic = @{@"mateId":[refData objectForKey:@"Mate_ID"],
                           @"optType":num};
        }
            break;
        default:
            break;
    }
    
    
    button.selected = !button.selected;
//    //添加收藏、取消收藏
    [[RusultManage shareRusultManage]studyCancelAndAddCollectRusult:requestDic
                                                     viewController:nil
                                                        successData:^(NSDictionary *result) {
        NDLog(@"%@",result);
        if (self.delegate && [self.delegate respondsToSelector:@selector(ccAndGouKuaiCancal)]) {
            [self.delegate ccAndGouKuaiCancal];
        }
    }];

}
#pragma mark -
#pragma mark - 右侧
- (void)rightCC
{
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(kSecondLevelLeftWidth, 20, kScreenWidth-kSecondLevelLeftWidth, kScreenHeight)];
    rightView.backgroundColor = rgb(230, 230, 230, 1.0);
    [self.view addSubview:rightView];
    
    _webView = [[UIWebView alloc]init];
    _webView.delegate = self;
    _webView.frame = CGRectMake(0, 0, kScreenWidth-kSecondLevelLeftWidth, kScreenHeight);
    _webView.scalesPageToFit = YES;
    _webView.backgroundColor = [UIColor whiteColor];
    [rightView addSubview:_webView];
    
    [self _loadData];
}

- (void)_loadData
{
    if (self.indexPathRow < self.listData.count) {
        NSDictionary *dataDic = self.listData[self.indexPathRow];
        
        if ([[dataDic objectForKey:@"TF_ID"] isKindOfClass:[NSNull class]]) {
            NSString *stid = [[dataDic  objectForKey:@"ST_ID"] stringValue];
            [[RusultManage shareRusultManage]homeTaskController:nil
                                                          keyID:stid
                                                     examInfoId:@""
                                                    SuccessData:^(NSDictionary *result) {
                                                        if (self.delegate && [self.delegate respondsToSelector:@selector(ccAndGouKuaiCancal)]) {
                                                            [self.delegate ccAndGouKuaiCancal];
                                                        }
                                                    } errorData:^(NSError *error) {
                                                        
                                                    }];
        }
    }

    
    if (![self.urlPath isKindOfClass:[NSNull class]] &&  self.urlPath.length > 0) {
        self.title = @"载入中...";
//            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://testielts.staff.xdf.cn/IELTS/materials/selectVideoMaterialsById?mId=10161"]];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.urlPath]];
//    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL fileURLWithPath:@""]];
        [_webView loadRequest:request];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
}
- (void)dealloc
{
    NSLog(@"WebView");
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //停止加载
    [self.webView stopLoading];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}



#pragma mark - Actions
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = title;
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    
}






@end
