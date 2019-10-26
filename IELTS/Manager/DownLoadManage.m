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

- (void)insertData:(NSString *)path  FileName:(NSString *)fileName PID:(NSString *)pid FileUrl:(NSString *)url
{
    
    NSString *sql = [NSString stringWithFormat:@"delete from DownloadFiles where PID='%@'",pid];
    
    [[DBHelper sharedDBHelper] ExecuteSql:sql];
    
    sql = [NSString stringWithFormat:@"insert into DownloadFiles(FileName,FileUrl,SavePath,PID) values('%@','%@','%@','%@') ",fileName,url,path,pid];

    
    [[DBHelper sharedDBHelper] ExecuteSql:sql];
}

- (void)removeData:(NSString *)pid
{
     NSString *sql = [NSString stringWithFormat:@"delete from DownloadFiles where PID = '%@'",pid];
    [[DBHelper sharedDBHelper]ExecuteSql:sql];
}

- (NSString *)useIDSelect:(NSString *)pid
{

    
    NSString *sql = [NSString stringWithFormat:@"select * from DownloadFiles where PID='%@'",pid];
    
    FMResultSet *rs = [[DBHelper sharedDBHelper] Query:sql];
    NSString *res = @"";
    while ([rs next])
    {
        res  = [rs stringForColumn:@"SavePath"];
        break;
    }
    [rs close];
    
    if(![res isEqualToString:@""])
    {
        return res;
    }
    
    return nil;
}

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
