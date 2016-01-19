//
//  StoreList.m
//  BeautyWhere
//
//  Created by lizhiwei on 16/1/8.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import "StoreList.h"

@implementation StoreList

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.PartnerID = [dic valueNull2NilForKey:@"id"];
        self.title = [dic valueNull2NilForKey:@"title"];
        self.phone = [dic valueNull2NilForKey:@"phone"];
        self.location = [dic valueNull2NilForKey:@"location"];
        self.image = [dic valueNull2NilForKey:@"image"];
    }
    return self;
}
@end
