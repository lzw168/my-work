//
//  NSDictionary+NSDictionaryTool.m
//  BeautyWhere
//
//  Created by Michael on 15/7/23.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "NSDictionary+NSDictionaryTool.h"

@implementation NSDictionary (NSDictionaryTool)

- (id)valueNull2NilForKey:(NSString *)key
{
    if ([[self allKeys] containsObject:key])
    {
        id value = [self objectForKey:key];
        return ([value isKindOfClass:[NSNull class]] || value == NULL) ? nil : value;
    }
    else
    {
        return nil;
    }
}

@end
