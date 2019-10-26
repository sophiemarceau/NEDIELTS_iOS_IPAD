//
//  BaseFillBlankView.h
//  vauleSelectDemo
//
//  Created by 李牛顿 on 14-12-10.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    ValueTypeNo,
    ValueTypeNum,
    ValueTypeYear,
    ValueTypeMonth,
    ValueTypeDay
}ValueType;

@protocol BaseFillBlankViewDelegate <NSObject>

- (void)selectNum:(NSString *)value selectFillBlank:(NSString *)fillBlank;

@end

@interface BaseFillBlankView : UIView

@property (nonatomic,unsafe_unretained)id<BaseFillBlankViewDelegate>delegate;
@property (nonatomic,assign)ValueType valueType; //类型

@property (nonatomic)float fillBlankWidth;  //填空宽度
@property (nonatomic,strong) NSString *fillBlankName;//空格前面的名字

@property (nonatomic,assign) float defaultValue;   //默认分数


@end
