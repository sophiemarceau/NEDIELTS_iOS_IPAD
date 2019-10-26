//
//  MaterialContentViewController.m
//  IELTS
//
//  Created by 李牛顿 on 14-11-14.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import "MaterialContentViewController.h"
#import "XDFWebViewController.h"

@interface MaterialContentViewController ()

@property (nonatomic,strong)XDFWebViewController *webSite;

@end

@implementation MaterialContentViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webSite = [[XDFWebViewController alloc]init];
    self.webSite.url = self.urlPath;
    [self addContentViewController:self.webSite];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
