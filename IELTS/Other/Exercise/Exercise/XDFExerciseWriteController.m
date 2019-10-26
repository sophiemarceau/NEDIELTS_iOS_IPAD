//
//  XDFExerciseWriteController.m
//  IELTS
//
//  Created by 李牛顿 on 15-1-4.
//  Copyright (c) 2015年 Newton. All rights reserved.
//

#import "XDFExerciseWriteController.h"

@interface XDFExerciseWriteController ()


@end

//120_write.png
@implementation XDFExerciseWriteController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.创建图像
    NSString *imgString= @"120_write.png";
    UIImageView *imgView  =[[UIImageView alloc]initWithFrame:CGRectMake(30,(self.topView.height-60)/2, 60, 60)];
    imgView.image = [UIImage imageNamed:imgString];
    [self.topView addSubview:imgView];

}

@end
