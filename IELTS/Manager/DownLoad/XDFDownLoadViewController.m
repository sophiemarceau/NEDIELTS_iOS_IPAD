//
//  XDFDownLoadViewController.m
//  IELTS
//
//  Created by 李牛顿 on 14-12-18.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFDownLoadViewController.h"
#import "DownLoadManage.h"
#import "XDFDownLoadModel.h"
#import "ZipArchive.h"

@interface XDFDownLoadViewController ()

@property (nonatomic,assign)BOOL NetworkStatus;

@property (nonatomic,strong)NSArray *data;

@property (nonatomic,assign)int i_;


@end

@implementation XDFDownLoadViewController
@synthesize i_;

+ (XDFDownLoadViewController *)shardedDownLoadManage
{
      
    static XDFDownLoadViewController *_download = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _download = [[self alloc] init];
    });
    return _download;
}

- (void)_initData:(NSArray *)dataArray
{
    _data = [[NSArray alloc]init];
    _data = dataArray;
    
    NDLog(@"%@",dataArray);
    NDLog(@"%d",_NetworkStatus);
    //
    
    i_ = 0;
    [self _dataArray];
}
- (void)_dataArray
{
    
    if (_data.count > 0 && i_ < _data.count ) {
        NSDictionary *dataDic = _data[i_];
        XDFDownLoadModel *downloadModel = [[XDFDownLoadModel alloc]initWithData:dataDic];
        [self downloadFileURL:downloadModel];
    }
}

/*
 "P_ID" = 1032;    //保存试卷
 PaperFolder = "TempPaper_1032";    //文件夹名字
 PaperState = 3;
 PaperVersion = 1;    //版本，判断是否更新
 PaperZip = "1032141895590442953.zip";
 domainPFolder = "http://115.28.129.210:8082/IELTS/paperzip/TempPaper_1032";
 domainPZip = "http://115.28.129.210:8082/IELTS/paperzip/1032141895590442953.zip";
 paperName = "\U7ec3\U4e60\U5377";
 uid = 10;
 */

- (void)downloadFileURL:(XDFDownLoadModel *)downloadModel  
{
#warning mark - 需要优化，实时监测网络状态
//    if (!_NetworkStatus) {
//        NDLog(@"当前非wifi网络");
//        return;
//    }
    //下载条件:1.wifi、   2.记录是否已答题、    3.判断版本、
    
    //下载地址
    NSString *tagetPath =  [DownLoadManage getTargetFloderPath];  //根目录
    NSString *zipFloder =  [downloadModel.domainPZip lastPathComponent];  //下载链接的后缀名字
    NSString *savZipPath = [NSString stringWithFormat:@"%@/%@",tagetPath,zipFloder]; //下载解压包的路径
    
    NSString *savZipFloderPath = [NSString stringWithFormat:@"%@/%@",tagetPath,downloadModel.paperFolder]; //解压后得文件夹路径
    NDLog(@"%@",savZipPath);
    //检查已经下载的文件
    if ([DownLoadManage isExistFile:savZipFloderPath] ) {
        
        NSString *status = [[DownLoadManage ShardedDownLoadManage]seachFilesStatus:downloadModel.pId];
        if ([status isEqualToString:@"1"]) {  //已经编辑状态
            i_ = i_+1;
            if (i_ < _data.count) {
                [self _dataArray];
            }
            return;
        }else   //试卷未编辑状态
        {
            //判断版本号  获取数据库版本和当前版本
            NSString *currentVersion = downloadModel.paperVersion;
            NSString *newVersion = [[DownLoadManage ShardedDownLoadManage]seachVersion:downloadModel.pId];
            if ([currentVersion isEqualToString:newVersion]) {
                NDLog(@"版本没变");
                i_ = i_+1;
                if (i_ < _data.count) {
                    [self _dataArray];
                }
                return;
            }
        }
    }

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:downloadModel.domainPZip]];
    //检查文件是否已经下载了一部分
    unsigned long long downloadedBytes = 0;
    if ([[NSFileManager defaultManager] fileExistsAtPath:savZipPath]) {  //存在zip包。
        //获取已下载的文件长度
        downloadedBytes = [self fileSizeForPath:savZipPath];
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
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:savZipPath append:YES];
    //下载进度回调
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        //下载进度
        float progress = ((float)totalBytesRead + downloadedBytes) / (totalBytesExpectedToRead + downloadedBytes);
//        NSLog(@"%.2f%%",progress*100);
        NDLog(@"%.2f%%",progress*100);
    }];
    //成功和失败回调
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //进行解压缩
        ZipArchive *za = [[ZipArchive alloc] init];
        if ([za UnzipOpenFile: savZipPath]) {
            BOOL ret = [za UnzipFileTo:tagetPath overWrite: YES];
            if (NO == ret){} [za UnzipCloseFile];
            
             //移除已解压文件
             NSError *err;
            [[NSFileManager defaultManager] removeItemAtPath:savZipPath error:&err];
             NDLog(@"移除文件:%@",err);
            
            //路径信息插入到数据库
            [[DownLoadManage ShardedDownLoadManage]insertSavePath:savZipFloderPath              //保存路径地址
                                                         FileName:downloadModel.paperFolder     //本地文件夹名字
                                                              PID:downloadModel.pId             //主键ID
                                                          FileUrl:downloadModel.domainPFolder    //服务器链接地址
                                                       FileStatus:@"0"
                                                          Version:downloadModel.paperVersion]; //试卷状态
            
            i_ = i_+1;
            if (i_ < _data.count) {
                [self _dataArray];
            }else
            {
                return ;
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NDLog(@"Error saving file %@",error);
        i_ = i_+1;
        if (i_ < _data.count) {
            [self _dataArray];
        }else
        {
            return ;
        }
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

- (void)viewDidLoad {
    [super viewDidLoad];

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



@end
