//
//  ADBean.h
//  BeautyWhere
//
//  Created by Michael on 15/7/29.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADBean : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imgURL;
@property (nonatomic, assign) BOOL isDisplay;
@property (nonatomic, assign) BOOL isDelete;
@property (nonatomic, strong) NSString *buttonLink;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
