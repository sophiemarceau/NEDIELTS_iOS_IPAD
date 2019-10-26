//
//  DownLoadManage.m
//  CountyHospital2
//
//  Created by ChinaSoft-Support on 13-12-10.
//  Copyright (c) 2013年 pfizer. All rights reserved.
//

#import "DownLoadManage.h"
#import "DBHelper.h"

@implementation DownLoadManage

static DownLoadManage *_download = nil;

+ (DownLoadManage *) ShardedDownLoadManage
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _download = [[self alloc] init];
    });
    return _download;
    
}

+(NSString *)getDocumentPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

+(NSString *)getTargetFloderPath
{
    return [self getDocumentPath];
}

+(NSString *)getTempFolderPath
{
    return [[self getDocumentPath] stringByAppendingPathComponent:@"Temp"];
}

+(BOOL)isExistFile:(NSString *)fileName
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:fileName];
}


#pragma mark - 插入数据
- (void)insertSavePath:(NSString *)path
              FileName:(NSString *)fileName
                   PID:(NSString *)pid
               FileUrl:(NSString *)url
            FileStatus:(NSString *)status
               Version:(NSString *)version
{
    
    NSString *sql = [NSString stringWithFormat:@"delete from DownloadFiles where PID='%@'",pid];
    
    [[DBHelper sharedDBHelper] ExecuteSql:sql];
    
    sql = [NSString stringWithFormat:@"insert into DownloadFiles(FileName,FileUrl,SavePath,PID,FileStatus,Version) values('%@','%@','%@','%@','%@','%@') ",fileName,url,path,pid,status,version];

    
    [[DBHelper sharedDBHelper] ExecuteSql:sql];
}

#pragma mark - 移除所有数据
- (void)removeData:(NSString *)pid
{
     NSString *sql = [NSString stringWithFormat:@"delete from DownloadFiles where PID = '%@'",pid];
    [[DBHelper sharedDBHelper]ExecuteSql:sql];
}

#pragma mark - 查找保存路径
- (NSString *)useIDSelect:(NSString *)pid
{
    NSString *sql = [NSString stringWithFormat:@"select * from DownloadFiles where PID='%@'",pid];
    
    FMResultSet *rs = [[DBHelper sharedDBHelper] Query:sql];
    NSString *res = @"";
    while ([rs next])
    {
        res  = [rs stringForColumn:@"FileName"];
        break;
    }
    [rs close];
    
    if(![res isEqualToString:@""])
    {
        return res;
    }
    
    return nil;
}

#pragma mark - 查找文件状态码
- (NSString *)seachFilesStatus:(NSString *)pid
{
    
    
    NSString *sql = [NSString stringWithFormat:@"select * from DownloadFiles where PID='%@'",pid];
    
    FMResultSet *rs = [[DBHelper sharedDBHelper] Query:sql];
    NSString *res = @"";
    while ([rs next])
    {
        res  = [rs stringForColumn:@"FileStatus"];
        break;
    }
    [rs close];
    
    if(![res isEqualToString:@""])
    {
        return res;
    }
    
    return nil;
}

- (void)changeFilesStatus:(NSString *)pid
{
    NSString *sql = [NSString stringWithFormat:@"UPDATTE DownloadFiles SET FileStatus = '1' WHERE FileStatus = '0' AND PID = '%@'",pid];
    FMResultSet *rs = [[DBHelper sharedDBHelper] Query:sql];
//    NSString *res = @"";
//    while ([rs next])
//    {
//        res  = [rs stringForColumn:@"FileStatus"];
//        break;
//    }
    [rs close];
}

#pragma mark - 查找版本号
- (NSString *)seachVersion:(NSString *)pid
{

    NSString *sql = [NSString stringWithFormat:@"select * from DownloadFiles where PID='%@'",pid];
    
    FMResultSet *rs = [[DBHelper sharedDBHelper] Query:sql];
    NSString *res = @"";
    while ([rs next])
    {
        res  = [rs stringForColumn:@"Version"];
        break;
    }
    [rs close];
    
    if(![res isEqualToString:@""])
    {
        return res;
    }
    
    return nil;
}



#pragma mark - 查找服务器链接
- (NSString *)selectPath:(NSString *)pid
{
    NSString *sql = [NSString stringWithFormat:@"select * from DownloadFiles where PID='%@'",pid];
    
    FMResultSet *rs = [[DBHelper sharedDBHelper] Query:sql];
    NSString *res = @"";
    while ([rs next])
    {
        res  = [rs stringForColumn:@"FileUrl"];
        break;
    }
    [rs close];
    
    if(![res isEqualToString:@""])
    {
        return res;
    }
    
    return nil;

}


@end
