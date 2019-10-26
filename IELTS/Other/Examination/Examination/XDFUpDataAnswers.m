//
//  XDFUpDataAnswers.m
//  IELTS
//
//  Created by 李牛顿 on 15-1-19.
//  Copyright (c) 2015年 Newton. All rights reserved.
//

#import "XDFUpDataAnswers.h"
#import "FileUploadHelper.h"
#import "XDFAnswersManage.h"

#define  kXDFPath_EvaluateThePaperSpeak @"PaperInfo/EvaluateThePaperSpeak"  //上传pm3


@interface XDFUpDataAnswers()<UIAlertViewDelegate>

@property (nonatomic,strong) NSString *lastAnser;
@property (nonatomic,strong) NSString *lastTimes;

@end


static XDFUpDataAnswers *_shareUpData;
@implementation XDFUpDataAnswers
@synthesize listenPage_,speakPage_,readPage_,writerPage_;

+(XDFUpDataAnswers *)shareUpDataAnswers
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        _shareUpData = [[self alloc]init];
    });
    return _shareUpData;
}

- (id)init
{
    if (self = [super init]) {
        [self _initView];
    }
    return self;
}

- (void)_initView
{
    //    self.dicData
    [[NSNotificationCenter defaultCenter]removeObserver:kNoNewtWork_];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(savLastAnswer) name:kNoNewtWork_ object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//保存最后的答案
- (void)savLastAnswer
{
    if (self.lastTimes.length>0 && self.lastAnser.length > 0) {
        NSString *uid = [UserModel LoadUserInfoFromLocal].UID;
        NSString *users = [NSString stringWithFormat:@"LastAnswers%@_",uid];
        [[XDFAnswersManage shardedAnswersManage]saveLastAnswer:self.lastAnser
                                                     anserTime:self.lastTimes
                                                          stID:self.stId
                                                           pID:self.pId
                                                     staskType:self.taskType
                                                         users:users];
    }
}

//移除最后的答案
- (void)remLastAnswer
{
    NSString *uid = [UserModel LoadUserInfoFromLocal].UID;
    NSString *users = [NSString stringWithFormat:@"LastAnswers%@_",uid];
    [[XDFAnswersManage shardedAnswersManage]removeLastAnswer:users];
}

- (void)finishUpLoadAnswer
{
    NSMutableString *answerString = [[NSMutableString alloc]init];
    for (int j= 0; j< listenPage_.count; j++) {
        NSDictionary * sectionData = listenPage_[j];
        NSArray *pageList =  [sectionData objectForKey:@"QuestionPageList"];
        for (int i=0 ;i < pageList.count ; i++) {
            //获取每张试卷的PID
            //            NDLog(@"%@",[pageList[i] objectForKey:@"PID"]);
            NSString *pagePId = [[pageList[i] objectForKey:@"PID"] stringValue];
            NSInteger qNumberBegin =  [[pageList[i] objectForKey:@"QNumberBegin"] integerValue];
            NSInteger qNumberEnd  = [[pageList[i] objectForKey:@"QNumberEnd"] integerValue];
            
            //有得分点
            if (qNumberEnd - qNumberBegin != 0) {
                NSString *string = [NSString stringWithFormat:@"exami%@_%@",self.pId,pagePId];
                if (![[[XDFAnswersManage shardedAnswersManage]getAnswersData:string] isKindOfClass:[NSNull class]]) {
                    NSString *answer = [[XDFAnswersManage shardedAnswersManage]getAnswersData:string];
                    if (answer != nil) {
                        [answerString appendFormat:@"%@;",answer];
                    }
                }
            }
        }
    }
    
    //    NDLog(@"%@",answerString);
    for (int j= 0; j< readPage_.count; j++) {
        NSDictionary * sectionData = readPage_[j];
        NSArray *pageList =  [sectionData objectForKey:@"QuestionPageList"];
        for (int i=0 ;i < pageList.count ; i++) {
            //获取每张试卷的PID
            //            NDLog(@"%@",[pageList[i] objectForKey:@"PID"]);
            NSString *pagePId = [[pageList[i] objectForKey:@"PID"] stringValue];
            NSInteger qNumberBegin =  [[pageList[i] objectForKey:@"QNumberBegin"] integerValue];
            NSInteger qNumberEnd  = [[pageList[i] objectForKey:@"QNumberEnd"] integerValue];
            
            if (qNumberEnd - qNumberBegin != 0) {
                NSString *string = [NSString stringWithFormat:@"exami%@_%@",self.pId,pagePId];
                if (![[[XDFAnswersManage shardedAnswersManage]getAnswersData:string] isKindOfClass:[NSNull class]]) {
                    NSString *answer = [[XDFAnswersManage shardedAnswersManage]getAnswersData:string];
                    if (answer != nil) {
                        [answerString appendFormat:@"%@;",answer];
                    }
                }
            }
        }
    }
    //    NDLog(@"%@",answerString);
    for (int j= 0; j< writerPage_.count; j++) {
        NSDictionary * sectionData = writerPage_[j];
        NSArray *pageList =  [sectionData objectForKey:@"QuestionPageList"];
        for (int i = 0 ;i < pageList.count ; i++) {
            //获取每张试卷的PID
            NDLog(@"%@",[pageList[i] objectForKey:@"PID"]);
            NSString *pagePId = [[pageList[i] objectForKey:@"PID"] stringValue];
            NSInteger qNumberBegin =  [[pageList[i] objectForKey:@"QNumberBegin"] integerValue];
            NSInteger qNumberEnd  = [[pageList[i] objectForKey:@"QNumberEnd"] integerValue];
            if (qNumberEnd - qNumberBegin != 0) {
                NSString *string = [NSString stringWithFormat:@"exami%@_%@",self.pId,pagePId];
                if (![[[XDFAnswersManage shardedAnswersManage]getAnswersData:string] isKindOfClass:[NSNull class]]) {
                    NSString *answer = [[XDFAnswersManage shardedAnswersManage]getAnswersData:string];
                    if (answer != nil) {
                        [answerString appendFormat:@"%@;",answer];
                    }
                }
            }
        }
    }
    
    //获取考试时间
    NSInteger times = 0;
    for (int i = 1; i< 5; i++) {
        NSString *saveTimeId = [NSString stringWithFormat:@"%@and%d",self.pId,i];
        NSInteger  timeId = [[XDFAnswersManage shardedAnswersManage]getTimerId:saveTimeId];
        times = times + timeId;
    }
    NSInteger cuntTimes = 40*60+60*60+60*60+14*60 - times;
    NSString *countTime = [NSString stringWithFormat:@"%ld",(long)cuntTimes];

    //上传答案
    [self upLoadAnwer:answerString times:countTime];
}


//上传答案
- (void)upLoadAnwer:(NSString *)answerString times:(NSString *)countTime
{
    self.lastAnser = @"";
    self.lastAnser = answerString;
    
    self.lastTimes = @"";
    self.lastTimes = countTime;
    
    if (countTime.length > 0 && self.pId.length > 0) {
        [[RusultManage shareRusultManage]requestExamInfoid:self.pId
                                                  costTime:countTime
                                          targetController:nil
                                                  taskType:self.taskType
                                               SuccessData:^(NSDictionary *result) {
                                                   if ([[result objectForKey:@"Result"]boolValue]) {
                                                       if (![[result objectForKey:@"Data"] isKindOfClass:[NSNull class]]) {
                                                           NSString *examinfoId =  [[result objectForKey:@"Data"] stringValue];
                                                           //上传Mp3
                                                           [self upLoadMp3:examinfoId];
                                                           //上传试卷
                                                           [self upLoadDataL:examinfoId answerString:answerString];
                                                           //修改完成状态
                                                           [self changeStatus:examinfoId stID:self.stId];
                                                       }
                                                   }else
                                                   {
                                                       NSString *infomation =  [result objectForKey:@"Infomation"];
                                                       if (kStringEqual(infomation, @"模考成绩已提交")) {
                                                           if (![[result objectForKey:@"Data"] isKindOfClass:[NSNull class]]) {
                                                               NSString *examinfoId =  [[result objectForKey:@"Data"] stringValue];
                                                               //修改完成状态
                                                               [self changeStatus:examinfoId stID:self.stId];
                                                           }

                                                           //上传成功，清除数据。
                                                           self.lastAnser = @"";
                                                           self.lastTimes = @"";
                                                           [self remLastAnswer];
                                                           //移除答案
                                                           [self removeAnswer];
                                                           //移除试卷
                                                           [self removePaper];
                                                           //移除时间
                                                           [self removeTime];
                                                           //移除考试状态
                                                           [self removeStartu];
                                                           
                                                           for (int j= 0; j< speakPage_.count; j++) {
                                                               NSDictionary * sectionData = speakPage_[j];
                                                               NSArray *pageList =  [sectionData objectForKey:@"QuestionPageList"];
                                                               for (int i=0 ;i < pageList.count ; i++) {
                                                                   //获取每张试卷的PID
                                                                   NSString *pagePId = [[pageList[i] objectForKey:@"PID"] stringValue];
                                                                   NSInteger qNumberBegin =  [[pageList[i] objectForKey:@"QNumberBegin"] integerValue];
                                                                   NSInteger qNumberEnd  = [[pageList[i] objectForKey:@"QNumberEnd"] integerValue];
                                                                   if (qNumberEnd - qNumberBegin != 0) {
                                                                       NSString *vodioUrl = [NSString stringWithFormat:@"%@_%@.mp3",self.pId,pagePId];
                                                                       NSString *localFile = [[DownLoadManage getDocumentPath] stringByAppendingPathComponent:vodioUrl];
                                                                       
                                                                       [kUserDefaults setBool:NO forKey:vodioUrl];  //可以开始录音
                                                                       [kUserDefaults synchronize];
                                                                       NSError *error;
                                                                       [[NSFileManager defaultManager]removeItemAtPath:localFile error:&error];
                                                                       NDLog(@"练习录音移除:%@",error);
                                                                   }
                                                               }
                                                           }
                                                       }
                                                   }
                                               } errorData:^(NSError *error) {
                                                   [self savLastAnswer];
                                                   NDLog(@"%@",error);
                                               }];
    }
}

- (void)upLoadDataL:(NSString *)examInfoId answerString:(NSString *)answerString
{

    //上传试卷
    if (examInfoId.length > 0 && answerString.length > 0) {
        [[RusultManage shareRusultManage]examiUpLoadController:nil
                                                       paperid:self.pId
                                                          stId:self.stId
                                                studentAnswers:answerString
                                                    examInfoId:examInfoId
                                                   SuccessData:^(NSDictionary *result) {
                                                       if ([[result objectForKey:@"Result"]boolValue]) {
                                                           //上传成功，清除数据。
                                                           self.lastAnser = @"";
                                                           self.lastTimes = @"";
                                                           [self remLastAnswer];
                                                           //移除答案
                                                           [self removeAnswer];
                                                           //移除试卷
                                                           [self removePaper];
                                                           //移除时间
                                                           [self removeTime];
                                                           //移除考试状态
                                                           [self removeStartu];
                                                       }else
                                                       {
                                                           [[RusultManage shareRusultManage]tipAlert:[result objectForKey:@"Infomation"]];
                                                       }
                                                   } errorData:^(NSError *error) {
                                                       [self savLastAnswer];
                                                       NDLog(@"%@",error);
                                                   }];
    }
}

//移除答案
- (void)removeAnswer{
    for (int j= 0; j< listenPage_.count; j++) {
        NSDictionary * sectionData = listenPage_[j];
        NSArray *pageList =  [sectionData objectForKey:@"QuestionPageList"];
        for (int i=0 ;i < pageList.count ; i++) {
            //获取每张试卷的PID
            NSString *pagePId = [[pageList[i] objectForKey:@"PID"] stringValue];
            NSInteger qNumberBegin =  [[pageList[i] objectForKey:@"QNumberBegin"] integerValue];
            NSInteger qNumberEnd  = [[pageList[i] objectForKey:@"QNumberEnd"] integerValue];
            
            //有得分点
            if (qNumberEnd - qNumberBegin != 0) {
                NSString *string = [NSString stringWithFormat:@"exami%@_%@",self.pId,pagePId];
                if (![[[XDFAnswersManage shardedAnswersManage]getAnswersData:string] isKindOfClass:[NSNull class]]) {
                    [[XDFAnswersManage shardedAnswersManage]removeAnswesData:string];
                }
            }
        }
    }
    
    for (int j= 0; j< readPage_.count; j++) {
        NSDictionary * sectionData = readPage_[j];
        NSArray *pageList =  [sectionData objectForKey:@"QuestionPageList"];
        for (int i=0 ;i < pageList.count ; i++) {
            //获取每张试卷的PID
            NSString *pagePId = [[pageList[i] objectForKey:@"PID"] stringValue];
            NSInteger qNumberBegin =  [[pageList[i] objectForKey:@"QNumberBegin"] integerValue];
            NSInteger qNumberEnd  = [[pageList[i] objectForKey:@"QNumberEnd"] integerValue];
            
            if (qNumberEnd - qNumberBegin != 0) {
                NSString *string = [NSString stringWithFormat:@"exami%@_%@",self.pId,pagePId];
                if (![[[XDFAnswersManage shardedAnswersManage]getAnswersData:string] isKindOfClass:[NSNull class]]) {
                    [[XDFAnswersManage shardedAnswersManage]removeAnswesData:string];
                }
            }
        }
    }
    for (int j= 0; j< writerPage_.count; j++) {
        NSDictionary * sectionData = writerPage_[j];
        NSArray *pageList =  [sectionData objectForKey:@"QuestionPageList"];
        for (int i=0 ;i < pageList.count ; i++) {
            //获取每张试卷的PID
            NDLog(@"%@",[pageList[i] objectForKey:@"PID"]);
            NSString *pagePId = [[pageList[i] objectForKey:@"PID"] stringValue];
            NSInteger qNumberBegin =  [[pageList[i] objectForKey:@"QNumberBegin"] integerValue];
            NSInteger qNumberEnd  = [[pageList[i] objectForKey:@"QNumberEnd"] integerValue];
            if (qNumberEnd - qNumberBegin != 0) {
                NSString *string = [NSString stringWithFormat:@"exami%@_%@",self.pId,pagePId];
                if (![[[XDFAnswersManage shardedAnswersManage]getAnswersData:string] isKindOfClass:[NSNull class]]) {
                    [[XDFAnswersManage shardedAnswersManage]removeAnswesData:string];
                }
            }
        }
    }
    
    for (int j= 0; j< speakPage_.count; j++) {
        NSDictionary * sectionData = speakPage_[j];
        NSArray *pageList =  [sectionData objectForKey:@"QuestionPageList"];
        for (int i=0 ;i < pageList.count ; i++) {
            //获取每张试卷的PID
            NDLog(@"%@",[pageList[i] objectForKey:@"PID"]);
            NSString *pagePId = [[pageList[i] objectForKey:@"PID"] stringValue];
            
            NSInteger qNumberBegin =  [[pageList[i] objectForKey:@"QNumberBegin"] integerValue];
            NSInteger qNumberEnd  = [[pageList[i] objectForKey:@"QNumberEnd"] integerValue];
            
            if (qNumberEnd - qNumberBegin != 0) {
                NSString *string = [NSString stringWithFormat:@"exami%@_%@",self.pId,pagePId];
                if (![[[XDFAnswersManage shardedAnswersManage]getAnswersData:string] isKindOfClass:[NSNull class]]) {
                    [[XDFAnswersManage shardedAnswersManage]removeAnswesData:string];
                }
            }
        }
    }
}

//移除试卷
- (void)removePaper
{
    NSError *err;
    NSString *fileForld = [[DownLoadManage ShardedDownLoadManage]useIDSelect:_pId];
    NSString *savZipFloderPath =  [NSString stringWithFormat:@"%@/%@",[DownLoadManage getDocumentPath],fileForld];
    [[NSFileManager defaultManager] removeItemAtPath:savZipFloderPath error:&err];
    if (err != nil) {
        NDLog(@"移除试卷失败:%@",err);
    }else
    {
        NDLog(@"移除试卷成功");
    }
}
//移除时间
- (void)removeTime
{
    for (int i = 1; i< 5; i++) {
        NSString *saveTimeId = [NSString stringWithFormat:@"%@and%d",self.pId,i];
        [[XDFAnswersManage shardedAnswersManage]remTimerId:saveTimeId];
    }
}
//移除本地保存状态
- (void)removeStartu
{
    [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:kCSection(self.pId)];
    [[NSUserDefaults standardUserDefaults]synchronize];
    //保存当前状态
    if (self.pId.length > 0) {
        [[XDFAnswersManage shardedAnswersManage]removeLastStatus:self.pId];
    }
}

//修改状态，用于首页和
- (void)changeStatus:(NSString *)examinfoId stID:(NSString *)st_id
{
    [[RusultManage shareRusultManage]homeTaskController:nil
                                                  keyID:st_id
                                             examInfoId:examinfoId
                                            SuccessData:^(NSDictionary *result) {
                                                NDLog(@"%@",result);
                                            } errorData:^(NSError *error) {
                                                
                                            }];
}

- (void)upLoadMp3:(NSString *)examinfoId
{
    for (int j= 0; j< speakPage_.count; j++) {
        NSDictionary * sectionData = speakPage_[j];
        NSArray *pageList =  [sectionData objectForKey:@"QuestionPageList"];
        for (int i=0 ;i < pageList.count ; i++) {
            //获取每张试卷的PID
            NDLog(@"%@",[pageList[i] objectForKey:@"PID"]);
            NSString *pagePId = [[pageList[i] objectForKey:@"PID"] stringValue];
            
            NSInteger qNumberBegin =  [[pageList[i] objectForKey:@"QNumberBegin"] integerValue];
            NSInteger qNumberEnd  = [[pageList[i] objectForKey:@"QNumberEnd"] integerValue];
            
            if (qNumberEnd - qNumberBegin != 0) {
                NSString *string = [NSString stringWithFormat:@"exami%@_%@",self.pId,pagePId];
                if (![[[XDFAnswersManage shardedAnswersManage]getAnswersData:string] isKindOfClass:[NSNull class]]) {
                    NSString *answer = [[XDFAnswersManage shardedAnswersManage]getAnswersData:string];
                    //上传mp3
                    [self upLoadMp3:examinfoId pageID:pagePId stId:self.stId answer:answer pid:self.pId];
                }
            }
        }
    }
    
    
}


- (void)upLoadMp3:(NSString *)examinfoId pageID:(NSString *)p_Id stId:(NSString *)st_ID answer:(NSString *)answer pid:(NSString *)pid
{
    /*
     /api/PaperInfo/EvaluateThePaperSpeak
     paperId=[考试试卷的主键ID]&examinfoId=[该次考试信息主键ID]&qsCode=[学生答案的code]& stid = [任务主键id]
     */
    NSString *qsCode = [[answer componentsSeparatedByString:@"|"]firstObject];
    if (qsCode.length > 0) {
        NSString *path = [NSString stringWithFormat:@"%@/PaperInfo/EvaluateThePaperSpeak?paperId=%@&examinfoId=%@&qsCode=%@&stId=%@",BaseURLString,pid,examinfoId,qsCode,st_ID];
        //        NSString *vodioUrl = [NSString stringWithFormat:@"%@.mp3",p_Id];
        NSString *vodioUrl = [NSString stringWithFormat:@"%@_%@.mp3",pid,p_Id];
        NSString *localFile = [[DownLoadManage getDocumentPath] stringByAppendingPathComponent:vodioUrl];
        NSString *fileName = vodioUrl;
        NSLog(@"%@",vodioUrl);
        if (fileName.length > 0) {
            [FileUploadHelper fileUploadMp3WithUrl:path FilePath:localFile FileName:fileName Success:^(NSDictionary *result){
                NSLog(@"%@",result);
                self.lastAnser = @"";
                self.lastTimes = @"";
                
                [kUserDefaults setBool:NO forKey:vodioUrl];  //可以开始录音
                [kUserDefaults synchronize];
                NSError *error;
                [[NSFileManager defaultManager]removeItemAtPath:localFile error:&error];
                NSLog(@"练习录音移除:%@",error);
            }];
        }
    }
}


@end
