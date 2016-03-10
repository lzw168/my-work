//
//  RankPageNetwork.h
//  BeautyWhere
//
//  Created by lizhiwei on 16/1/20.
//  Copyright © 2016年 Michael. All rights reserved.
//

#ifndef RankPageNetwork_h
#define RankPageNetwork_h

@interface RankPageNetwork : NSObject

+ (void)showRank:(void(^)(NSMutableDictionary *RankDic))successdBlock withErrorBlock:(void(^)(NSError *err))errBlock;

@end

#endif /* RankPageNetwork_h */
