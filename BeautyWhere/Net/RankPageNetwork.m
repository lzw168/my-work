//
//  RankPageNetwork.m
//  BeautyWhere
//
//  Created by lizhiwei on 16/1/20.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RankPageNetwork.h"
#import "RankBean.h"
#import "NSObject+SBJson.h"
#import "AppDelegate.h"

@implementation RankPageNetwork

+ (void)showRank:(void(^)(NSMutableDictionary *RankDic))successdBlock withErrorBlock:(void(^)(NSError *err))errBlock
{
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_Rank] withParamDic:nil withSuccessBlock:^(id response)
     {
         NSLog(@"response=================%@",response);
         NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
         NSLog(@"responseString %@",responseString);
         NSMutableDictionary *dictResponse=[responseString JSONValue];
         int ret = [[dictResponse objectForKey:@"ret"]intValue];
         NSString * img1 = [dictResponse objectForKey:@"data"][@"img1"];
         NSString * img2 = [dictResponse objectForKey:@"data"][@"img2"];
         NSString * img3 = [dictResponse objectForKey:@"data"][@"img3"];
         NSMutableArray *dataArray = [dictResponse objectForKey:@"data"][@"list"];
         //NSMutableDictionary *dictData = [data JSONValue];
         GetAppDelegate.img1 = img1;
         GetAppDelegate.img2 = img2;
         GetAppDelegate.img3 = img3;
         
         NSLog(@"ret=%d=%@",ret,dataArray);
         
         if (ret == 0)
         {
             if ([dataArray isKindOfClass:[NSMutableArray class]])
             {
                 NSMutableDictionary *rank = [[NSMutableDictionary alloc] init];
                 [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
                  {
                      /*[rank setValue:[obj objectForKey:@"order"] forKey:@"order"];
                      [rank setValue:[obj objectForKey:@"name"] forKey:@"name"];
                      [rank setValue:[obj objectForKey:@"money"] forKey:@"money"];*/
                      if ([obj isKindOfClass:[NSDictionary class]])
                      {
                          successdBlock(obj);
                      }
                  }];
                 if (rank.count == 0)
                 {
                     rank = nil;
                 }
             }
             else
             {
                 NSError *err = [NSError errorWithDomain:@"获取排行榜列表——后台返回数据格式有误" code:40000 userInfo:nil];
                 errBlock(err);
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
             [ProgressHUD showText:@"获取臭美排行列表失败" Interaction:YES Hide:YES];
         }
    }
    withErrorBlock:^(NSError *err)
    {
         errBlock(err);
     }];
}
@end