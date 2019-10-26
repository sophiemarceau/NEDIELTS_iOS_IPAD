//
//  HomeMaterialTableViewCell.m
//  IELTS
//
//  Created by 李牛顿 on 14-11-26.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import "HomeMaterialTableViewCell.h"

@implementation HomeMaterialTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}

- (void)_initView
{

}




- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
