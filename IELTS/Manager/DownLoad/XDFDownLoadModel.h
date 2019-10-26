//
//  XDFDownLoadModel.h
//  IELTS
//
//  Created by 李牛顿 on 14-12-20.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import <Foundation/Foundation.h>

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


@interface XDFDownLoadModel : NSObject


@property (nonatomic,strong)NSString *pId;
@property (nonatomic,strong)NSString *paperFolder;
@property (nonatomic,strong)NSString *paperState;
@property (nonatomic,strong)NSString *paperVersion;
@property (nonatomic,strong)NSString *paperZip;
@property (nonatomic,strong)NSString *domainPFolder;
@property (nonatomic,strong)NSString *domainPZip;
@property (nonatomic,strong)NSString *paperName;

- (id)initWithData:(NSDictionary *)dic;


@end
