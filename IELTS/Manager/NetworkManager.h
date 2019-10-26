//
//  NetworkManager.h
//  MedicineTrace
//
//  Created by melp on 13-9-18.
//  Copyright (c) 2013年 pfizer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h" 




@interface NetworkManager : NSObject <MBProgressHUDDelegate>

+(NetworkManager*) SharedNetworkManager;

@property (nonatomic) BOOL NetworkStatus;

//- (void)monitorNetwork;
- (void)monitorNetwork:(UIWindow *)window;

- (void)requestGetWithParameters:(NSDictionary *)parameters
                        ApiPath:(NSString*)path
                        WithHeader:(NSDictionary*)headers
                        onTarget:(UIViewController *)target
                        success:(void (^)(NSDictionary *result,NSDictionary *headers))success
                        failure:(void (^)(NSError *error))failure;

- (void)requestPostWithParameters:(NSDictionary *)parameters
                         ApiPath:(NSString*)path
                      WithHeader:(NSDictionary*)headers
                        onTarget:(UIViewController *)target
                         success:(void (^)(NSDictionary *result,NSDictionary *headers))success
                         failure:(void (^)(NSError *error))failure;

#pragma mark - 读服务器配置文件
- (void)requestGetWithApiPath:(NSString*)path
                   WithHeader:(NSDictionary*)headers
                     onTarget:(UIViewController *)target
                      success:(void (^)(NSDictionary *result,NSDictionary *headers))success
                      failure:(void (^)(NSError *error))failure;

#pragma mark - U2注册
- (void)registPostU2WithParameters:(NSDictionary *)parameters
                          onTarget:(UIViewController *)target
                           success:(void (^)(NSDictionary *result,NSDictionary *headers))success
                           failure:(void (^)(NSError *error))failure;




@end
