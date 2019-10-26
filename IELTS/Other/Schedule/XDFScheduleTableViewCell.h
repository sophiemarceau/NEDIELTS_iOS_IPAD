//
//  XDFScheduleTableViewCell.h
//  IELTS
//
//  Created by 李牛顿 on 15-1-10.
//  Copyright (c) 2015年 Newton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDFScheduleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *classTitle;
@property (weak, nonatomic) IBOutlet UILabel *classTimes;
@property (weak, nonatomic) IBOutlet UILabel *classAddress;

@property (nonatomic,strong)NSDictionary *dataDic;

@property (weak, nonatomic) IBOutlet UIImageView *timeImg;
@property (weak, nonatomic) IBOutlet UIImageView *addressImg;


@end
