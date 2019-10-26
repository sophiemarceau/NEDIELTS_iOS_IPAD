//
//  XDFAnswersManage.h
//  IELTS
//
//  Created by 李牛顿 on 14-12-23.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDFAnswersManage : NSObject

+ (XDFAnswersManage *) shardedAnswersManage;

#pragma mark - 插入数据
- (void)insertSaveAnswersData:(NSString *)data PageID:(NSString *)pageId;
#pragma mark - 移除所有数据
- (void)removeAnswesData:(NSString *)pageId;
#pragma mark - 查找答案
- (NSString *)getAnswersData:(NSString *)pageId;

#pragma mark - 保存最后一次退出的状态
- (void)saveStatus:(NSString *)pId
        examinType:(NSString *)type
     examinSection:(NSString *)section
        examinPage:(NSString *)page
     finishSection:(NSString *)finishSection;

#pragma mark - 获取最后退出时的状态
- (NSDictionary *)getStatus:(NSString *)pId;

#pragma mark - 移除最后退出状态
- (void)removeLastStatus:(NSString *)pId;


#pragma mark - 保存时间
- (void)savTimerId:(NSString *)pidAndCurrentType
           usetime:(NSInteger)time;
#pragma mark - 获取时间
- (NSInteger)getTimerId:(NSString *)pidAndCurrentType;
#pragma mark - 移除时间
- (void)remTimerId:(NSString *)pidAndCurrentType;


#pragma mark - 提交答案失败存储最后结果
- (void)saveLastAnswer:(NSString *)pidsAnswer
             anserTime:(NSString *)times
                  stID:(NSString *)stID
                   pID:(NSString *)pId
             staskType:(NSString *)staskType
                 users:(NSString *)user;
#pragma mark - 移除最后结果
- (void)removeLastAnswer:(NSString *)userAndpid;
#pragma mark - 获取答案失败存储最后结果
- (NSDictionary *)getLastAnswer:(NSString *)userAndpid;



@end
