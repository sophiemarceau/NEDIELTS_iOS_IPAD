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


+(NSString *)getDocumentPath;
+(NSString *)getTargetFloderPath;
+(NSString *)getTempFolderPath;

+(BOOL)isExistFile:(NSString *)fileName;


//插入数据
- (void)insertData:(NSString *)path  FileName:(NSString *)fileName PID:(NSString *)pid FileUrl:(NSString *)url;

//查询数据
- (NSString *)useIDSelect:(NSString *)pid;
//查询路径
- (NSString *)selectPath:(NSString *)pid;
//删除数据
- (void)removeData:(NSString *)pid;
@end
