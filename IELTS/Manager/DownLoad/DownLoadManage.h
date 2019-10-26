//
//  DownLoadManage.h
//  CountyHospital2
//
//  Created by ChinaSoft-Support on 13-12-10.
//  Copyright (c) 2013年 pfizer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownLoadManage : NSObject

+ (DownLoadManage *) ShardedDownLoadManage;


+ (NSString *)getDocumentPath;
+ (NSString *)getTargetFloderPath;
+ (NSString *)getTempFolderPath;

+ (BOOL)isExistFile:(NSString *)fileName;


//插入数据
- (void)insertSavePath:(NSString *)path
              FileName:(NSString *)fileName
                   PID:(NSString *)pid
               FileUrl:(NSString *)url
            FileStatus:(NSString *)status
               Version:(NSString *)version;


//查询查找保存路径
- (NSString *)useIDSelect:(NSString *)pid;
//查找服务器链接
- (NSString *)selectPath:(NSString *)pid;
//删除数据
- (void)removeData:(NSString *)pid;
//查找文件状态
- (NSString *)seachFilesStatus:(NSString *)pid;

#pragma mark - 查找版本号
- (NSString *)seachVersion:(NSString *)pid;
@end
