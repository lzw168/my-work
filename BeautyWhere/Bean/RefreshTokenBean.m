//
//  refreshTokenBean.m
//  BeautyWhere
//
//  Created by lizhiwei on 16/1/20.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import "RefreshTokenBean.h"

@implementation RefreshTokenBean

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.uid = [[dic valueNull2NilForKey:@"uid"]intValue];
        self.refresh_token = [dic valueNull2NilForKey:@"refresh_token"];
        self.expire = [[dic valueNull2NilForKey:@"expire"]intValue];
        self.access_token = [dic valueNull2NilForKey:@"access_token"];
    }
    return self;
}
@end
