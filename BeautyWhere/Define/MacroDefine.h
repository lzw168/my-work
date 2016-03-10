//
//  MacroDefine.h
//  BeautyWhere
//
//  Created by Michael on 15-7-21.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#ifndef BeautyWhere_MacroDefine_h
#define BeautyWhere_MacroDefine_h

#ifdef DEBUG
#else
#define NSLog(...){}
#define NSAssert(...){}
#endif

typedef void(^LoadDataComplete)(int aAddedRowCount);
typedef void(^RefreshDataComplete)();

static NSString * const loginTime = @"loginTime";
static NSString * const addUserMarkByLogin = @"addUserMarkByLogin";
static NSString * const sharedItem = @"SharedItem";
///第三方登录
static NSString * const ThirdPartyLoginWithQQ = @"loginWithQQ";
static NSString * const ThirdPartyLoginWithWX = @"loginWithWX";

#define ShareContent @"我正在使用\"上哪美\"这个app，你也来下载吧 https://itunesconnect.apple.com/WebObjects/iTunesConnect.woa/ra/ng/app/1041884628"

#define GetAppDelegate ((AppDelegate*)[UIApplication sharedApplication].delegate)

#pragma mark - 各种尺寸的获取
///获取屏幕宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define CellHeight [tableView rectForRowAtIndexPath:indexPath].size.height

#define ThreePointFiveScreen ScreenHeight<500

///获取导航栏高度
#define NavHeight(viewController) viewController.navigationController.navigationBar.frame.size.height

#pragma mark - File Path
///app沙盒内Documents路径
#define DocumentsPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject]
///用户信息文件存储路径
#define UserInfoFilePath [DocumentsPath stringByAppendingPathComponent:@"UserInfo.txt"]

#pragma mark - Color Define
///获取导航栏颜色
#define NavBarColor [UIColor colorWithRed:249.0/255.0 green:58.0/255.0 blue:98.0/255.0 alpha:1.0]
///获取底部菜单背景颜色
#define BottomMenuBackgroundColor [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]
///获取底部菜单被选中项文字颜色
#define BottomMenuSelectedColor [UIColor colorWithRed:239.0/255.0 green:102.0/255.0 blue:172.0/255.0 alpha:1.0]

#pragma mark - user
#define User GetAppDelegate.user

#pragma mark - color
#define KMainBackgroundColor [UIColor colorWithHexString:@"#f8f8f8"]

#define RatioWidth ScreenWidth/1080
#define RatioHeight ScreenHeight/1920

#define RefreshToken @"RefreshToken"
#define AccessToken  @"AccessToken"

#define Reciver @"Reciver"
#define Mobile  @"Mobile"
#define Location @"Location"
#define AddressID @"addressid"

#endif
