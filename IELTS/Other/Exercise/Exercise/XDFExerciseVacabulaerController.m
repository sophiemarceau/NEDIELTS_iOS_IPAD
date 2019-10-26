//
//  XDFExerciseVacabulaerController.m
//  IELTS
//
//  Created by 李牛顿 on 15-1-5.
//  Copyright (c) 2015年 Newton. All rights reserved.
//

#import "XDFExerciseVacabulaerController.h"

@interface XDFExerciseVacabulaerController ()@end

//120_Vocabular.png
@implementation XDFExerciseVacabulaerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.创建图像
    UIImageView *imgView  =[[UIImageView alloc]initWithFrame:CGRectMake(30,(self.topView.height-60)/2, 60, 60)];
    imgView.image = [UIImage imageNamed:@"120_Vocabular.png"];
    [self.topView addSubview:imgView];

}


@end
