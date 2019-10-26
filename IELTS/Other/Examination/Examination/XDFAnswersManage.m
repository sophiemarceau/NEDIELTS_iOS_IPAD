//
//  XDFAnswersManage.m
//  IELTS
//
//  Created by 李牛顿 on 14-12-23.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFAnswersManage.h"
#import "DBHelper.h"

static  XDFAnswersManage *_download = nil;
@implementation XDFAnswersManage

+ (XDFAnswersManage *) shardedAnswersManage
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _download = [[self alloc] init];
    });
    return _download;
}
#pragma mark - 初始化数据
- (id)init
{
    if (self = [super init]) {
        [self _initView];
    }
    return self;
}
- (void)_initView
{

}

#pragma mark - 保存时间
- (void)savTimerId:(NSString *)pidAndCurrentType
           usetime:(NSInteger)time
{
    [kUserDefaults setInteger:time forKey:pidAndCurrentType];
    [kUserDefaults synchronize];
}
#pragma mark - 移除时间
- (void)remTimerId:(NSString *)pidAndCurrentType
{
    [kUserDefaults removeObjectForKey:pidAndCurrentType];
    [kUserDefaults synchronize];
}

#pragma mark - 获取时间
- (NSInteger)getTimerId:(NSString *)pidAndCurrentType
{
    NSInteger time = [kUserDefaults integerForKey:pidAndCurrentType];
    if (time > 0) {
        return time;
    }
    return 0;
}




#pragma mark - 保存最后一次退出的状态
- (void)saveStatus:(NSString *)pId
        examinType:(NSString *)type
     examinSection:(NSString *)section
        examinPage:(NSString *)page
     finishSection:(NSString *)finishSection
{
    NSDictionary *dataDic = @{@"type":type,
                              @"section":section,
                              @"page":page,
                              @"finishSection":finishSection};
    NSDictionary *dic = [kUserDefaults objectForKey:pId];
    if (dic.count > 0) {  //有数据先移除
        [kUserDefaults removeObjectForKey:pId];
        [kUserDefaults synchronize];
    }
    [kUserDefaults setObject:dataDic forKey:pId];
    [kUserDefaults synchronize];
}

#pragma mark - 获取最后退出时的状态
- (NSDictionary *)getStatus:(NSString *)pId
{
    NSDictionary *lastStatus = [kUserDefaults objectForKey:pId];
    if (lastStatus.count > 0) {
        return lastStatus;
    }
    return nil;
}

#pragma mark - 移除最后退出状态
- (void)removeLastStatus:(NSString *)pId
{
    NSDictionary *lastStatus = [kUserDefaults objectForKey:pId];
    if (lastStatus.count > 0) {
        [kUserDefaults removeObjectForKey:pId];
    }
}



#pragma mark - 插入数据
- (void)insertSaveAnswersData:(NSString *)data PageID:(NSString *)pageId
{
    NSString *defaultString = [kUserDefaults objectForKey:pageId];
    if (![defaultString isEqualToString:data]) { //有数据，而且和前面存的不一样
        [kUserDefaults setObject:data forKey:pageId];
        [kUserDefaults synchronize];
    }

}

#pragma mark - 移除所有数据
- (void)removeAnswesData:(NSString *)pageId
{
    NSString *answers = [kUserDefaults objectForKey:pageId];
    if (answers.length > 0) {
        [kUserDefaults removeObjectForKey:pageId];
        [kUserDefaults synchronize];
    }
}

#pragma mark - 查找答案
- (NSString *)getAnswersData:(NSString *)pageId
{
    NSString *answers =  [kUserDefaults objectForKey:pageId];
    if (answers.length > 0) { //试卷存在
        return answers;
    }else  //不存在
    {
        return nil;
    }
}

#pragma mark - 提交答案失败存储最后结果
- (void)saveLastAnswer:(NSString *)pidsAnswer
             anserTime:(NSString *)times
                  stID:(NSString *)stID
                   pID:(NSString *)pId
             staskType:(NSString *)staskType
                 users:(NSString *)userAndpid
{
    NSDictionary *dic = @{@"pidsAnswer":pidsAnswer,
                          @"pidsTims":times,
                          @"pid":pId,
                          @"staskType":staskType,
                          @"stid":stID};
    NSDictionary *data = [kUserDefaults objectForKey:userAndpid];
    if (![data isEqualToDictionary:dic]) { //有数据，而且和前面存的不一样
        [kUserDefaults setObject:dic forKey:userAndpid];
        [kUserDefaults synchronize];
    }
}
#pragma mark - 移除最后结果
- (void)removeLastAnswer:(NSString *)userAndpid
{
    [kUserDefaults removeObjectForKey:userAndpid];
    [kUserDefaults synchronize];
}
#pragma mark - 获取答案失败存储最后结果
- (NSDictionary *)getLastAnswer:(NSString *)userAndpid
{
    NSDictionary *dic = [kUserDefaults objectForKey:userAndpid];
    if (dic.count > 0) {
        return dic;
    }
    return nil;
}


@end
