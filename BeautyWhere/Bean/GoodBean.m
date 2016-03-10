//
//  GoodBean.m
//  BeautyWhere
//
//  Created by Michael on 15/8/12.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "GoodBean.h"

@implementation GoodBean

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.img_thumb = [dic valueNull2NilForKey:@"img_thumb"];
        self.goodIntro = [dic valueNull2NilForKey:@"intro"];
        self.goodName = [dic valueNull2NilForKey:@"name"];
        self.goodsID = [dic valueNull2NilForKey:@"id"];
        self.goodPrice = [dic valueNull2NilForKey:@"goods_price"];
    }
    return self;
}

@end
