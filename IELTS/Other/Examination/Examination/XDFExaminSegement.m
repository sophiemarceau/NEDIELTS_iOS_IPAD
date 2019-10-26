//
//  XDFExaminSegement.m
//  IELTS
//
//  Created by 李牛顿 on 14-12-21.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFExaminSegement.h"
#import <QuartzCore/QuartzCore.h>

#define SEGMENT_MENU_HEIGHT 60

@interface XDFExaminSegement ()


@end

@implementation XDFExaminSegement
{
    NSArray *_titleList;
//    NSMutableArray *_titleBageList;
}

//-(void) updateBage:(int)idx Number:(int)num
//{
//    [_titleBageList removeObjectAtIndex:idx];
//    [_titleBageList insertObject:[NSNumber numberWithInt:num] atIndex:idx];
//}

-(id) initWithTitles:(NSArray *)titleList AndFrame:(CGRect)frame
{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if(self)
    {
        _titleList = titleList;
        self.dataSource = self;
        self.delegate = self;
        self.bounces = NO;
        self.backgroundColor = [UIColor clearColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titleList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *vtbci = @"vtbciCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:vtbci];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vtbci];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        UIView *selectview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width , cell.bounds.size.height)];
        cell.selectedBackgroundView = selectview;
        selectview.backgroundColor = TABBAR_BACKGROUND_SELECTED;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.textLabel.textColor = [UIColor whiteColor];

    }
    cell.textLabel.text = _titleList[indexPath.row];
    
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
