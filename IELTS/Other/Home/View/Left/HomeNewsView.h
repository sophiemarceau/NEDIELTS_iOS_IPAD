//
//  HomeNewsView.h
//  IELTS
//
//  Created by 李牛顿 on 14-11-13.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HomeNewViewDelegate<NSObject>
- (void)selectMessageType:(NSString *)type;
@end
@interface HomeNewsView : UIView

@property (nonatomic,unsafe_unretained)id<HomeNewViewDelegate>delegate;


- (void)startReloadData;

@end
