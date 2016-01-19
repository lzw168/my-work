//
//  CouponBean.h
//  BeautyWhere
//
//  Created by Michael on 15/8/17.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponBean : NSObject

@property (nonatomic, strong) NSString *couponID;
@property (nonatomic, strong) NSString *couponUserID;
@property (nonatomic, strong) NSString *couponCouponID;
@property (nonatomic, strong) NSString *couponGetTime;
@property (nonatomic, assign) BOOL couponIsUse;
@property (nonatomic, assign) BOOL couponIsOver;
@property (nonatomic, strong) NSString *couponTitle;
@property (nonatomic, strong) NSString *couponExpireTime;
@property (nonatomic, strong) NSString *couponImage;
@property (nonatomic, strong) NSString *couponType;//类型credit是代金券，consume是折扣券
@property (nonatomic, strong) NSString *couponDiscount;//折扣
@property (nonatomic, strong) NSString *couponTerms;//满几钱可以用

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
