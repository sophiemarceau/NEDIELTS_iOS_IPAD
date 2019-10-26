//
//  XDFExerciseReadController.m
//  IELTS
//
//  Created by 李牛顿 on 15-1-4.
//  Copyright (c) 2015年 Newton. All rights reserved.
//

#import "XDFExerciseReadController.h"

@interface XDFExerciseReadController ()
@end

@implementation XDFExerciseReadController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.创建图像
    UIImageView *imgView  =[[UIImageView alloc]initWithFrame:CGRectMake(30,(self.topView.height-60)/2, 60, 60)];
    imgView.image = [UIImage imageNamed:@"120_read.png"];
    [self.topView addSubview:imgView];
}

@end
