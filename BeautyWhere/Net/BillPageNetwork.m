//
//  BillPageNetwork.m
//  BeautyWhere
//
//  Created by Michael on 15/8/25.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "BillPageNetwork.h"
#import "BillBean.h"
#import "NSObject+SBJson.h"

@implementation BillPageNetwork

+ (void)showOrderWithUserID:(NSString *)userID withType:(CheckGoodsOnSellsType)type withPageNum:(NSString *)currentPage withSucceedBlock:(void(^)(NSMutableArray *orderArr))successdBlock withErrorBlock:(void(^)(NSError *err))errBlock
{
    NSString *sellsType = nil;
    switch (type)
    {
        case CheckGoodsOnSellsTypeInStore:
            sellsType = @"0";
            break;
        case CheckGoodsOnSellsTypeLimitToFactory:
            sellsType = @"2";
            break;
        case CheckGoodsOnSellsTypeShopping:
            sellsType = @"1";
            break;
    }
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_ShowOrder] withParamDic:@{@"user_id":userID, @"type":sellsType, @"page":currentPage} withSuccessBlock:^(id response)
     {
         NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
         NSLog(@"responseString------9999%@",responseString);
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
                    BillBean *bill = [[BillBean alloc] initWithDic:obj];
                    [result addObject:bill];
                }
            }];
            if (result.count == 0)
            {
                result = nil;
            }
            successdBlock(result);
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
            NSError *err = [NSError errorWithDomain:@"获取订单详情——后台返回数据格式有误" code:40000 userInfo:nil];
            errBlock(err);
        }
    } withErrorBlock:^(NSError *err)
    {
        errBlock(err);
    }];
}

@end
