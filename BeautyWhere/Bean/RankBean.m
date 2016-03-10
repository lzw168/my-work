//
//  RankBean.m
//  BeautyWhere
//
//  Created by lizhiwei on 16/1/20.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import "RankBean.h"

@implementation RankBean

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.order = [[dic valueNull2NilForKey:@"order"]intValue];
        self.name = [dic valueNull2NilForKey:@"name"];
        self.money = [[dic valueNull2NilForKey:@"money"]intValue];
    }
    return self;
}
@end
