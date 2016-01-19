//
//  ADNetwork.m
//  BeautyWhere
//
//  Created by Michael on 15/7/29.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "ADNetwork.h"
#import "ADBean.h"

@implementation ADNetwork

+ (void)getADListWithSuccessBlock:(void(^)(NSArray *ADArr))successBlock withErrorBlock:(void(^)(NSError *err))errBlock {
    NSLog(@"url====%@",[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_ADInfo]);
    [NetworkEngine postWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_ADInfo] withParamDic:nil withSuccessBlock:^(id response) {
        NSLog(@"ad response:%@",response);
        if ([response isKindOfClass:[NSArray class]]) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"ADInfo.txt"]]) {
                NSArray *recorded = [NSKeyedUnarchiver unarchiveObjectWithFile:[NSTemporaryDirectory() stringByAppendingPathComponent:@"ADInfo.txt"]];
                if ([recorded isEqualToArray:response])
                {
                    NSLog(@"AD info is the same!!");
                    return;
                }
                else {
                    [NSKeyedArchiver archiveRootObject:response toFile:[NSTemporaryDirectory() stringByAppendingPathComponent:@"ADInfo.txt"]];
                }
            }
            else {
                [NSKeyedArchiver archiveRootObject:response toFile:[NSTemporaryDirectory() stringByAppendingPathComponent:@"ADInfo.txt"]];
            }
            __block NSMutableArray *adListArr = [[NSMutableArray alloc] init];
            [response enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    [adListArr addObject:[[ADBean alloc] initWithDic:obj]];
                }
                else {
                    NSLog(@"%lu obj isn't a dic:%@",(unsigned long)idx, obj);
                }
                if (idx == ((NSArray*)response).count-1) {
                    successBlock(adListArr);
                }
            }];
            if (((NSArray*)response).count==0) {
                successBlock(nil);
            }
        }
        else {
            NSError *err = [NSError errorWithDomain:@"getAD 返回的数据不是 Array" code:40000 userInfo:response];
            errBlock(err);
        }
    } withErrorBlock:^(NSError *err) {
        errBlock(err);
    }];
}

@end
