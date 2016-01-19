//
//  StoreBean.m
//  BeautyWhere
//
//  Created by Michael on 15/8/3.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "StoreBean.h"

@implementation StoreBean

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.storeID = [dic valueNull2NilForKey:@"id"];
        self.storeUserName = [dic valueNull2NilForKey:@"username"];
        self.storePW = [dic valueNull2NilForKey:@"password"];
        self.storeTitle = [dic valueNull2NilForKey:@"title"];
        self.storeGroupID = [dic valueNull2NilForKey:@"group_id"];
        self.storeHomePage = [dic valueNull2NilForKey:@"homepage"];
        self.storeBankName = [dic valueNull2NilForKey:@"bank_name"];
        self.storeBankNum = [dic valueNull2NilForKey:@"bank_no"];
        self.storeBankUser = [dic valueNull2NilForKey:@"bank_user"];
        self.storeLocation = [dic valueNull2NilForKey:@"location"];
        self.storeContact = [dic valueNull2NilForKey:@"contact"];
        self.storeImage = [dic valueNull2NilForKey:@"image"];
        self.storeImage1 = [dic valueNull2NilForKey:@"image1"];
        self.storeImage2 = [dic valueNull2NilForKey:@"image2"];
        self.storeImageThumb = [dic valueNull2NilForKey:@"image_thumb"];
        self.storeImage1Thumb = [dic valueNull2NilForKey:@"image1_thumb"];
        self.storeImage2Thumb = [dic valueNull2NilForKey:@"image2_thumb"];
        self.storePhone = [dic valueNull2NilForKey:@"phone"];
        self.storeAddress = [dic valueNull2NilForKey:@"address"];
        self.storeOther = [dic valueNull2NilForKey:@"other"];
        self.storeMobile =[dic valueNull2NilForKey:@"mobile"];
        self.storeOpen = [[dic valueNull2NilForKey:@"open"] boolValue];
        self.storeEnable = [[dic valueNull2NilForKey:@"enable"] boolValue];
        self.storeHead = [dic valueNull2NilForKey:@"head"];
        self.storeUserID = [dic valueNull2NilForKey:@"user_id"];
        self.storeCreateTime = [dic valueNull2NilForKey:@"create_time"];
        self.storeLNG = [dic valueNull2NilForKey:@"lng"];
        self.storeLAT = [dic valueNull2NilForKey:@"lat"];
        self.storeDisplay = [[dic valueNull2NilForKey:@"display"] boolValue];
        self.storeStar = [dic valueNull2NilForKey:@"star"];
        self.storeEnvironment = [dic valueNull2NilForKey:@"environment"];
        self.storeService = [dic valueNull2NilForKey:@"service"];
        self.storeCommentGood = [dic valueNull2NilForKey:@"comment_good"];
        self.storeCommentNone = [dic valueNull2NilForKey:@"comment_none"];
        self.storeCommentBad = [dic valueNull2NilForKey:@"comment_bad"];
        self.storeCommentNum = [dic valueNull2NilForKey:@"comment_num"];
        self.storeCity = [dic valueNull2NilForKey:@"city"];
        self.storeDistrict = [dic valueNull2NilForKey:@"district"];
        self.storeProvince = [dic valueNull2NilForKey:@"province"];
        self.storeSCity = [dic valueNull2NilForKey:@"s_city"];
        self.storeSDistrict = [dic valueNull2NilForKey:@"s_district"];
        self.storeSArea = [dic valueNull2NilForKey:@"s_area"];
        self.storeDistance = [dic valueNull2NilForKey:@"distance"];
        self.storeCollected = [[dic valueNull2NilForKey:@"is_collect"] boolValue];
        self.storeStreet = [dic valueNull2NilForKey:@"street"];
    }
    return self;
}

@end
