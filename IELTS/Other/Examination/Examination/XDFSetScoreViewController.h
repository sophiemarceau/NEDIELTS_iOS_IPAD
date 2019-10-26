
//  IELTS
//
//  Created by 李牛顿 on 14-12-27.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XDFSetScoreViewControllerDelegeat<NSObject>

- (void)setScoreView:(NSString *)score1 scoreString:(NSString *)score2;
@optional
- (void)shutSetScoreView;

@end

@interface XDFSetScoreViewController : UIViewController


@property (nonatomic,strong)id<XDFSetScoreViewControllerDelegeat>delegate;
@property (nonatomic,strong)NSString *examInfoId;

@end
