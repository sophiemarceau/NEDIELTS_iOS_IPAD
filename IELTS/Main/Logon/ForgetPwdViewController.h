//
//  ForgetPwdViewController.h
//  IELTS
//
//  Created by 李牛顿 on 14-11-14.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ForgetPwdViewControllerDelegate<NSObject>
@optional
- (void)shutForgetModelView;
@end
@interface ForgetPwdViewController : UIViewController

@property (nonatomic,unsafe_unretained)id<ForgetPwdViewControllerDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIView *backImgView;
@property (weak, nonatomic) IBOutlet UIView *mailTextBgView;
@property (weak, nonatomic) IBOutlet UITextField *mailTextField;
@property (weak, nonatomic) IBOutlet UIButton *getPwdButton;

@property (weak, nonatomic) IBOutlet UILabel *titleBgLabel;


- (IBAction)getPwdAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *lognButton;

- (IBAction)lognButtonAction:(UIButton *)sender;

@end
