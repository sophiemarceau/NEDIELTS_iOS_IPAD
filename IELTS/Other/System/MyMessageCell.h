//
//  MyMessageCell.h
//  IELTS
//
//  Created by melp on 14/12/2.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMessageCell : UITableViewCell

@property (nonatomic,strong)NSDictionary *dataDic; //字典

@property (weak, nonatomic) IBOutlet UILabel *newsImage;

@property (weak, nonatomic) IBOutlet UILabel *titeNames;

@property (weak, nonatomic) IBOutlet UILabel *detailNameLabel;

@end
