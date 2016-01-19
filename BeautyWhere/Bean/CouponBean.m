//
//  CouponBean.m
//  BeautyWhere
//
//  Created by Michael on 15/8/17.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "CouponBean.h"

@implementation CouponBean

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        self.couponCouponID = [dic valueNull2NilForKey:@"coupon_id"];
        self.couponID = [dic valueNull2NilForKey:@"id"];
        self.couponUserID = [dic valueNull2NilForKey:@"user_id"];
        self.couponGetTime = [dic valueNull2NilForKey:@"get_time"];
        self.couponIsUse = [[dic valueNull2NilForKey:@"is_use"] boolValue];
        self.couponIsOver = [[dic valueNull2NilForKey:@"is_over"] boolValue];
        self.couponTitle = [dic valueNull2NilForKey:@"title"];
        self.couponExpireTime = [dic valueNull2NilForKey:@"expire_time"];
        self.couponType = [dic valueNull2NilForKey:@"type"];
        self.couponImage = [dic valueNull2NilForKey:@"image"];
        self.couponDiscount = [dic valueNull2NilForKey:@"discount"];
        self.couponTerms = [dic valueNull2NilForKey:@"terms"];
    }
    return self;
}

@end
