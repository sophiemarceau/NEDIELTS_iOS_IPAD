//
//  Dlg_BindCodeViewController.h
//  IELTS
//
//  Created by melp on 14/12/1.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Dlg_BindCodeViewControllerDelegate<NSObject>
@optional
- (void)shutBindCodeModelView;
@end


@interface Dlg_BindCodeViewController : UIViewController
@property (nonatomic,unsafe_unretained)id<Dlg_BindCodeViewControllerDelegate>delegate;
@property (weak, nonatomic) IBOutlet UITextField *txtCode;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
- (IBAction)onSubmit:(id)sender;
- (IBAction)onCancel:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *line1;

@property (weak, nonatomic) IBOutlet UIView *bgViews;

@end
