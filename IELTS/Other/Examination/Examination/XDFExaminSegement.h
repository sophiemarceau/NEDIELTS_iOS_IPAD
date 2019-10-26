//
//  XDFExaminSegement.h
//  IELTS
//
//  Created by 李牛顿 on 14-12-21.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^IndexChangeBlock)(NSInteger index);
@interface XDFExaminSegement : UITableView<UITableViewDataSource,UITableViewDelegate>

-(id) initWithTitles:(NSArray *)titleList AndFrame:(CGRect)frame;

//-(void) updateBage:(int)idx Number:(int)num;

@property (nonatomic, copy) IndexChangeBlock indexChangeBlock;

@property (nonatomic,strong)UIColor *cellTittleColor;


@end
