//
//  XDFSetScoreViewController.m
//  IELTS
//
//  Created by 李牛顿 on 14-12-27.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFSetScoreViewController.h"
#import "BaseFillBlankView.h"
@interface XDFSetScoreViewController ()<BaseFillBlankViewDelegate>

@property (nonatomic,strong)NSArray *array;

@property (nonatomic,strong)NSString *writeScore;
@property (nonatomic,strong)NSString *speakScore;

@end


@implementation XDFSetScoreViewController
@synthesize array;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    array = @[@"写作",@"口语"];
    for (int i= 0; i<array.count; i++) {
        
        UILabel *listen  = [[UILabel alloc]initWithFrame:CGRectMake(120+i*140, 80+15, 50, 30)];
        listen.text =array[i];
        [self.view addSubview:listen];
        
        BaseFillBlankView *fillBlank = [[BaseFillBlankView alloc]initWithFrame:CGRectMake(170+i*140, 30, 50, 150)];
        fillBlank.fillBlankWidth = 50;
        fillBlank.delegate = self;
        fillBlank.fillBlankName =array[i];
        fillBlank.defaultValue = 5.0;
        fillBlank.valueType = ValueTypeNum;
        [self.view addSubview:fillBlank];
    }

    //设置大小
//    [ZCControl presentNavController:self Width:480 Height:320];
    
    UIButton *button = [ZCControl createButtonWithFrame:CGRectMake(21, 320-80, 208, 40) ImageName:@"bg.png" Target:self Action:@selector(backResult:) Title:@"确认"];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    UIButton *button2 = [ZCControl createButtonWithFrame:CGRectMake(250, 320-80, 208, 40) ImageName:@"bg.png" Target:self Action:@selector(CaclResult:) Title:@"取消"];
    [button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:button2];
    
    //默认
    self.writeScore = @"5.0";
    self.speakScore = @"5.0";
    
}

- (void)selectNum:(NSString *)value selectFillBlank:(NSString *)fillBlank
{
    //保存数据
    static NSString *speak = @"5.0";
    static NSString *write = @"5.0";
    
    if ([array containsObject:fillBlank]) {
        NSUInteger integet = [array indexOfObject:fillBlank];
        switch (integet) {
            case 0:
            {
                NSLog(@"写作");
                write = value;
                self.writeScore = write;

            }
                break;
            case 1:
            {
                NSLog(@"口语");
                speak = value;
                self.speakScore = speak;
            }
                break;
            default:
                break;
        }
    }
}

- (void)backResult:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(setScoreView:scoreString:)]) {
        [self.delegate setScoreView:self.writeScore scoreString:self.speakScore];
        
        //发送请求设置自我评价成绩
        [self _requestData:self.writeScore Score:self.speakScore];
        
//        [self dismissViewControllerAnimated:YES completion:nil];
        [self shutSETSELF];
    }
}

//设置自我评价成绩
- (void)_requestData:(NSString *)score1 Score:(NSString *)score2
{
    NDLog(@"写作分数:%@_______口语分数:%@",score1,score2);
    if (score1.length > 0  && score2.length > 0  && self.examInfoId > 0) {
        [[RusultManage shareRusultManage]updateScoreOfMyOwnGive:nil
                                                     examInfoId:self.examInfoId
                                                        MySpeak:score2
                                                        MyWrite:score1
                                                    SuccessData:^(NSDictionary *result) {
                                                        
                                                    } errorData:^(NSError *error) {
                                                        
                                                    }];
    }
}

- (void)CaclResult:(UIButton *)button
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self shutSETSELF];
}

- (void)shutSETSELF
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shutSetScoreView)]) {
        [self.delegate shutSetScoreView];
    }
}





@end
