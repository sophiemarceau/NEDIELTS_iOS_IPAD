//
//  SACalendarCell.m
//  SACalendarExample
//
//  Created by Nop Shusang on 7/12/14.
//  Copyright (c) 2014 SyncoApp. All rights reserved.
//
//  Distributed under MIT License

#import "SACalendarCell.h"
#import "SACalendarConstants.h"

#define kPointWith 6
@implementation SACalendarCell

/**
 *  Draw the basic components of the cell, including the top grey line, the red current date circle,
 *  the black selected circle and the date label. Customized the cell apperance by editing this function.
 *
 *  @param frame - size of the cell
 *
 *  @return initialized cell
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView:frame];
    }
    return self;
}

- (void)_initView:(CGRect) frame
{
    self.backgroundColor = cellBackgroundColor;
    
    self.topLineView = [[UIView alloc]initWithFrame:CGRectMake(-1, 0, frame.size.width + 1, 0.5)];
    self.topLineView.backgroundColor = cellTopLineColor;
    
    self.bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(-1, frame.size.height, frame.size.width + 1, 0.5)];
    self.bottomLineView.backgroundColor = cellTopLineColor;
    
    
    self.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 3, frame.size.width-5, 20)];
    self.dateLabel.textAlignment = NSTextAlignmentRight;
    self.dateLabel.contentScaleFactor = 0.6;
    self.dateLabel.font = [UIFont systemFontOfSize:16.0];
    
    CGRect labelFrame = self.dateLabel.frame;
    CGSize labelSize = labelFrame.size;
    
    CGPoint origin;
    int length;
    if (labelSize.width > labelSize.height) {
        origin.x = (labelSize.width - labelSize.height * circleToCellRatio) / 2;
        origin.y = (labelSize.height * (1 - circleToCellRatio)) / 2;
        length = labelSize.height * circleToCellRatio;
    }
    else{
        origin.x = (labelSize.width * (1 - circleToCellRatio)) / 2;
        origin.y = (labelSize.height - labelSize.width * circleToCellRatio) / 2;
        length = labelSize.width * circleToCellRatio;
    }
    
    self.circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width , 26)];
    self.circleView.backgroundColor = currentDateCircleColor;
    
    self.selectedView = [[UIView alloc] initWithFrame:CGRectMake(0 , 0, frame.size.width, frame.size.height)];
    self.selectedView.backgroundColor = selectedDateCircleColor;
    self.selectedView.layer.borderWidth = 1;
    self.selectedView.layer.borderColor = [UIColor redColor].CGColor;
    
    
    //创建视图
    self.contentLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height-20, frame.size.width, 20)];
    self.contentLabel1.backgroundColor = taskEightColor;
    [self.contentView addSubview:self.contentLabel1];
    
//    self.viewPoint1 = [[UIView alloc]initWithFrame:CGRectMake(5,(20-kPointWith)/2, kPointWith, kPointWith)];
    self.viewPoint1 = [[UIView alloc]initWithFrame:CGRectMake(5,self.contentLabel1.top+(20-kPointWith)/2, kPointWith, kPointWith)];
    [ZCControl circleView:self.viewPoint1];
    self.viewPoint1.backgroundColor = taskSevenColor;
    [self.contentView addSubview:self.viewPoint1];

    
    self.contentLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height-20*2, frame.size.width, 20)];
    self.contentLabel2.backgroundColor = taskSixColor;
    [self.contentView addSubview:self.contentLabel2];
    
    self.viewPoint2 = [[UIView alloc]initWithFrame:CGRectMake(5,self.contentLabel2.top+(20-kPointWith)/2, kPointWith, kPointWith)];
    [ZCControl circleView:self.viewPoint2];
    self.viewPoint2.backgroundColor = taskFiveColor;
    [self.contentView addSubview:self.viewPoint2];

    self.contentLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height-20*3, frame.size.width, 20)];
    self.contentLabel3.backgroundColor = taskThreeColor ;
    [self.contentView addSubview:self.contentLabel3];
    
    self.viewPoint3 = [[UIView alloc]initWithFrame:CGRectMake(5,self.contentLabel3.top+(20-kPointWith)/2, kPointWith, kPointWith)];
    [ZCControl circleView:self.viewPoint3];
    self.viewPoint3.backgroundColor = taskFourColor ;
    [self.contentView addSubview:self.viewPoint3];
    
    
    self.viewPoint1.hidden = YES;
    self.viewPoint2.hidden = YES;
    self.viewPoint3.hidden = YES;
    
    
    self.contentLabel4 = [[UILabel alloc]initWithFrame:CGRectMake(15, frame.size.height-20*1, frame.size.width-20, 20)];
    self.contentLabel4.font = [UIFont systemFontOfSize:12.0f];
    self.contentLabel4.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.contentLabel4];
    
    self.viewPoint4 = [[UIView alloc]initWithFrame:CGRectMake(0,self.contentLabel4.top + (20-kPointWith)/2, kPointWith, kPointWith)];
    [ZCControl circleView:self.viewPoint4];
    self.viewPoint4.backgroundColor = taskThreeColor;
    [self.contentView addSubview:self.viewPoint4];

    self.contentLabel5 = [[UILabel alloc]initWithFrame:CGRectMake(15, frame.size.height-20*2, frame.size.width-20, 20)];
    self.contentLabel5.font = [UIFont systemFontOfSize:12.0f];
    self.contentLabel5.backgroundColor = [UIColor clearColor];
    
    self.viewPoint5 = [[UIView alloc]initWithFrame:CGRectMake(0,self.contentLabel5.top + (20-kPointWith)/2, kPointWith, kPointWith)];
    [ZCControl circleView:self.viewPoint5];
    self.viewPoint5.backgroundColor = taskSevenColor;
    [self.contentView addSubview:self.viewPoint5];
    [self.contentView addSubview:self.contentLabel5];
    

    self.contentLabel6 = [[UILabel alloc]initWithFrame:CGRectMake(15, frame.size.height-20*3, frame.size.width-20, 20)];
    self.contentLabel6.font = [UIFont systemFontOfSize:12.0f];
    self.contentLabel6.backgroundColor = [UIColor clearColor];
    //        self.contentLabel6.numberOfLines = 0;
    self.viewPoint6 = [[UIView alloc]initWithFrame:CGRectMake(0,self.contentLabel6.top+(20-kPointWith)/2, kPointWith, kPointWith)];
    [ZCControl circleView:self.viewPoint6];
    self.viewPoint6.backgroundColor = taskFiveColor;
    [self.contentView addSubview:self.viewPoint6];
    [self.contentView addSubview:self.contentLabel6];
    
    self.viewPoint4.hidden = YES;
    self.viewPoint5.hidden = YES;
    self.viewPoint6.hidden = YES;
    
    [self.contentView addSubview:self.topLineView];
    [self.contentView addSubview:self.circleView];
    [self.contentView addSubview:self.selectedView];
    [self.contentView addSubview:self.dateLabel];

    
}


//布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
}



@end
