//
//  IListTabelView.h
//  IELTS
//
//  Created by 李牛顿 on 14-11-27.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol IListTabelViewDelegate <NSObject>

- (void)selectIndexRow:(NSString *)index;

@end
@interface IListTabelView : UIView

@property (nonatomic,strong)NSArray *classCount;

@property (nonatomic,unsafe_unretained)id<IListTabelViewDelegate>delegate;

@end
