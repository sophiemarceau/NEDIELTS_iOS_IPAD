//
//  XDFExaminaDetailViewController.h
//  IELTS
//
//  Created by 李牛顿 on 14-12-5.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XDFExaminaDetailViewDelegate<NSObject>

- (void)examinaDetailFinishs:(NSInteger)pageIndex;  //

@end


@interface XDFExaminaDetailViewController : UIViewController

@property (nonatomic,strong)NSString *urlPath;  //试卷链接地址
@property (nonatomic,strong)NSString *audioFiles;  //声音链接地址
@property (nonatomic,assign)NSInteger curentSections;   //标识当前为听说读写。
@property (nonatomic,unsafe_unretained)id<XDFExaminaDetailViewDelegate>delegate;

@end
