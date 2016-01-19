//
//  NetworkEngine.m
//  BeautyWhere
//
//  Created by Michael Chan on 15/7/26.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "NetworkEngine.h"

@implementation NetworkEngine

+ (void)postWithURL:(NSString *)url withParamDic:(NSDictionary *)paramDic withSuccessBlock:(void(^)(id response))successBlock withErrorBlock:(void(^)(NSError * err))failBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = NetworkRequestTimeout;
    ((AFJSONResponseSerializer*)manager.responseSerializer).removesKeysWithNullValues = YES;
    [manager POST:url parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failBlock(error);
    }];
}

+ (void)httpRequestPostWithURL:(NSString *)url withParamDic:(NSDictionary *)paramDic withSuccessBlock:(void(^)(id response))successBlock withErrorBlock:(void(^)(NSError * err))failBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = NetworkRequestTimeout;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failBlock(error);
    }];
}

+ (void)httpRequestPostWithURL:(NSString *)url withParamDic:(NSDictionary *)paramDic withImgs:(NSArray *)imgArr withImgNames:(NSArray *)imgNameArr toServerImgKeys:(NSArray *)serverImgKeyArr withSuccessBlock:(void(^)(id response))successBlock withErrorBlock:(void(^)(NSError * err))failBlock {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = NetworkRequestTimeout;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:paramDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [imgArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
        {
            NSData *imgData = UIImageJPEGRepresentation(obj, 1.0);
            //添加要上传的文件，此处为图片
            [formData appendPartWithFileData:imgData name:[serverImgKeyArr objectAtIndex:idx] fileName:[imgNameArr objectAtIndex:idx] mimeType:@"image/jpeg"];
        }];
    } success:^(AFHTTPRequestOperation * operation, id responseObject) {
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failBlock(error);
    }];
}

+ (void)downloadFileWithoutProgressWithURL:(NSString *)url withFilePath:(NSString *)path withSuccessBlock:(void(^)(NSString *fileName))successBlock withErrorBlock:(void(^)(NSError *err))errBlock {
/*    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    //添加下载请求（获取服务器的输出流）
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    //请求管理判断请求结果
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //请求成功
        NSArray *pathComponents = [path componentsSeparatedByString:@"/"];
        NSLog(@"[pathComponents lastObject]:%@",[pathComponents lastObject]);
        successBlock([pathComponents lastObject]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //请求失败
        NSLog(@"Error: %@",error);
        errBlock(error);
    }];*/
    
    //创建请求（iOS7专用）
    AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    //添加请求接口
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    //发送下载请求
    NSURLSessionDownloadTask *downloadTask = [sessionManager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        //设置存放文件的位置（此Demo把文件保存在iPhone沙盒中的Documents文件夹中。关于如何获取文件路径，请自行搜索相关资料）
//        NSURL *filePath = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
        
//        return [filePath URLByAppendingPathComponent:[response suggestedFilename]];
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        //下载完成
//        NSLog(@"Finish and Download to: %@", filePath);
        NSArray *pathComponents = [path componentsSeparatedByString:@"/"];
//        NSLog(@"[pathComponents lastObject]:%@",[pathComponents lastObject]);
        successBlock([pathComponents lastObject]);
        if (error) {
            NSLog(@"下载 err:%@",error);
            errBlock(error);
        }
    }];
    
    //开始下载
    [downloadTask resume];
}

@end
