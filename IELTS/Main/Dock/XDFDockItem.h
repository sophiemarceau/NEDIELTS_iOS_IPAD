//
//  XDFDockItem.h
//  IELTS
//
//  Created by 李牛顿 on 14-11-29.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDFDockItem : UIButton
- (void)setIcon:(NSString *)icon selectedIcon:(NSString *)selectedIcon;
@property (nonatomic, copy) NSString *icon; // 普通图片
@property (nonatomic, copy) NSString *selectedIcon; // 选中图片


@end
