//
//  BillPageNetwork.m
//  BeautyWhere
//
//  Created by Michael on 15/8/25.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "BillPageNetwork.h"
#import "BillBean.h"

@implementation BillPageNetwork

+ (void)showOrderWithUserID:(NSString *)userID withType:(CheckGoodsOnSellsType)type withPageNum:(NSString *)currentPage withSucceedBlock:(void(^)(NSMutableArray *orderArr))successdBlock withErrorBlock:(void(^)(NSError *err))errBlock {
    NSString *sellsType = nil;
    switch (type) {
        case CheckGoodsOnSellsTypeInStore:
            sellsType = @"comment";
            break;
        case CheckGoodsOnSellsTypeLimitToFactory:
            sellsType = @"flash";
            break;
        case CheckGoodsOnSellsTypeSeckill:
            sellsType = @"seckill";
            break;
        case CheckGoodsOnSellsTypeShopping:
            sellsType = @"luojia";
            break;
    }
    [NetworkEngine postWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_ShowOrder] withParamDic:@{@"user_id":userID, @"type":sellsType, @"pagenum":currentPage} withSuccessBlock:^(id response) {
        if ([response isKindOfClass:[NSArray class]]) {
            __block NSMutableArray *result = [[NSMutableArray alloc] init];
            [response enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    BillBean *bill = [[BillBean alloc] initWithDic:obj];
                    [result addObject:bill];
                }
            }];
            if (result.count == 0) {
                result = nil;
            }
            successdBlock(result);
        }
        else {
            NSError *err = [NSError errorWithDomain:@"获取订单详情——后台返回数据格式有误" code:40000 userInfo:nil];
            errBlock(err);
        }
    } withErrorBlock:^(NSError *err) {
        errBlock(err);
    }];
}

@end
