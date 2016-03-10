//
//  PersonalPageNetwork.m
//  BeautyWhere
//
//  Created by Michael Chan on 15/8/1.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "PersonalPageNetwork.h"
#import "StoreBean.h"
#import "CouponBean.h"
#import "NSObject+SBJson.h"

@implementation PersonalPageNetwork

+ (void)changeUserName:(NSString *)userName headerImg:(UIImage *)avatar withUserID:(NSString *)userID withMobileNumber:(NSString *)phoneNum withSuccessBlock:(void(^)(NSString *userName, NSString *imgURL))successBlock withErrorBlock:(void(^)(NSError *err))errBlock
{
                                                                    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:userID, @"user_id", phoneNum, @"mobile", nil];
    if (userName)
    {
        [paramDic setObject:userName forKey:@"nickname"];
    }
    NSArray *imgArr = nil;
    NSArray *imgNameArr = nil;
    NSArray *serverImgKeys = nil;
    if (avatar)
    {
        imgArr = @[avatar];
        imgNameArr = @[@"userHeaderImg.jpg"];
        serverImgKeys = @[@"avatar"];
        
    }
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_UpdateUserInfo] withParamDic:paramDic withImgs:imgArr withImgNames:imgNameArr toServerImgKeys:serverImgKeys withSuccessBlock:^(id response)
    {
                                                                        
        if ([response isKindOfClass:[NSData class]])
        {
            NSString *result = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            int ret = [[[result JSONValue] objectForKey:@"ret"]intValue];
            if (ret == 0)
            {
                if (userName && avatar)
                {
                    successBlock(userName, [NSString stringWithFormat:@"%@userHeaderImg.jpg",GetAppDelegate.img_path]);
                }
                else
                {
                    if (userName)
                    {
                        successBlock(userName, nil);
                    }
                    else
                    {
                        successBlock(nil, [NSString stringWithFormat:@"%@userHeaderImg.jpg",GetAppDelegate.img_path]);
                    }
                }
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
                
                NSString * message = [[result JSONValue] objectForKey:@"msg"];
                [ProgressHUD showText:message Interaction:YES Hide:YES];
                return;
                //successBlock(@"", @"");
            }
        }
        else
        {
            NSError *err = [NSError errorWithDomain:@"修改用户昵称或头像——后台返回数据格式有误" code:40000 userInfo:nil];
            errBlock(err);
        }
    } withErrorBlock:^(NSError *err)
    {
        errBlock(err);
    }];
}

+ (void)getCollectionDetailWithUserID:(NSString *)userID withPageNum:(NSString *)pageNum withSuccessBlock:(void(^)(NSArray *collectionArr))successBlock withErrBlock:(void(^)(NSError *err))errBlock
{
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_GetCollectionList] withParamDic:@{@"id":userID, @"page":pageNum} withSuccessBlock:^(id response)
    {
        NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"responseString %@",responseString);
        NSMutableDictionary *dictResponse=[responseString JSONValue];
        int ret = [[dictResponse objectForKey:@"ret"]intValue];
        NSArray * dataArray = [dictResponse objectForKey:@"data"];
        
        if (ret == 0)
        {
            __block NSMutableArray *result = [[NSMutableArray alloc] init];
            [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
             {
                [result addObject:[[StoreBean alloc] initWithDic:obj]];
                if (idx == (dataArray.count-1))
                {
                    successBlock(result);
                }
            }];
            if (dataArray.count==0)
            {
                successBlock(nil);
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
            NSError *err = [NSError errorWithDomain:@"获取收藏详情——后台返回数据格式有误" code:40000 userInfo:nil];
            errBlock(err);
        }
    } withErrorBlock:^(NSError *err)
    {
        errBlock(err);
    }];
}

+ (void)getMyCouponWithUserID:(NSString *)userID withType:(NSString *)type withPageNum:(NSString *)pageNum withSuccessBlock:(void(^)(NSArray *coupons))successBlock withErrorBlock:(void(^)(NSError *err))errBlock
{
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_ShowMyCoupon] withParamDic:@{@"id":userID, @"page":pageNum, @"valid":type} withSuccessBlock:^(id response)
    {
        NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"responseString %@",responseString);
        NSMutableDictionary *dictResponse=[responseString JSONValue];
        int ret = [[dictResponse objectForKey:@"ret"]intValue];
        NSArray * dataArray = [dictResponse objectForKey:@"data"];
        
        if (ret == 0)
        {
            __block NSMutableArray *result = [[NSMutableArray alloc] init];
            [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
            {
                NSLog(@"有效期------%@",obj);
                [result addObject:[[CouponBean alloc] initWithDic:obj]];
                if (idx == (dataArray.count-1))
                {
                    successBlock(result);
                }
            }];
            if (dataArray.count==0) {
                successBlock(nil);
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
            NSError *err = [NSError errorWithDomain:@"获取coupon详情——后台返回数据格式有误" code:40000 userInfo:nil];
            errBlock(err);
        }
    } withErrorBlock:^(NSError *err) {
        errBlock(err);
    }];
}

+ (void)addScoreWithType:(NSString *)type withUserID:(NSString *)userID withSuccessBlock:(void(^)(BOOL finished, NSString *score))successBlock withErrBlock:(void(^)(NSError *err))errBlock {
    [NetworkEngine postWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_AddScore] withParamDic:@{@"type":type, @"user_id":userID} withSuccessBlock:^(id response) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            NSLog(@"增加积分%@",response);
            if (((NSDictionary*)response).count>1) {
                id score = [response valueNull2NilForKey:@"score"];
                if ([score isKindOfClass:[NSNumber class]]) {
                    NSString *s = [NSString stringWithFormat:@"%i",[score integerValue]];
                    successBlock(YES,s);
                }
                else if ([score isKindOfClass:[NSString class]]) {
                    successBlock(YES,score);
                }
                else {
                    successBlock(YES,nil);
                }
            }
            else {
                successBlock(NO,nil);
            }
        }
        else {
            successBlock(NO,nil);
        }
    } withErrorBlock:^(NSError *err) {
        errBlock(err);
    }];
}

@end
