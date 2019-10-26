//
//  XDFGuideView2.h
//  IELTS
//
//  Created by 李牛顿 on 14-12-9.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XDFGuideView2Delegate  <NSObject>

- (void)typeButtonAction;

@end


@interface XDFGuideView2 : UIView

@property(nonatomic,unsafe_unretained)id<XDFGuideView2Delegate>delegate;

- (IBAction)typeAButton:(UIButton *)sender;
- (IBAction)typeBButton:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UIButton *typeA;

@property (weak, nonatomic) IBOutlet UIButton *typeB;

@end
