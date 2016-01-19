//
//  ADNetwork.h
//  BeautyWhere
//
//  Created by Michael on 15/7/29.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADNetwork : NSObject

+ (void)getADListWithSuccessBlock:(void(^)(NSArray *ADArr))successBlock withErrorBlock:(void(^)(NSError *err))errBlock;

@end
