//
//  Comment.h
//  IOS_iAssistant2
//
//  Created by 李牛顿 on 14-6-6.
//  Copyright (c) 2014年 Personal. All rights reserved.
//

#ifndef IOS_iAssistant2_Comment_h
#define IOS_iAssistant2_Comment_h


//一期正式环境头像
//#define   BaseURLString @"http://ilearning.xdf.cn/IELTS/api"
//#define   BaseUserIconPath @"http://ielts.staff.xdf.cn/upload/fileupload"

//一期测试环境头像
//#define  BaseURLString    @"http://testielts.staff.xdf.cn/IELTS/api"
//#define  BaseUserIconPath @"http://testielts.staff.xdf.cn/upload/fileupload"



//二期开发
#define  BaseURLString          @"http://testielts2.staff.xdf.cn/IELTS_2_DEV/api"
//#define  BaseVideoMaterialsPath @"http://testielts2.staff.xdf.cn/IELTS_2_DEV/materials/selectVideoMaterialsById"
#define  BaseUserIconPath       @"http://testielts2.staff.xdf.cn/upload_dev/userImage"

//二期测试环境
//#define  BaseURLString    @"http://testielts2.staff.xdf.cn/IELTS_2/api"
//#define  BaseVideoMaterialsPath @"http://testielts2.staff.xdf.cn/IELTS_2/materials/selectVideoMaterialsById"
//#define  BaseUserIconPath @"http://testielts2.staff.xdf.cn/upload/userImage"

//业务部分测试环境
//#define  BaseURLString           @"http://ieltstest.staff.xdf.cn/IELTS/api"
//#define  BaseVideoMaterialsPath  @"http://ieltstest.staff.xdf.cn/IELTS/materials/selectVideoMaterialsById"
//#define  BaseUserIconPath        @"http://ieltstest.staff.xdf.cn/upload/userImage"



//对比字符串
#define kStringEqual(a,b)  [a isEqualToString:b] ? YES : NO

//通过三色值获取颜色对象
#define rgb(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//左边背景颜色
#define TABBAR_BACKGROUND  rgb(54,57,81,1)
//内容区域
#define TABBAR_BACKGROUNDLight  rgb(79,88,122,1)
//左侧Tab按钮选中的背景颜色
#define TABBAR_BACKGROUND_SELECTED rgb(234,64,70,1)
//左边宽度
#define DEFAULT_TAB_BAR_HEIGHT 107.0f
//左边按钮宽度
#define kDockItemH 107.0
#define kDockItemW 107.0

//二级控制器左边宽度
#define  kSecondLevelLeftWidth 80


#define kAlphaNum   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define kAlpha      @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
#define kNumbers        @"0123456789"
#define kNumbersPeriod  @"0123456789."

//#define kCurrentSection @"currentSection" //模拟试卷的section记录
#define kCSection(pId) [NSString stringWithFormat:@"%@currentSection",pId]
#define kUserDefaults [NSUserDefaults standardUserDefaults]

//字体大小
#define kFontCommetn(a)  [UIFont fontWithName:@"HelveticaNeue-Bold" size:a]
//首页--圆环
#define kClosedIndicatorWidth 100
#define kIndicatorColor     rgb(240.0,240.0,240.0,1.0)
#define kIndicatorColorPro  rgb(231.0,66.0,70.0,1.0)

#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


//模拟器获取物理屏幕的尺寸

#define kScreenWidth   1024//IS_IOS8?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height
#define kScreenHeight  748//IS_IOS8?([UIScreen mainScreen].bounds.size.height-20):([UIScreen mainScreen].bounds.size.width-20)


#define kUpdateBage @"updateBage"
#define kEnterBackSaveAnswers @"saveAnswers"   //通知进入后台保存答案
#define kNoNewtWork_ @"NoNetwork" //没网
#define kHasNewtWork_ @"hasNetwork" //没网

#define kUserIconUpdate @"IconUpdate123"

#import "UIViewExt.h"
#import "ZCControl.h"
#import "UIView+ViewController.h"
#import "RusultManage.h"
#import "DownLoadManage.h"
#import "XDFAnswersManage.h"
#import "Toast+UIView.h"
#import "UIViewController+HUD.h"


///////////通知////////////
#define k_HeadphonesAudio @"HeadphonesAudio"

///////////////////////
//U2登录
#define  BaseU2LoginURLString    @"http://testu2.staff.xdf.cn/apis/usersv2.ashx" //测试环境
//#define  BaseU2LoginURLString    @"http://passport.xdf.cn/apis/usersv2.ashx"// 正式环境

////测试环境
#define  U2AppId  @"90101"
#define  U2AppKey @"u2testAppKey#$vs"
////正式环境
//#define  U2AppId  @"90120"
//#define  U2AppKey @"u2ys#vskvqy*@%!vs15v"


////////////////////////////////////////////////////////////////////////
//设置是否调试模式
#define NDDEBUG 0

#if NDDEBUG
#define NDLog(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define NDLog(xx, ...)  ((void)0)
#endif

#define CHECK_DATA_IS_NSNULL(param,type) param = [param isKindOfClass:[NSNull class]] ? [type new] : param


#endif


