//
//  XDFGuideView2.m
//  IELTS
//
//  Created by 李牛顿 on 14-12-9.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFGuideView2.h"
@interface XDFGuideView2()

@property (nonatomic,strong)UIButton *selectButton;

@end
@implementation XDFGuideView2

- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.backgroundColor = [UIColor grayColor];
}

- (IBAction)typeAButton:(UIButton *)sender {
    
    // 1.控制状态
    _selectButton.enabled = YES;
    sender.enabled = NO;
    _selectButton = sender;
    NSString *buttonTag = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    [self _requestType:buttonTag];
    [self clickTypeButton];
}

- (IBAction)typeBButton:(UIButton *)sender {
    
    // 1.控制状态
    _selectButton.enabled = YES;
    sender.enabled = NO;
    _selectButton = sender;
    NSString *buttonTag = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    [self _requestType:buttonTag];
    [self clickTypeButton];
}

//保存考试类型
- (void)_requestType:(NSString *)buttonTag
{
    [kUserDefaults setObject:buttonTag forKey:@"examType"];
    [kUserDefaults synchronize];
}

//自动跳到下一页
- (void)clickTypeButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(typeButtonAction)]) {
        [self.delegate typeButtonAction];
    }
}


@end
