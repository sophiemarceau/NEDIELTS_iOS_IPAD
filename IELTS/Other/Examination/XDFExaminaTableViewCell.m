//
//  XDFExaminaTableViewCell.m
//  IELTS
//
//  Created by 李牛顿 on 14-12-5.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFExaminaTableViewCell.h"

@implementation XDFExaminaTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self _initView];
}

- (void)_initView
{
    self.bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.bgView.layer.borderWidth = 0.5;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 5;

}
/*
 {
 AssignCount = "<null>";
 AssignDate = "<null>";
 "CC_ID" = "<null>";
 "C_ID" = 1233;
 Catagory = "<null>";
 CreateTime = "<null>";
 ExTime = "<null>";
 Name = "<null>";
 NickName = "<null>";
 OpenDate = "<null>";
 "P_ID" = "<null>";
 PaperNumber = "<null>";
 RefID = 2;
 RoleId = "<null>";
 "ST_ID" = 1037;
 Source = "<null>";
 SubjectiveIn = "<null>";
 "TF_ID" = "<null>";
 Target = "<null>";
 TaskType = 1;
 UID = "<null>";
 ifJieSuo = no;
 },
 */
- (void)setDataDic:(NSDictionary *)dataDic
{
    if (_dataDic != dataDic) {
        _dataDic = dataDic;
        //处理
        [self _dealData:dataDic];
    }
}
//处理数据
- (void)_dealData:(NSDictionary *)dataDic
{
    //隐藏标示视图
    self.finishImg.hidden = YES;
     //设置主标题
    if (![[dataDic objectForKey:@"Name"]isKindOfClass:[NSNull class]]) {
        NSString *testName = [dataDic objectForKey:@"Name"];
        self.testTitle.text = testName;
    }
    //设置头像
//    if (![[dataDic objectForKey:@"Catagory"]isKindOfClass:[NSNull class]]) {
//        [ZCControl imgTypeCatagory:[dataDic objectForKey:@"Catagory"]];
//    }
    _imgType.image = [UIImage imageNamed:@"150_exercise_08.png"];

    NSString *p_id = [[dataDic objectForKey:@"P_ID"] stringValue];
    NSString *finishPID = [NSString stringWithFormat:@"%@finish",p_id];

    if ([[dataDic objectForKey:@"TF_ID"] isKindOfClass:[NSNull class]]) {  //如果没有完成
        self.taskTime.textColor = [UIColor darkGrayColor];
        self.testTitle.textColor = [UIColor darkGrayColor];
        self.finishImg.hidden = YES;

        [kUserDefaults setBool:NO forKey:finishPID];
        [kUserDefaults synchronize];
        
        if ([[dataDic objectForKey:@"OpenDate"] isKindOfClass:[NSNull class]]) {  //如果没有时间，判断是否解锁
            self.taskTime.hidden = YES;  //隐藏时间label
            self.testTitle.top = (self.bgView.height-self.testTitle.height)/2;  //标题居中
//            if ([[dataDic objectForKey:@"ifJieSuo"] isEqualToString:@"yes"]) {//如果解锁
//                self.finishImg.hidden = YES;
//                self.userInteractionEnabled = YES;
//            }else{//未解锁
//                self.finishImg.hidden = NO;
//                self.finishImg.image = [UIImage imageNamed:@"daijiesuo.png"];
//                self.userInteractionEnabled = NO;
//            }
        }else
        {
            self.finishImg.hidden = YES;
           //有时间，为班级考卷
            self.taskTime.hidden = NO;  //显示时间label
            NSString *openDate = [dataDic objectForKey:@"OpenDate"];
            self.taskTime.text = [NSString stringWithFormat:@"任务时间：%@",openDate];
        }
    }else
    {  //完成了显示在最底下
        self.finishImg.hidden = NO;
        self.finishImg.image = [UIImage imageNamed:@"yiwancheng.png"];

        self.taskTime.textColor = [UIColor lightGrayColor];
        self.testTitle.textColor = [UIColor lightGrayColor];
        
#pragma mark - 完成后.每次都进入答题页面
        [kUserDefaults setBool:YES forKey:finishPID];
        [kUserDefaults synchronize];

        
        if (![[dataDic objectForKey:@"OpenDate"] isKindOfClass:[NSNull class]]) {  //有时间
             self.taskTime.hidden = NO;  //显示时间label
             NSString *openDate = [dataDic objectForKey:@"OpenDate"];
            self.taskTime.text = [NSString stringWithFormat:@"任务时间：%@",openDate];
        }else
        {
            self.taskTime.hidden = YES;  //隐藏时间label
            self.testTitle.top = (self.bgView.height-self.testTitle.height)/2;  //标题居中
        }
    }
}

@end
