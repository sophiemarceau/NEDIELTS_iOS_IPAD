//
//  XDFText.m
//  IELTS
//
//  Created by 李牛顿 on 14-12-2.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFText.h"

@implementation XDFText
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self _initView];
    }
    return self;
}

- (void)_initView
{
    
    UIButton *buttonText = [ZCControl createButtonWithFrame:CGRectMake(0, 0, 75, 90) ImageName:@"" Target:self Action:@selector(textAction:) Title:@"测试"];
    [self addSubview:buttonText];
    
}
- (void)textAction:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textSelectType:)]) {
        [self.delegate textSelectType:@"1"];
    }
    
}





@end
