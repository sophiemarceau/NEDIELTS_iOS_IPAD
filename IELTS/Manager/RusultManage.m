//
//  RusultManage.m
//  IELTS
//
//  Created by 李牛顿 on 14-11-19.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import "RusultManage.h"
#import "NetworkManager.h"

#define kXDFPath_Logon                          @"User/logon"                   //登陆
//#define kXDFPath_Logon                          @"User/AppStudentLogin"

#define kXDFPath_Regist                         @"User/regist"                  //注册
//#define kXDFPath_Passforget                     @"User/passforget"              //忘记密码
#define kXDFPath_PassChange                     @"User/passchange"              //修改密码
#define kXDFPath_BindStudentCode                @"User/bindstudentcode"         //绑定学员编号
#define kXDFPath_LoadBindStudentCode            @"User/studentcodelist"         //获取已绑定的学员编号
#define kXDFPath_HomeComplete                   @"Home/CompleteRate"            //首页-进度
#define kXDFPath_HomeMessage                    @"Home/MyMessageList"           //首页-消息
#define kXDFPath_HomeTask                       @"Home/MyTaskList"              //首页-任务
#define kXDFPath_HomeMessageRead                @"Message/MessageRead"          //首页-读取消息
#define kXDFPath_ScheduleTask                   @"Task/MyAllTasks"              //计划-任务
#define kXDFPath_ScheduleClass                  @"Task/MyAllLessons"            //计划-课表
#define kXDFPath_MyMaterialsList                @"Material/MyMaterialsList"               //学习-班级列表
#define kXDFPath_MyMaterialsFavoriteList        @"Material/MyMaterialsFavoriteList"       //学习-收藏列表
#define kXDFPath_AddOrCancelMaterialsFavorite   @"Material/AddOrCancelMaterialsFavorite"  //学习-取消或添加收藏
#define kXDFPath_ClassListByUID                 @"User/classListByUID"                //学习-班级列表
#define kXDFPath_LessonListByClassID            @"User/lessonListByClassID"           //学习-课次
#define kXDFPath_ExerciseResult                 @"PaperInfo/MyAllPaperInfoOfLx"       //练习-首页
#define kXDFPath_ExerciseDateResult             @"PaperInfo/MyPaperInfoOfDayLx"       //练习-日
#define kXDFPath_ExerciseTypeResult             @"PaperInfo/MyPaperInfoOfTypeLx"      //练习-类型
#define kXDFPath_ExaminationController          @"PaperInfo/MyAllPaperInfoOfMk"       //模考-首页
#define kXDFPath_SysMessageSuggestion           @"Message/AddSuggestionInfo"          //设置-意见反馈
#define kXDFPath_SysMyAllMessage                @"Message/MyAllMessageNoRead"         //设置-我的消息
#define kXDFPath_SysTargetPage                  @"Home/MyTargetsPage"                 //设置-我的目标-所有数据
#define kXDFPath_SysTargetScore                 @"Home/UpdateStudentSettings"         //设置-我的目标-设定的目标成绩
#define kXDFPath_SysCurrentScore                @"Home/UpdateStudentSettingsMyLastScores"         //设置-我的目标-设定的目前成绩
#define kXDFPath_SysTestType                    @"Home/UpdateStudentSettingsKslb"    //设置-我的目标-考试类别
#define kXDFPath_SysUpDateTargetDate            @"Home/UpdateTargetDate"             //设置-我的目标-更新一条我设定的各种日期
#define kXDFPath_SysDelTargetDate               @"Home/RemoveTargetDate"             //设置-我的目标-删除一条我设定的各种日期
#define kXDFPath_SysAddTargetDate               @"Home/AddTargetDate"                //设置-我的目标-新增一条我设定的各种日期
#define kXDFPath_DownloadZip                    @"Task/MyMkDownloadTasks"            //下载本人的zip列表
#define kXDFPath_SearchMarkResultMK             @"PaperInfo/MyMarkReportOfMk"        //模考-成绩报告
#define kXDFPath_SearchMarkResultLX             @"PaperInfo/MyMarkReportOfLx"        //练习-成绩报告
#define kXDFPath_InsertTaskFinish               @"Task/InsertTaskFinish"             //更新TaskFinish任务完成情况表
#define kXDFPath_MyAllMessageNoReadCount        @"Message/MyAllMessageNoReadCount"   //所有未读消息
#define kXDFPath_EvaluateThePaper               @"PaperInfo/EvaluateThePaper"        //判卷
#define kXDFPath_createExamInfoId               @"PaperInfo/createExamInfoId"        //查询examinfoid
#define kXDFPath_LookQuestionDocs               @"PaperInfo/LookQuestionDocs"        //查看解析
#define kXDFPath_LookThePaperAnswer             @"PaperInfo/LookThePaperAnswer"      //查看答案
#define kXDFPath_ReadOrDelMessage               @"Message/ReadOrDelMessage"          //更新具体人员的系统消息的阅读(或删除)状态
#define kXDFPath_UpdateScoreOfMyOwnGive         @"PaperInfo/updateScoreOfMyOwnGive"  //自我评分
#define kXDFPath_UpdateScheduleTaskStatus       @"Task/UpdateScheduleTaskStatus"   //更新任务状态




@implementation RusultManage

+(RusultManage *)shareRusultManage
{
    static RusultManage *shareRusult;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        shareRusult = [[self alloc]init];
    });
    return shareRusult;
}

#pragma  mark - 登陆接口
- (void)logonRusult:(NSDictionary *)dicData
     viewController:(UIViewController *)controller
        successData:(SuccessData)success
{

    [[NetworkManager SharedNetworkManager]requestPostWithParameters:dicData
                                                            ApiPath:kXDFPath_Logon
                                                         WithHeader:nil
                                                           onTarget:controller
                                                            success:^(NSDictionary *result, NSDictionary *headers) {
                                                                
                                                                if ([[result objectForKey:@"Result"]boolValue]) {
                                                                    
                                                                    NSDictionary *userData =  [result objectForKey:@"Data"];
                                                                    self.userToken = [userData objectForKey:@"Token"];
                                                                    
                                                                    NSDictionary *userInfor = [userData objectForKey:@"UserInfo"];
                                                                    
                                                                    NSString *account = [userInfor objectForKey:@"Account"];
                                                                    CHECK_DATA_IS_NSNULL(account, NSString);
                                                                    self.userId = account;

                                                                    
                                                                    self.userMode = [[UserModel alloc]initWithDataDic:userInfor];
                                                        
                                                                    [self.userMode SaveUserInfoLocal:self.userToken];
                                                                    
                                                                     success(result);
                                                                }else
                                                                {
                                                                    [self tipAlert:[result objectForKey:@"Infomation"] viewController:controller];
                                                                }
                                                               
                                                            } failure:^(NSError *error) {
                                                                [self tipAlert:[error localizedDescription]];
//                                                                [self tipAlert:@"登陆失败" viewController:controller];
                                                            }];

    
}

#pragma mark - 注册接口
- (void)registRusult:(NSDictionary *)dicData
      viewController:(UIViewController *)controller
         successData:(SuccessData)success
{
    
    [[NetworkManager SharedNetworkManager]requestPostWithParameters:dicData
                                                            ApiPath:kXDFPath_Regist
                                                         WithHeader:nil
                                                           onTarget:controller
                                                            success:^(NSDictionary *result, NSDictionary *headers) {
                                                                NDLog(@"%@",[result objectForKey:@"Result"]);
                                                                
                                                                if ([[result objectForKey:@"Result"]boolValue]) {
                                                                    success(result);
                                                                }else
                                                                {
                                                                    [self tipAlert:[result objectForKey:@"Infomation"]];
                                                                }
                                                            } failure:^(NSError *error) {
                                                                [self tipAlert:[error localizedDescription]];
                                                            }];

    
}

#pragma mark - 找回密码
//- (void)passforgetRusult:(NSDictionary *)dicData
//          viewController:(UIViewController *)controller
//             successData:(SuccessData)success
//{
//    [[NetworkManager SharedNetworkManager]requestPostWithParameters:dicData
//                                                            ApiPath:kXDFPath_Passforget
//                                                         WithHeader:nil
//                                                           onTarget:controller
//                                                            success:^(NSDictionary *result, NSDictionary *headers) {
//                                                                if ([[result objectForKey:@"Result"]boolValue]) {
//                                                                     success(result);
//                                                                }else
//                                                                {
//                                                                    [self tipAlert:[result objectForKey:@"Infomation"] viewController:controller];
//                                                                }
//                                                                
//                                                            } failure:^(NSError *error) {
////                                                                [self tipAlert:[error localizedDescription]];
//                                                            }];
//
//}

#pragma mark - 修改密码
- (void)passChangeRusult:(NSDictionary *)dicData
          viewController:(UIViewController *)controller
             successData:(SuccessData)success
{
     NSDictionary *dic = @{@"Authentication":self.userToken};
    [[NetworkManager SharedNetworkManager]requestGetWithParameters:dicData
                                                            ApiPath:kXDFPath_PassChange
                                                         WithHeader:dic
                                                           onTarget:controller
                                                            success:^(NSDictionary *result, NSDictionary *headers) {
                                                                
//                                                                if ([[result objectForKey:@"Result"]boolValue]) {
                                                                    success(result);
//                                                                }else
//                                                                {
//                                                                    [self tipAlert:[result objectForKey:@"Infomation"]];
//                                                                }
                                                                
                                                            } failure:^(NSError *error) {
//                                                                [self tipAlert:[error localizedDescription]];
                                                            }];



}

#pragma mark - 绑定学员编号
- (void)bindStudentCodeRusult:(NSDictionary *)dicData
               viewController:(UIViewController *)controller
                  successData:(SuccessData)success
{
    NSDictionary *dic = @{@"Authentication":self.userToken};
    [[NetworkManager SharedNetworkManager]requestGetWithParameters:dicData
                                                            ApiPath:kXDFPath_BindStudentCode
                                                         WithHeader:dic
                                                           onTarget:controller
                                                            success:^(NSDictionary *result, NSDictionary *headers) {
                                                                
                                                                    success(result);
                                                                                                                                
                                                            } failure:^(NSError *error) {
//                                                                [self tipAlert:[error localizedDescription]];
                                                            }];
}

#pragma mark - 获取已绑定的学员编号
- (void)LoadbindStudentCodeRusult:(NSDictionary *)dicData
                   viewController:(UIViewController *)controller
                      successData:(SuccessData)success
{
    NSDictionary *dic = @{@"Authentication":self.userToken};
    [[NetworkManager SharedNetworkManager]requestGetWithParameters:dicData
                                                            ApiPath:kXDFPath_LoadBindStudentCode
                                                         WithHeader:dic
                                                           onTarget:controller
                                                            success:^(NSDictionary *result, NSDictionary *headers) {
                                                                
                                                                if ([[result objectForKey:@"Result"]boolValue]) {
                                                                    success(result);
                                                                }else
                                                                {
//                                                                    [self tipAlert:[result objectForKey:@"Infomation"]];
                                                                }
                                                                
                                                            } failure:^(NSError *error) {
//                                                                [self tipAlert:[error localizedDescription]];
                                                            }];
}


#pragma mark - 【首页-各种完成进度】
- (void)completeRateviewController:(UIViewController *)controller
                       successData:(SuccessData)success
                        errorData:(ErrorData)errors
{
    NSDictionary *dic = @{@"Authentication":self.userToken};
    [[NetworkManager SharedNetworkManager]requestGetWithParameters:nil
                                                           ApiPath:kXDFPath_HomeComplete
                                                        WithHeader:dic
                                                          onTarget:controller
                                                           success:^(NSDictionary *result, NSDictionary *headers) {
                                                               if ([[result objectForKey:@"Result"]boolValue]) {
                                                                   success(result);
                                                               }else
                                                               {
//                                                                   [self tipAlert:[result objectForKey:@"Infomation"]];
                                                               }

                                                           } failure:^(NSError *error) {
                                                               errors(error);
//                                                               [self tipAlert:[error localizedDescription]];
                                                           }];
    
}

#pragma mark - 【首页-我的消息】
- (void)myMessageListRusult:(NSDictionary *)dicData
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                  errorData:(ErrorData)errors
{
    NSDictionary *dic = @{@"Authentication":self.userToken};
    [[NetworkManager SharedNetworkManager]requestGetWithParameters:dicData
                                                           ApiPath:kXDFPath_HomeMessage
                                                        WithHeader:dic
                                                          onTarget:controller
                                                           success:^(NSDictionary *result, NSDictionary *headers) {
                                                               success(result);

                                                           } failure:^(NSError *error) {
                                                                errors(error);
//                                                                [self tipAlert:[error localizedDescription]];
                                                           }];

}

#pragma mark - 【首页-我的任务】
- (void)myTaskListRusult:(NSDictionary *)dicData
          viewController:(UIViewController *)controller
             successData:(SuccessData)success
               errorData:(ErrorData)errors
{
    NSDictionary *dic = @{@"Authentication":self.userToken};
    [[NetworkManager SharedNetworkManager]requestGetWithParameters:nil
                                                           ApiPath:kXDFPath_HomeTask
                                                        WithHeader:dic
                                                          onTarget:controller
                                                           success:^(NSDictionary *result, NSDictionary *headers) {
//                                                               if ([[result objectForKey:@"Result"]boolValue]) {
                                                                   success(result);
//                                                               }else
//                                                               {
//                                                                   
////                                                                   [self tipAlert:[result objectForKey:@"Infomation"]];
//                                                               }

                                                           } failure:^(NSError *error) {
                                                               errors(error);
//                                                               [self tipAlert:[error localizedDescription]];

                                                           }];

}


#pragma mark - 【首页-读取一条消息】
- (void)messageReadRusult:(NSDictionary *)dicData
           viewController:(UIViewController *)controller
              successData:(SuccessData)success
{
    /*
     读取一条消息
     [Get] + Auth
     /api/Message/MessageRead?mid=[消息ID]
     */
    [[NetworkManager SharedNetworkManager]requestGetWithParameters:dicData
                                                           ApiPath:kXDFPath_HomeMessageRead
                                                        WithHeader:nil
                                                          onTarget:controller
                                                           success:^(NSDictionary *result, NSDictionary *headers) {
                                                               
                                                           } failure:^(NSError *error) {
                                                               
                                                           }];

}

#pragma mark - 【计划-任务】
- (void)scheduleTaskRusult:(NSString *)dateString
            viewController:(UIViewController *)controller
               successData:(SuccessData)success
{
    NSDictionary *dic = @{@"Authentication":self.userToken};
    NSDictionary *dicData = @{@"dateParam":dateString};
    [[NetworkManager SharedNetworkManager]requestGetWithParameters:dicData
                                                           ApiPath:kXDFPath_ScheduleTask
                                                        WithHeader:dic
                                                          onTarget:controller
                                                           success:^(NSDictionary *result, NSDictionary *headers) {
                                                               if ([[result objectForKey:@"Result"]boolValue]) {
                                                                   success(result);
                                                               }else
                                                               {
//                                                                   [self tipAlert:[result objectForKey:@"Infomation"]];
                                                               }
                                                               
                                                           } failure:^(NSError *error) {
//                                                               [self tipAlert:[error localizedDescription]];
                                                               
                                                           }];

}

#pragma mark - 【计划-课表】
- (void)scheduleClassRusult:(NSString *)dateString
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
{
    NSDictionary *dicData = @{@"dateParam":dateString};
    NSDictionary *dic = @{@"Authentication":self.userToken};
    [[NetworkManager SharedNetworkManager]requestGetWithParameters:dicData
                                                           ApiPath:kXDFPath_ScheduleClass
                                                        WithHeader:dic
                                                          onTarget:controller
                                                           success:^(NSDictionary *result, NSDictionary *headers) {
                                                               if ([[result objectForKey:@"Result"]boolValue]) {
                                                                   success(result);
                                                               }else
                                                               {
//                                                                   [self tipAlert:[result objectForKey:@"Infomation"]];
                                                               }
                                                               
                                                           } failure:^(NSError *error) {
//                                                               [self tipAlert:[error localizedDescription]];
                                                               
                                                           }];

}

#pragma mark - 【学习-查出班级】
- (void)studyGetClassRusult:(UIViewController *)controller
                successData:(SuccessData)success
                   errorData:(ErrorData)errors
{
    
    NSDictionary *dic = @{@"Authentication":self.userToken};
    [[NetworkManager SharedNetworkManager]requestGetWithParameters:nil
                                                           ApiPath:kXDFPath_ClassListByUID
                                                        WithHeader:dic
                                                          onTarget:controller
                                                           success:^(NSDictionary *result, NSDictionary *headers) {
                                                               if ([[result objectForKey:@"Result"]boolValue]) {
                                                                   success(result);
                                                               }else
                                                               {
                                                                   [self tipAlert:[result objectForKey:@"Infomation"] viewController:controller];
                                                               }
                                                               
                                                           } failure:^(NSError *error) {
//                                                               [self tipAlert:[error localizedDescription]];
                                                               errors(error);
                                                           }];

    
}

#pragma mark - 【学习-查出课次】
- (void)studyGetLessonRusult:(NSDictionary *)dicData
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success
                   errorData:(ErrorData)errors
{
    NSDictionary *dic = @{@"Authentication":self.userToken};
    [[NetworkManager SharedNetworkManager]requestGetWithParameters:dicData
                                                           ApiPath:kXDFPath_LessonListByClassID
                                                        WithHeader:dic
                                                          onTarget:controller
                                                           success:^(NSDictionary *result, NSDictionary *headers) {
                                                               if ([[result objectForKey:@"Result"]boolValue]) {
                                                                   success(result);
                                                               }else
                                                               {
//                                                                   [self tipAlert:[result objectForKey:@"Infomation"]];
                                                               }
                                                               
                                                           } failure:^(NSError *error) {
//                                                               [self tipAlert:[error localizedDescription]];
                                                               errors(error);
                                                           }];

}

#pragma mark - 【学习-班级资料列表】
- (void)studyGetClassResourecRusult:(NSDictionary *)dicData
                     viewController:(UIViewController *)controller
                        successData:(SuccessData)success
                          errorData:(ErrorData)errors
{
    NSDictionary *dic = @{@"Authentication":self.userToken};
    [[NetworkManager SharedNetworkManager]requestGetWithParameters:dicData
                                                           ApiPath:kXDFPath_MyMaterialsList
                                                        WithHeader:dic
                                                          onTarget:controller
                                                           success:^(NSDictionary *result, NSDictionary *headers) {
                                                               success(result);
                                                           } failure:^(NSError *error) {
                                                               errors(error);
//                                                               [self tipAlert:[error localizedDescription]];
                                                               
                                                           }];


}

#pragma mark - 【学习-收藏列表】
- (void)studyGetCollectRusult:(NSInteger)pageInt
               viewController:(UIViewController *)controller
                  successData:(SuccessData)success
{
    NSDictionary *dic = @{@"Authentication":self.userToken};
    NSNumber *value = [NSNumber numberWithInteger:pageInt];
    
    NSDictionary *dicData = @{@"pageIndex":value};
    
    [[NetworkManager SharedNetworkManager]requestGetWithParameters:dicData
                                                           ApiPath:kXDFPath_MyMaterialsFavoriteList
                                                        WithHeader:dic
                                                          onTarget:controller
                                                           success:^(NSDictionary *result, NSDictionary *headers) {
                                                               if ([[result objectForKey:@"Result"]boolValue]) {
                                                                   success(result);
                                                               }else
                                                               {
//                                                                   [self tipAlert:[result objectForKey:@"Infomation"]];
                                                               }
                                                               
                                                           } failure:^(NSError *error) {
//                                                               [self tipAlert:[error localizedDescription]];
                                                               
                                                           }];

}

#pragma mark - 【学习-添加取消收藏】
- (void)studyCancelAndAddCollectRusult:(NSDictionary *)optTypeAndId
                        viewController:(UIViewController *)controller
                           successData:(SuccessData)success
{
    
    NSDictionary *dic = @{@"Authentication":self.userToken};
    [[NetworkManager SharedNetworkManager]requestGetWithParameters:optTypeAndId
                                                           ApiPath:kXDFPath_AddOrCancelMaterialsFavorite
                                                        WithHeader:dic
                                                          onTarget:controller
                                                           success:^(NSDictionary *result, NSDictionary *headers) {
                                                               if ([[result objectForKey:@"Result"]boolValue]) {
                                                                   success(result);
//                                                                   [self tipAlert:@"" viewController:controller];
                                                               }else
                                                               {
//                                                                   [self tipAlert:[result objectForKey:@"Infomation"]];
                                                               }
                                                               
                                                           } failure:^(NSError *error) {
//                                                               [self tipAlert:[error localizedDescription]];
                                                               
                                                           }];


}

#pragma mark - 【练习-首页】
- (void)exerciseRusultController:(UIViewController *)controller
                     successData:(SuccessData)success
{

    NSDictionary *dic = @{@"Authentication":self.userToken};
    [[NetworkManager SharedNetworkManager]requestGetWithParameters:nil
                                                           ApiPath:kXDFPath_ExerciseResult
                                                        WithHeader:dic
                                                          onTarget:controller
                                                           success:^(NSDictionary *result, NSDictionary *headers) {
                                                               if ([[result objectForKey:@"Result"]boolValue]) {
                                                                   success(result);
                                                               }else
                                                               {
//                                                                   [self tipAlert:[result objectForKey:@"Infomation"]];
                                                               }
                                                               
                                                           } failure:^(NSError *error) {
//                                                               [self tipAlert:[error localizedDescription]];
                                                               
                                                           }];


}

#pragma mark - 【练习-日】
- (void)exerciseDayRuslt:(NSString *)dateString
              Controller:(UIViewController *)controller
             successData:(SuccessData)success
{
     NSDictionary *dateDic = @{@"dateParam":dateString};
     NSDictionary *dic = @{@"Authentication":self.userToken};
    [[NetworkManager SharedNetworkManager]requestGetWithParameters:dateDic
                                                           ApiPath:kXDFPath_ExerciseDateResult
                                                        WithHeader:dic
                                                          onTarget:controller
                                                           success:^(NSDictionary *result, NSDictionary *headers) {
                                                               if ([[result objectForKey:@"Result"]boolValue]) {
                                                                   success(result);
                                                               }else
                                                               {
//                                                                   [self tipAlert:[result objectForKey:@"Infomation"]];
                                                               }
                                                               
                                                           } failure:^(NSError *error) {
//                                                               [self tipAlert:[error localizedDescription]];
                                                               
                                                           }];
}


#pragma mark - 【练习-类型】
- (void)exerciseTypeRuslt:(NSString *)types
               Controller:(UIViewController *)controller
              successData:(SuccessData)success
{
    NSDictionary *typesDic = @{@"type":types};
    NSDictionary *dic = @{@"Authentication":self.userToken};
    [[NetworkManager SharedNetworkManager]requestGetWithParameters:typesDic
                                                           ApiPath:kXDFPath_ExerciseTypeResult
                                                        WithHeader:dic
                                                          onTarget:controller
                                                           success:^(NSDictionary *result, NSDictionary *headers) {
                                                               if ([[result objectForKey:@"Result"]boolValue]) {
                                                                   success(result);
                                                               }else
                                                               {
//                                                                   [self tipAlert:[result objectForKey:@"Infomation"]];
                                                               }
                                                               
                                                           } failure:^(NSError *error) {
//                                                               [self tipAlert:[error localizedDescription]];
                                                               
                                                           }];
}

#pragma mark - 【模考-首页】
- (void)examinationViewController:(UIViewController *)controller
                      successData:(SuccessData)success
{
     NSDictionary *dic = @{@"Authentication":self.userToken};
    [[NetworkManager SharedNetworkManager]requestGetWithParameters:nil
                                                           ApiPath:kXDFPath_ExaminationController
                                                        WithHeader:dic
                                                          onTarget:controller
                                                           success:^(NSDictionary *result, NSDictionary *headers) {
                                                               if ([[result objectForKey:@"Result"]boolValue]) {
                                                                   success(result);
                                                               }else
                                                               {
//                                                                   [self tipAlert:[result objectForKey:@"Infomation"]];
                                                               }
                                                               
                                                           } failure:^(NSError *error) {
//                                                               [self tipAlert:[error localizedDescription]];
                                                               
                                                           }];

}
#pragma mark - 【设置-意见反馈】
- (void)sysSuggestController:(UIViewController *)controller
                 contentText:(NSString *)content
                 SuccessData:(SuccessData)success
{

    NSDictionary *contentDic = @{@"contentText":content};
    NSDictionary *dic = @{@"Authentication":self.userToken};
    [[NetworkManager SharedNetworkManager]requestPostWithParameters:contentDic
                                                            ApiPath:kXDFPath_SysMessageSuggestion
                                                         WithHeader:dic
                                                           onTarget:controller
                                                            success:^(NSDictionary *result, NSDictionary *headers) {
                                                                
                                                                if ([[result objectForKey:@"Result"]boolValue]) {
                                                                    success(result);
                                                                }else
                                                                {
//                                                                    [self tipAlert:[result objectForKey:@"Infomation"]];
                                                                }
        
                                                            } failure:^(NSError *error) {
//                                                                 [self tipAlert:[error localizedDescription]];
                                                            }];


}
#pragma mark - 【设置-我的目标】
- (void)LoadStudentSettingRusult:(NSDictionary *)dicData
                  viewController:(UIViewController *)controller
                     successData:(SuccessData)success
{
    NSDictionary *dic = @{@"Authentication":self.userToken};
    [[NetworkManager SharedNetworkManager]requestGetWithParameters:dicData
                                                           ApiPath:kXDFPath_SysTargetPage
                                                        WithHeader:dic
                                                          onTarget:controller
                                                           success:^(NSDictionary *result, NSDictionary *headers) {
                                                               
                                                               if ([[result objectForKey:@"Result"]boolValue]) {
                                                                   success(result);
                                                               }else
                                                               {
//                                                                   [self tipAlert:[result objectForKey:@"Infomation"]];
                                                               }
                                                               
                                                           } failure:^(NSError *error) {
//                                                               [self tipAlert:[error localizedDescription]];
                                                           }];
}


#pragma mark - 【设置-我的目标-更新学生设定的目标成绩】
- (void)sysTargetController:(UIViewController *)controller
                     Lisent:(NSString *)lisent
                      Speak:(NSString *)speak
                       Read:(NSString *)read
                      write:(NSString *)write
                SuccessData:(SuccessData)success
{

    NSDictionary *contentDic = @{@"lisent":lisent,
                                 @"speak":speak,
                                 @"read":read,
                                 @"write":write};
    NSDictionary *dic = @{@"Authentication":self.userToken};
    [[NetworkManager SharedNetworkManager]requestGetWithParameters:contentDic
                                                            ApiPath:kXDFPath_SysTargetScore
                                                         WithHeader:dic
                                                           onTarget:controller
                                                            success:^(NSDictionary *result, NSDictionary *headers) {
                                                                
                                                                if ([[result objectForKey:@"Result"]boolValue]) {
                                                                    success(result);
                                                                }else
                                                                {
//                                                                    [self tipAlert:[result objectForKey:@"Infomation"]];
                                                                }
                                                                
                                                            } failure:^(NSError *error) {
//                                                                [self tipAlert:[error localizedDescription]];
                                                            }];


}

#pragma mark - 【设置-我的目标-更新学生设定的目前成绩】
- (void)sysCurrentController:(UIViewController *)controller
                      Lisent:(NSString *)lisent
                       Speak:(NSString *)speak
                        Read:(NSString *)read
                       write:(NSString *)write
                 SuccessData:(SuccessData)success
{
    NSDictionary *contentDic = @{@"lisent":lisent,
                                 @"speak":speak,
                                 @"read":read,
                                 @"write":write};
    NSDictionary *dic = @{@"Authentication":self.userToken};
    [[NetworkManager SharedNetworkManager]requestGetWithParameters:contentDic
                                                           ApiPath:kXDFPath_SysCurrentScore
                                                        WithHeader:dic
                                                          onTarget:controller
                                                           success:^(NSDictionary *result, NSDictionary *headers) {
                                                                
                                                                if ([[result objectForKey:@"Result"]boolValue]) {
                                                                    success(result);
                                                                }else
                                                                {
//                                                                    [self tipAlert:[result objectForKey:@"Infomation"]];
                                                                }
                                                                
                                                            } failure:^(NSError *error) {
//                                                                [self tipAlert:[error localizedDescription]];
                                                            }];
}

#pragma mark - 【设置-我的目标-更新学生设定的考试类别】
- (void)sysTargetController:(UIViewController *)controller
                   examType:(NSString *)examType
                SuccessData:(SuccessData)success
{
    NSDictionary *contentDic = @{@"examType":examType};
    NSDictionary *dic = @{@"Authentication":self.userToken};
    [[NetworkManager SharedNetworkManager]requestGetWithParameters:contentDic
                                                            ApiPath:kXDFPath_SysTestType
                                                         WithHeader:dic
                                                           onTarget:controller
                                                            success:^(NSDictionary *result, NSDictionary *headers) {
                                                                
                                                                if ([[result objectForKey:@"Result"]boolValue]) {
                                                                    success(result);
                                                                }else
                                                                {
//                                                                    [self tipAlert:[result objectForKey:@"Infomation"]];
                                                                }
                                                                
                                                            } failure:^(NSError *error) {
//                                                                [self tipAlert:[error localizedDescription]];
                                                            }];


}

#pragma mark - 【设置-我的目标-更新一条我设定的各种日期】
- (void)sysUpdateTestDateController:(UIViewController *)controller
                      tDateId:(NSString *)tDateId
                     destDate:(NSString *)destDate
                  SuccessData:(SuccessData)success
{
    NSDictionary *contentDic = @{@"destDate":destDate,
                                 @"tDateId":tDateId};
    NSDictionary *dic = @{@"Authentication":self.userToken};
    [[NetworkManager SharedNetworkManager]requestGetWithParameters:contentDic
                                                            ApiPath:kXDFPath_SysUpDateTargetDate
                                                         WithHeader:dic
                                                           onTarget:controller
                                                            success:^(NSDictionary *result, NSDictionary *headers) {
                                                                
                                                                if ([[result objectForKey:@"Result"]boolValue]) {
                                                                    success(result);
                                                                }else
                                                                {
//                                                                    [self tipAlert:[result objectForKey:@"Infomation"]];
                                                                }
                                                                
                                                            } failure:^(NSError *error) {
//                                                                [self tipAlert:[error localizedDescription]];
                                                            }];
    
    
}

#pragma mark - 【设置-我的目标-删除一条我设定的各种日期】
- (void)sysDelTestDateController:(UIViewController *)controller
                      tDateId:(NSString *)tDateId
                  SuccessData:(SuccessData)success
{
    NSDictionary *contentDic = @{@"tDateId":tDateId};
    NSDictionary *dic = @{@"Authentication":self.userToken};
    [[NetworkManager SharedNetworkManager]requestGetWithParameters:contentDic
                                                            ApiPath:kXDFPath_SysDelTargetDate
                                                         WithHeader:dic
                                                           onTarget:controller
                                                            success:^(NSDictionary *result, NSDictionary *headers) {
                                                                
                                                                if ([[result objectForKey:@"Result"]boolValue]) {
                                                                    success(result);
                                                                    [self tipAlert:@"删除成功" viewController:controller];
                                                                }else
                                                                {
                                                                    [self tipAlert:@"删除失败" viewController:controller];
//                                                                    [self tipAlert:[result objectForKey:@"Infomation"]];
                                                                }
                                                                
                                                            } failure:^(NSError *error) {
//                                                                [self tipAlert:[error localizedDescription]];
                                                                [self tipAlert:@"删除失败" viewController:controller];
                                                            }];
    
    
}

#pragma mark - 【设置-我的目标-新增我设定的各种日期】
- (void)sysAddTestDateController:(UIViewController *)controller
                      dateTypeId:(NSString *)dateTypeId
                        destDate:(NSString *)destDate
                     SuccessData:(SuccessData)success
{
    NSDictionary *contentDic = @{@"dateTypeId":dateTypeId,
                                 @"destDate":destDate};
    NSDictionary *dic = @{@"Authentication":self.userToken};
    [[NetworkManager SharedNetworkManager]requestGetWithParameters:contentDic
                                                            ApiPath:kXDFPath_SysAddTargetDate
                                                         WithHeader:dic
                                                           onTarget:controller
                                                            success:^(NSDictionary *result, NSDictionary *headers) {
                                                                
                                                                if ([[result objectForKey:@"Result"]boolValue]) {
                                                                    success(result);
                                                                }else
                                                                {
//                                                                    [self tipAlert:[result objectForKey:@"Infomation"]];
                                                                }
                                                                
                                                            } failure:^(NSError *error) {
//                                                                [self tipAlert:[error localizedDescription]];
                                                            }];
    
    
}

#pragma mark - 【设置-我的消息】
- (void)sysMyAllMessageController:(UIViewController *)controller
                          dicData:(NSDictionary *)dicData
                      SuccessData:(SuccessData)success
                        errorData:(ErrorData)errors
{
     NSDictionary *dic = @{@"Authentication":self.userToken};
    [[NetworkManager SharedNetworkManager]requestGetWithParameters:dicData
                                                           ApiPath:kXDFPath_SysMyAllMessage
                                                        WithHeader:dic
                                                          onTarget:controller
                                                           success:^(NSDictionary *result, NSDictionary *headers) {
                                                                   success(result);
                                                      
                                                           } failure:^(NSError *error) {
                                                               errors(error);
//                                                               [self tipAlert:[error localizedDescription]];
                                                           }];



}

#pragma mark - 【设置-我的消息总数】
- (void)sysMyAllMessageCountController:(UIViewController *)controller
                           SuccessData:(SuccessData)success
                             errorData:(ErrorData)errors
{
//    kXDFPath_MyAllMessageNoReadCount
    NSDictionary *dic = @{@"Authentication":self.userToken};
    [[NetworkManager SharedNetworkManager]requestGetWithParameters:nil
                                                           ApiPath:kXDFPath_MyAllMessageNoReadCount
                                                        WithHeader:dic
                                                          onTarget:controller
                                                           success:^(NSDictionary *result, NSDictionary *headers) {
                                                               success(result);
                                                           } failure:^(NSError *error) {
                                                               errors(error);
//                                                               [self tipAlert:[error localizedDescription]];
                                                           }];


}


#pragma mark - 【下载-DownLoadZip】
- (void)sysDownLoadController:(UIViewController *)controller
                  SuccessData:(SuccessData)success
                    errorData:(ErrorData)errors
{
    NSDictionary *dic = @{@"Authentication":self.userToken};
    [[NetworkManager SharedNetworkManager]requestGetWithParameters:nil
                                                           ApiPath:kXDFPath_DownloadZip
                                                        WithHeader:dic
                                                          onTarget:controller
                                                           success:^(NSDictionary *result, NSDictionary *headers) {
                                                               
                                                               if ([[result objectForKey:@"Result"]boolValue]) {
                                                                   success(result);
                                                               }else
                                                               {
//                                                                   [self tipAlert:[result objectForKey:@"Infomation"]];
                                                               }
                                                               
                                                           } failure:^(NSError *error) {
//                                                               [self tipAlert:[error localizedDescription]];
                                                           }];
}


#pragma mark - 模考-成绩报告
- (void)requestMyMarkReportOfMk:(NSString *)pid
                 viewController:(UIViewController *)viewController
                    SuccessData:(SuccessData)success
                        errorData:(ErrorData)errors
{

    NSDictionary *dic = @{@"Authentication":self.userToken};
    NSDictionary *dicData = @{@"paperId":pid};
    [[NetworkManager SharedNetworkManager]requestGetWithParameters:dicData
                                                           ApiPath:kXDFPath_SearchMarkResultMK
                                                        WithHeader:dic
                                                          onTarget:viewController
                                                           success:^(NSDictionary *result, NSDictionary *headers) {
                                                               
                                                               if ([[result objectForKey:@"Result"]boolValue]) {
                                                                   success(result);
                                                               }else
                                                               {
//                                                                   [self tipAlert:[result objectForKey:@"Infomation"]];
                                                               }
                                                               
                                                           } failure:^(NSError *error) {
                                                               errors(error);
//                                                               [self tipAlert:[error localizedDescription]];
                                                           }];

}

#pragma mark - 练习-成绩报告
- (void)requestMyMarkReportOfLX:(NSString *)paperid
                 viewController:(UIViewController *)viewController
                    SuccessData:(SuccessData)success
                    errorData:(ErrorData)errors
{
    NSDictionary *dic = @{@"Authentication":self.userToken};
    NSDictionary *dicData = @{@"paperId":paperid};
    [[NetworkManager SharedNetworkManager]requestGetWithParameters:dicData
                                                           ApiPath:kXDFPath_SearchMarkResultLX
                                                        WithHeader:dic
                                                          onTarget:viewController
                                                           success:^(NSDictionary *result, NSDictionary *headers) {
                                                               
                                                               if ([[result objectForKey:@"Result"]boolValue]) {
                                                                   success(result);
                                                               }else
                                                               {
//                                                                   [self tipAlert:[result objectForKey:@"Infomation"]];
                                                               }
                                                               
                                                           } failure:^(NSError *error) {
                                                               errors(error);
//                                                               [self tipAlert:[error localizedDescription]];
                                                           }];
}

#pragma mark - 【查看答案】
- (void)requestMyAnswer:(UIViewController *)controller
           ANswerQSCode:(NSString *)stringAnswer
                paperId:(NSString *)paperId
            SuccessData:(SuccessData)success
              errorData:(ErrorData)errors
{
    NSDictionary *dic = @{@"Authentication":self.userToken};
    NSDictionary *params = @{@"studentAnswerQSCodes":stringAnswer,
                             @"paperId":paperId};
    [[NetworkManager SharedNetworkManager]requestPostWithParameters:params
                                                            ApiPath:kXDFPath_LookThePaperAnswer
                                                         WithHeader:dic
                                                           onTarget:nil
                                                            success:^(NSDictionary *result, NSDictionary *headers) {
                                                                if ([[result objectForKey:@"Result"]boolValue]) {
                                                                    success(result);
                                                                }else
                                                                {
//                                                                    [self tipAlert:[result objectForKey:@"Infomation"]];
                                                                }
                                                            } failure:^(NSError *error) {
                                                                errors(error);
//                                                                [self tipAlert:[error localizedDescription]];
                                                            }];

}


#pragma mark - 【首页-TaskFinish】
- (void)homeTaskController:(UIViewController *)controller
                     keyID:(NSString *)keyid
                examInfoId:(NSString *)examInfoId
               SuccessData:(SuccessData)success
                 errorData:(ErrorData)errors
{
    NSDictionary *dic = @{@"Authentication":self.userToken};
    if (keyid.length > 0) {
        NSDictionary *dicData = @{@"stId":keyid,
                                  @"examInfoId":examInfoId};
        
        [[NetworkManager SharedNetworkManager]requestGetWithParameters:dicData
                                                               ApiPath:kXDFPath_InsertTaskFinish
                                                            WithHeader:dic
                                                              onTarget:controller
                                                               success:^(NSDictionary *result, NSDictionary *headers) {
                                                                   
                                                                   if ([[result objectForKey:@"Result"]boolValue]) {
                                                                       success(result);
                                                                   }else
                                                                   {
//                                                                       [self tipAlert:[result objectForKey:@"Infomation"]];
                                                                   }
                                                               } failure:^(NSError *error) {
//                                                                   [self tipAlert:[error localizedDescription]];
                                                               }];
    }
}


#pragma mark - 【上传答案之前获取ExamInfoid】
- (void)requestExamInfoid:(NSString *)paperId
                 costTime:(NSString *)times
         targetController:(UIViewController *)controller
                 taskType:(NSString *)taskType
              SuccessData:(SuccessData)success
                errorData:(ErrorData)errors
{
     NSDictionary *parmas = @{@"paperId":paperId,
                             @"costTime":times,
                              @"taskType":taskType};
     NSDictionary *dic = @{@"Authentication":self.userToken};
    
    [[NetworkManager SharedNetworkManager]requestGetWithParameters:parmas
                                                           ApiPath:kXDFPath_createExamInfoId
                                                        WithHeader:dic
                                                          onTarget:controller
                                                           success:^(NSDictionary *result, NSDictionary *headers) {
                                                               success(result);
//                                                               if ([[result objectForKey:@"Result"]boolValue]) {
//                                                                   success(result);
//                                                               }else
//                                                               {
////                                                                   [self tipAlert:[result objectForKey:@"Infomation"]];
//                                                               }
                                                            }failure:^(NSError *error) {
                                                                errors(error);
//                                                                [self tipAlert:[error localizedDescription]];
                                                            }];
}
#pragma mark - 【上传-模考试卷答案】
- (void)examiUpLoadController:(UIViewController *)controller
                      paperid:(NSString *)pid
                         stId:(NSString *)stId
               studentAnswers:(NSString *)answer
                   examInfoId:(NSString *)examInfoId
                  SuccessData:(SuccessData)success
                    errorData:(ErrorData)errors
{
    NSDictionary *parms = @{@"paperId":pid,
                            @"stId":stId,
                            @"studentAnswers":answer,
                            @"examInfoId":examInfoId};
    NSDictionary *dic = @{@"Authentication":self.userToken};
    [[NetworkManager SharedNetworkManager]requestPostWithParameters:parms
                                                            ApiPath:kXDFPath_EvaluateThePaper
                                                         WithHeader:dic
                                                           onTarget:nil
                                                            success:^(NSDictionary *result, NSDictionary *headers) {
                                                                    success(result);
                                                            } failure:^(NSError *error) {
                                                                errors(error);
                                                            }];


}

#pragma mark - 【查看答案解析】
- (void)lookQuestionDocs:(NSString *)qid
        targetController:(UIViewController *)controller
             SuccessData:(SuccessData)success
               errorData:(ErrorData)errors
{
    NSDictionary *params = @{@"QID":qid};
    NSDictionary *dic = @{@"Authentication":self.userToken};
    [[NetworkManager SharedNetworkManager]requestGetWithParameters:params
                                                           ApiPath:kXDFPath_LookQuestionDocs
                                                        WithHeader:dic
                                                          onTarget:controller
                                                           success:^(NSDictionary *result, NSDictionary *headers) {
                                                               if ([[result objectForKey:@"Result"]boolValue]) {
                                                                   success(result);
                                                               }else
                                                               {
//                                                                   [self tipAlert:[result objectForKey:@"Infomation"]];
                                                               }
                                                        } failure:^(NSError *error) {
                                                            errors(error);
//                                                             [self tipAlert:[error localizedDescription]];
                                                        }];
}

#pragma mark - 【设置-最新消息-阅读/删除】
- (void)sysMessageControll:(UIViewController *)controller
                 messageId:(NSString  *)messageId
                      type:(NSString *)type
               SuccessData:(SuccessData)success
                 errorData:(ErrorData)errors
{
    
    NSDictionary *parms = @{@"messageId":messageId,
                            @"type":type};
    NSDictionary *dic = @{@"Authentication":self.userToken};

    [[NetworkManager SharedNetworkManager]requestGetWithParameters:parms
                                                           ApiPath:kXDFPath_ReadOrDelMessage
                                                        WithHeader:dic
                                                          onTarget:nil
                                                           success:^(NSDictionary *result, NSDictionary *headers) {
                                                               
                                                               
                                                               if ([[result objectForKey:@"Result"]boolValue]) {
                                                                   success(result);
                                                               }else
                                                               {
//                                                                   [self tipAlert:[result objectForKey:@"Infomation"]];
                                                               }
                                                               
                                                        } failure:^(NSError *error) {
                                                            
//                                                             [self tipAlert:[error localizedDescription]];
                                                        }];

}


#pragma mark - 【读取服务器-config】
- (void)ruquestServerConfig:(UIViewController *)controller
                       path:(NSString *)path
                SuccessData:(SuccessData)success
                  errorData:(ErrorData)errors
{
    [[NetworkManager SharedNetworkManager]requestGetWithApiPath:path
                                                     WithHeader:nil
                                                       onTarget:controller success:^(NSDictionary *result, NSDictionary *headers){
                                                                success(result);
                                                            } failure:^(NSError *error) {
                                                                errors(error);
                                                            }];

}


#pragma mark - 【模考-自我评分】
- (void)updateScoreOfMyOwnGive:(UIViewController *)controller
                    examInfoId:(NSString *)examInfoId
                       MySpeak:(NSString *)mySpeak
                       MyWrite:(NSString *)myWrite
                   SuccessData:(SuccessData)success
                     errorData:(ErrorData)errors
{
     NSDictionary *parms = @{@"examInfoId":examInfoId,
                                @"MySpeak":mySpeak,
                                @"MyWrite":myWrite};
     NSDictionary *dic = @{@"Authentication":self.userToken};
    [[NetworkManager SharedNetworkManager]requestGetWithParameters:parms
                                                           ApiPath:kXDFPath_UpdateScoreOfMyOwnGive
                                                        WithHeader:dic
                                                          onTarget:controller
                                                           success:^(NSDictionary *result, NSDictionary *headers) {
                                                               if ([[result objectForKey:@"Result"]boolValue]) {
                                                                   success(result);
                                                               }else
                                                               {
//                                                                   [self tipAlert:[result objectForKey:@"Infomation"]];
                                                               }
                                                            } failure:^(NSError *error) {
//                                                                [self tipAlert:[error localizedDescription]];
                                                            }];
}


#pragma mark - 【更新任务状态】
- (void)tellServerTaskSTID:(NSString *)st_id
{
     NSDictionary *parms = @{@"stId":st_id};
    [[NetworkManager SharedNetworkManager]requestGetWithParameters:parms
                                                           ApiPath:kXDFPath_UpdateScheduleTaskStatus
                                                        WithHeader:nil
                                                          onTarget:nil
                                                           success:^(NSDictionary *result, NSDictionary *headers) {
                                                               NSLog(@"%@",result);
                                                           } failure:^(NSError *error) {
                                                           }];
}



//- (void)curentNetWork:(UIViewController *)viewController
//{
//    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        switch (status) {
//            case AFNetworkReachabilityStatusNotReachable:
//            {
//                [[NSNotificationCenter defaultCenter] postNotificationName:kNoNewtWork_ object:nil];
//                [viewController.view makeToast:@"当前网络不可用,请检测网络。" duration:2.0 position:@"bottom"];
//                break;
//            }
//            default:
//                break;
//        }
//    }];
//}

#pragma mark -
#pragma mark - 错误提示语言
- (void)tipAlert:(NSString *)results  viewController:(UIViewController *)controller
{
    if ([results isKindOfClass:[NSNull class]]) {
        
        return;
    }
    
//    [controller.view makeToast:results duration:2.0 position:@"bottom"];
    [controller.view makeToast:results duration:2.0 position:@"center"];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    return;
}

- (void)tipAlert:(NSString *)results
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:results
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
    [alertView show];
}


@end
