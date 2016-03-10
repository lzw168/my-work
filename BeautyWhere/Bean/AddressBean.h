//
//  AddressBean.h
//  BeautyWhere
//
//  Created by lizhiwei on 16/1/20.
//  Copyright © 2016年 Michael. All rights reserved.
//

#ifndef AddressBean_h
#define AddressBean_h

#import <Foundation/Foundation.h>

@interface AddressBean : NSObject

@property (nonatomic) int addressid;
@property (nonatomic, strong)NSString *receiver;
@property (nonatomic) int is_default;
@property (nonatomic, strong)NSString *mobile;
@property (nonatomic, strong)NSString *location;
@property (nonatomic) int uid;
@property (nonatomic, strong)NSString *region;

-(instancetype)initWithDic:(NSDictionary *)dic;

@end

#endif /* RankBean_h */
