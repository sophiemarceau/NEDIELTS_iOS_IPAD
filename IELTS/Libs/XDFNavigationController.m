//
//  XDFNavigationController.m
//  IELTS
//
//  Created by melp on 14/12/1.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFNavigationController.h"
#import "XDFPresentationController.h"

@interface XDFNavigationController ()

@end

@implementation XDFNavigationController
{
    CGRect _FrameRect;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationBar setBackgroundImage:[ZCControl createImageWithColor:TABBAR_BACKGROUND_SELECTED] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
  //  self.view.superview.frame =  CGRectMake(0, 0, _FrameRect.size.width, _FrameRect.size.height);
  //  self.view.superview.center = CGPointMake(512, 384);
    
    if(!IS_IOS8)
    {
        self.view.superview.layer.cornerRadius = 7;
        self.view.superview.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.view.superview.clipsToBounds = YES;
        self.view.superview.frame = _FrameRect;
    }
}

- (void)cancellAction:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setFormRect:(CGRect)rect
{
    _FrameRect = rect;
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented
                                                      presentingViewController:(UIViewController *)presenting
                                                          sourceViewController:(UIViewController *)source
{
    XDFPresentationController *pre = [[XDFPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    
    [pre setFormRect:_FrameRect];
    
    return  pre;
}

@end
