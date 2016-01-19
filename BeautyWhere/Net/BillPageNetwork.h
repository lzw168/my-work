//
//  BillPageNetwork.h
//  BeautyWhere
//
//  Created by Michael on 15/8/25.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomePageNetwork.h"

@interface BillPageNetwork : NSObject

+ (void)showOrderWithUserID:(NSString *)userID withType:(CheckGoodsOnSellsType)type withPageNum:(NSString *)currentPage withSucceedBlock:(void(^)(NSMutableArray *orderArr))successdBlock withErrorBlock:(void(^)(NSError *err))errBlock;

@end
