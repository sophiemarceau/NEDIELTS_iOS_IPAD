//
//  MyMessageCell.m
//  IELTS
//
//  Created by melp on 14/12/2.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "MyMessageCell.h"

@interface MyMessageCell ()

@end

@implementation MyMessageCell

/*
 {
 "MState" : 1,
 "Title" : "1227给学生消息标题",
 "Account" : "admin1",
 "Body" : "1227给学生消息内容",
 "MI_ID" : 3034,
 "MR_ID" : null,
 "CreateTime" : 1419651834000,
 "AssignRoleID" : 3
 }
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSString *titLabel = [self.dataDic objectForKey:@"Title"];
    self.titeNames.text = titLabel;
    self.titeNames.font = [UIFont systemFontOfSize:18.0f];
    self.titeNames.textColor = [UIColor blackColor];
    self.detailNameLabel.textColor = [UIColor darkGrayColor];//rgb(114, 114, 114, 1.0);
//    self.titeNames.backgroundColor = [UIColor orangeColor];
    NSString *bodyName = [self.dataDic objectForKey:@"Body"];
    self.detailNameLabel.text = bodyName;
    
    
    if (![[self.dataDic objectForKey:@"MR_ID"] isKindOfClass:[NSNull class]]) {
        self.titeNames.textColor = [UIColor darkGrayColor];
//        self.detailNameLabel.textColor = [UIColor darkGrayColor];
        self.newsImage.hidden = YES;
    }else
    {
        self.titeNames.textColor = [UIColor blackColor];
//        self.detailNameLabel.textColor = [UIColor darkGrayColor];
        self.newsImage.hidden = NO;
    }
}



@end
