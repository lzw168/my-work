//
//  CityBean.h
//  BeautyWhere
//
//  Created by Michael on 15/8/3.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityBean : NSObject

@property (nonatomic, strong) NSString *cityID;
@property (nonatomic, strong) NSString *cityCode;
@property (nonatomic, strong) NSString *cityParentID;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *cityLevel;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
