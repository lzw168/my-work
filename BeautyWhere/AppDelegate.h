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
@property (strong, nonatomic) NSString *img1;
@property (strong, nonatomic) NSString *img2;
@property (strong, nonatomic) NSString *img3;
@property (strong, nonatomic) NSString *refresh_token;
@property (strong, nonatomic) NSString *access_token;
@property (strong, nonatomic) NSString *receiver;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *addressid;
@property (nonatomic) unsigned int expire;
@property (strong, nonatomic) NSString *fee_shipping_num;
@property (strong, nonatomic) NSString *img_path;
@property (strong, nonatomic) NSString *service_tel;
@property (strong, nonatomic) NSString *rank_visitor;
@property (nonatomic, strong) UIImage *cacheHeaderImg;

- (void)startLocate;
- (void)Refreshtoken;
@end

