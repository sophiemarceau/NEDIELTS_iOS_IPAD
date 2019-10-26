//
//  XDFExaminaDetailViewController.m
//  IELTS
//
//  Created by 李牛顿 on 14-12-5.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFExaminaDetailViewController.h"

@interface XDFExaminaDetailViewController ()<UIWebViewDelegate>

@property (nonatomic,strong)UIWebView *webView;

@end

@implementation XDFExaminaDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _webView = [[UIWebView alloc]init];
    _webView.delegate = self;
    _webView.frame = CGRectMake(0, 0, kScreenWidth-80, kScreenHeight);
    _webView.scalesPageToFit = YES;
    
    [self.view addSubview:_webView];
    
}

- (void)setUrlPath:(NSString *)urlPath
{
    if (_urlPath != urlPath) {
        _urlPath = urlPath;
        [self loadWebView];
    }
}
//加载网页
- (void)loadWebView
{
    self.title = @"载入中...";
//    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://115.28.129.210:8082/IELTS/materials/selectVideoMaterialsById?mId=1051"]];
    if (_urlPath.length > 0) {
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL fileURLWithPath:_urlPath]];
        [_webView loadRequest:request];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //停止加载
    [self.webView stopLoading];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - Actions
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = title;
}
//
//- (void)doJS:(NSString *)JS
//{
//    [_webView  stringByEvaluatingJavaScriptFromString:JS];
//}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    
}


#pragma mark -Actions
- (void)goBack:(UIButton *)sender {
    [self.webView goBack];
}

- (void)forward:(UIButton *)sender {
    [self.webView goForward];
}

- (void)refresh:(UIButton *)sender {
    [self.webView reload];
}
//
//- (void)open:(UIButton *)sender {
//    //提示用户，打开链接
//    
//    //http://
//    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:_urlPath]];
//    
//}


//完成时候调用
- (void)finishTest
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(examinaDetailFinishs:)]) {
        [self.delegate examinaDetailFinishs:self.curentSections];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //重新调整坐标
    CGFloat w = kScreenWidth- kSecondLevelLeftWidth;
    CGFloat h = kScreenHeight;
    self.view.frame = CGRectMake(0, 0, w, h);
}

@end
