//
//  XDFExerciseDetailTableViewCell.m
//  IELTS
//
//  Created by 李牛顿 on 14-12-3.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFExerciseDetailTableViewCell.h"

@implementation XDFExerciseDetailTableViewCell

/*  类型
 {
    AssignCount = "<null>";
    AssignDate = "<null>";
    "CC_ID" = "<null>";
    "C_ID" = 17285;
    Catagory = 2;
    CreateTime = 1417483971940;
    ExTime = "<null>";
    Name = "\U6a21\U8003_\U8bd5\U5377_3";
    NickName = xsaaad;
    OpenDate = "<null>";
    "P_ID" = 9;
    PaperNumber = 00003;
    RefID = 9;
    RoleId = "<null>";
    "ST_ID" = 1008;
    Source = "<null>";
    SubjectiveIn = "<null>";
    "TF_ID" = "<null>";
    Target = "<null>";
    TaskType = 2;
    UID = 1;
 }
 */
- (void)awakeFromNib {
    // Initialization code
    [self _initView];
}
- (void)_initView
{
    self.bgView.layer.borderWidth = 0.5;
    self.bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.masksToBounds = YES;
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    if (_dataDic != dataDic) {
        _dataDic = dataDic;
        
        switch (_exerType) {
            case ExerciseCellDate:
            {
                [self _dealDate];
            }
                break;
            case ExerciseCellType:
            {
                [self _dealType];
            }
                break;
            default:
                break;
        }
    }
}
//处理类型数据
- (void)_dealType
{
    self.topicTitle.text = [_dataDic objectForKey:@"Name"];
    NSString *tf = [_dataDic objectForKey:@"TF_ID"];//判断是否完成
    
    NSString *p_id = [[_dataDic objectForKey:@"P_ID"]stringValue];
    NSString *status = [NSString stringWithFormat:@"%@finish",p_id];

    if (![tf isKindOfClass:[NSNull class]]) {
        self.finishImgView.hidden = NO;
        self.finishImgView.image = [UIImage imageNamed:@"yiwancheng.png"];
        self.topicTitle.textColor = [UIColor lightGrayColor];
        self.subHeard.textColor = [UIColor lightGrayColor];
        
        [kUserDefaults setBool:YES forKey:status];
        [kUserDefaults synchronize];
    }else
    {
        
        [kUserDefaults setBool:NO forKey:status];
        [kUserDefaults synchronize];

        self.topicTitle.textColor = [UIColor darkGrayColor];
        self.subHeard.textColor = [UIColor darkGrayColor];
 
        self.finishImgView.hidden = YES;
    }
    NSString *openDate =[_dataDic objectForKey:@"OpenDate"];//判断时间
    if ([openDate isKindOfClass:[NSNull class]]) {
         self.subHeard.text = @"";//任务时间
         self.topicTitle.top = self.bgView.height/2-self.topicTitle.height/2;
    }else
    {
         self.topicTitle.top = self.bgView.height/2-self.topicTitle.height/2-10;
         self.subHeard.text = [NSString stringWithFormat:@"任务时间：%@",openDate];//任务时间
    }
   
//    [_dataDic objectForKey:@"Catagory"]; //判断类型：听说读写选图片
    NSString *lcName =  [_dataDic objectForKey:@"lcName"];
    NSString *imageName = [ZCControl imgTypeCatagory:lcName];
    self.touImgeView.image = [UIImage imageNamed:imageName];

}
//处理日期数据
/*
 {
     AssignCount = "<null>";
     AssignDate = "<null>";
     "CC_ID" = 109;
     "C_ID" = 17285;
     Catagory = 1;
     CreateTime = 1417483971940;
     ExTime = "<null>";
     Name = "\U7ec3\U4e60_\U8bd5\U5377_1";
     NickName = xsaaad;
     OpenDate = "2014-11-26";
     "P_ID" = 7;
     PaperNumber = 00001;
     RefID = 7;
     RoleId = "<null>";
     "ST_ID" = 11;
     Source = "<null>";
     SubjectiveIn = "<null>";
     "TF_ID" = 4;
     Target = "<null>";
     TaskType = 2;
     UID = 1;
 }
 */

- (void)_dealDate
{
    NDLog(@"%@",_dataDic);
    //主题标题
    self.topicTitle.text  = [_dataDic objectForKey:@"Name"];
    self.topicTitle.top = self.bgView.height/2-self.topicTitle.height/2;
    //副标题
    self.subHeard.hidden = YES;
    
    //判断是否完成
    NSString *tf = [_dataDic objectForKey:@"TF_ID"];
    
    NSString *p_id = [[_dataDic objectForKey:@"P_ID"]stringValue];
    NSString *status = [NSString stringWithFormat:@"%@finish",p_id];

    if (![tf isKindOfClass:[NSNull class]]) {
        self.finishImgView.hidden = NO;
        self.finishImgView.image = [UIImage imageNamed:@"yiwancheng.png"];
        self.topicTitle.textColor = [UIColor lightGrayColor];
        
        [kUserDefaults setBool:YES forKey:status];
        [kUserDefaults synchronize];
    }else
    {
        [kUserDefaults setBool:NO forKey:status];
        [kUserDefaults synchronize];
        
        self.topicTitle.textColor = [UIColor darkGrayColor];
        self.finishImgView.hidden = YES;
    }
    
//   [_dataDic objectForKey:@"Catagory"]; //判断类型：听说读写选图片
    NSString *lcName =  [_dataDic objectForKey:@"lcName"];
    NSString *imageName = [ZCControl imgTypeCatagory:lcName];
    self.touImgeView.image = [UIImage imageNamed:imageName];
}


@end
