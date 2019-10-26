//
//  BaseSubView.h
//  IELTS
//
//  Created by melp on 14/11/26.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseSubView : UIView

@property (nonatomic) BOOL IsInited;
@property (nonatomic,assign) UIViewController *ParentViewControll;

- (void)initView:(UIViewController *)parentView;
- (void)onDisplayView;
- (void)AlertTip:(NSString *)msg;

@end
