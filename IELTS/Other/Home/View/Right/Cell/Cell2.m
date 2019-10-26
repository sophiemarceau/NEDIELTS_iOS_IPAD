//
//  DiYuCell2.m
//  IYLM
//
//  Created by JianYe on 13-1-11.
//  Copyright (c) 2013年 Jian-Ye. All rights reserved.
//

#import "Cell2.h"
#import "TQViewCell.h"


@interface Cell2()

@property (nonatomic,strong)TQViewCell *cellView;


@end

@implementation Cell2
@synthesize exerciseArray,resourceArray,testArray;
- (void)awakeFromNib
{
    [super awakeFromNib];
    if (resourceArray!=nil) {
        resourceArray = nil;
    }
    
    if (exerciseArray!=nil) {
        exerciseArray = nil;
    }

    if (testArray!=nil) {
        testArray = nil;
    }

    
    resourceArray = [[NSMutableArray alloc]init];
    exerciseArray = [[NSMutableArray alloc]init];
    testArray = [[NSMutableArray alloc]init];
    
    if (_cellView != nil) {
        _cellView = nil;
        [_cellView removeFromSuperview];
    }
    _cellView = [[TQViewCell alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:_cellView];

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self _initData];
}

- (void)_initData
{
    _cellView.frame = CGRectMake(0, 0, self.width, self.height);
    _cellView.testArray = testArray;
    _cellView.exerciseArray = exerciseArray;
    _cellView.resourceArray = resourceArray;
    _cellView.isToday = self.isToday;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
