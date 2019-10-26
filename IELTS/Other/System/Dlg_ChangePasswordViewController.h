//
//  Dlg_ChangePasswordViewController.h
//  IELTS
//
//  Created by melp on 14/12/1.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Dlg_ChangePasswordViewControllerDelegate<NSObject>
@optional
- (void)shutChangePassWordModelView;
@end


@interface Dlg_ChangePasswordViewController : UIViewController

@property (nonatomic,unsafe_unretained)id<Dlg_ChangePasswordViewControllerDelegate>delegate;

- (IBAction)onCancel:(id)sender;
- (IBAction)onSubmit:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtOldPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtRePassword;

@property (weak, nonatomic) IBOutlet UIView *bgImgView;


@property (weak, nonatomic) IBOutlet UILabel *line2;
@property (weak, nonatomic) IBOutlet UILabel *line;


@end
