//
//  PersonalPageNetwork.h
//  BeautyWhere
//
//  Created by Michael Chan on 15/8/1.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalPageNetwork : NSObject

+ (void)changeUserName:(NSString *)userName headerImg:(UIImage *)avatar withUserID:(NSString *)userID withMobileNumber:(NSString *)phoneNum withSuccessBlock:(void(^)(NSString *userName, NSString *imgURL))successBlock withErrorBlock:(void(^)(NSError *err))errBlock;

+ (void)getCollectionDetailWithUserID:(NSString *)userID withPageNum:(NSString *)pageNum withSuccessBlock:(void(^)(NSArray *collectionArr))successBlock withErrBlock:(void(^)(NSError *err))errBlock;

+ (void)getMyCouponWithUserID:(NSString *)userID withType:(NSString *)type withPageNum:(NSString *)pageNum withSuccessBlock:(void(^)(NSArray *coupons))successBlock withErrorBlock:(void(^)(NSError *err))errBlock;

+ (void)addScoreWithType:(NSString *)type withUserID:(NSString *)userID withSuccessBlock:(void(^)(BOOL finished, NSString *score))successBlock withErrBlock:(void(^)(NSError *err))errBlock;

@end
