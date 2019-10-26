//
//  Sys_AboutView.m
//  IELTS
//
//  Created by melp on 14/11/17.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import "Sys_AboutView.h"

@interface Sys_AboutView ()

@property (nonatomic,strong)UIImageView *imageView;

@end

@implementation Sys_AboutView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //创建图片视图
    _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    _imageView.image = [UIImage imageNamed:@"Default-Landscape.png"];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imageView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _imageView.frame = CGRectMake(0, -100, self.width, self.height);
    
}


@end
