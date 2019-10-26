//
//  UserModel.m
//  IELTS
//
//  Created by 李牛顿 on 14-11-19.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import "UserModel.h"
#import "RusultManage.h"

#define USERINFOSAVE @"UserInfoData"

@implementation UserModel

-(void) SaveUserInfoLocal:(NSString *)token
{
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    CHECK_DATA_IS_NSNULL(self.UID, NSString);
    CHECK_DATA_IS_NSNULL(self.Account, NSString);
    CHECK_DATA_IS_NSNULL(self.NickName, NSString);
    CHECK_DATA_IS_NSNULL(token, NSString);

    NSDictionary *data = @{@"UID":self.UID,
                           @"Account":self.Account,
                           @"IconUrl":self.IconUrl,
                           @"NickName":self.NickName,
                           @"Token":token};
    
    [accountDefaults setObject:data forKey:USERINFOSAVE];
}

-(void) UserLogoff
{
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults removeObjectForKey:USERINFOSAVE];
    [RusultManage shareRusultManage].userToken = nil;
    [RusultManage shareRusultManage].userMode = nil;
    [RusultManage shareRusultManage].userId = nil;
}

+(UserModel *) LoadUserInfoFromLocal
{
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userinfo = [accountDefaults objectForKey:USERINFOSAVE];
    if(userinfo == nil) return nil;
    
    UserModel *um = [[UserModel alloc] init];
    um.UID = [userinfo objectForKey:@"UID"];
    um.Account = [userinfo objectForKey:@"Account"];
    um.IconUrl = [userinfo objectForKey:@"IconUrl"];
    um.NickName = [userinfo objectForKey:@"NickName"];
    
    [RusultManage shareRusultManage].userToken = [userinfo objectForKey:@"Token"];
    [RusultManage shareRusultManage].userMode = um;
    [RusultManage shareRusultManage].userId = [userinfo objectForKey:@"Account"];
    
    return um;
}

@end
