//
//  XDFDownLoadViewController.h
//  IELTS
//
//  Created by 李牛顿 on 14-12-18.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"


@interface XDFDownLoadViewController : UIViewController


+ (XDFDownLoadViewController *)shardedDownLoadManage;

- (void)_initData:(NSArray *)dataArray;



@end
