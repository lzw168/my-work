//
//  MorePageNetwork.h
//  BeautyWhere
//
//  Created by Michael Chan on 15/7/24.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MorePageNetwork : NSObject

+ (void)checkUpdateWithSuccessBlock:(void(^)(NSString *version, NSString *tip, NSString *downloadURL, BOOL mustUpdate))successBlock withErrorBlock:(void(^)(NSError *err))errorBlock;

+ (void)getCheckCodeWithPhoneNum:(NSString *)phoneNum withSuccessBlock:(void(^)(BOOL finished))successBlock withErrorBlock:(void(^)(NSError *err))errorBlock;

+ (void)loginWithPhoneNum:(NSString *)phoneNum withCheckCode:(NSString *)checkCode withNickName:(NSString *)nickName withSuccessBlock:(void(^)(BOOL finished))successBlock withErrorBlock:(void(^)(NSError *err))errorBlock;

+ (void)sendFeedBackWithUserName:(NSString *)userName withUserID:(NSString *)userID withContent:(NSString *)content withSuccessBlock:(void(^)(BOOL finished))successBlock withErrorBlock:(void(^)(NSError *err))errorBlock;

+ (void)refleshUserInfoWithUserID:(NSString *)userID withSuccessBlock:(void(^)(BOOL finished))successBlock withErrorBlock:(void(^)(NSError *err))errorBlock;

+ (void)loginWithThirdPartyNickName:(NSString *)nickName withType:(NSString *)type withSuccessBlock:(void(^)(BOOL finished))successBlock withErrorBlock:(void(^)(NSError *err))errorBlock;

@end
