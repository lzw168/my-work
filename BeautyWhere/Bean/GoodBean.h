//
//  GoodBean.h
//  BeautyWhere
//
//  Created by Michael on 15/8/12.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodBean : NSObject

@property (nonatomic, strong) NSString *goodName;
@property (nonatomic, strong) NSString *goodsID;//仅作识别用
@property (nonatomic, strong) NSString *goodPrice;
@property (nonatomic, strong) NSString *img_thumb;
@property (nonatomic, strong) NSString *goodIntro;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
