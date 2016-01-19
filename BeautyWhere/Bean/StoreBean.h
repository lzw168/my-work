//
//  StoreBean.h
//  BeautyWhere
//
//  Created by Michael on 15/8/3.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreBean : NSObject

@property (nonatomic, strong) NSString *storeID;
@property (nonatomic, strong) NSString *storeUserName;
@property (nonatomic, strong) NSString *storePW;
@property (nonatomic, strong) NSString *storeTitle;
@property (nonatomic, strong) NSString *storeGroupID;
@property (nonatomic, strong) NSString *storeHomePage;
@property (nonatomic, strong) NSString *storeBankName;
@property (nonatomic, strong) NSString *storeBankNum;
@property (nonatomic, strong) NSString *storeBankUser;
@property (nonatomic, strong) NSString *storeLocation;
@property (nonatomic, strong) NSString *storeContact;
@property (nonatomic, strong) NSString *storeImage;
@property (nonatomic, strong) NSString *storeImage1;
@property (nonatomic, strong) NSString *storeImage2;
@property (nonatomic, strong) NSString *storeImageThumb;
@property (nonatomic, strong) NSString *storeImage1Thumb;
@property (nonatomic, strong) NSString *storeImage2Thumb;
@property (nonatomic, strong) NSString *storePhone;
@property (nonatomic, strong) NSString *storeAddress;
@property (nonatomic, strong) NSString *storeOther;
@property (nonatomic, strong) NSString *storeMobile;
@property (nonatomic, assign) BOOL storeOpen;
@property (nonatomic, assign) BOOL storeEnable;
@property (nonatomic, strong) NSString *storeHead;
@property (nonatomic, strong) NSString *storeUserID;
@property (nonatomic, strong) NSString *storeCreateTime;
@property (nonatomic, strong) NSString *storeLNG;//经度，double百度地图经度
@property (nonatomic, strong) NSString *storeLAT;//纬度，double百度地图维度
@property (nonatomic, assign) BOOL storeDisplay;
@property (nonatomic, strong) NSString *storeStar;
@property (nonatomic, strong) NSString *storeEnvironment;
@property (nonatomic, strong) NSString *storeService;
@property (nonatomic, strong) NSString *storeCommentGood;
@property (nonatomic, strong) NSString *storeCommentNone;
@property (nonatomic, strong) NSString *storeCommentBad;
@property (nonatomic, strong) NSString *storeCity;//城市
@property (nonatomic, strong) NSString *storeDistrict;//区
@property (nonatomic, strong) NSString *storeProvince;
@property (nonatomic, strong) NSString *storeSCity;
@property (nonatomic, strong) NSString *storeSDistrict;
@property (nonatomic, strong) NSString *storeSArea;
@property (nonatomic, strong) NSString *storeCommentNum;//估计是多少个
@property (nonatomic, strong) NSString *storeDistance;
@property (nonatomic, assign) BOOL storeCollected;
@property (nonatomic, strong) NSString *storeStreet;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
