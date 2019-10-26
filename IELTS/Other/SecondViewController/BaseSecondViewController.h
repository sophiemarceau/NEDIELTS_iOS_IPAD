//
//  BaseSecondViewController.h
//  IELTS
//
//  Created by 李牛顿 on 14-11-29.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseSecondViewController : UIViewController

@property (nonatomic,strong)UIButton *starButton ; //星星按钮


@property (nonatomic,strong)UIView *leftView_;

- (void)addContentViewController:(UIViewController *)view;

//后退
- (void)leftAction:(UIButton *)button;
//前进
- (void)rightAction:(UIButton *)button;



@end
