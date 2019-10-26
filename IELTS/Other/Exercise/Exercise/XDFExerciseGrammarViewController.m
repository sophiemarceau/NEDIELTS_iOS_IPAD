//
//  XDFExerciseGrammarViewController.m
//  IELTS
//
//  Created by 李牛顿 on 15-1-5.
//  Copyright (c) 2015年 Newton. All rights reserved.
//

#import "XDFExerciseGrammarViewController.h"

@interface XDFExerciseGrammarViewController ()
@end

//120_grammar.png
@implementation XDFExerciseGrammarViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //1.创建图像
    UIImageView *imgView  =[[UIImageView alloc]initWithFrame:CGRectMake(30,(self.topView.height-60)/2, 60, 60)];
    imgView.image = [UIImage imageNamed:@"120_grammar.png"];
    [self.topView addSubview:imgView];
    
}


@end
