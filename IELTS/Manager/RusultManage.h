//
//  RusultManage.h
//  IELTS
//
//  Created by 李牛顿 on 14-11-19.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"


typedef void(^SuccessData)(NSDictionary *result);
typedef void(^ErrorData)( NSError *error);

@interface RusultManage : NSObject<UIAlertViewDelegate>

+(RusultManage *)shareRusultManage;

@property (nonatomic,strong)NSString *userToken;   //用户token

@property (nonatomic,copy) NSString *userId;   //u2 ID

@property (nonatomic,strong)UserModel *userMode;

#pragma mark - 登陆
- (void)logonRusult:(NSDictionary *)dicData
     viewController:(UIViewController *)controller
        successData:(SuccessData)success;

#pragma mark - 注册接口
//- (void)registRusult:(NSDictionary *)dicData
//     viewController:(UIViewController *)controller
//        successData:(SuccessData)success;



#pragma mark - 找回密码
//- (void)passforgetRusult:(NSDictionary *)dicData
//      viewController:(UIViewController *)controller
//         successData:(SuccessData)success;

#pragma mark - 修改密码
- (void)passChangeRusult:(NSDictionary *)dicData
          viewController:(UIViewController *)controller
             successData:(SuccessData)success;

#pragma mark - 绑定学员编号
- (void)bindStudentCodeRusult:(NSDictionary *)dicData
          viewController:(UIViewController *)controller
             successData:(SuccessData)success;

#pragma mark - 获取已绑定的学员编号
- (void)LoadbindStudentCodeRusult:(NSDictionary *)dicData
               viewController:(UIViewController *)controller
                  successData:(SuccessData)success;

#pragma mark - 获取学生分数设定
- (void)LoadStudentSettingRusult:(NSDictionary *)dicData
                   viewController:(UIViewController *)controller
                      successData:(SuccessData)success;

#pragma mark -
#pragma mark - 【首页-各种完成进度】
- (void)completeRateviewController:(UIViewController *)controller
                       successData:(SuccessData)success
                         errorData:(ErrorData)errors;

#pragma mark - 【首页-我的消息】
- (void)myMessageListRusult:(NSDictionary *)dicData
            viewController:(UIViewController *)controller
               successData:(SuccessData)success
                errorData:(ErrorData)errors;

#pragma mark - 【首页-我的任务】
- (void)myTaskListRusult:(NSDictionary *)dicData
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                 errorData:(ErrorData)errors;

#pragma mark - 【首页-读取一条消息】
- (void)messageReadRusult:(NSDictionary *)dicData
          viewController:(UIViewController *)controller
             successData:(SuccessData)success;

#pragma mark - 【计划-任务】
- (void)scheduleTaskRusult:(NSString *)dateString
           viewController:(UIViewController *)controller
              successData:(SuccessData)success;

#pragma mark - 【计划-课表】
- (void)scheduleClassRusult:(NSString *)dateString
           viewController:(UIViewController *)controller
              successData:(SuccessData)success;




#pragma mark - 【学习-查出班级】
- (void)studyGetClassRusult:(UIViewController *)controller
                successData:(SuccessData)success
                   errorData:(ErrorData)errors;

#pragma mark - 【学习-查出课次】
- (void)studyGetLessonRusult:(NSDictionary *)dicData
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                   errorData:(ErrorData)errors;

#pragma mark - 【学习-班级资料列表】
- (void)studyGetClassResourecRusult:(NSDictionary *)dicData
                     viewController:(UIViewController *)controller
                        successData:(SuccessData)success
                        errorData:(ErrorData)errors;

#pragma mark - 【学习-收藏列表】
- (void)studyGetCollectRusult:(NSInteger)pageInt
           viewController:(UIViewController *)controller
              successData:(SuccessData)success;

#pragma mark - 【学习-添加取消收藏】
- (void)studyCancelAndAddCollectRusult:(NSDictionary *)optTypeAndId
           viewController:(UIViewController *)controller
              successData:(SuccessData)success;

#pragma mark - 【练习-首页】
- (void)exerciseRusultController:(UIViewController *)controller
                     successData:(SuccessData)success;


#pragma mark - 【练习-日】
- (void)exerciseDayRuslt:(NSString *)dateString
              Controller:(UIViewController *)controller
             successData:(SuccessData)success;


#pragma mark - 【练习-类型】
- (void)exerciseTypeRuslt:(NSString *)types
               Controller:(UIViewController *)controller
              successData:(SuccessData)success;



#pragma mark - 【模考-首页】
- (void)examinationViewController:(UIViewController *)controller
                      successData:(SuccessData)success;


#pragma mark - 【设置-意见反馈】
- (void)sysSuggestController:(UIViewController *)controller
                 contentText:(NSString *)contentDic
                 SuccessData:(SuccessData)success;

#pragma mark - 【设置-我的目标-更新学生设定的目标成绩】
- (void)sysTargetController:(UIViewController *)controller
                     Lisent:(NSString *)lisent
                      Speak:(NSString *)speak
                       Read:(NSString *)read
                      write:(NSString *)write
                 SuccessData:(SuccessData)success;

#pragma mark - 【设置-我的目标-更新学生设定的目前成绩】
- (void)sysCurrentController:(UIViewController *)controller
                     Lisent:(NSString *)lisent
                      Speak:(NSString *)speak
                       Read:(NSString *)read
                      write:(NSString *)write
                SuccessData:(SuccessData)success;



#pragma mark - 【设置-我的目标-更新学生设定的考试类别】
- (void)sysTargetController:(UIViewController *)controller
                   examType:(NSString *)examType
                SuccessData:(SuccessData)success;

#pragma mark - 【设置-我的目标-更新一条我设定的各种日期】
- (void)sysUpdateTestDateController:(UIViewController *)controller
                            tDateId:(NSString *)tDateId
                           destDate:(NSString *)destDate
                        SuccessData:(SuccessData)success;
#pragma mark - 【设置-我的目标-删除一条我设定的各种日期】
- (void)sysDelTestDateController:(UIViewController *)controller
                         tDateId:(NSString *)tDateId
                     SuccessData:(SuccessData)success;


#pragma mark - 【设置-我的目标-新增我设定的各种日期】
- (void)sysAddTestDateController:(UIViewController *)controller
                      dateTypeId:(NSString *)dateTypeId
                        destDate:(NSString *)destDate
                     SuccessData:(SuccessData)success;

#pragma mark - 【设置-我的消息】
- (void)sysMyAllMessageController:(UIViewController *)controller
                          dicData:(NSDictionary *)dicData
                     SuccessData:(SuccessData)success
                       errorData:(ErrorData)errors;
#pragma mark - 【设置-我的消息总数】
- (void)sysMyAllMessageCountController:(UIViewController *)controller
                      SuccessData:(SuccessData)success
                        errorData:(ErrorData)errors;



#pragma mark - 【下载-DownLoadZip】
- (void)sysDownLoadController:(UIViewController *)controller
                  SuccessData:(SuccessData)success
                    errorData:(ErrorData)errors;

#pragma mark - 【上传-模考试卷答案】
- (void)examiUpLoadController:(UIViewController *)controller
                      paperid:(NSString *)pid
                         stId:(NSString *)stId
               studentAnswers:(NSString *)answer
                   examInfoId:(NSString *)examInfoId
                  SuccessData:(SuccessData)success
                    errorData:(ErrorData)errors;

#pragma mark - 【上传答案之前获取】
- (void)requestExamInfoid:(NSString *)paperId
                 costTime:(NSString *)times
         targetController:(UIViewController *)controller
                 taskType:(NSString *)taskType
              SuccessData:(SuccessData)success
                errorData:(ErrorData)errors;

#pragma mark - 【查看答案解析】
- (void)lookQuestionDocs:(NSString *)qid
         targetController:(UIViewController *)controller
              SuccessData:(SuccessData)success
                errorData:(ErrorData)errors;



#pragma mark - 【模考-成绩报告】
- (void)requestMyMarkReportOfMk:(NSString *)pid
                 viewController:(UIViewController *)viewController
                    SuccessData:(SuccessData)success
                      errorData:(ErrorData)errors;

#pragma mark - 【练习-成绩报告】
- (void)requestMyMarkReportOfLX:(NSString *)paperid
                 viewController:(UIViewController *)viewController
                    SuccessData:(SuccessData)success
                      errorData:(ErrorData)errors;

#pragma mark - 【查看答案】
- (void)requestMyAnswer:(UIViewController *)controller
           ANswerQSCode:(NSString *)stringAnswer
                paperId:(NSString *)paperId
            SuccessData:(SuccessData)success
              errorData:(ErrorData)errors;

#pragma mark - 【首页-TaskFinish】
- (void)homeTaskController:(UIViewController *)controller
                     keyID:(NSString *)keyid
                examInfoId:(NSString *)examInfoId
                  SuccessData:(SuccessData)success
                    errorData:(ErrorData)errors;

#pragma mark - 【设置-最新消息-阅读/删除】
- (void)sysMessageControll:(UIViewController *)controller
                 messageId:(NSString  *)messageId
                      type:(NSString *)type
               SuccessData:(SuccessData)success
                 errorData:(ErrorData)errors;


#pragma mark - 【读取服务器-config】
- (void)ruquestServerConfig:(UIViewController *)controller
                       path:(NSString *)path
                SuccessData:(SuccessData)success
                 errorData:(ErrorData)errors;


#pragma mark - 【模考-自我评分】
- (void)updateScoreOfMyOwnGive:(UIViewController *)controller
                    examInfoId:(NSString *)examInfoId
                       MySpeak:(NSString *)mySpeak
                       MyWrite:(NSString *)myWrite
                   SuccessData:(SuccessData)success
                     errorData:(ErrorData)errors;

#pragma mark - 【检测-试卷是否被点击】
- (void)tellServerTaskSTID:(NSString *)st_id;



#pragma mark - 【检测-网络状态】
//- (void)curentNetWork:(UIViewController *)viewController;
#pragma mark - 弹出窗
- (void)tipAlert:(NSString *)results  viewController:(UIViewController *)controller;
- (void)tipAlert:(NSString *)results;




@end
