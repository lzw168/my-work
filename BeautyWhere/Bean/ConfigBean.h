//
//  ConfigBean.h
//  BeautyWhere
//
//  Created by lizhiwei on 16/1/20.
//  Copyright © 2016年 Michael. All rights reserved.
//

#ifndef ConfigBean_h
#define ConfigBean_h

#import <Foundation/Foundation.h>

@interface ConfigBean : NSObject

@property (nonatomic, strong)NSString *free_shipping_num;
@property (nonatomic, strong)NSString *img_path;
@property (nonatomic, strong)NSString *service_tel;
@property (nonatomic, strong)NSString *rank_visitor;

-(instancetype)initWithDic:(NSDictionary *)dic;

@end

#endif /* ConfigBean_h */
