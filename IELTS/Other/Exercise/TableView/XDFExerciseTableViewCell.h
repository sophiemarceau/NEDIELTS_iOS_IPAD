//
//  XDFExerciseTableViewCell.h
//  IELTS
//
//  Created by 李牛顿 on 14-12-2.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDFExerciseTableViewCell : UITableViewCell

@property (nonatomic,strong)NSDictionary *dataDic;

@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *scheduleLabel;
@property (weak, nonatomic) IBOutlet UILabel *accuracyLabel;

@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@end
