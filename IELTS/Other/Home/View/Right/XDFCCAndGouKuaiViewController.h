//
//  XDFCCAndGouKuaiViewController.h
//  IELTS
//
//  Created by 李牛顿 on 14-12-29.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    WhereTaskTypeNone,
    WhereTaskTypeHome,
    WhereTaskTypeMaterials,
    WhereTaskTypeSchedul
}WhereTaskType;

@protocol XDFCCAndGouKuaiDelegate <NSObject>

- (void)ccAndGouKuaiCancal;

@end

@interface XDFCCAndGouKuaiViewController : UIViewController

@property (nonatomic,strong)NSString *urlPath;  //资料链接地址
@property (nonatomic,strong)NSArray *listData;      //数据列表
@property (nonatomic,assign)NSInteger indexPathRow; //选中的行号
@property (nonatomic,assign)WhereTaskType taskType;

@property (nonatomic,unsafe_unretained)id<XDFCCAndGouKuaiDelegate>delegate;

@end
