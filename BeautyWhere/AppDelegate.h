//
//  AppDelegate.h
//  BeautyWhere
//
//  Created by Michael on 15-7-21.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserBean.h"
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI/BMapKit.h>

typedef void (^locationResponseBlock)(NSString *lng, NSString *lat);

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UserBean *user;
@property (atomic, copy) locationResponseBlock locateBlock;
@property (strong, nonatomic) NSString *lng;
@property (strong, nonatomic) NSString *lat;
@property (strong, nonatomic) NSMutableArray *businessZone;
@property (nonatomic, assign) BOOL mapManagerIsOK;
@property (nonatomic, weak) UIViewController *openURLHandlerViewController;
@property (strong, nonatomic) NSString *paySource;

- (void)startLocate;

@end

