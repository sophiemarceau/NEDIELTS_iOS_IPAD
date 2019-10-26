//
//  XDFAppDelegate.m
//  IELTS
//
//  Created by 李牛顿 on 14-11-29.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFAppDelegate.h"
#import "XDFMainViewController.h"
#import "LogonViewController.h"
#import "GuideViewController.h"
#import "NetworkManager.h"
#import "AudioStreamer.h"
#import <AVFoundation/AVFoundation.h>
@implementation XDFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor blackColor];

    [[NetworkManager SharedNetworkManager]monitorNetwork:self.window];
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLogonChange:) name:@"LOGONCHANGE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLogoffChange:) name:@"LOGOFFCHANGE" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LOGINMainTab) name:@"LOGINMainTab" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RestoreWindowFrame:) name:@"RestoreWindowFrame" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OrgWindowFrame:) name:@"OrgWindowFrame" object:nil];
    
    isUIInterfaceOrientationMaskPortrait_ = NO;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(outputDeviceChanged:)name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
    
    
    //启动动画
//    BOOL showGuide = [kUserDefaults boolForKey:@"_showGuides"];
//    if (!showGuide) {
//        [kUserDefaults setBool:YES forKey:@"_showGuides"];
//        //将数据同步
//        [kUserDefaults synchronize];
//        
//        self.window.rootViewController = [[GuideViewController alloc]init];
//    }else
//    {
        self.window.rootViewController = [[LogonViewController alloc] initWithNibName:@"LogonViewController" bundle:nil];
//    }
//    self.window.rootViewController = [[GuideViewController alloc]init];
    
    
    
    [self.window makeKeyAndVisible];
    return YES;

}

- (void)outputDeviceChanged:(NSNotification *)notification
{
    NSDictionary *dic = notification.userInfo;
    int changeReason= [dic[AVAudioSessionRouteChangeReasonKey] intValue];
    
    AVAudioSessionRouteDescription * routeDescription = dic[AVAudioSessionRouteChangePreviousRouteKey];
    AVAudioSessionPortDescription * portDescription = [routeDescription.outputs firstObject];
    NSString * portType = portDescription.portType;
    
    
    if (changeReason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        
        //原设备为耳机则暂停
        if ([portType isEqualToString:@"Headphones"]) {
            
            NSLog(@"耳机拔出了");
            [[RusultManage shareRusultManage]tipAlert:@"耳机已经拔出了" viewController:self.window.rootViewController];
            
            //通知修改状态
            [[NSNotificationCenter defaultCenter]postNotificationName:k_HeadphonesAudio object:nil];
        }
        
    }else if(changeReason == AVAudioSessionRouteChangeReasonNewDeviceAvailable){
        
        if ([portType isEqualToString:@"Speaker"]) {
            
            NSLog(@"耳机插入了");
            [[RusultManage shareRusultManage]tipAlert:@"检测到耳机插入了" viewController:self.window.rootViewController];
        }
    }
}




- (void)onLogonChange:(id)sender
{
    
    BOOL showGuide = [kUserDefaults boolForKey:@"_showGuides"];
    if (!showGuide) {
        [kUserDefaults setBool:YES forKey:@"_showGuides"];
        //将数据同步
        [kUserDefaults synchronize];
        
        self.window.rootViewController = [[GuideViewController alloc]init];
    }else
    {
//        self.window.rootViewController = [[LogonViewController alloc] initWithNibName:@"LogonViewController" bundle:nil];
        
        [self LOGINMainTab];
    }
}

- (void)LOGINMainTab
{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    XDFMainViewController *main = [[XDFMainViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:main];
    nav.navigationBarHidden = YES;
    self.window.rootViewController = nav;


}


- (void)onLogoffChange:(id)sender
{
    [[UIApplication sharedApplication]setStatusBarHidden:NO] ;
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    LogonViewController *v = [[LogonViewController alloc] initWithNibName:@"LogonViewController" bundle:nil];
    self.window.rootViewController = v;
}

- (void)RestoreWindowFrame:(id)sender
{
    isUIInterfaceOrientationMaskPortrait_ = NO;

}
- (void)OrgWindowFrame:(id)sender
{
    isUIInterfaceOrientationMaskPortrait_ = YES;
}


#pragma mark - 处理内存警告处理
-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
#pragma mark - 保存试卷
    [[NSNotificationCenter defaultCenter]postNotificationName:kEnterBackSaveAnswers object:nil];
}



- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//RestoreWindowFrame   返回横屏
//OrgWindowFrame  支持竖屏

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if(isUIInterfaceOrientationMaskPortrait_){
        return UIInterfaceOrientationMaskPortrait;
    }else
    {
        return UIInterfaceOrientationMaskLandscape;
    }
}

@end
