//
//  AddressPageNetwork.h
//  BeautyWhere
//
//  Created by lizhiwei on 16/1/20.
//  Copyright © 2016年 Michael. All rights reserved.
//

#ifndef AddressPageNetwork_h
#define AddressPageNetwork_h

@interface AddressPageNetwork : NSObject

+ (void)showAddress:(void(^)(NSMutableDictionary *RankDic))successdBlock withErrorBlock:(void(^)(NSError *err))errBlock;

+ (void)AddAddressWithReceiver:(NSString *)receiver withMobile:(NSString *)mobile withLocation:(NSString *)location withIsDefault:(int)isdefault withRegion:(NSString *)region withSuccessBlock:(void(^)(BOOL finished))successdBlock withErrorBlock:(void(^)(NSError *err))errBlock;

+ (void)EditAddressWithId:(NSString *)receiver withMobile:(NSString *)mobile withLocation:(NSString *)location withIsDefault:(int)isdefault withid:(int)addId withRegion:(NSString *)region withSuccessBlock:(void(^)(BOOL finished))successdBlock withErrorBlock:(void(^)(NSError *err))errBlock;

+ (void)DelAddressWithAddressId:(int)addId withSuccessBlock:(void(^)(BOOL finished))successdBlock withErrorBlock:(void(^)(NSError *err))errBlock;

@end

#endif /* AddressPageNetwork_h */
