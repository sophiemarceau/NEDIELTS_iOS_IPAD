//
//  XDFBaseLandscapeTableView.h
//  IELTS
//
//  Created by 李牛顿 on 14-12-2.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDFBaseLandscapeTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)NSArray *data;

@end
