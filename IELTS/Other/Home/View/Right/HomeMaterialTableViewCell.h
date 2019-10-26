//
//  HomeMaterialTableViewCell.h
//  IELTS
//
//  Created by 李牛顿 on 14-11-26.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    MaterialNo,        //无
    MaterialExercise,  //练习
    MaterialExam,      //考试
    MaterialMaterial   //新资料
}MaterialType;

@interface HomeMaterialTableViewCell : UITableViewCell

@property (nonatomic,assign)MaterialType materialType;

@end
