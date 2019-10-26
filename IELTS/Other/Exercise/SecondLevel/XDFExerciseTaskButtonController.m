//
//  XDFExerciseTaskButtonController.m
//  IELTS
//
//  Created by 李牛顿 on 14-12-2.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFExerciseTaskButtonController.h"
#import "XDFExerciseDetailViewController.h"

@interface XDFExerciseTaskButtonController ()

@property (nonatomic,strong)XDFExerciseDetailViewController  *detailViewController;

@property (nonatomic,strong)NSString *currentTypes;

@property (nonatomic,assign)BOOL currentLeftButton;
@property (nonatomic,assign)BOOL currentRightButton;

@end

@implementation XDFExerciseTaskButtonController
@synthesize detailViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currentLeftButton = YES;  //左边可以点击
    _currentRightButton = YES; //右边可以点击
   
    detailViewController = [[XDFExerciseDetailViewController alloc]init];
    detailViewController.typs = self.typeString;
    [self addContentViewController:detailViewController];
    
    self.currentTypes = self.typeString;
    UIButton *nextButton = (UIButton *)[super.view viewWithTag:101];
    UIButton *beforeButton = (UIButton *)[super.view viewWithTag:100];
    if ([self.typeString isEqualToString:@"1"]) {
        
        beforeButton.enabled = NO;
        
    }else if ([self.typeString isEqualToString:@"7"])
    {
        nextButton.enabled = NO;
    }
    
}
//后腿
- (void)leftAction:(UIButton *)button
{
    UIButton *nextButton = (UIButton *)[super.view viewWithTag:101];
    if ([self.currentTypes isEqualToString:@"1"]) {
        button.enabled = NO;
        detailViewController.typs = self.currentTypes;
    }else
    {
        button.enabled = YES;
        nextButton.enabled = YES;
        
        NSString *stringType = [NSString stringWithFormat:@"%d",[self.currentTypes intValue]-1];
        if ([stringType isEqualToString:@"1"]) {
            
            button.enabled = NO;
            detailViewController.typs = stringType;
            self.currentTypes = stringType;

        }else
        {
            detailViewController.typs = stringType;
            self.currentTypes = stringType;
        }
    }
}

//前进
- (void)rightAction:(UIButton *)button
{
    UIButton *beforeButton = (UIButton *)[super.view viewWithTag:100];
    if ([self.currentTypes isEqualToString:@"7"]) {
        button.enabled = NO;
        detailViewController.typs = self.currentTypes;
    }else
    {
        button.enabled = YES;
        beforeButton.enabled = YES;
  
        NSString *stringType = [NSString stringWithFormat:@"%d",[self.currentTypes intValue]+1];
        if ([stringType isEqualToString:@"7"]) {
            
            button.enabled = NO;
            detailViewController.typs = stringType;
            self.currentTypes = stringType;

        }else
        {
            detailViewController.typs = stringType;
            self.currentTypes = stringType;
        }
    }
}


@end
