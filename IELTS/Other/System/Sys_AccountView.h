//
//  Sys_AccountView.h
//  IELTS
//
//  Created by melp on 14/11/17.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSubView.h"

@interface Sys_AccountView : BaseSubView<UIActionSheetDelegate,UIImagePickerControllerDelegate>

- (IBAction)onUserLogoff:(id)sender;
- (IBAction)chanegPsw:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *imgUserImage;
@property (weak, nonatomic) IBOutlet UILabel *txtNickName;

@end
