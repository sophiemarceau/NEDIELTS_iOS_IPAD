//
//  XDFExaminaTestViewController.h
//  IELTS
//
//  Created by 李牛顿 on 14-12-5.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "BaseSecondViewController.h"
@protocol XDFExaminaTestDelegate<NSObject>
- (void)examinaFinishs:(NSInteger)pageIndex;
@end

@interface XDFExaminaTestViewController : BaseSecondViewController

@property (nonatomic,strong)NSString *pId;  //试卷ID
@property (nonatomic,strong)NSArray *dataArray;  //section数据
@property (nonatomic,assign)NSInteger currentSeciton; //当前的section标记
@property (nonatomic,unsafe_unretained)id<XDFExaminaTestDelegate>delegate;  //完成代理

@end
