//
//  SegmentTableMenu.h
//  IELTS
//
//  Created by melp on 14/11/26.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^IndexChangeBlock)(NSInteger index);

@interface SegmentTableMenu : UITableView<UITableViewDataSource,UITableViewDelegate>

-(id) initWithTitles:(NSArray *)titleList AndFrame:(CGRect)frame;
-(void) updateBage:(int)idx Number:(int)num;

@property (nonatomic, copy) IndexChangeBlock indexChangeBlock;

@property (nonatomic,strong)UIColor *cellTittleColor;

@end
