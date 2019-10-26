//
//  XDFDockItem.m
//  IELTS
//
//  Created by 李牛顿 on 14-11-29.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFDockItem.h"

@implementation XDFDockItem
#pragma mark - 初始化方法
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}


- (void)setFrame:(CGRect)frame
{
    frame.size = CGSizeMake(kDockItemW, kDockItemH*0.7);
    [super setFrame:frame];
}

// 没有高亮状态
- (void)setHighlighted:(BOOL)highlighted { }

#pragma mark - 设置按钮内部的图片
- (void)setIcon:(NSString *)icon selectedIcon:(NSString *)selectedIcon
{
    self.icon = icon;
    self.selectedIcon = selectedIcon;
}

- (void)setIcon:(NSString *)icon
{
    _icon = icon;
    [self setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
}

- (void)setSelectedIcon:(NSString *)selectedIcon
{
    _selectedIcon = selectedIcon;
    [self setImage:[UIImage imageNamed:selectedIcon] forState:UIControlStateDisabled];
}

@end
