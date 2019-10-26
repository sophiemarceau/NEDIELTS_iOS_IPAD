//
//  XDFExerciseTaskButton.m
//  IELTS
//
//  Created by 李牛顿 on 14-12-3.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFExercisesTaskButton.h"
#import "XDFExerciseTypeListController.h"

@interface XDFExercisesTaskButton()

@property (nonatomic,strong) UIButton *taskButton;
@property (nonatomic,strong) UILabel *imgLabel;
@property (nonatomic,strong) UILabel *mainLabel;
@property (nonatomic,strong) UIImageView *imageViewBg;

@end

@implementation XDFExercisesTaskButton
@synthesize taskButton,imgLabel,mainLabel,imageViewBg;
/*
 85, 105
 */
- (id)init
{
    if (self = [super init]) {
        //        [self _initView];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self _initView];
    }
    return self;
}
- (void)_initView
{
    taskButton = [UIButton buttonWithType:UIButtonTypeCustom];
    taskButton.frame = CGRectMake(5, 5, 75, 75);
    [taskButton addTarget:self action:@selector(taskButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [ZCControl circleButton:taskButton];
    [self addSubview:taskButton];
    
    imageViewBg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"exerciseNum.png"]];
    imageViewBg.frame = CGRectMake(64, 1, 24, 24);
    imageViewBg.hidden = YES;
    [self addSubview:imageViewBg];
    
    imgLabel = [ZCControl createLabelWithFrame:CGRectMake(0, 0, 24, 24) Font:14 Text:@""];
    imgLabel.backgroundColor = [UIColor clearColor];
    imgLabel.textAlignment = NSTextAlignmentCenter;
    imgLabel.textColor = [UIColor whiteColor];
    imgLabel.layer.cornerRadius = imgLabel.width/2;
    imgLabel.layer.masksToBounds = YES;
    [imageViewBg addSubview:imgLabel];
    
    mainLabel = [ZCControl createLabelWithFrame:CGRectMake(0, 75, 85, 30) Font:16 Text:@""];
    mainLabel.textAlignment = NSTextAlignmentCenter;
    mainLabel.textColor = [UIColor darkGrayColor];
    [self addSubview: mainLabel];
}

#pragma mark -
- (void)_initData
{
    //1.创建大按钮
    [taskButton setBackgroundImage:[UIImage imageNamed:_imgName] forState:UIControlStateNormal];
    //3.创建主题
    mainLabel.text  = self.titleName;
}
//
- (void)setImgName:(NSString *)imgName
{
    if (_imgName != imgName) {
        _imgName = imgName;
        [self _initData];
    }
}

- (void)setNums:(NSString *)nums
{
    if (_nums != nums) {
        _nums = nums;
        [self changeNum];
    }
}

- (void)changeNum
{
    //2.创建小视图  20*20
    NSString *string = [NSString stringWithFormat:@"%@",self.nums];
    if ([string isEqualToString:@"0"]) {
        imageViewBg.hidden = YES;
    }else
    {
        imageViewBg.hidden = NO;
        imgLabel.text =string;
    }
}



- (void)taskButtonAction:(UIButton *)button
{
    NSString *typeString = [NSString stringWithFormat:@"%ld",(long)self.tag];
    XDFExerciseTypeListController *typeList = [[XDFExerciseTypeListController alloc]init];
    typeList.typeString = typeString;
    [self.viewController.parentViewController.parentViewController.navigationController pushViewController:typeList animated:YES];
}



@end
