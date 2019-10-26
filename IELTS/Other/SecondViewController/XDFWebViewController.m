//
//  XDFWebViewController.m
//  IELTS
//
//  Created by 李牛顿 on 14-11-30.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFWebViewController.h"
#import "NetworkManager.h"

@interface XDFWebViewController ()<UIWebViewDelegate>

@property (nonatomic,strong)UIWebView *webView;

@end

@implementation XDFWebViewController

- (id)initWithUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        self.url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView = [[UIWebView alloc]init];
    _webView.delegate = self;
    _webView.frame = CGRectMake(0, 0, kScreenWidth-80, kScreenHeight);
    _webView.scalesPageToFit = YES;

    [self.view addSubview:_webView];

    [self _loadData];

}

//- (void)_loadData
//{
////    if (self.url.length > 0) {
////        self.title = @"载入中...";
//////        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:_url]];
////        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL fileURLWithPath:@"/Users/liniudun/Desktop/JSVidio/index.html"]];
////        [_webView loadRequest:request];
////        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
////    }
//    [self _loadData:@"/Users/liniudun/Desktop/JSVidio/index.html"];
//}

- (void)_loadData
{

    self.title = @"载入中...";
//    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://test.shike.me/xdf.html"]];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://115.28.129.210:8082/IELTS/materials/selectVideoMaterialsById?mId=1051"]];
    
//    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL fileURLWithPath:@"/Users/liniudun/Desktop/JSVidio/index.html"]];
    [_webView loadRequest:request];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

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

- (void)open:(UIButton *)sender {
    //提示用户，打开链接
    
    //http://
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.url]];
    
}

@end
