//
//  XDFExaminaTestHome.h
//  IELTS
//
//  Created by 李牛顿 on 14-12-20.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDFResultViewController.h"
@interface XDFExaminaTestHome : UIViewController

@property (nonatomic,strong) NSString *pId;  //试卷id
@property (nonatomic,strong) NSString *stId; //上传答案的id

@property (nonatomic,strong) NSDictionary *dicData;  //数据
@property (nonatomic,assign) BOOL isChack; //是否是查看题目

@property (nonatomic,copy) NSString *testTitles;//试卷标题
@property (nonatomic,assign) NSInteger startuInte;//当前状态

@property (nonatomic,strong) XDFResultViewController *resultView;

@property (nonatomic,copy) NSString *taskType;

@end
