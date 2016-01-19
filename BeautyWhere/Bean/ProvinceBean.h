//
//  ProvinceBean.h
//  BeautyWhere
//
//  Created by Michael on 15/8/3.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProvinceBean : NSObject

@property (nonatomic, strong) NSString *provinceID;
@property (nonatomic, strong) NSString *provinceCode;
@property (nonatomic, strong) NSString *provinceParentID;
@property (nonatomic, strong) NSString *provinceName;
@property (nonatomic, strong) NSString *provinceLevel;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
