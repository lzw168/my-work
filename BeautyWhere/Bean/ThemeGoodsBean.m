//
//  ThemeGoodsBean.m
//  BeautyWhere
//
//  Created by lizhiwei on 16/1/20.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import "ThemeGoodsBean.h"

@implementation ThemeGoodsBean

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.image = [dic valueNull2NilForKey:@"image"];
        self.action = [dic valueNull2NilForKey:@"action"];
        self.order = [dic valueNull2NilForKey:@"order"];
        self.type = [dic valueNull2NilForKey:@"type"];
    }
    return self;
}
@end
