//
//  MorePageNetwork.m
//  BeautyWhere
//
//  Created by Michael Chan on 15/7/24.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "MorePageNetwork.h"
#import "NSObject+SBJson.h"

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

+ (void)getCheckCodeWithPhoneNum:(NSString *)phoneNum withSuccessBlock:(void(^)(BOOL finished))successBlock withErrorBlock:(void(^)(NSError *err))errorBlock
{
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_RequestMessageCode] withParamDic:@{@"phone":phoneNum} withSuccessBlock:^(id response)
    {
        NSLog(@"getCheckCodeWithPhoneNum response:%@",response);
        NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"responseString %@",responseString);
        NSMutableDictionary *dictResponse=[responseString JSONValue];
        int ret = [[dictResponse objectForKey:@"ret"]intValue];
        
        if (ret == 0)
        {
           successBlock(YES);
        }
        else
        {
            if (ret== 1000)
            {
                NSString * message = [[responseString JSONValue] objectForKey:@"msg"];
                [ProgressHUD showText:message Interaction:YES Hide:YES];
                [GetAppDelegate Refreshtoken];
                return;
            }
            successBlock(NO);
            NSError *err = [NSError errorWithDomain:@"获取验证码——后台返回数据格式有误" code:40000 userInfo:nil];
            errorBlock(err);
        }
    } withErrorBlock:^(NSError *err) {
        errorBlock(err);
    }];
}

+ (void)loginWithThirdPartyNickName:(NSString *)nickName withType:(NSString *)type withSuccessBlock:(void(^)(BOOL finished))successBlock withErrorBlock:(void(^)(NSError *err))errorBlock
{
    NSString * clientVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];//获取应用版本号
    
    NSString * osVersion = [[UIDevice currentDevice] systemVersion];//系统版本
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    int width = size.width;
    int height = size.height;
    
    NSString * resolution = [NSString stringWithFormat:@"%d,%d",width,height];//屏幕分辨率
    NSString * osName = @"ios";
    NSString * identify = @"";
    
    NSString *paramType = @"qq";
    if ([type isEqualToString:ThirdPartyLoginWithWX])
    {
        paramType = @"wechat";
    }
    NSString * channel_id = @"99999999";
    
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_LoginByThird] withParamDic:@{@"key":nickName, @"type":paramType,@"osName":osName,@"clientVersion":clientVersion,@"osVersion":osVersion,@"resolution":resolution,@"identify":identify,@"channel_id":channel_id} withSuccessBlock:^(id response)
    {
            NSString *result = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSLog(@"result===================%@",result);
            
            NSMutableDictionary *dictResponse=[result JSONValue];
            NSMutableDictionary *dataDic = [dictResponse objectForKey:@"data"][@"user"];
            int ret = [[dictResponse objectForKey:@"ret"]intValue];
            GetAppDelegate.refresh_token = [dictResponse objectForKey:@"data"][@"refresh_token"];
            GetAppDelegate.access_token = [dictResponse objectForKey:@"data"][@"access_token"];
            GetAppDelegate.expire = [[dictResponse objectForKey:@"data"][@"expire"]intValue];
        
           NSLog(@"GetAppDelegate.access_token===================%@",GetAppDelegate.access_token);
        
           [[NSUserDefaults standardUserDefaults] setObject:GetAppDelegate.refresh_token forKey:RefreshToken];
        
           [[NSUserDefaults standardUserDefaults] setObject:GetAppDelegate.access_token forKey:AccessToken];
           [[NSUserDefaults standardUserDefaults] synchronize];
        
            if (ret == 0)
            {
                NSLog(@"dataDic===================%@",dataDic);
                if ([dataDic isKindOfClass:[NSMutableDictionary class]])
                {
                    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:loginTime];
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:addUserMarkByLogin];
                    User = [[UserBean alloc] initWithUserInfoDic:dataDic];
                    [NSKeyedArchiver archiveRootObject:dataDic toFile:UserInfoFilePath];
                    successBlock(YES);
                }
                else
                {
                    if (ret== 1000)
                    {
                        NSString * message = [[result JSONValue] objectForKey:@"msg"];
                        [ProgressHUD showText:message Interaction:YES Hide:YES];
                        [GetAppDelegate Refreshtoken];
                        return;
                    }
                    NSError *err = [NSError errorWithDomain:@"获取数据——后台返回数据格式有误" code:40000 userInfo:nil];
                    errorBlock(err);
                }
            }
            else
            {
                successBlock(NO);
                NSString * message = [dictResponse objectForKey:@"message"];
                [ProgressHUD showText:message Interaction:YES Hide:YES];
            }
    } withErrorBlock:^(NSError *err)
     {
        errorBlock(err);
    }];
}

+ (void)loginWithPhoneNum:(NSString *)phoneNum withCheckCode:(NSString *)checkCode withNickName:(NSString *)nickName withSuccessBlock:(void(^)(BOOL finished))successBlock withErrorBlock:(void(^)(NSError *err))errorBlock
{
    NSString * clientVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];//获取应用版本号
    
    NSString * osVersion = [[UIDevice currentDevice] systemVersion];//系统版本
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    int width = size.width;
    int height = size.height;
    
    NSString * resolution = [NSString stringWithFormat:@"%d,%d",width,height];//屏幕分辨率
    NSString * osName = @"ios";
    NSString * identify = @"";
    
    NSString *paramType = @"sns";
    NSString * channel_id = @"99999999";
  
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_LoginByThird] withParamDic:@{@"key":checkCode, @"type":paramType,@"osName":osName,@"clientVersion":clientVersion,@"osVersion":osVersion,@"resolution":resolution,@"identify":identify,@"channel_id":channel_id} withSuccessBlock:^(id response)
     {
         NSString *result = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
         NSLog(@"result===================%@",result);
         
         NSMutableDictionary *dictResponse=[result JSONValue];
         NSMutableDictionary *dataDic = [dictResponse objectForKey:@"data"][@"user"];
         int ret = [[dictResponse objectForKey:@"ret"]intValue];
         GetAppDelegate.refresh_token = [dictResponse objectForKey:@"data"][@"refresh_token"];
         GetAppDelegate.access_token = [dictResponse objectForKey:@"data"][@"access_token"];
         GetAppDelegate.expire = [[dictResponse objectForKey:@"data"][@"expire"]intValue];
         
         NSLog(@"GetAppDelegate.access_token===================%@",GetAppDelegate.access_token);
         
         [[NSUserDefaults standardUserDefaults] setObject:GetAppDelegate.refresh_token forKey:RefreshToken];
         
         [[NSUserDefaults standardUserDefaults] setObject:GetAppDelegate.access_token forKey:AccessToken];
         [[NSUserDefaults standardUserDefaults] synchronize];
         
         if (ret == 0)
         {
             NSLog(@"dataDic===================%@",dataDic);
             if ([dataDic isKindOfClass:[NSMutableDictionary class]])
             {
                 [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:loginTime];
                 [[NSUserDefaults standardUserDefaults] setBool:NO forKey:addUserMarkByLogin];
                 User = [[UserBean alloc] initWithUserInfoDic:dataDic];
                 [NSKeyedArchiver archiveRootObject:dataDic toFile:UserInfoFilePath];
                 successBlock(YES);
             }
             else
             {
                 if (ret== 1000)
                 {
                     NSString * message = [[result JSONValue] objectForKey:@"msg"];
                     [ProgressHUD showText:message Interaction:YES Hide:YES];
                     [GetAppDelegate Refreshtoken];
                     return;
                 }
                 NSError *err = [NSError errorWithDomain:@"获取数据——后台返回数据格式有误" code:40000 userInfo:nil];
                 errorBlock(err);
             }
         }
         else
         {
             successBlock(NO);
             NSString * message = [dictResponse objectForKey:@"message"];
             [ProgressHUD showText:message Interaction:YES Hide:YES];
         }
     } withErrorBlock:^(NSError *err)
     {
         errorBlock(err);
     }];
}

+ (void)sendFeedBackWithUserName:(NSString *)userName withUserID:(NSString *)userID withContent:(NSString *)content withSuccessBlock:(void(^)(BOOL finished))successBlock withErrorBlock:(void(^)(NSError *err))errorBlock {
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_FeedBack] withParamDic:@{@"username":userName, @"user_id":userID, @"content":content} withSuccessBlock:^(id response)
    {
        if ([response isKindOfClass:[NSData class]])
        {
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

+ (void)refleshUserInfoWithUserID:(NSString *)userID withSuccessBlock:(void(^)(BOOL finished))successBlock withErrorBlock:(void(^)(NSError *err))errorBlock
{
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_GetSingleUserInfo] withParamDic:@{@"user_id":userID} withSuccessBlock:^(id response)
     {
         NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
         NSLog(@"responseString-------7777%@",responseString);
         NSMutableDictionary *dictResponse=[responseString JSONValue];
         int ret = [[dictResponse objectForKey:@"ret"]intValue];
         NSMutableDictionary * dataDic = [dictResponse objectForKey:@"data"];
         
        if (ret == 0)
        {
            if ([dataDic isKindOfClass:[NSMutableDictionary class]])
            {
                User = [[UserBean alloc] initWithUserInfoDic:dataDic];
                [NSKeyedArchiver archiveRootObject:dataDic toFile:UserInfoFilePath];
                successBlock(YES);
            }
            else
            {
                successBlock(NO);
            }
        }
        else
        {
            if (ret== 1000)
            {
                NSString * message = [[responseString JSONValue] objectForKey:@"msg"];
                [ProgressHUD showText:message Interaction:YES Hide:YES];
                [GetAppDelegate Refreshtoken];
                return;
            }
            NSError *err = [NSError errorWithDomain:@"刷新用户信息——后台返回数据格式有误" code:40000 userInfo:nil];
            errorBlock(err);
        }
    } withErrorBlock:^(NSError *err) {
        errorBlock(err);
    }];
}

@end
