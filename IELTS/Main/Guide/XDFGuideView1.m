//
//  XDFGuideView1.m
//  IELTS
//
//  Created by 李牛顿 on 14-12-9.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFGuideView1.h"

@implementation XDFGuideView1

- (void)layoutSubviews
{
    [super layoutSubviews];
//     self.backgroundColor = [UIColor whiteColor];
    
}

- (IBAction)skipButton:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickSkipeAction)]) {
        [self.delegate clickSkipeAction];
    }
}

@end
