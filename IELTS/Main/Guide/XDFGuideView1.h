//
//  XDFGuideView1.h
//  IELTS
//
//  Created by 李牛顿 on 14-12-9.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XDFGuideView1Delegate  <NSObject>

- (void)clickSkipeAction;

@end

@interface XDFGuideView1 : UIView

@property (weak, nonatomic) IBOutlet UIButton *skipBtn;
- (IBAction)skipButton:(UIButton *)sender;

@property (nonatomic,unsafe_unretained)id<XDFGuideView1Delegate>delegate;



@end
