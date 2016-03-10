//
//  AddressPageNetwork.m
//  BeautyWhere
//
//  Created by lizhiwei on 16/1/20.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressPageNetwork.h"
#import "AddressBean.h"
#import "NSObject+SBJson.h"
#import "AppDelegate.h"

@implementation AddressPageNetwork

+ (void)showAddress:(void(^)(NSMutableDictionary *RankDic))successdBlock withErrorBlock:(void(^)(NSError *err))errBlock
{
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_Address] withParamDic:nil withSuccessBlock:^(id response)
     {
         NSLog(@"response=================%@",response);
         NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
         NSLog(@"responseString %@",responseString);
         NSMutableDictionary *dictResponse=[responseString JSONValue];
         int ret = [[dictResponse objectForKey:@"ret"]intValue];
         NSMutableArray *dataArray = [dictResponse objectForKey:@"data"][@"list"];
         NSLog(@"ret=%d=%@",ret,dataArray);
         
         if (ret == 0)
         {
             if ([dataArray isKindOfClass:[NSMutableArray class]])
             {
                 if (dataArray.count == 0)
                 {
                     dataArray = nil;
                     successdBlock(nil);
                 }
                 [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
                  {
                      if ([obj isKindOfClass:[NSDictionary class]])
                      {
                          successdBlock(obj);
                      }
                  }];
             }
             else
             {
                 NSError *err = [NSError errorWithDomain:@"获取收货管理列表——后台返回数据格式有误" code:40000 userInfo:nil];
                 errBlock(err);
             }
         }
         else
         {
             if (ret== 1000)
             {
                 NSString * refresh_token = [[NSUserDefaults standardUserDefaults] objectForKey:RefreshToken];
                 if (refresh_token.length == 0)
                 {
                     return;
                 }
                 NSString * message = [[responseString JSONValue] objectForKey:@"msg"];
                 [ProgressHUD showText:message Interaction:YES Hide:YES];
                 [GetAppDelegate Refreshtoken];
                 return;
             }
             [ProgressHUD showText:@"获取收货管理列表失败" Interaction:YES Hide:YES];
         }
    }
    withErrorBlock:^(NSError *err)
    {
         errBlock(err);
     }];
}

+ (void)AddAddressWithReceiver:(NSString *)receiver withMobile:(NSString *)mobile withLocation:(NSString *)location withIsDefault:(int)isdefault withRegion:(NSString *)region withSuccessBlock:(void(^)(BOOL finished))successdBlock withErrorBlock:(void(^)(NSError *err))errBlock
{
    NSString * IsDefault = [NSString stringWithFormat:@"%d",isdefault];
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_Address_add] withParamDic:@{@"receiver":receiver, @"mobile":mobile, @"location":location, @"is_default":IsDefault,@"region":region} withSuccessBlock:^(id response)
     {
         NSLog(@"response=================%@",response);
         NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
         NSLog(@"responseString %@",responseString);
         NSMutableDictionary *dictResponse=[responseString JSONValue];
         int ret = [[dictResponse objectForKey:@"ret"]intValue];
         
         if (ret == 0)
         {
             BOOL sucess  = YES;
             successdBlock(sucess);
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
             [ProgressHUD showText:@"增加收货地址失败" Interaction:YES Hide:YES];
         }
     }
     withErrorBlock:^(NSError *err)
     {
         errBlock(err);
     }];
}

+ (void)DelAddressWithAddressId:(int)addId withSuccessBlock:(void(^)(BOOL finished))successdBlock withErrorBlock:(void(^)(NSError *err))errBlock
{
    NSString * AddId = [NSString stringWithFormat:@"%d",addId];
    NSLog(@"AddId=============%@",AddId);
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_Address_delete] withParamDic:@{@"id":AddId} withSuccessBlock:^(id response)
     {
         NSLog(@"response=================%@",response);
         NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
         NSLog(@"responseString %@",responseString);
         NSMutableDictionary *dictResponse=[responseString JSONValue];
         int ret = [[dictResponse objectForKey:@"ret"]intValue];
         
         if (ret == 0)
         {
             BOOL sucess  = YES;
             successdBlock(sucess);
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
             [ProgressHUD showText:@"删除收货地址失败" Interaction:YES Hide:YES];
         }
     }
     withErrorBlock:^(NSError *err)
     {
         errBlock(err);
     }];
}

+(void)EditAddressWithId:(NSString *)receiver withMobile:(NSString *)mobile withLocation:(NSString *)location withIsDefault:(int)isdefault withid:(int)addId withRegion:(NSString *)region withSuccessBlock:(void(^)(BOOL finished))successdBlock withErrorBlock:(void(^)(NSError *err))errBlock
{
    NSString * IsDefault = [NSString stringWithFormat:@"%d",isdefault];
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_Address_edit] withParamDic:@{@"id":[NSString stringWithFormat:@"%d",addId],@"receiver":receiver, @"mobile":mobile, @"location":location, @"is_default":IsDefault,@"region":region} withSuccessBlock:^(id response)
     {
         NSLog(@"response=================%@",response);
         NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
         NSLog(@"responseString %@",responseString);
         NSMutableDictionary *dictResponse=[responseString JSONValue];
         int ret = [[dictResponse objectForKey:@"ret"]intValue];
         
         if (ret == 0)
         {
             BOOL sucess  = YES;
             successdBlock(sucess);
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
             [ProgressHUD showText:@"修改收货地址失败" Interaction:YES Hide:YES];
         }
     }
     withErrorBlock:^(NSError *err)
     {
         errBlock(err);
     }];
}

@end