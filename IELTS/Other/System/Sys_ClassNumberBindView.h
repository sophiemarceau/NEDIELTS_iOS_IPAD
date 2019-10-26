//
//  Sys_ClassNumberBindView.h
//  IELTS
//
//  Created by melp on 14/11/17.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSubView.h"

@interface Sys_ClassNumberBindView : BaseSubView

- (IBAction)onShowBindForm:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *viewMaskView;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserIcon;
@property (weak, nonatomic) IBOutlet UILabel *txtUserName;

@end
