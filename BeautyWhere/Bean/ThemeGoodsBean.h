//
//  ThemeGoodsBean.h
//  BeautyWhere
//
//  Created by lizhiwei on 16/1/20.
//  Copyright © 2016年 Michael. All rights reserved.
//

#ifndef ThemeGoodsBean_h
#define ThemeGoodsBean_h

#import <Foundation/Foundation.h>

@interface ThemeGoodsBean : NSObject

@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *order;

-(instancetype)initWithDic:(NSDictionary *)dic;

@end

#endif /* ThemeGoodsBean_h */
