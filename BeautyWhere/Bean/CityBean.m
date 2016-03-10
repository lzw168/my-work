//
//  CityBean.m
//  BeautyWhere
//
//  Created by Michael on 15/8/3.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "CityBean.h"

@implementation CityBean

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.cityID = [dic valueNull2NilForKey:@"id"];
        self.cityCode = [dic valueNull2NilForKey:@"code"];
        self.cityParentID = [dic valueNull2NilForKey:@"parentid"];
        self.cityName = [dic valueNull2NilForKey:@"name"];
        self.cityLevel = [dic valueNull2NilForKey:@"level"];
    }
    return self;
}

@end
