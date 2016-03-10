//
//  refreshTokenBean.h
//  BeautyWhere
//
//  Created by lizhiwei on 16/1/20.
//  Copyright © 2016年 Michael. All rights reserved.
//

#ifndef refreshTokenBean_h
#define refreshTokenBean_h

#import <Foundation/Foundation.h>

@interface RefreshTokenBean : NSObject

@property (nonatomic) int uid;
@property (nonatomic, strong)NSString *refresh_token;
@property (nonatomic, strong)NSString *access_token;
@property (nonatomic) int expire;
-(instancetype)initWithDic:(NSDictionary *)dic;

@end

#endif /* RankBean_h */
