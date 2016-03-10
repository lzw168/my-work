//
//  ADNetwork.m
//  BeautyWhere
//
//  Created by Michael on 15/7/29.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "ADNetwork.h"
#import "ADBean.h"
#import "NSObject+SBJson.h"

@implementation ADNetwork

+ (void)getADListWithSuccessBlock:(void(^)(NSArray *ADArr))successBlock withErrorBlock:(void(^)(NSError *err))errBlock
{
    NSLog(@"url====%@",[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_ADInfo]);
    
    [NetworkEngine httpRequestPostWithURL:[NSString stringWithFormat:@"%@%@",Server_RequestHost, Server_ADInfo] withParamDic:nil withSuccessBlock:^(id response)
     {
        NSLog(@"ad response:%@",response);
        
         NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
         NSLog(@"responseString---ad%@",responseString);
         NSMutableDictionary *dictResponse=[responseString JSONValue];
         int ret = [[dictResponse objectForKey:@"ret"]intValue];
         NSArray * dataArray = [dictResponse objectForKey:@"data"];
         
        if (ret == 0)
        {
            if ([[NSFileManager defaultManager] fileExistsAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"ADInfo.txt"]])
            {
                NSArray *recorded = [NSKeyedUnarchiver unarchiveObjectWithFile:[NSTemporaryDirectory() stringByAppendingPathComponent:@"ADInfo.txt"]];
                NSLog(@"recorded=========%@",recorded);
                 NSLog(@"dataArray=========%@",dataArray);
                if ([recorded isEqualToArray:dataArray])
                {
                    NSLog(@"AD info is the same!!");
                    return;
                }
                else
                {
                    [NSKeyedArchiver archiveRootObject:dataArray toFile:[NSTemporaryDirectory() stringByAppendingPathComponent:@"ADInfo.txt"]];
                }
            }
            else
            {
                [NSKeyedArchiver archiveRootObject:dataArray toFile:[NSTemporaryDirectory() stringByAppendingPathComponent:@"ADInfo.txt"]];
            }
            __block NSMutableArray *adListArr = [[NSMutableArray alloc] init];
            [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
            {
                if ([obj isKindOfClass:[NSDictionary class]])
                {
                    [adListArr addObject:[[ADBean alloc] initWithDic:obj]];
                }
                else
                {
                    NSLog(@"%lu obj isn't a dic:%@",(unsigned long)idx, obj);
                }
                if (idx == (dataArray.count-1))
                {
                    successBlock(adListArr);
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
            NSError *err = [NSError errorWithDomain:@"getAD 返回的数据不是 Array" code:40000 userInfo:response];
            errBlock(err);
        }
    } withErrorBlock:^(NSError *err) {
        errBlock(err);
    }];
}

@end
