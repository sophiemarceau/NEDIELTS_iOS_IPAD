//
//  HomeViewController.h
//  IELTS
//
//  Created by 李牛顿 on 14-11-12.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import "BaseViewController.h"

@protocol HomeViewControllerDelegate <NSObject>
@optional
- (void)homeTabChangeTo:(NSInteger)to;
- (void)homeTabChangeTo:(NSInteger)to typeString:(NSString *)types;

@end
@interface HomeViewController : BaseViewController

@property (nonatomic,unsafe_unretained)id<HomeViewControllerDelegate>delegate;

@end
