//
//  SACalendarCell.h
//  SACalendarExample
//
//  Created by Nop Shusang on 7/12/14.
//  Copyright (c) 2014 SyncoApp. All rights reserved.
//
//  Distributed under MIT License

#import <UIKit/UIKit.h>
typedef enum
{
    CellTypeNo,
    CellTypeTask,
    CellTypeClass
}CellType;

@interface SACalendarCell : UICollectionViewCell

@property (nonatomic,assign)CellType cellType;
//
@property (nonatomic,strong)NSArray *currentDateData;


@property (nonatomic,strong)UILabel *contentLabel1;
@property (nonatomic,strong)UILabel *contentLabel2;
@property (nonatomic,strong)UILabel *contentLabel3;
@property (nonatomic,strong)UILabel *contentLabel4;
@property (nonatomic,strong)UILabel *contentLabel5;

@property (nonatomic,strong)UILabel *contentLabel6;

@property (nonatomic,strong)UIView *viewPoint1;
@property (nonatomic,strong)UIView *viewPoint2;
@property (nonatomic,strong)UIView *viewPoint3;
@property (nonatomic,strong)UIView *viewPoint4;
@property (nonatomic,strong)UIView *viewPoint5;

@property (nonatomic,strong)UIView *viewPoint6;

/**
 *  grey line above the label
 */
@property UIView *topLineView;

/**
 *  grey line above the label
 */
@property UIView *bottomLineView;

/**
 *  a circle that appears on the current date
 */
@property UIView *circleView;

/**
 *  a circle that appears on the selected date
 */
@property UIView *selectedView;

/**
 *  the label showing the cell's date
 */
@property UILabel *dateLabel;

@end
