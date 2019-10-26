//
//  SegmentTableMenu.m
//  IELTS
//
//  Created by melp on 14/11/26.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import "SegmentTableMenu.h"
#import "STMenuCell.h"
#import <QuartzCore/QuartzCore.h>

#define SEGMENT_MENU_HEIGHT 75

@interface SegmentTableMenu ()

@property (nonatomic,assign)NSInteger indexRow;

@end

@implementation SegmentTableMenu
{
    NSArray *_titleList;
    NSMutableArray *_titleBageList;
}

-(void) updateBage:(int)idx Number:(int)num
{
    [_titleBageList removeObjectAtIndex:idx];
    [_titleBageList insertObject:[NSNumber numberWithInt:num] atIndex:idx];
}

-(id) initWithTitles:(NSArray *)titleList AndFrame:(CGRect)frame
{
    CGFloat heigt;
    if (titleList.count * SEGMENT_MENU_HEIGHT+19 > kScreenHeight - 75 -20) {
        heigt = kScreenHeight - 75 -20;
    }else
    {
        heigt = titleList.count * SEGMENT_MENU_HEIGHT+19;
    }

   frame = CGRectMake(frame.origin.x-10,
                       frame.origin.y-20,
                       frame.size.width+20,
                       heigt);
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if(self)
    {
        _titleList = titleList;
        _titleBageList = [[NSMutableArray alloc] init];
        for (int i=0;i<_titleList.count;i++)
        {
            [_titleBageList addObject:@0];
        }
        self.dataSource = self;
        self.delegate = self;
        self.bounces = NO;
        self.backgroundColor = [UIColor clearColor];
        self.indexRow = 1000;
    }
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titleList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *vtbci = @"vtbci";
    STMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:vtbci];
    if (cell == nil)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"STMenuCell" owner:self options:nil];
        
        cell = [array objectAtIndex:0];
        cell.txtBage.layer.cornerRadius = 12;
        cell.txtBage.layer.masksToBounds = YES;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        UIView *selectview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width , cell.bounds.size.height)];
        cell.selectedBackgroundView = selectview;
        selectview.backgroundColor = rgb(238, 238, 238, 1);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    
    NSString *title = [_titleList objectAtIndex:indexPath.row];
    cell.txtTitle.text = title;
    cell.txtTitle.textColor = self.cellTittleColor;
    
    int bage = [[_titleBageList objectAtIndex:indexPath.row] intValue];
    if (bage == 0)
    {
        [cell.txtBage setHidden:YES];
    }
    else
    {
        [cell.txtBage setHidden:NO];
         cell.txtBage.text = [NSString stringWithFormat:@"%d",bage];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SEGMENT_MENU_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NDLog(@"%ld",(long)indexPath.row);
//    if (self.indexRow != indexPath.row) {  //限制重复点击
//        self.indexRow = indexPath.row;
//        
//    }
    self.indexChangeBlock(indexPath.row);
  }

@end
