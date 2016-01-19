//
//  MorePageNetwork.m
//  BeautyWhere
//
//  Created by Michael Chan on 15/7/24.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "MorePageNetwork.h"

@implementation MorePageNetwork

+ (void)checkUpdateWithSuccessBlock:(void(^)(NSString *version, NSString *tip, NSString *downloadURL, BOOL mustUpdate))successBlock withErrorBlock:(void(^)(NSError *err))errorBlock {
    [NetworkEngine postWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_CheckUpGrade] withParamDic:@{@"isIphone":@"1"} withSuccessBlock:^(id response) {
        if ([response isKindOfClass:[NSDictionary class]] && [[response objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            successBlock([[response objectForKey:@"data"] objectForKey:@"version"], [[response objectForKey:@"data"] objectForKey:@"upgrade_tips"], [[response objectForKey:@"data"] objectForKey:@"download_url"], [[[response objectForKey:@"data"] objectForKey:@"must_upgrade"] boolValue]);
        }
        else {
            NSError *err = [NSError errorWithDomain:@"检查更新——后台返回数据格式有误" code:40000 userInfo:nil];
            errorBlock(err);
        }
    } withErrorBlock:^(NSError *err) {
        errorBlock(err);
    }];
}

+ (void)getCheckCodeWithPhoneNum:(NSString *)phoneNum withSuccessBlock:(void(^)(BOOL finished))successBlock withErrorBlock:(void(^)(NSError *err))errorBlock {
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_RequestMessageCode] withParamDic:@{@"phone":phoneNum} withSuccessBlock:^(id response) {
        NSLog(@"getCheckCodeWithPhoneNum response:%@",response);
        if ([response isKindOfClass:[NSData class]])
        {
            NSString *result = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            if ([result isEqualToString:@"\"send\""]) {
                successBlock(YES);
            }
            else {
                successBlock(NO);
            }
        }
        else {
            NSError *err = [NSError errorWithDomain:@"获取验证码——后台返回数据格式有误" code:40000 userInfo:nil];
            errorBlock(err);
        }
    } withErrorBlock:^(NSError *err) {
        errorBlock(err);
    }];
}

+ (void)loginWithThirdPartyNickName:(NSString *)nickName withType:(NSString *)type withSuccessBlock:(void(^)(BOOL finished))successBlock withErrorBlock:(void(^)(NSError *err))errorBlock {
    NSString *paramType = @"qq";
    if ([type isEqualToString:ThirdPartyLoginWithWX]) {
        paramType = @"wechat";
    }
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_LoginByThird] withParamDic:@{@"num":nickName, @"type":paramType} withSuccessBlock:^(id response) {
        if ([response isKindOfClass:[NSData class]] && ((NSData*)response).length>0) {
            NSString *result = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            if ([result isEqualToString:@"wrong"] || [result isEqualToString:@"\"wrong\""]) {
                successBlock(NO);
            }
            else {
                NSError *error = nil;
                id json = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&error];
                NSDictionary *responseDic = nil;
                if ([json isKindOfClass:[NSArray class]]) {
                    responseDic = [(NSArray*)json firstObject];
                }
                else if ([json isKindOfClass:[NSDictionary class]]) {
                    responseDic = json;
                }
                if (error || !responseDic) {
                    NSLog(@"string2dic err:%@",error);
                    if (!responseDic) {
                        NSLog(@"responseDic is nil");
                    }
                    successBlock(NO);
                }
                else {
                    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:loginTime];
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:addUserMarkByLogin];
                    User = [[UserBean alloc] initWithUserInfoDic:responseDic];
                    [NSKeyedArchiver archiveRootObject:responseDic toFile:UserInfoFilePath];
                    successBlock(YES);
                }
            }
        }
        else {
            successBlock(NO);
        }
    } withErrorBlock:^(NSError *err) {
        errorBlock(err);
    }];
}

+ (void)loginWithPhoneNum:(NSString *)phoneNum withCheckCode:(NSString *)checkCode withNickName:(NSString *)nickName withSuccessBlock:(void(^)(BOOL finished))successBlock withErrorBlock:(void(^)(NSError *err))errorBlock {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithDictionary:@{@"phone":phoneNum, @"code":checkCode}];
    if (nickName && ![nickName isEqualToString:@""]) {
        [paramDic setObject:nickName forKey:@"nickname"];
    }
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_LoginAndRegister] withParamDic:paramDic withSuccessBlock:^(id response) {
        if ([response isKindOfClass:[NSData class]]) {
            NSString *result = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSLog(@"loginWithPhoneNum err:%@",result);
            NSError *error = nil;
            id json = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&error];
            NSDictionary *responseDic = nil;
            if ([json isKindOfClass:[NSArray class]]) {
                responseDic = [(NSArray*)json firstObject];
            }
            else if ([json isKindOfClass:[NSDictionary class]]) {
                responseDic = json;
            }
            if (error || !responseDic) {
                NSLog(@"string2dic err:%@",error);
                if (!responseDic) {
                    NSLog(@"responseDic is nil");
                }
                successBlock(NO);
            }
            else {
                [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:loginTime];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:addUserMarkByLogin];
                User = [[UserBean alloc] initWithUserInfoDic:responseDic];
                [NSKeyedArchiver archiveRootObject:responseDic toFile:UserInfoFilePath];
                successBlock(YES);
            }
        }
        else {
            NSError *err = [NSError errorWithDomain:@"登录注册——后台返回数据格式有误" code:40000 userInfo:nil];
            errorBlock(err);
        }
    } withErrorBlock:^(NSError *err) {
        errorBlock(err);
    }];
}

+ (void)sendFeedBackWithUserName:(NSString *)userName withUserID:(NSString *)userID withContent:(NSString *)content withSuccessBlock:(void(^)(BOOL finished))successBlock withErrorBlock:(void(^)(NSError *err))errorBlock {
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_FeedBack] withParamDic:@{@"username":userName, @"user_id":userID, @"content":content} withSuccessBlock:^(id response) {
        if ([response isKindOfClass:[NSData class]]) {
            NSString *result = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            if ([result isEqualToString:@"\"success\""]) {
                successBlock(YES);
            }
            else {
                successBlock(NO);
            }
        }
        else {
            NSError *err = [NSError errorWithDomain:@"发送反馈——后台返回数据格式有误" code:40000 userInfo:nil];
            errorBlock(err);
        }
    } withErrorBlock:^(NSError *err) {
        errorBlock(err);
    }];
}

+ (void)refleshUserInfoWithUserID:(NSString *)userID withSuccessBlock:(void(^)(BOOL finished))successBlock withErrorBlock:(void(^)(NSError *err))errorBlock {
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_GetSingleUserInfo] withParamDic:@{@"user_id":userID} withSuccessBlock:^(id response) {
        if ([response isKindOfClass:[NSData class]]) {
            NSString *result = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSLog(@"refleshUserInfoWithUserID err:%@",result);
            NSError *error = nil;
            id json = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&error];
            NSDictionary *responseDic = nil;
            if ([json isKindOfClass:[NSArray class]]) {
                responseDic = [(NSArray*)json firstObject];
            }
            else if ([json isKindOfClass:[NSDictionary class]]) {
                responseDic = json;
            }
            if (error || !responseDic) {
                NSLog(@"string2dic err:%@",error);
                if (!responseDic) {
                    NSLog(@"responseDic is nil");
                }
                successBlock(NO);
            }
            else {
                User = [[UserBean alloc] initWithUserInfoDic:responseDic];
                [NSKeyedArchiver archiveRootObject:responseDic toFile:UserInfoFilePath];
                successBlock(YES);
            }
        }
        else {
            NSError *err = [NSError errorWithDomain:@"刷新用户信息——后台返回数据格式有误" code:40000 userInfo:nil];
            errorBlock(err);
        }
    } withErrorBlock:^(NSError *err) {
        errorBlock(err);
    }];
}

@end
