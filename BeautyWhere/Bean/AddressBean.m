//
//  AddressBean.m
//  BeautyWhere
//
//  Created by lizhiwei on 16/1/20.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import "AddressBean.h"

@implementation AddressBean

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.addressid = [[dic valueNull2NilForKey:@"id"]intValue];
        self.uid = [[dic valueNull2NilForKey:@"uid"]intValue];
        self.receiver = [dic valueNull2NilForKey:@"receiver"];
        self.mobile = [dic valueNull2NilForKey:@"mobile"];
        self.location = [dic valueNull2NilForKey:@"location"];
        self.is_default = [[dic valueNull2NilForKey:@"is_default"]intValue];
        self.region = [dic valueNull2NilForKey:@"region"];
    }
    return self;
}
@end
