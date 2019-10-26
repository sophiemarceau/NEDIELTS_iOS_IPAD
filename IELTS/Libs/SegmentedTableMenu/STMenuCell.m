//
//  STMenuCell.m
//  IELTS
//
//  Created by melp on 14/12/2.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "STMenuCell.h"

@interface STMenuCell ()

@end

@implementation STMenuCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.txtTitle.numberOfLines = 0;
    self.txtTitle.textAlignment = NSTextAlignmentCenter;
    self.backgroundColor = [UIColor clearColor];
}



@end
