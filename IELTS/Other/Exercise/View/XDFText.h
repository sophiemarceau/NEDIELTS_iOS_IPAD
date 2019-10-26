//
//  XDFText.h
//  IELTS
//
//  Created by 李牛顿 on 14-12-2.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XDFTextDelegate <NSObject>

-(void)textSelectType:(NSString *)typeString;

@end
@interface XDFText : UIView

@property (nonatomic,unsafe_unretained)id<XDFTextDelegate>delegate;

@end
