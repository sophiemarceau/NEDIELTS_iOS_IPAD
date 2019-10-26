//
//  XDFGuideView5.m
//  IELTS
//
//  Created by 李牛顿 on 14-12-9.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFGuideView5.h"

@interface XDFGuideView5()

@property (nonatomic,strong)UIButton *selectButton;

@end

@implementation XDFGuideView5

- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.backgroundColor = [UIColor magentaColor];
}


- (IBAction)joinYesAction:(UIButton *)sender {
    
    // 1.控制状态
    _selectButton.enabled = YES;
    sender.enabled = NO;
    _selectButton = sender;
    NSString *buttonTag = [NSString stringWithFormat:@"%ld",(long)sender.tag];

}

- (IBAction)joinNoAction:(UIButton *)sender {
    
    // 1.控制状态
    _selectButton.enabled = YES;
    sender.enabled = NO;
    _selectButton = sender;
    NSString *buttonTag = [NSString stringWithFormat:@"%ld",(long)sender.tag];

}
@end
