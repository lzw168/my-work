//
//  ADBean.m
//  BeautyWhere
//
//  Created by Michael on 15/7/29.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "ADBean.h"

@implementation ADBean

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.ID = [dic valueNull2NilForKey:@"id"];
        self.title = [dic valueNull2NilForKey:@"title"];
        self.imgURL = [NSString stringWithFormat:@"%@%@",GetAppDelegate.img_path, [dic valueNull2NilForKey:@"image"]];
        self.isDisplay = [[dic valueNull2NilForKey:@"display"] boolValue];
        self.isDelete = [[dic valueNull2NilForKey:@"is_delete"] boolValue];
        self.buttonLink = [dic valueNull2NilForKey:@"link"];
    }
    return self;
}

@end
