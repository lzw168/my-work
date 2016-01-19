//
//  UserBean.m
//  BeautyWhere
//
//  Created by Michael Chan on 15/7/24.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "UserBean.h"

@implementation UserBean

- (instancetype)initWithUserInfoDic:(NSDictionary *)dic {
    if (self = [super init]) {
        self.userID = [dic valueNull2NilForKey:@"id"];
        self.email = [dic valueNull2NilForKey:@"email"];
        self.userName = [dic valueNull2NilForKey:@"username"];
        self.realName = [dic valueNull2NilForKey:@"realname"];
        self.alipayID = [dic valueNull2NilForKey:@"alipay_id"];
        self.password = [dic valueNull2NilForKey:@"password"];
        self.avatar = [NSString stringWithFormat:@"%@%@",Server_ImgHost, [dic valueNull2NilForKey:@"avatar"]];
        self.gender = [dic valueNull2NilForKey:@"gender"];
        self.newbie = [dic valueNull2NilForKey:@"newbie"];
        self.mobile = [dic valueNull2NilForKey:@"mobile"];
        self.qqNum = [dic valueNull2NilForKey:@"qq"];
        self.money = [dic valueNull2NilForKey:@"money"];
        self.score = [dic valueNull2NilForKey:@"score"];
        self.zipCode = [dic valueNull2NilForKey:@"zipcode"];
        self.address = [dic valueNull2NilForKey:@"address"];
        self.cityID = [dic valueNull2NilForKey:@"city_id"];
        if ([[dic valueNull2NilForKey:@"emailable"] isKindOfClass:[NSString class]]) {
            self.emailable = [((NSString*)[dic valueNull2NilForKey:@"emailable"]) boolValue];
        }
        else
        {
            self.emailable = NO;
        }
        if ([[dic valueNull2NilForKey:@"enable"] isKindOfClass:[NSString class]]) {
            self.enable = [((NSString*)[dic valueNull2NilForKey:@"enable"]) boolValue];
        }
        else
        {
            self.enable = NO;
        }
        if ([[dic valueNull2NilForKey:@"manager"] isKindOfClass:[NSString class]]) {
            self.manager = [((NSString*)[dic valueNull2NilForKey:@"manager"]) boolValue];
        }
        else
        {
            self.manager = NO;
        }
        self.secret = [dic valueNull2NilForKey:@"secret"];
        self.recode = [dic valueNull2NilForKey:@"recode"];
        self.sns = [dic valueNull2NilForKey:@"sns"];
        self.collectPartner = [dic valueNull2NilForKey:@"collectpartner"];
        self.ip = [dic valueNull2NilForKey:@"ip"];
        self.loginTime = [dic valueNull2NilForKey:@"login_time"];
        self.createTime = [dic valueNull2NilForKey:@"create_time"];
        self.mobileCode = nil;
        self.hasSupercard = [[dic valueNull2NilForKey:@"supercard"] boolValue];
        self.canGetScoreByLogin = [[dic valueNull2NilForKey:@"getScore"] boolValue];
        self.canGetScoreByShare = [[dic valueNull2NilForKey:@"isshare"] boolValue];
    }
    return self;
}

@end
