//
//  XDFDownLoadViewController.m
//  IELTS
//
//  Created by 李牛顿 on 14-12-18.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFDownLoadViewController.h"
#import "DownLoadManage.h"

@interface XDFDownLoadViewController ()

@property (nonatomic,assign)BOOL NetworkStatus;


@end

@implementation XDFDownLoadViewController

+ (XDFDownLoadViewController *)shardedDownLoadManage
{
      
    static XDFDownLoadViewController *_download = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _download = [[self alloc] init];
    });
    return _download;
}

- (id)init
{
    if (self = [super init]) {
        [self _reachability];
    }
    return self;
}

//检测网络状态
- (void)_reachability
{
    _NetworkStatus = NO;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
             _NetworkStatus = YES;
         }else
         {
             _NetworkStatus = NO;
         }
     }];
}

- (void)downloadFileURL:(NSString *)aUrl
               savePath:(NSString *)aSavePath
               fileName:(NSString *)aFileName
                    tag:(NSInteger)aTag
{
    if (!_NetworkStatus) {
        return;
    }
    
    NSString *downloadUrl = aUrl;

    NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *downloadPath = [cacheDirectory stringByAppendingPathComponent:@"xxx.zip"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:downloadUrl]];
    //检查文件是否已经下载了一部分
    unsigned long long downloadedBytes = 0;
    if ([[NSFileManager defaultManager] fileExistsAtPath:downloadPath]) {
        //获取已下载的文件长度
        downloadedBytes = [self fileSizeForPath:downloadPath];
        if (downloadedBytes > 0) {
            NSMutableURLRequest *mutableURLRequest = [request mutableCopy];
            NSString *requestRange = [NSString stringWithFormat:@"bytes=%llu-", downloadedBytes];
            [mutableURLRequest setValue:requestRange forHTTPHeaderField:@"Range"];
            request = mutableURLRequest;
        }
    }
    //不使用缓存，避免断点续传出现问题
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
    //下载请求
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    //下载路径
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:downloadPath append:YES];
    //下载进度回调
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        //下载进度
        float progress = ((float)totalBytesRead + downloadedBytes) / (totalBytesExpectedToRead + downloadedBytes);
    }];
    //成功和失败回调
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [operation start];
}

//获取已下载的文件大小
- (unsigned long long)fileSizeForPath:(NSString *)path {
    signed long long fileSize = 0;
    NSFileManager *fileManager = [NSFileManager new]; // default is not thread safe
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileSize = [fileDict fileSize];
        }
    }
    return fileSize;
}


- (void)requestFinished:(NSDictionary *)dic tag:(NSInteger)aTag
{

}
- (void)requestFailed:(NSInteger)aTag
{


}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
}



@end
