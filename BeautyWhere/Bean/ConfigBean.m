//
//  ConfigBean.m
//  BeautyWhere
//
//  Created by lizhiwei on 16/1/20.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import "ConfigBean.h"

@implementation ConfigBean

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.free_shipping_num = [dic valueNull2NilForKey:@"order.fee_shipping_num"];
        self.img_path = [dic valueNull2NilForKey:@"resource.img_path"];
        self.service_tel = [dic valueNull2NilForKey:@"other.service_tel"];
        self.rank_visitor = [dic valueNull2NilForKey:@"ctrl.rank_visitor"];
    }
    return self;
}
@end
