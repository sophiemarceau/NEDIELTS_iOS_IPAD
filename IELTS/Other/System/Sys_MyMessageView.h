//
//  Sys_MyMessageView.h
//  IELTS
//
//  Created by melp on 14/11/17.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSubView.h"

@interface Sys_MyMessageView : BaseSubView <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewEditTable;
@property (weak, nonatomic) IBOutlet UITableView *tbMessage;

@property (weak, nonatomic) IBOutlet UIButton *onSelectAllBt;
@property (weak, nonatomic) IBOutlet UIButton *onGroupDeleteBt;

- (IBAction)onSelectAll:(id)sender;
- (IBAction)onGroupDelete:(id)sender;
- (IBAction)onEdit:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *editButton;


@end
