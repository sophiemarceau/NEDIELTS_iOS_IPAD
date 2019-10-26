//
//  NetworkManager.m
//  MedicineTrace
//
//  Created by melp on 13-9-18.
//  Copyright (c) 2013年 pfizer. All rights reserved.
//

#import "NetworkManager.h"
//#import "CacheManage.h"

static NetworkManager *_sharedNetworkManager;

#define TIMEOUTTIME 10

@implementation NetworkManager
{
    MBProgressHUD *HUD;
    BOOL _isShowHUD;
    
    int r;
    NSTimer *_Timeout;
}

+(NetworkManager*) SharedNetworkManager
{
    static NetworkManager *shareRusult;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        shareRusult = [[self alloc]init];
    });
    return shareRusult;
}

-(id) init
{
    self = [super init];
    
    _NetworkStatus = YES;
    r = 0;
    HUD = [MBProgressHUD showHUDAddedTo:[[UIView alloc] init] animated:YES];
    _isShowHUD = NO;
    
    return self;
}

- (void)monitorNetwork:(UIWindow *)window
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNoNewtWork_ object:nil];
            [window makeToast:@"当前网络不可用,请检测网络。" duration:2.0 position:@"bottom"];
        }else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kHasNewtWork_ object:nil];
        }
    }];
}


- (void)onTimeoutTimer:(NSTimer *)timer
{
    if(_isShowHUD)
    {
        _isShowHUD = !_isShowHUD;
       [HUD hide:YES];
    }
    
    _NetworkStatus = NO;
}

- (void)requestGetWithParameters:(NSDictionary *)parameters
                        ApiPath:(NSString*)path
                        WithHeader:(NSDictionary*)headers
                        onTarget:(UIViewController *)target
                        success:(void (^)(NSDictionary *result,NSDictionary *headers))success
                        failure:(void (^)(NSError *error))failure
{

    if(!_NetworkStatus)
    {
//        NSDictionary *cacheData = [[CacheManage SharedCacheManages] CachedResponse:path];
//        NSString *cached = [cacheData objectForKey:@"cache"];
//        if([cached isEqualToString:@"YES"])
//        {
//            id jObj = [cacheData objectForKey:@"json"];
//            success(jObj,nil);
//            return;
//        }else
//        {
//            [[RusultManage shareRusultManage]tipAlert:@"请检查网络状态"];
//            return;
//        }
    }
    
    NSString *apiPath = path;
    NSMutableDictionary *hrParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    if(target != nil)
    {
        if(!_isShowHUD)
        {
            HUD = [MBProgressHUD showHUDAddedTo:target.view animated:YES];
            HUD.delegate = self;
            HUD.labelText = @"Loading ...";
            HUD.removeFromSuperViewOnHide = YES;
            [HUD show:YES];
            _isShowHUD = YES;
        }
    }
    
//    [_Timeout invalidate];
//    _Timeout = [NSTimer scheduledTimerWithTimeInterval:TIMEOUTTIME target:self selector:@selector(onTimeoutTimer:) userInfo:nil repeats:NO];
    
    path = [NSString stringWithFormat:@"%@/%@",BaseURLString,path];
    

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if (headers != nil) {
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager.requestSerializer setValue:[headers objectForKey:@"Authentication"] forHTTPHeaderField:@"Authentication"];
    }

    [manager GET:path
      parameters:hrParameters
         success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        _NetworkStatus = YES;
        [_Timeout invalidate];
        
        NDLog(@"\n[API]= %@\n[RES]= %@", apiPath,[operation responseString]);
        
//        [[CacheManage SharedCacheManages] CacheWebAPI:apiPath AndResponse:[operation responseString]];
        
        if(target != nil)
        {
            _isShowHUD = NO;
            [HUD hide:YES];
        }
        
        success(responseObject,[operation.response allHeaderFields]);
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NDLog(@"Error: %@", [operation responseString]);
        [_Timeout invalidate];
        failure(error);
        
        if (target != nil)
        {
            _isShowHUD = NO;
            [HUD hide:YES];
        }
        
        if([operation responseString] == nil) return;
        
        NSRange range = [[operation responseString] rangeOfString:@"您长时间未操作，请重新登录"];
        if(range.location != NSNotFound)
        {
            NSLog(@"%@",[operation responseString]);
            
            //登录过期
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SYSTEMMSG" object:@{@"Action":@"Exit"}];
        }
        
        
    }];
}

- (void)requestPostWithParameters:(NSDictionary *)parameters
                         ApiPath:(NSString*)path
                      WithHeader:(NSDictionary*)headers
                        onTarget:(UIViewController *)target
                         success:(void (^)(NSDictionary *result,NSDictionary *headers))success
                         failure:(void (^)(NSError *error))failure
{
    

    
     if(!_NetworkStatus)
     {
//         NSDictionary *cacheData = [[CacheManage SharedCacheManages] CachedResponse:path];
//         NSString *cached = [cacheData objectForKey:@"cache"];
//         if([cached isEqualToString:@"YES"])
//         {
//             id jObj = [cacheData objectForKey:@"json"];
//             success(jObj,nil);
//             return;
//         }else
//         {
//             [[RusultManage shareRusultManage]tipAlert:@"请检查网络状态"];
//             return;
//         }
     }
    
     NSString *apiPath = path;
     
     NSMutableDictionary *hrParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
     
     if(target != nil)
     {
       if(!_isShowHUD)
       {
         HUD = [MBProgressHUD showHUDAddedTo:target.view animated:YES];
         HUD.delegate = self;
         HUD.labelText = @"Loading ...";
         HUD.removeFromSuperViewOnHide = YES;
         [HUD show:YES];
         _isShowHUD = YES;
       }
     }
     
//     [_Timeout invalidate];
//     _Timeout = [NSTimer scheduledTimerWithTimeInterval:TIMEOUTTIME target:self selector:@selector(onTimeoutTimer:) userInfo:nil repeats:NO];
    
     path = [NSString stringWithFormat:@"%@/%@",BaseURLString,path];
     
     AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    if (headers != nil) {
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//        manager.requestSerializer = [AFJSONRequestSerializer serializer];
//        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager.requestSerializer setValue:[headers objectForKey:@"Authentication"] forHTTPHeaderField:@"Authentication"];
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    }
     [manager POST:path
        parameters:hrParameters
           success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         _NetworkStatus = YES;
         [_Timeout invalidate];
         
         NDLog(@"\n[API]= %@\n[RES]= %@", apiPath,[operation responseString]);
         //缓存数据
//         [[CacheManage SharedCacheManages] CacheWebAPI:apiPath AndResponse:[operation responseString]];
         
         if(target != nil)
         {
           _isShowHUD = NO;
           [HUD hide:YES];
         }
          success(responseObject,[operation.response allHeaderFields]);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", [operation responseString]);
         [_Timeout invalidate];
         failure(error);
         
         if (target != nil)
         {
          _isShowHUD = NO;
          [HUD hide:YES];
         }
         
         if([operation responseString] == nil) return;
         
         NSRange range = [[operation responseString] rangeOfString:@"您长时间未操作，请重新登录"];
         if(range.location != NSNotFound)
         {
         NDLog(@"%@",[operation responseString]);
         
         //登录过期
         [[NSNotificationCenter defaultCenter] postNotificationName:@"SYSTEMMSG" object:@{@"Action":@"Exit"}];
         }
     }];

}


#pragma mark - 读服务器配置文件
- (void)requestGetWithApiPath:(NSString*)path
                   WithHeader:(NSDictionary*)headers
                     onTarget:(UIViewController *)target
                      success:(void (^)(NSDictionary *result,NSDictionary *headers))success
                      failure:(void (^)(NSError *error))failure
{

    NSString *apiPath = path;
    if(target != nil)
    {
        if(!_isShowHUD)
        {
            HUD = [MBProgressHUD showHUDAddedTo:target.view animated:YES];
            HUD.delegate = self;
            HUD.labelText = @"Loading ...";
            HUD.removeFromSuperViewOnHide = YES;
            [HUD show:YES];
            _isShowHUD = YES;
        }
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:apiPath
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         _NetworkStatus = YES;

         NDLog(@"\n[API]= %@\n[RES]= %@", apiPath,[operation responseString]);
         
         if(target != nil)
         {
             _isShowHUD = NO;
             [HUD hide:YES];
         }
         
         success(responseObject,[operation.response allHeaderFields]);
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NDLog(@"Error: %@", [operation responseString]);
         failure(error);

         if (target != nil)
         {
             _isShowHUD = NO;
             [HUD hide:YES];
         }
         if([operation responseString] == nil) return;
     }];
}


- (void)registPostU2WithParameters:(NSDictionary *)parameters
                        onTarget:(UIViewController *)target
                         success:(void (^)(NSDictionary *result,NSDictionary *headers))success
                         failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *hrParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if(target != nil)
    {
        if(!_isShowHUD)
        {
            HUD = [MBProgressHUD showHUDAddedTo:target.view animated:YES];
            HUD.delegate = self;
            HUD.labelText = @"Loading ...";
            HUD.removeFromSuperViewOnHide = YES;
            [HUD show:YES];
            _isShowHUD = YES;
        }
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:BaseU2LoginURLString
       parameters:hrParameters
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         _NetworkStatus = YES;
         
         if(target != nil)
         {
             _isShowHUD = NO;
             [HUD hide:YES];
         }
         NSError *error = nil;
         id jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
         NDLog(@"U2_jsonObject%@",error);
         success(jsonObject,[operation.response allHeaderFields]);
//         success(responseObject,[operation.response allHeaderFields]);
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"U2_Error: %@", [operation responseString]);
         failure(error);
         if (target != nil)
         {
             _isShowHUD = NO;
             [HUD hide:YES];
         }
         if([operation responseString] == nil) return;
     }];
}



@end
