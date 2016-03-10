//
//  UserBean.h
//  BeautyWhere
//
//  Created by Michael Chan on 15/7/24.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserBean : NSObject

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *realName;
@property (nonatomic, strong) NSString *alipayID;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *avatar;//头像文件路径
@property (nonatomic, strong) NSString *gender;//性别
@property (nonatomic, strong) NSString *newbie;//新手
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *qqNum;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *score;//积分
@property (nonatomic, strong) NSString *zipCode;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *cityID;
@property (nonatomic, assign) BOOL emailable;
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, assign) BOOL manager;
@property (nonatomic, strong) NSString *secret;
@property (nonatomic, strong) NSString *recode;
@property (nonatomic, strong) NSString *sns;
@property (nonatomic, strong) NSString *collectPartner;
@property (nonatomic, strong) NSString *ip;
@property (nonatomic, strong) NSString *loginTime;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *mobileCode;
@property (nonatomic, assign) BOOL hasSupercard;//是否有特权卡，Y是有，N则无
@property (nonatomic, assign) BOOL canGetScoreByLogin;//1,是这次登录可以领取积分而且已经领取，0 是这次登录不能领取
@property (nonatomic, assign) BOOL canGetScoreByShare;//1 是今天分享就可以领取积分，0则不可

- (instancetype)initWithUserInfoDic:(NSDictionary *)dic;

@end
