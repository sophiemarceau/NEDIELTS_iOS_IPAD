//
//  HomeNewsTableViewCell.h
//  IELTS
//
//  Created by 李牛顿 on 14-11-26.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    NewsCellNo,      //无
    NewsCellCourse,  //课程
    NewsCellExam,    //考试
    NewsCellAbroad,  //留学申请
    NewsCellSys,     //系统
    NewsCellMaterial //新资料
}NewsCellType;

@interface HomeNewsTableViewCell : UITableViewCell

@property (nonatomic,strong)NSDictionary *newsDic;

@property (nonatomic,assign)NewsCellType newsCellType;

@end
