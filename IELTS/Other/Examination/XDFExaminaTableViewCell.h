
//  IELTS
//
//  Created by 李牛顿 on 14-12-5.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDFExaminaTableViewCell : UITableViewCell

@property (nonatomic,strong)NSDictionary *dataDic;   //数据源
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *imgType;

@property (weak, nonatomic) IBOutlet UILabel *testTitle;
@property (weak, nonatomic) IBOutlet UILabel *taskTime;

@property (weak, nonatomic) IBOutlet UIImageView *finishImg;


@end
