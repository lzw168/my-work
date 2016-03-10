//
//  AppDelegate.m
//  BeautyWhere
//
//  Created by Michael on 15-7-21.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"
#import "HomePageNetwork.h"
#import "Pingpp.h"
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "APService.h"
#include "RefreshTokenNetwork.h"
#include "RefreshTokenBean.h"
#import "ConfigBean.h"

@interface AppDelegate ()

@property (strong, nonatomic) CLLocationManager* locationManager;
@property (nonatomic, strong) BMKMapManager* mapManager;
@property (nonatomic, assign) BOOL hasShowCloseLocateTip;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.access_token = @"";
    self.service_tel = @"";
    self.img_path = @"";
    self.fee_shipping_num = @"";
    // Override point for customization after application launch.
    if ([[NSFileManager defaultManager] fileExistsAtPath:UserInfoFilePath])
    {
        self.user = [[UserBean alloc] initWithUserInfoDic:[NSKeyedUnarchiver unarchiveObjectWithFile:UserInfoFilePath]];
        NSLog(@"user_id:%@",self.user.userID);
    }
    self.businessZone = [[NSMutableArray alloc] initWithObjects:@"全部商区", nil];
    [self resetAddUserMarkPossible];
    [self netReachabilityManager];
    [self configShareSDK];
    self.mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [self.mapManager start:@"MEVMEGkuqUkUxdoqi1X6YAs9" generalDelegate:nil];
    if (!ret)
    {
        NSLog(@"manager start failed!");
        self.mapManagerIsOK = NO;
    }
    else {
        self.mapManagerIsOK = YES;
    }
    [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(startLocate) userInfo:nil repeats:YES];
    
    
    // 极光通知
    /*[APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
    [APService setupWithOption:launchOptions];
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];*/
    
    [HomePageNetwork GetConfigInfo:^(NSMutableDictionary *ConfigDic)
     {
         ConfigBean *config = [[ConfigBean alloc] initWithDic:ConfigDic];
         GetAppDelegate.img_path = config.img_path;
         GetAppDelegate.service_tel = config.service_tel;
         NSLog(@"config.free_shipping_num======%@",config.free_shipping_num);
         GetAppDelegate.fee_shipping_num = config.free_shipping_num;
         GetAppDelegate.rank_visitor = config.rank_visitor;
         NSUserDefaults *rank_visitor = [NSUserDefaults standardUserDefaults];
         NSString *rankvisitor= [rank_visitor objectForKey:@"rank_visitor"];
         if (rankvisitor.length == 0)
         {
             [[NSUserDefaults standardUserDefaults] setObject:GetAppDelegate.rank_visitor forKey:@"rank_visitor"];
             [[NSUserDefaults standardUserDefaults] synchronize];
         }
         NSLog(@"rank_visitor============%@",config.rank_visitor);
     } withErrorBlock:^(NSError *err)
     {
         [ProgressHUD showText:@"请检查网络后稍后再试" Interaction:YES Hide:YES];
     }];

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [BMKMapView willBackGround];//当应用即将后台时调用，停止一切调用opengl相关的操作
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self startLocate];
    [BMKMapView didForeGround];//当应用恢复前台状态时调用，回复地图的渲染和opengl相关的操作
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"[ShareSDK hasAuthorized:SSDKPlatformTypeQQ]:%i",[ShareSDK hasAuthorized:SSDKPlatformTypeQQ]);
    NSLog(@"[ShareSDK hasAuthorized:SSDKPlatformTypeWechat]:%i",[ShareSDK hasAuthorized:SSDKPlatformTypeWechat]);
/*    if ([sourceApplication isEqualToString:@"com.tencent.mqq"]) {
        BOOL authFinished = [ShareSDK hasAuthorized:SSDKPlatformTypeQQ];
        if (!authFinished) {
            [ProgressHUD showText:@"QQ授权失败" Interaction:YES Hide:YES];
        }
        else {
            [ProgressHUD show:nil];
            [self.openURLHandlerViewController performSelector:@selector(loginWithThirdParty:) withObject:ThirdPartyLoginWithQQ];
        }
    }
    else if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {
        BOOL authFinished = [ShareSDK hasAuthorized:SSDKPlatformTypeWechat];
        if (!authFinished) {
            [ProgressHUD showText:@"微信授权失败" Interaction:YES Hide:YES];
        }
        else {
            [ProgressHUD show:nil];
            [self.openURLHandlerViewController performSelector:@selector(loginWithThirdParty:) withObject:ThirdPartyLoginWithWX];
        }
    }
    else {*/
        [Pingpp handleOpenURL:url withCompletion:^(NSString *result, PingppError *error) {
            NSLog(@"result = %@, error : %@", result, error == nil ? @"nil" : [error getMsg]);
            if (error) {
                [ProgressHUD showText:@"支付失败" Interaction:YES Hide:NO];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [ProgressHUD dismiss];
                });
            }
            else
            {
                //[ProgressHUD showText:@"支付成功，可到订单页查看" Interaction:YES Hide:YES];
                [self.openURLHandlerViewController.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
//    }
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    [Pingpp handleOpenURL:url withCompletion:^(NSString *result, PingppError *error) {
        NSLog(@"result = %@, error : %@", result, error == nil ? @"nil" : [error getMsg]);
        if (error)
        {
            [ProgressHUD showText:@"支付失败" Interaction:YES Hide:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
            {
                [ProgressHUD dismiss];
            });
        }
        else
        {
            //[ProgressHUD showText:@"支付成功，可到订单页查看" Interaction:YES Hide:YES];
            [self.openURLHandlerViewController.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
    return YES;
}

#pragma mark - Tool
- (void)resetAddUserMarkPossible
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    
    NSDate *loginDate = [[NSUserDefaults standardUserDefaults] objectForKey:loginTime];
    NSString *strLoginTime = [formatter stringFromDate:loginDate];
    NSDate *dateLogin = [formatter dateFromString:strLoginTime];
    NSTimeInterval loginTimeInterval = [dateLogin timeIntervalSince1970];
    
    NSString *strDate = [formatter stringFromDate:[NSDate date]];
    NSDate *dateToday = [formatter dateFromString:strDate];
    NSTimeInterval todayTimeInterval = [dateToday timeIntervalSince1970];
    
/*    NSLog(@"date:%f",[dateToday timeIntervalSince1970]);
    
    NSDate *tomorrow = [NSDate dateWithTimeInterval:24*3600 sinceDate:dateToday];
    NSString *tomorrowStr = [formatter stringFromDate:tomorrow];NSLog(@"tomorrow:%@",tomorrowStr);
    NSDate *tomorrowDate = [formatter dateFromString:tomorrowStr];
    NSLog(@"tomorrow since1970:%f",[tomorrowDate timeIntervalSince1970]);*/
    NSLog(@"loginTimeInterval:%f  todayTimeInterval:%f",loginTimeInterval, todayTimeInterval);
    if (loginTimeInterval != todayTimeInterval)
    {
        NSLog(@"resetAddUserMarkPossible");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:addUserMarkByLogin];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:sharedItem];
    }
}

#pragma mark - ShareSDK
- (void)configShareSDK
{
    [ShareSDK registerApp:@"88c8e754b8f6"
          activePlatforms:@[@(SSDKPlatformTypeSinaWeibo), @(SSDKPlatformTypeQQ), @(SSDKPlatformTypeWechat)]
                 onImport:^(SSDKPlatformType platformType)
     {
                     switch (platformType)
         {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         case SSDKPlatformTypeSinaWeibo:
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             break;
                         default:
                             NSLog(@"需要连接的——没有 %li 分享平台",(long)platformType);
                             break;
                     }
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType) {
            case SSDKPlatformTypeSinaWeibo:
                [appInfo SSDKSetupSinaWeiboByAppKey:@"4035745061" appSecret:@"f95955c92d3e840992490b9164ad23a8" redirectUri:@"http://www.weibo.com" authType:SSDKAuthTypeBoth];
                break;
            case SSDKPlatformTypeQQ:
//                [appInfo SSDKSetupQQByAppId:@"1104802852" appKey:@"eHQJjZusMNKIgd9h" authType:SSDKAuthTypeSSO];
                [appInfo SSDKSetupQQByAppId:@"1104759815" appKey:@"UvXdJYa8dQj0HZkR" authType:SSDKAuthTypeSSO];
                break;
            case SSDKPlatformTypeWechat://微信
                [appInfo SSDKSetupWeChatByAppId:@"wxbffac04c5245ba13" appSecret:@"7e5488f37efa2a606c5524cde4861266"];
                break;
            default:
                NSLog(@"配置——没有 %li 分享平台",(long)platformType);
                break;
        }
    }];
}

#pragma mark - Reachability Management (iOS 6-7)
//网络监听（用于检测网络是否可以链接。此方法最好放于AppDelegate中，可以使程序打开便开始检测网络）
- (void)netReachabilityManager
{
    //创建请求
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //打开网络监听
    [manager.reachabilityManager startMonitoring];
    
    if (![manager.reachabilityManager isReachable])
    {
        [ProgressHUD showText:@"无网络连接，请检查" Interaction:YES Hide:YES];
    }
    else
    {
        //监听网络变化
        [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                    
                    //当网络不可用（无网络或请求延时）
                case AFNetworkReachabilityStatusNotReachable:
                    [ProgressHUD showText:@"无网络连接，请检查" Interaction:NO Hide:YES];
                    break;
                    
                    //当为手机蜂窝数据网和WiFi时
                case AFNetworkReachabilityStatusReachableViaWiFi:
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    break;
                    
                    //其它情况
                default:
                    break;
            }
        }];
    }
    //停止网络监听（若需要一直检测网络状态，可以不停止，使其一直运行）
//    [manager.reachabilityManager stopMonitoring];
}

#pragma mark - 定位
- (void)startLocate
{
    if (!self.locationManager)
    {
        if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
        {
            if (!self.hasShowCloseLocateTip)
            {
                self.hasShowCloseLocateTip = YES;
                [ProgressHUD showText:@"您关闭了的定位功能，将无法收到位置信息，建议您到系统设置打开定位功能!" Interaction:YES Hide:YES];
            }
        }
        else
        {
            //开启定位
            self.locationManager = [[CLLocationManager alloc] init];//创建位置管理器
            self.locationManager.delegate=self;
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            {
                [self.locationManager requestAlwaysAuthorization];
            }
            self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
            self.locationManager.distanceFilter=1000.0f;
        }
    }
    if (self.locationManager)
    {
        //启动位置更新
        [self.locationManager startUpdatingLocation];
    }
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //得到newLocation
    CLLocation *cloc = [locations lastObject];
    // 获取经纬度
    NSLog(@"纬度:%f",cloc.coordinate.latitude);
    NSLog(@"经度:%f",cloc.coordinate.longitude);
    self.lat = [NSString stringWithFormat:@"%f",cloc.coordinate.latitude];
    self.lng = [NSString stringWithFormat:@"%f",cloc.coordinate.longitude];
    if (self.locateBlock)
    {
        self.locateBlock([NSString stringWithFormat:@"%f",cloc.coordinate.longitude], [NSString stringWithFormat:@"%f",cloc.coordinate.latitude]);
    }
    //[self.locationManager stopUpdatingLocation];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:cloc completionHandler:^(NSArray *placemarks, NSError *error)
    {
        if (!error)
        {
            for (CLPlacemark * placemark in placemarks)
            {
                NSDictionary *test = [placemark addressDictionary];
                NSLog(@"定位：%@",test);
                //  Country(国家)  State(省) City（市） SubLocality(区)
                NSLog(@"选择城市===========%@", [test objectForKey:@"City"]);
                /*[HomePageNetwork getBusinessZoneWithCity:[test objectForKey:@"City"] withSuccessBlock:^(NSArray *storeArr)
                {
                    //[self.businessZone removeAllObjects];//修复重复数据问题
                    NSLog(@"获取所在城市的行政区：%lu",(unsigned long)[storeArr count]);
                    //[self.businessZone addObjectsFromArray:storeArr];
                    [storeArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
                    {
                        for (NSString *item in self.businessZone)
                        {
                            if ([item isEqualToString:obj])
                            {
                                *stop = YES;
                                break;
                            }
                        }
                        if (!*stop)
                        {
                            //[self.businessZone removeAllObjects];
                            [self.businessZone addObject:obj];
                        }
                    }];
                    [[NSUserDefaults standardUserDefaults] setObject:self.businessZone forKey:@"businessZone"];
                    [[NSUserDefaults standardUserDefaults] synchronize];

                } withErrorBlock:^(NSError *err)
                 {
                    NSLog(@"getBusinessZone err:%@",err);
                }];*/
                break;
            }
        }
        [self.locationManager stopUpdatingLocation];
    }];
}


#pragma mark -
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token_str=[NSString stringWithFormat:@"%@", deviceToken];
    token_str = [token_str stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token_str = [token_str stringByReplacingOccurrencesOfString:@" " withString:@""];
    token_str = [token_str stringByReplacingOccurrencesOfString:@">" withString:@""];
    [[NSUserDefaults standardUserDefaults] setObject:token_str forKey:@"device_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"token_str:%@", token_str);
    
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.string = token_str;
    //    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [APService handleRemoteNotification:userInfo];
    // userInfo 就是push消息的Payload
    NSDictionary *apsDic = userInfo[@"aps"];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notification" message:apsDic[@"alert"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void) Refreshtoken
{
    [RefreshTokenNetwork GetRefreshToken:^(NSMutableDictionary *RefreshTokenDic)
     {
         [ProgressHUD dismiss];
         RefreshTokenBean *Rtbean = [[RefreshTokenBean alloc] initWithDic:RefreshTokenDic];
         NSLog(@"Rtbean.access_token=======%@",Rtbean.access_token);
         GetAppDelegate.access_token = Rtbean.access_token;
         GetAppDelegate.refresh_token = Rtbean.refresh_token;
         
         [[NSUserDefaults standardUserDefaults] setObject:GetAppDelegate.refresh_token forKey:RefreshToken];
         
         [[NSUserDefaults standardUserDefaults] setObject:GetAppDelegate.access_token forKey:AccessToken];
         [[NSUserDefaults standardUserDefaults] synchronize];
     } withErrorBlock:^(NSError *err)
     {
         [ProgressHUD showText:@"获取失败，请检查网络后稍后再试" Interaction:YES Hide:YES];
     }];
}

@end
