//
//  XDFTabItem.m
//  IELTS
//
//  Created by 李牛顿 on 14-11-29.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFTabItem.h"

#define kImageScale 0.5

@implementation XDFTabItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 3.设置选中（disable）时的背景图片
    [self setBackgroundImage:[ZCControl createImageWithColor:TABBAR_BACKGROUND_SELECTED] forState:UIControlStateDisabled];
    }
    return self;
}

- (void)setTitleItems:(NSString *)titleItems
{
    _titleItems = titleItems;
    
    [self setTitle:_titleItems forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    // 1.自动伸缩
//    self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    // 2.设置图片属性
//    self.imageView.contentMode = UIViewContentModeCenter;
 
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat w = contentRect.size.width *kImageScale*0.7;
    CGFloat h = contentRect.size.height * kImageScale;
    return CGRectMake((kDockItemW-w)/2, 10, w, h);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat w = contentRect.size.width;
    CGFloat h = contentRect.size.height * (1 - kImageScale);
    CGFloat y = contentRect.size.height - h;
    return CGRectMake(0, y+3, w, h);
}




@end
