//
//  XDFGuideView4.h
//  IELTS
//
//  Created by 李牛顿 on 14-12-9.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XDFGuideView4Delegate<NSObject>

- (void)timeUndetermine;

@end

@interface XDFGuideView4 : UIView


@property (nonatomic,unsafe_unretained)id<XDFGuideView4Delegate>delegate;

- (IBAction)undeterminedButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *undetermine;

@property (weak, nonatomic) IBOutlet UIView *timeBgView;


@property (weak, nonatomic) IBOutlet UITextField *yearTextField;
@property (weak, nonatomic) IBOutlet UITextField *monthTextField;
@property (weak, nonatomic) IBOutlet UITextField *dayTextField;



@end
