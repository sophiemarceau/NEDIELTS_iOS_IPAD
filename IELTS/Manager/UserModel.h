//
//  UserModel.h
//  IELTS
//
//  Created by 李牛顿 on 14-11-19.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface UserModel : BaseModel

@property (nonatomic,strong)NSString *Account; //登陆名
@property (nonatomic,strong)NSString *IconUrl;
@property (nonatomic,strong)NSString *UID;
@property (nonatomic,strong)NSString *NickName;  //昵称

-(void) SaveUserInfoLocal:(NSString *)token;
-(void) UserLogoff;
+(UserModel *) LoadUserInfoFromLocal;

@end
