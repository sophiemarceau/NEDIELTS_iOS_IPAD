//
//  XDFExaminaTestButton.m
//  IELTS
//
//  Created by 李牛顿 on 14-12-20.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFExaminaTestButton.h"


#define kImageScale 0.7
@implementation XDFExaminaTestButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.设置内部的图片
//        [self setIcon:@"ic_district.png" selectedIcon:@"ic_district_hl.png"];
        
    }
    return  self;
}

- (id)initWithTitle:(NSString *)title
            imgView:(NSString *)img
          imgHlView:(NSString *)hlImg
             Target:(id)target
              frame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:hlImg] forState:UIControlStateDisabled];
        // 2.自动伸缩
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        
        // 3.设置默认的文字
        [self setTitle:title forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        // 4.设置图片属性
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.userInteractionEnabled = NO;
        // 5.监听点击
//        [self addTarget:target action:action forControlEvents:UIControlEventTouchDown];

    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat w = contentRect.size.width;
    CGFloat h = contentRect.size.height * kImageScale;
    return CGRectMake(0, 0, w, h);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat w = contentRect.size.width;
    CGFloat h = contentRect.size.height * (1 - kImageScale);
    CGFloat y = contentRect.size.height - h;
    return CGRectMake(0, y, w, h);
}


@end
