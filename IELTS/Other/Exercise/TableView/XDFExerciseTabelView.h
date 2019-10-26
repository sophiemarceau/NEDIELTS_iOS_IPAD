//
//  XDFExerciseTabelView.h
//  IELTS
//
//  Created by 李牛顿 on 14-12-2.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFBaseLandscapeTableView.h"

@protocol XDFExerciseTabelViewDelegate <NSObject>

- (void)exerciseSelectIndexRow;

@end

@interface XDFExerciseTabelView : XDFBaseLandscapeTableView

@property (nonatomic,unsafe_unretained)id<XDFExerciseTabelViewDelegate>exerciseDelegate;

@property (nonatomic,strong)NSArray *rwDayProgressList;


@end
