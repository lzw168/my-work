//
//  HomePageNetwork.m
//  BeautyWhere
//
//  Created by Michael on 15/8/3.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "HomePageNetwork.h"
#import "ProvinceBean.h"
#import "InfoBean.h"
#import "GoodsBean.h"
#import "StoreBean.h"
#import "CommentBean.h"
#import "NursingCouponView.h"
#import "KGModal.h"
#import "StoreList.h"
#import "CouponBean.h"
#include "NSObject+SBJson.h"
#import "ConfigBean.h"
#import "CityBean.h"
#include "GoodBean.h"
#include "IntegralTableViewController.h"

@implementation HomePageNetwork

+ (void)getProvinceListWithSuccessBlock:(void(^)(NSArray *provinceArr))successBlock withErrorBlock:(void(^)(NSError *err))errBlock
{
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_ProviceList] withParamDic:nil withSuccessBlock:^(id response)
     {
         NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
         NSLog(@"responseString %@",responseString);
         NSMutableDictionary *dictResponse=[responseString JSONValue];
         int ret = [[dictResponse objectForKey:@"ret"]intValue];
         NSMutableArray *dataArray = [dictResponse objectForKey:@"data"];
         
        if (ret == 0)
        {
            __block NSMutableArray *result = [[NSMutableArray alloc] init];
            [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
            {
                [result addObject:[[ProvinceBean alloc] initWithDic:obj]];
                if (idx == dataArray.count-1)
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
            NSError *err = [NSError errorWithDomain:@"获取列表后台返回数据格式有误" code:40000 userInfo:nil];
            errBlock(err);
        }
    } withErrorBlock:^(NSError *err)
    {
        errBlock(err);
    }];
}

+ (void)getCityListWithSuccessBlock:(NSString *)province withSuccessBlock:(void(^)(NSArray *cityArr))successBlock withErrorBlock:(void(^)(NSError *err))errBlock
{
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_GetCity] withParamDic:@{@"province":province} withSuccessBlock:^(id response)
     {
         NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
         NSLog(@"citylist=====%@",responseString);
         NSMutableDictionary *dictResponse=[responseString JSONValue];
         int ret = [[dictResponse objectForKey:@"ret"]intValue];
         NSMutableArray *dataArray = [dictResponse objectForKey:@"data"];
         
         if (ret == 0)
         {
             __block NSMutableArray *result = [[NSMutableArray alloc] init];
             [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
              {
                  [result addObject:[[CityBean alloc] initWithDic:obj]];
                  if (idx == dataArray.count-1)
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
             NSError *err = [NSError errorWithDomain:@"获取列表后台返回数据格式有误" code:40000 userInfo:nil];
             errBlock(err);
         }
     } withErrorBlock:^(NSError *err)
     {
         errBlock(err);
     }];
}

+ (void)showGoodsWithSuccessBlock:(NSString *)goodID withSuccessBlock:(void(^)(NSMutableDictionary*GoodsDic))successBlock withErrorBlock:(void(^)(NSError *err))errBlock
{
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_showGoods] withParamDic:@{@"goods_id":goodID} withSuccessBlock:^(id response)
     {
         NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
         NSLog(@"goodlist========%@",responseString);
         NSMutableDictionary *dictResponse=[responseString JSONValue];
         int ret = [[dictResponse objectForKey:@"ret"]intValue];
         NSMutableDictionary *dataDic = [dictResponse objectForKey:@"data"];
         
         if (ret == 0)
         {
             /*__block NSMutableArray *result = [[NSMutableArray alloc] init];
             [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
              {
                  [result addObject:[[GoodBean alloc] initWithDic:obj]];
                  if (idx == dataArray.count-1)
                  {
                      successBlock(result);
                  }
              }];
             if (dataArray.count==0)
             {
                 successBlock(nil);
             }*/
             if ([dataDic isKindOfClass:[NSMutableDictionary class]])
             {
                 successBlock(dataDic);
             }
             else
             {
                 NSError *err = [NSError errorWithDomain:@"获取后台返回数据格式有误" code:40000 userInfo:nil];
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
             NSError *err = [NSError errorWithDomain:@"获取列表后台返回数据格式有误" code:40000 userInfo:nil];
             errBlock(err);
         }
     } withErrorBlock:^(NSError *err)
     {
         errBlock(err);
     }];
}

+ (void)showGoodsWithActivity:(NSString *)goodID withSuccessBlock:(void(^)(NSMutableDictionary*GoodsDic))successBlock withErrorBlock:(void(^)(NSError *err))errBlock
{
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_showGoods] withParamDic:@{@"activity_id":goodID} withSuccessBlock:^(id response)
     {
         NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
         NSLog(@"goodlist========%@",responseString);
         NSMutableDictionary *dictResponse=[responseString JSONValue];
         int ret = [[dictResponse objectForKey:@"ret"]intValue];
         NSMutableDictionary *dataDic = [dictResponse objectForKey:@"data"];
         
         if (ret == 0)
         {
             /*__block NSMutableArray *result = [[NSMutableArray alloc] init];
              [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
              {
              [result addObject:[[GoodBean alloc] initWithDic:obj]];
              if (idx == dataArray.count-1)
              {
              successBlock(result);
              }
              }];
              if (dataArray.count==0)
              {
              successBlock(nil);
              }*/
             if ([dataDic isKindOfClass:[NSMutableDictionary class]])
             {
                 successBlock(dataDic);
             }
             else
             {
                 NSError *err = [NSError errorWithDomain:@"获取后台返回数据格式有误" code:40000 userInfo:nil];
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
             NSError *err = [NSError errorWithDomain:@"获取列表后台返回数据格式有误" code:40000 userInfo:nil];
             errBlock(err);
         }
     } withErrorBlock:^(NSError *err)
     {
         errBlock(err);
     }];
}


+ (void)getInfoWithPageNum:(NSString *)pageNum withSuccessBlock:(void(^)(NSArray *infoArr))successBlock withErrBlock:(void(^)(NSError *err))errBlock
{
    [NetworkEngine postWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_InfoList] withParamDic:@{@"page":pageNum} withSuccessBlock:^(id response)
    {
        if ([response isKindOfClass:[NSArray class]])
        {
            __block NSMutableArray *result = [[NSMutableArray alloc] init];
            [response enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
            {
                [result addObject:[[InfoBean alloc] initWithDic:obj]];
                if (idx == ((NSArray*)response).count-1)
                {
                    successBlock(result);
                }
            }];
            if (((NSArray*)response).count==0)
            {
                successBlock(nil);
            }
        }
        else
        {
            NSError *err = [NSError errorWithDomain:@"获取列表后台返回数据格式有误" code:40000 userInfo:nil];
            errBlock(err);
        }
    } withErrorBlock:^(NSError *err)
    {
        errBlock(err);
    }];
}

+ (void)getCouponInfoWithSuccessBlock:(void(^)(NSDictionary *couponArr))successBlock withErrorBlock:(void(^)(NSError *err))errBlock
{
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_CouponInfo] withParamDic:nil withSuccessBlock:^(id response)
     {
         NSLog(@"response=================%@",response);
         NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
         NSLog(@"responseString %@",responseString);
         NSMutableDictionary *dictResponse=[responseString JSONValue];
         int ret = [[dictResponse objectForKey:@"ret"]intValue];
         NSDictionary *dataDic = [dictResponse objectForKey:@"data"];

         if (ret == 0)
         {
             successBlock(dataDic);
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
             NSError *err = [NSError errorWithDomain:@"getCouponInfo——后台返回数据格式有误" code:40000 userInfo:nil];
             errBlock(err);
         }

        /*if ([response isKindOfClass:[NSDictionary class]])
        {
            NSArray * couponlist =
            successBlock([response objectForKey:@"id"]);
        }
        else
        {
            NSError *err = [NSError errorWithDomain:@"getCouponInfo——后台返回数据格式有误" code:40000 userInfo:nil];
            errBlock(err);
        }*/
    } withErrorBlock:^(NSError *err)
    {
        NSLog(@"err========%@",err.description);
        errBlock(err);
    }];
}

+ (void)getCouponWithUserID:(NSString *)userID withCouponID:(NSString *)couponID withCouponImage:(NSString *)couponImage withCouponPrice:(NSString *)couponPrice withSuccessBlock:(void(^)(NSString *message))successBlock withErrBlock:(void(^)(NSError *err))errBlock
{
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_GetCoupon] withParamDic:@{@"user_id":userID, @"coupon_id":couponID} withSuccessBlock:^(id response)
    {
        NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"responseString%@",responseString);
        NSMutableDictionary *dictResponse=[responseString JSONValue];
        int ret = [[dictResponse objectForKey:@"ret"]intValue];

        if (ret == 2)
        {
            UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 265, 189)];
            contentView.backgroundColor = [UIColor whiteColor];
            UILabel *Xztext = [[UILabel alloc] initWithFrame:CGRectMake(contentView.frame.size.width/2-110, 10, 220, 15)];
            NSString * title = [NSString stringWithFormat:@"你已经领取过%@个臭美币",couponPrice];
            Xztext.text = title;//@"你已经领取过52元的护理代金劵";
            Xztext.font = [UIFont systemFontOfSize:15.0f];
            Xztext.textColor = [UIColor grayColor];
            Xztext.textAlignment = NSTextAlignmentCenter;
            
            NursingCouponView * NurCouView = [[NursingCouponView alloc] init];
            NurCouView.view.frame = CGRectMake(0, 30, 265, 159);
            [NurCouView setWidth:261 andsetHeight:157 andsetImage:couponImage];
            NurCouView.view.backgroundColor = [UIColor clearColor];
            
            [contentView addSubview:NurCouView.view];
            [contentView addSubview:Xztext];
            
            [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
            successBlock(@"");
            //successBlock(@"你已经领取过52元的护理代金劵");
        }
        else if (ret == 0)
        {
            UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 265, 189)];
            contentView.backgroundColor = [UIColor whiteColor];
            UILabel *Xztext = [[UILabel alloc] initWithFrame:CGRectMake(contentView.frame.size.width/2-110, 10, 220, 15)];
            NSString * title = [NSString stringWithFormat:@"成功领取%@个臭美币",couponPrice];
            Xztext.text = title;//@"成功领取52元的护理代金劵";
            Xztext.font = [UIFont systemFontOfSize:15.0f];
            Xztext.textColor = [UIColor grayColor];
            Xztext.textAlignment = NSTextAlignmentCenter;
            
            NursingCouponView * NurCouView = [[NursingCouponView alloc] init];
            NurCouView.view.frame = CGRectMake(0, 30, 265, 159);
            [NurCouView setWidth:261 andsetHeight:157 andsetImage:couponImage];
            NurCouView.view.backgroundColor = [UIColor clearColor];
            
            [contentView addSubview:NurCouView.view];
            [contentView addSubview:Xztext];
            
            [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
            successBlock(@"");
            //successBlock(@"成功领取52元的护理代金劵");
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
            NSError *err = [NSError errorWithDomain:@"领取失败" code:40000 userInfo:nil];
            errBlock(err);
        }
    } withErrorBlock:^(NSError *err) {
        errBlock(err);
    }];
}

+ (void)getLimitTimeToBuyListWithStartTime:(NSString *)startTime withLng:(NSString *)lng withLat:(NSString *)lat withCurrentPage:(NSString *)pageNum withSuccessBlock:(void (^)(NSMutableArray *goodsArr))successBlock withErrorBlock:(void(^)(NSError *err))errBlock
{
    [NetworkEngine postWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_ShowSeckillList] withParamDic:@{@"start_time":startTime, @"lng":lng, @"lat":lat, @"page":pageNum} withSuccessBlock:^(id response)
    {
        if ([response isKindOfClass:[NSDictionary class]] && [[response objectForKey:@"list"] isKindOfClass:[NSArray class]])
        {
            __block NSMutableArray *goodsBeanArr = [[NSMutableArray alloc] init];
            [[response objectForKey:@"list"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:obj];
                [dic setObject:[response objectForKey:@"state"] forKey:@"state"];
                GoodsBean *goods = [[GoodsBean alloc] initWithDic:dic];
                [goodsBeanArr addObject:goods];
            }];
            if (goodsBeanArr.count == 0) {
                goodsBeanArr = nil;
            }
            successBlock(goodsBeanArr);
        }
        else
        {
            NSError *err = [NSError errorWithDomain:@"getLimitTimeToBuyListWithStartTime——后台返回数据格式有误" code:40000 userInfo:nil];
            errBlock(err);
        }
    } withErrorBlock:^(NSError *err) {
        errBlock(err);
    }];
}

+ (void)getShoppingInfoWithStartTime:(NSString *)startTime withPageNum:(NSString *)pageNum withSuccessBlock:(void (^)(NSMutableArray *goodsArr))successBlock withErrorBlock:(void(^)(NSError *err))errBlock
{
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_showActivity] withParamDic:@{@"start_time":startTime, @"page":pageNum,@"type":@"1"} withSuccessBlock:^(id response)
    {
        NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"responseString %@",responseString);
        NSMutableDictionary *dictResponse=[responseString JSONValue];
        int ret = [[dictResponse objectForKey:@"ret"]intValue];
        NSMutableArray *dataArray = [dictResponse objectForKey:@"data"];
        
        if (ret == 0)
        {
            __block NSMutableArray *goodsBeanArr = [[NSMutableArray alloc] init];
            [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
            {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:obj];
                GoodsBean *goods = [[GoodsBean alloc] initWithDic:dic];
                [goodsBeanArr addObject:goods];
            }];
            if (goodsBeanArr.count == 0) {
                goodsBeanArr = nil;
            }
            successBlock(goodsBeanArr);
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
            NSError *err = [NSError errorWithDomain:@"getShoppingInfo——后台返回数据格式有误" code:40000 userInfo:nil];
            errBlock(err);
        }
    } withErrorBlock:^(NSError *err) {
        errBlock(err);
    }];
}

+ (void)getLimitFactoryInfoWithStartTime:(NSString *)startTime withPageNum:(NSString *)pageNum withSuccessBlock:(void (^)(NSMutableArray *goodsArr))successBlock withErrorBlock:(void(^)(NSError *err))errBlock
{
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_showActivity] withParamDic:@{@"start_time":startTime, @"page":pageNum,@"type":@"2"} withSuccessBlock:^(id response)
    {
        NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"responseString %@",responseString);
        NSMutableDictionary *dictResponse=[responseString JSONValue];
        int ret = [[dictResponse objectForKey:@"ret"]intValue];
        NSMutableArray *dataArray = [dictResponse objectForKey:@"data"];
        
        if (ret == 0)
        {
            __block NSMutableArray *goodsBeanArr = [[NSMutableArray alloc] init];
            [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
            {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:obj];
                GoodsBean *goods = [[GoodsBean alloc] initWithDic:dic];
                [goodsBeanArr addObject:goods];
            }];
            if (goodsBeanArr.count == 0)
            {
                goodsBeanArr = nil;
            }
            successBlock(goodsBeanArr);
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
            
            NSError *err = [NSError errorWithDomain:@"getLimitFactoryInfo——后台返回数据格式有误" code:40000 userInfo:nil];
            errBlock(err);
        }
    } withErrorBlock:^(NSError *err)
     {
        errBlock(err);
    }];
}

+ (void)getBusinessZoneWithCity:(NSString *)city withSuccessBlock:(void (^)(NSArray *storeArr))successBlock withErrorBlock:(void(^)(NSError *err))errBlock {
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_BussinessArea] withParamDic:@{@"city":city} withSuccessBlock:^(id response)
     {
         NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
         NSLog(@"responseString %@",responseString);
         NSMutableDictionary *dictResponse=[responseString JSONValue];
        int ret = [[dictResponse objectForKey:@"ret"]intValue];
         NSArray *dataArray = [dictResponse objectForKey:@"data"];
         
        if (ret == 0)
        {
            NSMutableArray *area = [[NSMutableArray alloc] init];
            [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
            {
                NSLog(@"name===========%@",[obj objectForKey:@"name"]);
                [area addObject:[obj objectForKey:@"name"]];
            }];
            if (area.count == 0) {
                area = nil;
            }
            successBlock(area);
            NSLog(@"getBusinessZone response:%@",dataArray);
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
            NSError *err = [NSError errorWithDomain:@"getNearbyStore——后台返回数据格式有误" code:40000 userInfo:nil];
            errBlock(err);
        }
    } withErrorBlock:^(NSError *err) {
        errBlock(err);
    }];
}

+ (void)getNearbyStoreWithUserID:(NSString *)userID withCity:(NSString *)city withDistrict:(NSString *)district withLng:(NSString *)lng withLat:(NSString *)lat withPageNum:(NSString *)pageNum withGroupID:(NSString *)groupID withTerm:(NSString *)term withSuccessBlock:(void (^)(NSArray *storeArr))successBlock withErrorBlock:(void(^)(NSError *err))errBlock
{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:userID, @"user_id", city, @"city", lng, @"lng", lat, @"lat", pageNum, @"page", nil];
    if (groupID && ![groupID isEqualToString:@""])
    {
        [paramDic setObject:groupID forKey:@"group_id"];
    }
    if (term && ![term isEqualToString:@""])
    {
        [paramDic setObject:term forKey:@"filter_type"];
    }
    if (district && ![district isEqualToString:@""]) {
        [paramDic setObject:district forKey:@"district"];
    }
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_StoreList] withParamDic:paramDic withSuccessBlock:^(id response)
     {
         NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
         NSLog(@"responseString %@",responseString);
         NSMutableDictionary *dictResponse=[responseString JSONValue];
         int ret = [[dictResponse objectForKey:@"ret"]intValue];
         NSMutableArray *dataArray = [dictResponse objectForKey:@"data"];
         
         if (ret == 0)
         {
             __block NSMutableArray *result = [[NSMutableArray alloc] init];
             [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
              {
                  if ([obj isKindOfClass:[NSDictionary class]])
                  {
                      StoreBean *store = [[StoreBean alloc] initWithDic:obj];
                      [result addObject:store];
                  }
              }];
             if (result.count == 0)
             {
                 result = nil;
             }
             successBlock(result);
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
             NSError *err = [NSError errorWithDomain:@"getNearbyStore后台返回数据格式有误" code:40000 userInfo:nil];
             errBlock(err);
         }
    } withErrorBlock:^(NSError *err)
    {
        errBlock(err);
    }];
}

+ (void)sendStoreCommentWithUserID:(NSString *)userID withPartnerID:(NSString *)partnerID withStarMark:(NSString *)starMark withJiSuMark:(NSString *)jiSuMark withContent:(NSString *)content withSuccessBlock:(void (^)(BOOL finished))successBlock withErrorBlock:(void(^)(NSError *err))errBlock
{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:userID, @"user_id", partnerID, @"partner_id", content, @"content", nil];
    if (starMark)
    {
        [paramDic setObject:starMark forKey:@"star"];
    }
    if (jiSuMark)
    {
        [paramDic setObject:jiSuMark forKey:@"tech"];
    }
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_WriteComment] withParamDic:paramDic withSuccessBlock:^(id response)
    {
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
        }
    } withErrorBlock:^(NSError *err) {
        errBlock(err);
    }];
}

+ (void)getStoreCommentWithPartnerID:(NSString *)partnerID withSuccessBlock:(void (^)(NSArray *commentArr))successBlock withErrorBlock:(void(^)(NSError *err))errBlock
{
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_ShowComment] withParamDic:@{@"partner_id":partnerID} withSuccessBlock:^(id response){
        NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"responseString %@",responseString);
        NSMutableDictionary *dictResponse=[responseString JSONValue];
        int ret = [[dictResponse objectForKey:@"ret"]intValue];
        NSMutableArray *dataArray = [dictResponse objectForKey:@"data"];
        
        if (ret == 0)
        {
            NSLog(@"getStoreCommen response:%@",dataArray);
            NSMutableArray *result = [[NSMutableArray alloc] init];
            [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
            {
                if ([obj isKindOfClass:[NSDictionary class]])
                {
                    CommentBean *store = [[CommentBean alloc] initWithDic:obj];
                    [result addObject:store];
                }
            }];
            if (result.count == 0) {
                result = nil;
            }
            successBlock(result);
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
            NSError *err = [NSError errorWithDomain:@"getStoreCommen——后台返回数据格式有误" code:40000 userInfo:nil];
            errBlock(err);
        }
    } withErrorBlock:^(NSError *err)
     {
        errBlock(err);
    }];
}

+ (void)getGoodsInStoreDetailPageWithPartnerID:(NSString *)partnerID withSuccessBlock:(void (^)(NSArray *goodsArr))successBlock withErrorBlock:(void(^)(NSError *err))errBlock
{
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_GoodsInStore] withParamDic:@{@"partner_id":partnerID} withSuccessBlock:^(id response)
    {
        NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"responseString %@",responseString);
        NSMutableDictionary *dictResponse=[responseString JSONValue];
        int ret = [[dictResponse objectForKey:@"ret"]intValue];
        NSMutableArray *dataArray = [dictResponse objectForKey:@"data"];

        if (ret == 0)
        {
            NSLog(@"getStoreCommen response:%@",response);
            NSMutableArray *result = [[NSMutableArray alloc] init];
            [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
            {
                if ([obj isKindOfClass:[NSDictionary class]])
                {
                    GoodsBean *store = [[GoodsBean alloc] initWithDic:obj];
                    [result addObject:store];
                }
            }];
            if (result.count == 0) {
                result = nil;
            }
            successBlock(result);
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
            NSError *err = [NSError errorWithDomain:@"getStoreCommen——后台返回数据格式有误" code:40000 userInfo:nil];
            errBlock(err);
        }
    } withErrorBlock:^(NSError *err) {
        errBlock(err);
    }];
}

+ (void)collectStoreWithUserID:(NSString *)userID withPartnerID:(NSString *)partnerID withType:(NSString *)collectOrNot withSuccessBlock:(void (^)(BOOL finished))successBlock withErrorBlock:(void(^)(NSError *err))errBlock {
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_CollectStore] withParamDic:@{@"user_id":userID, @"partner_id":partnerID, @"type":collectOrNot} withSuccessBlock:^(id response)
     {
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
        }
    } withErrorBlock:^(NSError *err)
    {
        errBlock(err);
    }];
}

+ (void)checkGoodsOnSellOrNotWithGoodsID:(NSString *)goodsID withType:(CheckGoodsOnSellsType)type
                        withGoodsNum:(NSString *)goodsNum withSuccessBlock:(void (^)(BOOL finished))successBlock withErrorBlock:(void(^)(NSError *err))errBlock
{
    switch (type)
    {
        case CheckGoodsOnSellsTypeInStore:
        {
            if(GetAppDelegate.addressid == nil)
            {
                GetAppDelegate.addressid = @"";
            }
            [HomePageNetwork GetNewOrder:goodsID withUserId:GetAppDelegate.user.userID withActivityId:@"0" withAddressID:GetAppDelegate.addressid withgoodsnum:goodsNum withSuccessBlock:^(NSString *message)
             {
                 NSLog(@"message===============%@",message);
                 [ProgressHUD showText:message Interaction:YES Hide:YES];
                 if ([message isEqualToString:@"臭美币不足"])
                 {
                     successBlock(YES);
                 }
             } withErrBlock:^(NSError *err)
             {
                 [ProgressHUD showText:@"购买失败" Interaction:YES Hide:YES];
             }];

        }
            break;
        case CheckGoodsOnSellsTypeLimitToFactory:
        {
            if(GetAppDelegate.addressid == nil)
            {
                GetAppDelegate.addressid = @"";
            }
            [HomePageNetwork GetNewOrder:@"" withUserId:GetAppDelegate.user.userID withActivityId:goodsID withAddressID:GetAppDelegate.addressid withgoodsnum:goodsNum withSuccessBlock:^(NSString *message)
             {
                 NSLog(@"message===============%@",message);
                 [ProgressHUD showText:message Interaction:YES Hide:YES];
                 if ([message isEqualToString:@"臭美币不足"])
                 {
                     successBlock(YES);
                 }
             } withErrBlock:^(NSError *err)
             {
                 [ProgressHUD showText:@"购买失败" Interaction:YES Hide:YES];
             }];

        }
            break;
        case CheckGoodsOnSellsTypeShopping:
        {
            if(GetAppDelegate.addressid == nil)
            {
                GetAppDelegate.addressid = @"";
            }
            [HomePageNetwork GetNewOrder:@"" withUserId:GetAppDelegate.user.userID withActivityId:goodsID withAddressID:GetAppDelegate.addressid withgoodsnum:goodsNum withSuccessBlock:^(NSString *message)
             {
                 NSLog(@"message===============%@",message);
                 [ProgressHUD showText:message Interaction:YES Hide:YES];
                 if ([message isEqualToString:@"臭美币不足"])
                 {
                     successBlock(YES);
                 }
             } withErrBlock:^(NSError *err)
             {
                 [ProgressHUD showText:@"购买失败" Interaction:YES Hide:YES];
             }];

        }
            break;
    }
    
    /*if (type == CheckGoodsOnSellsTypeInStore)
    {
        successBlock(YES);
    }
    else
    {
        [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_NewOrder] withParamDic:@{@"good_id":goodsID} withSuccessBlock:^(id response)
        {
            NSLog(@"response:%@",response);
            
            NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSLog(@"responseString %@",responseString);
            NSMutableDictionary *dictResponse=[responseString JSONValue];
            int ret = [[dictResponse objectForKey:@"ret"]intValue];
            
            if (ret == 0)
            {
                //BOOL canBuy = [[response valueNull2NilForKey:@"canbuy"] boolValue];
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
                
                NSError *err = [NSError errorWithDomain:@"checkGoodsOnSellOrNotWithGoodsID——后台返回数据格式有误" code:40000 userInfo:nil];
                errBlock(err);
            }
        } withErrorBlock:^(NSError *err)
        {
            errBlock(err);
        }];
    }*/
}

+ (void)getPingPPChargeWithGoodsID:(NSString *)goodsID withGoodsType:(NSString *)goodsType withUserID:(NSString *)userID withPartnerID:(NSString *)partnerID withAmount:(NSString *)amount withSubject:(NSString *)subject withMobile:(NSString *)mobile withChannel:(NSString *)channel withBody:(NSString *)body withSuccessBlock:(void (^)(NSDictionary *pingPPCharge))successBlock withErrorBlock:(void(^)(NSError *err))errBlock
{
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_OrderPay] withParamDic:@{@"goods_id":goodsID, @"goods_type":goodsType, @"user_id":userID, @"partner_id":partnerID, @"amount":amount, @"subject":subject, @"mobile":mobile, @"channel":channel, @"body":body} withSuccessBlock:^(id response)
     {
         NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
         NSLog(@"responseString----88%@",responseString);
         NSMutableDictionary *dictResponse=[responseString JSONValue];
         int ret = [[dictResponse objectForKey:@"ret"]intValue];
         NSString * dataStr = [dictResponse objectForKey:@"data"];
         NSMutableDictionary * dataDic = [dataStr JSONValue];
         NSLog(@"dataDic===========%@",dataDic);
         
        if (ret == 0)
        {
            if (dataDic)
            {
                successBlock(dataDic);
            }
            else
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
                return;
            }
            successBlock(nil);
        }
    } withErrorBlock:^(NSError *err)
    {
        errBlock(err);
    }];
}

/*-----增加获取分店列表功能*/
+ (void)getStoreListPageWithPartnerID:(NSString *)partnerID withSuccessBlock:(void (^)(NSArray *goodsArr))successBlock withErrorBlock:(void(^)(NSError *err))errBlock
{
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_Sub] withParamDic:@{@"partner_id":partnerID} withSuccessBlock:^(id response)
     {
         NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
         NSLog(@"responseString %@",responseString);
         NSMutableDictionary *dictResponse=[responseString JSONValue];
         int ret = [[dictResponse objectForKey:@"ret"]intValue];
         NSMutableArray *dataArray = [dictResponse objectForKey:@"data"];

        if (ret == 0)
        {
            NSLog(@"getStoreList response:%@",response);
            NSMutableArray *result = [[NSMutableArray alloc] init];
            [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
            {
                if ([obj isKindOfClass:[NSDictionary class]])
                {
                    StoreBean *store = [[StoreBean alloc] initWithDic:obj];
                    [result addObject:store];
                }
            }];
            if (result.count == 0)
            {
                result = nil;
            }
            successBlock(result);
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
            
            NSError *err = [NSError errorWithDomain:@"getStoreCommen——后台返回数据格式有误" code:40000 userInfo:nil];
            errBlock(err);
        }
    } withErrorBlock:^(NSError *err)
    {
        errBlock(err);
    }];
}

+(void)GetNewOrder:(NSString *)goodsID withUserId:(NSString *)userID withActivityId:(NSString *)activityID withAddressID:(NSString *)addressID withgoodsnum:(NSString *)goodsNum withSuccessBlock:(void(^)(NSString *message))successBlock withErrBlock:(void(^)(NSError *err))errBlock
{
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_NewOrder] withParamDic:@{@"user_id":userID, @"goods_id":goodsID,@"activity_id":activityID,@"address_id":addressID,@"goods_num":goodsNum} withSuccessBlock:^(id response)
     {
         NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
         NSLog(@"responseString %@",responseString);
         NSMutableDictionary *dictResponse=[responseString JSONValue];
         int ret = [[dictResponse objectForKey:@"ret"]intValue];
        
         if (ret == 0)
         {
             successBlock(@"购买成功");
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
             NSString * message = [[responseString JSONValue] objectForKey:@"msg"];
             successBlock(message);
         }
     }withErrorBlock:^(NSError *err)
    {
        errBlock(err);
    }];
}

+ (void)GetConfigInfo:(void(^)(NSMutableDictionary *ConfigDic))successBlock withErrorBlock:(void(^)(NSError *err))errBlock
{
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_Config] withParamDic:nil withSuccessBlock:^(id response)
     {
         NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
         NSLog(@"responseString %@",responseString);
         NSMutableDictionary *dictResponse=[responseString JSONValue];
         int ret = [[dictResponse objectForKey:@"ret"]intValue];
         NSMutableDictionary *dataDic = [dictResponse objectForKey:@"data"];
         
         if (ret == 0)
         {
            successBlock(dataDic);
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
             NSError *err = [NSError errorWithDomain:@"获取配置信息——后台返回数据格式有误" code:40000 userInfo:nil];
             errBlock(err);
         }
     } withErrorBlock:^(NSError *err)
     {
         errBlock(err);
     }];
}

@end
