//
//  XDFGetScoreViewController.h
//  IELTS
//
//  Created by 李牛顿 on 15-1-5.
//  Copyright (c) 2015年 Newton. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XDFExerciseTypeListController;
@class XDFExerciseTableDetailController;
typedef enum
{
    DayOrTypeNone,
    DayOrTypeDay,  //每日任务进入
    DayOrTypeTypes, //类型进入
    DayOrTypeHome,
    DayOrTypeSchedule
}DayOrType;

@interface XDFGetScoreViewController : UIViewController

@property (nonatomic,strong) NSDictionary *dataDic; //所有数据
@property (nonatomic,strong) NSString *testType;  //区分听说读写
@property (nonatomic,strong) XDFExerciseTypeListController *listController; //类型
@property (nonatomic,strong) XDFExerciseTableDetailController *dayDetailController; //每日
@property (nonatomic,assign) DayOrType dayType;   //判断从哪里进到此页面
@property (nonatomic,strong) NSString *st_Id;


@end
