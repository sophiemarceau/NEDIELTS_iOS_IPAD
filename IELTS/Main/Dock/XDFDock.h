//
//  XDFDock.h
//  IELTS
//
//  Created by 李牛顿 on 14-11-29.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDFDock;
@protocol XDFDockDelegate <NSObject>
@optional
- (void)dock:(XDFDock *)dock tabChangeFrom:(NSInteger)from to:(NSInteger)to;
@end

@interface XDFDock : UIView

@property (nonatomic, weak) id<XDFDockDelegate> delegate;
@property (nonatomic,strong) UIImageView *UserIconImg;

- (void)dockTabChangeTo:(NSInteger)to;

@end
