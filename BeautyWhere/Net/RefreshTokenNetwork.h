//
//  RefreshTokenNetwork.h
//  BeautyWhere
//
//  Created by lizhiwei on 16/1/20.
//  Copyright © 2016年 Michael. All rights reserved.
//

#ifndef RefreshTokenNetwork_h
#define RefreshTokenNetwork_h

@interface RefreshTokenNetwork : NSObject

+ (void)GetRefreshToken:(void(^)(NSMutableDictionary *RefreshTokenDic))successdBlock withErrorBlock:(void(^)(NSError *err))errBlock;

@end

#endif /* RefreshTokenNetwork_h */
