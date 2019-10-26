//
//  XDFExerciseListentController.m
//  IELTS
//
//  Created by 李牛顿 on 15-1-4.
//  Copyright (c) 2015年 Newton. All rights reserved.
//

#import "XDFExerciseListentController.h"

@interface XDFExerciseListentController ()

@end

@implementation XDFExerciseListentController


- (void)viewDidLoad {
    [super viewDidLoad];
    //1.创建图像
    NSString *imgString= @"120_listen.png";
    UIImageView *imgView  =[[UIImageView alloc]initWithFrame:CGRectMake(30,(self.topView.height-60)/2, 60, 60)];
    imgView.image = [UIImage imageNamed:imgString];
    [self.topView addSubview:imgView];

}
@end
