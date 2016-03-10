//
//  RankBean.h
//  BeautyWhere
//
//  Created by lizhiwei on 16/1/20.
//  Copyright © 2016年 Michael. All rights reserved.
//

#ifndef RankBean_h
#define RankBean_h

#import <Foundation/Foundation.h>

@interface RankBean : NSObject

@property (nonatomic) int order;
@property (nonatomic, strong)NSString *name;
@property (nonatomic) int money;

-(instancetype)initWithDic:(NSDictionary *)dic;

@end

#endif /* RankBean_h */
