//
//  IListTabelView.m
//  IELTS
//
//  Created by 李牛顿 on 14-11-27.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import "IListTabelView.h"

#define rowHeigth_  52
@interface IListTabelView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *listTable;
@property (nonatomic,strong)UIView *allView;
@property (nonatomic,strong)UIButton *selectAllButton;
@property (nonatomic,strong)NSIndexPath *selectIndexPath;

@end
@implementation IListTabelView


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
    }
    return self;
}
- (void)_initView
{
    _listTable = [[UITableView alloc] initWithFrame:CGRectZero];
    _listTable.backgroundColor = [UIColor clearColor];
    _listTable.showsVerticalScrollIndicator = NO;
    _listTable.delegate = self;
    _listTable.dataSource = self;
    _listTable.bounces = NO;
    _listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_listTable];

}
//查全部课次
- (void)allActions:(UIButton *)button
{
    NSLog(@"全部");
    if (self.selectIndexPath != nil) {   //取消当前cell的选择状态
        [_listTable deselectRowAtIndexPath:self.selectIndexPath animated:NO];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectIndexRow:)]) {
        [self.delegate selectIndexRow:@""];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _listTable.transform = CGAffineTransformMakeRotation(M_PI/-2);
    _listTable.frame = CGRectMake(0, rowHeigth_, self.width, rowHeigth_);
    [_listTable.layer setAnchorPoint:CGPointMake(0.0, 0.0)];
    _listTable.rowHeight = rowHeigth_;
    _listTable.sectionHeaderHeight = 100;
}
- (void)setClassCount:(NSArray *)classCount
{
    if (_classCount != classCount) {
        _classCount = classCount;
        [_listTable reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _classCount.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIndetify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];
        UIView *selectview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width , cell.bounds.size.height)];
        cell.selectedBackgroundView = selectview;
        selectview.backgroundColor = rgb(158, 174, 217, 1);
        
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, rowHeigth_, rowHeigth_)];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.transform = CGAffineTransformMakeRotation(M_PI/2);
        textLabel.tag = 1;
        textLabel.highlightedTextColor = [UIColor whiteColor];
        [cell.contentView addSubview:textLabel];
        
        UILabel *labelLine = [ZCControl createLabelLineFrame:CGRectMake(26, rowHeigth_-26, 1, rowHeigth_)];
        labelLine.transform = CGAffineTransformMakeRotation(M_PI/2);
        [cell.contentView addSubview:labelLine];

    }
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:1];
    label.text = [NSString stringWithFormat:@"%@",[_classCount[indexPath.row] objectForKey:@"nLessonNo"]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectIndexPath = indexPath;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectIndexRow:)]) {
       
        [self.delegate selectIndexRow:[[_classCount[indexPath.row] objectForKey:@"id"] stringValue]];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //182 × 66
    //
    _allView = [[UIView alloc]initWithFrame:CGRectZero];
    _allView.backgroundColor = [UIColor whiteColor];
    _allView.frame = CGRectMake(0, 0, rowHeigth_, 100);

    _selectAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectAllButton setBackgroundImage:[UIImage imageNamed:@"btn_all.png"] forState:UIControlStateNormal];
    [_selectAllButton addTarget:self action:@selector(allActions:) forControlEvents:UIControlEventTouchUpInside];
    _selectAllButton.transform = CGAffineTransformMakeRotation(M_PI/2);
    _selectAllButton.frame = CGRectMake(9, 4, rowHeigth_- 19, 92);
    
    UILabel *line = [ZCControl createLabelLineFrame:CGRectMake(26, 74, 0.5, rowHeigth_)];
    line.transform = CGAffineTransformMakeRotation(M_PI/2);
    [_allView addSubview:line];
    [_allView addSubview:_selectAllButton];

    return _allView;
}



@end
