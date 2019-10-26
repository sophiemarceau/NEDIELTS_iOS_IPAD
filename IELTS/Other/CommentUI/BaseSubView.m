//
//  BaseSubView.m
//  IELTS
//
//  Created by melp on 14/11/26.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import "BaseSubView.h"

@implementation BaseSubView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initView:(UIViewController *)parentView
{
    self.ParentViewControll = parentView;
}

- (void)onDisplayView
{
    
}

- (void) AlertTip:(NSString *)msg
{
    UIAlertView *alertViews = [[UIAlertView alloc]initWithTitle:@"提示"
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertViews show];
}


@end
