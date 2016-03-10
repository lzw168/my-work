//
//  ThemeGoodsPageNetwork.m
//  BeautyWhere
//
//  Created by lizhiwei on 16/1/20.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThemeGoodsPageNetwork.h"
#import "NSObject+SBJson.h"
#import "AppDelegate.h"

@implementation ThemeGoodsPageNetwork

+ (void)showThemeGoods:(void(^)(NSMutableDictionary *ThemeGoodsDic))successdBlock withErrorBlock:(void(^)(NSError *err))errBlock
{
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_Themgoods] withParamDic:nil withSuccessBlock:^(id response)
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
                 NSError *err = [NSError errorWithDomain:@"获取主题列表——后台返回数据格式有误" code:40000 userInfo:nil];
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
             [ProgressHUD showText:@"获取主题列表失败" Interaction:YES Hide:YES];
         }
    }
    withErrorBlock:^(NSError *err)
    {
         errBlock(err);
     }];
}
@end