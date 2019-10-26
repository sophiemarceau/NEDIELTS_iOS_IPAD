//
//  XDFBaseLandscapeTableView.m
//  IELTS
//
//  Created by 李牛顿 on 14-12-2.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFBaseLandscapeTableView.h"

@implementation XDFBaseLandscapeTableView

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        //逆时针旋转90°
        self.transform = CGAffineTransformMakeRotation(-M_PI_2);
        //将旋转后的坐标给
        self.frame = frame;
        
        self.delegate = self;
        self.dataSource = self;
        
        self.showsVerticalScrollIndicator = NO;
        
        //设置减速的方式
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        
        self.backgroundColor = [UIColor clearColor];
        self.separatorStyle = UITableViewCellSelectionStyleNone;
        
    }
    return  self;
}

-(void)layoutSubviews
{
//    CGFloat edge = (kScreenWidth - self.rowHeight)/2;
//    self.contentInset = UIEdgeInsetsMake(edge, 0, edge, 0);
    [super layoutSubviews];
}

#pragma mark -UITableView dataSoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"posterTabelView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        //取消cell的选中状态
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //将cell.contentView顺时针旋转90°
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}



@end
