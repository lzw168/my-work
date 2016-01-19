//
//  ProvinceBean.m
//  BeautyWhere
//
//  Created by Michael on 15/8/3.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "ProvinceBean.h"

@implementation ProvinceBean

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        self.provinceID = [dic valueNull2NilForKey:@"id"];
        self.provinceCode = [dic valueNull2NilForKey:@"code"];
        self.provinceParentID = [dic valueNull2NilForKey:@"parentid"];
        self.provinceName = [dic valueNull2NilForKey:@"name"];
        self.provinceLevel = [dic valueNull2NilForKey:@"level"];
    }
    return self;
}

@end
