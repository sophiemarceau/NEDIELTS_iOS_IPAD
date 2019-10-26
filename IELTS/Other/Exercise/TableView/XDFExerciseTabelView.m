//
//  XDFExerciseTabelView.m
//  IELTS
//
//  Created by 李牛顿 on 14-12-2.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFExerciseTabelView.h"
#import "XDFExerciseTableViewCell.h"

//#import "XDFExerciseTableController.h"

#import "XDFExerciseTableDetailController.h"

#define exerciseRowHeigth_  200
@interface XDFExerciseTabelView()

@property (nonatomic,strong)NSMutableArray *dayProgress;

@end

@implementation XDFExerciseTabelView

- (void)setRwDayProgressList:(NSArray *)rwDayProgressList
{
    if (_rwDayProgressList != rwDayProgressList) {
        _rwDayProgressList = rwDayProgressList;
        _dayProgress  = [[NSMutableArray alloc]initWithCapacity:rwDayProgressList.count];
        for (NSDictionary *dicData in _rwDayProgressList) {
            NSString *timeDay = [dicData objectForKey:@"openDay"];
            [_dayProgress addObject:timeDay];
        }
    }

}

#pragma mark -UITabelViewDelegate
//覆写父类创建cell的方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"posterTabelView2";
    XDFExerciseTableViewCell *cell = (XDFExerciseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XDFExerciseTableViewCell" owner:self options:nil]lastObject];
        //取消cell的选中状态
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //将cell.contentView顺时针旋转90°
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
        cell.contentView.backgroundColor =rgb(230, 230, 230, 1);
        
    }
    if (indexPath.row == 0) {
        UILabel *moreLabel = [ZCControl createLabelWithFrame:CGRectMake(0, 0, cell.width, cell.height) Font:22.0 Text:@"更多"];
        moreLabel.textColor = TABBAR_BACKGROUND_SELECTED;
        moreLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:moreLabel];
    }else
    {
        cell.dataDic = self.data[indexPath.row];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (self.exerciseDelegate && [self.exerciseDelegate respondsToSelector:@selector(exerciseSelectIndexRow)]) {
            [self.exerciseDelegate exerciseSelectIndexRow];
        }
    }else
    {
        if (self.data.count > 0) {
            NSString *string =  [self.data[indexPath.row] objectForKey:@"openDay"];
            XDFExerciseTableDetailController *exercise = [[XDFExerciseTableDetailController alloc]init];
            exercise.openDate = string;
            exercise.dateArray = _dayProgress;
            [self.viewController.parentViewController.parentViewController.navigationController pushViewController:exercise animated:YES ];
        }
    }
}



@end
