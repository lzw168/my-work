//
//  InfoBean.m
//  BeautyWhere
//
//  Created by Michael on 15/8/6.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "InfoBean.h"

@implementation InfoBean

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.infoCreateTime = [dic valueNull2NilForKey:@"create_time"];
        self.infoDetail = [dic valueNull2NilForKey:@"detail"];
        self.infoID = [dic valueNull2NilForKey:@"id"];
        self.infoImage = [dic valueNull2NilForKey:@"image"];
        self.infoIntro = [dic valueNull2NilForKey:@"intro"];
        self.infoIsCollect = [[dic valueNull2NilForKey:@"is_collect"] boolValue];
        self.infoTitle = [dic valueNull2NilForKey:@"title"];
        self.infoType = [dic valueNull2NilForKey:@"type"];
        self.videoURL = [dic valueNull2NilForKey:@"videourl"];
    }
    return self;
}

@end
