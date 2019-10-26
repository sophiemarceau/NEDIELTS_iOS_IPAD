//
//  XDFUpDataAnswers.h
//  IELTS
//
//  Created by 李牛顿 on 15-1-19.
//  Copyright (c) 2015年 Newton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDFUpDataAnswers : NSObject

+(XDFUpDataAnswers *)shareUpDataAnswers;

@property (nonatomic,strong) NSArray *listenPage_;
@property (nonatomic,strong) NSArray *speakPage_;
@property (nonatomic,strong) NSArray *readPage_;
@property (nonatomic,strong) NSArray *writerPage_;
@property (nonatomic,strong) NSString *pId;
@property (nonatomic,strong) NSString *stId;
@property (nonatomic,strong) NSString *taskType;

//- (void)savLastAnswer; //没网保存答案
- (void)finishUpLoadAnswer; //完成提交答案
- (void)upLoadAnwer:(NSString *)answerString times:(NSString *)countTime; //提交没网时保存的答案
//- (void)tuichuApp;//退出App

@end
