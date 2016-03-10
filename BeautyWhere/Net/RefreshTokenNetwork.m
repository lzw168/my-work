//
//  RefreshTokenNetwork.m
//  BeautyWhere
//
//  Created by lizhiwei on 16/1/20.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RefreshTokenNetwork.h"
#import "NSObject+SBJson.h"
#import "AppDelegate.h"

@implementation RefreshTokenNetwork

+ (void)GetRefreshToken:(void(^)(NSMutableDictionary *RefreshTokenDic))successdBlock withErrorBlock:(void(^)(NSError *err))errBlock
{
    NSString * refresh_token = [[NSUserDefaults standardUserDefaults] objectForKey:RefreshToken];
    NSLog(@"refresh_token==========%@",refresh_token);
    if(refresh_token.length == 0||refresh_token == NULL)
    {
        return;
    }
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_RefreshToken] withParamDic:@{@"refresh_token":refresh_token} withSuccessBlock:^(id response)
     {
         NSLog(@"response=================%@",response);
         NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
         NSLog(@"responseString %@",responseString);
         NSMutableDictionary *dictResponse=[responseString JSONValue];
         int ret = [[dictResponse objectForKey:@"ret"]intValue];
         NSMutableDictionary *dataDic = [dictResponse objectForKey:@"data"];
         NSLog(@"ret=%d=%@",ret,dataDic);
         
         if (ret == 0)
         {
             if ([dataDic isKindOfClass:[NSMutableDictionary class]])
             {
                 successdBlock(dataDic);
             }
             else
             {
                 NSError *err = [NSError errorWithDomain:@"获取RefreshToken后台返回数据格式有误" code:40000 userInfo:nil];
                 errBlock(err);
             }
         }
         else
         {
             [ProgressHUD showText:@"获取RefreshToken失败" Interaction:YES Hide:YES];
         }
    }
    withErrorBlock:^(NSError *err)
    {
         errBlock(err);
     }];
}
@end