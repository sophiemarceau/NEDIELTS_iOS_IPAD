//
//  XDFDownLoadModel.m
//  IELTS
//
//  Created by 李牛顿 on 14-12-20.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFDownLoadModel.h"

@implementation XDFDownLoadModel

- (id)initWithData:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self _dealWithData:dic];
    }
    return  self;
}

- (void)_dealWithData:(NSDictionary *)dic
{
    self.pId = [dic objectForKey:@"P_ID"];
    self.paperFolder = [dic objectForKey:@"PaperFolder"];
    self.paperState = [dic objectForKey:@"PaperState"];
    self.paperVersion = [[dic objectForKey:@"PaperVersion"] stringValue];
    self.paperZip = [dic objectForKey:@"PaperZip"];
    self.domainPFolder = [dic objectForKey:@"domainPFolder"];
    self.domainPZip = [dic objectForKey:@"domainPZip"];
    self.paperName = [dic objectForKey:@"paperName"];
}

@end
