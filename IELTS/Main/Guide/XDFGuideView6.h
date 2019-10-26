//
//  XDFGuideView6.h
//  IELTS
//
//  Created by 李牛顿 on 14-12-9.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import <UIKit/UIKit.h>
 
@protocol  XDFGuideView6Delegate <NSObject>
- (void)startStudyAction;
@end

@interface XDFGuideView6 : UIView

@property (nonatomic,unsafe_unretained)id<XDFGuideView6Delegate>delegate;

- (IBAction)startStudy:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UIView *scoreBgView;


@end
