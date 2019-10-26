//
//  BaseNavigationController.m
//  IELTS
//
//  Created by 李牛顿 on 14-11-13.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadImage];
}
- (void)loadImage
{
    self.navigationBar.translucent = NO;

    //1.设置导航栏的背景颜色
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"mask_titlebar.png"]
                             forBarMetrics:UIBarMetricsDefault];
    
    //2.设置导航栏得字
    self.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIColor whiteColor],NSForegroundColorAttributeName,
                                              [UIFont boldSystemFontOfSize:24],NSFontAttributeName,nil];

}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
