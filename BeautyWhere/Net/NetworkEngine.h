//
//  NetworkEngine.h
//  BeautyWhere
//
//  Created by Michael Chan on 15/7/26.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkEngine : NSObject

+ (void)postWithURL:(NSString *)url withParamDic:(NSDictionary *)paramDic withSuccessBlock:(void(^)(id response))successBlock withErrorBlock:(void(^)(NSError * err))failBlock;//用默认 JSON

+ (void)httpRequestPostWithURL:(NSString *)url withParamDic:(NSDictionary *)paramDic withSuccessBlock:(void(^)(id response))successBlock withErrorBlock:(void(^)(NSError * err))failBlock;//用默认二进制

+ (void)httpRequestPostWithURL:(NSString *)url withParamDic:(NSDictionary *)paramDic withImgs:(NSArray *)imgArr withImgNames:(NSArray *)imgNameArr toServerImgKeys:(NSArray *)serverImgKeyArr withSuccessBlock:(void(^)(id response))successBlock withErrorBlock:(void(^)(NSError * err))failBlock;//NSData返回

+ (void)downloadFileWithoutProgressWithURL:(NSString *)url withFilePath:(NSString *)path withSuccessBlock:(void(^)(NSString *fileName))successBlock withErrorBlock:(void(^)(NSError *err))errBlock;

@end
