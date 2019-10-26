//
//  XDFScheduleTableViewCell.m
//  IELTS
//
//  Created by 李牛顿 on 15-1-10.
//  Copyright (c) 2015年 Newton. All rights reserved.
//

#import "XDFScheduleTableViewCell.h"

@implementation XDFScheduleTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    [self _initView];
}

- (void)_initView
{
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //@"标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题"];
//    CGFloat titileHeight =  [XDFScheduleTableViewCell titleHeightForText:self.classTitle.text];
//    CGFloat timeHeight = [XDFScheduleTableViewCell heightForText:self.classTimes.text];
//    CGFloat addressHeight = [XDFScheduleTableViewCell heightForText:self.classAddress.text];
//    
//    self.classTitle.height = titileHeight;
//    self.classTimes.height = timeHeight;
//    self.classAddress.height = addressHeight;
    
//    self.classTimes.top = self.classTitle.bottom+10;
//    self.classAddress.top = self.classTimes.bottom+10;
//    
//    self.timeImg.top = self.classTimes.top + (self.classTimes.height-self.timeImg.height)/2;
//    self.addressImg.top = self.classAddress.top + (self.classAddress.height-self.addressImg.height)/2;
//    self.height = timeHeight+titileHeight+addressHeight+30;
//    self.backgroundColor = [UIColor redColor];
}

/*
+(CGFloat)titleHeightForText:(NSString *)title
{
    
    NSDictionary *attrbute = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0f]};
    return [title boundingRectWithSize:CGSizeMake(236, 1000)
                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                           attributes:attrbute context:nil].size.height;
}

+ (CGFloat)heightForText:(NSString *)text
{
    //设置计算文本时字体的大小,以什么标准来计算
    NSDictionary *attrbute = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]};
    return [text boundingRectWithSize:CGSizeMake(210, 1000)
                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                           attributes:attrbute context:nil].size.height;
}
*/

@end
