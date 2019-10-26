//
//  MaterialTableViewCell.h
//  IELTS
//
//  Created by 李牛顿 on 14-11-27.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MaterialTableViewCellDelegate <NSObject>
- (void)cancelCollent;
@end

@interface MaterialTableViewCell : UITableViewCell

@property (nonatomic,strong)NSDictionary *dicData;
@property (nonatomic,unsafe_unretained)id<MaterialTableViewCellDelegate> delegate;

@end
