//
//  ExerciseViewController.h
//  IELTS
//
//  Created by 李牛顿 on 14-11-12.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import "BaseViewController.h"
@protocol ExerciseViewControllerDelegate<NSObject>

- (void)exerciseToPage:(NSInteger)index;

@end
@interface ExerciseViewController : BaseViewController

@property (nonatomic,unsafe_unretained)id<ExerciseViewControllerDelegate>delegate;

@end
