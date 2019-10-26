//
//  XDFExerciseDetailTableViewCell.h
//  IELTS
//
//  Created by 李牛顿 on 14-12-3.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    ExerciseCellDate,
    ExerciseCellType
}ExerciseCell;

@interface XDFExerciseDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *touImgeView;  //头像
@property (weak, nonatomic) IBOutlet UILabel *topicTitle;  //主题
@property (weak, nonatomic) IBOutlet UILabel *subHeard;    //副标题

@property (nonatomic,assign) ExerciseCell exerType;
@property (nonatomic,strong) NSDictionary *dataDic;


@property (weak, nonatomic) IBOutlet UIImageView *finishImgView;

@end
