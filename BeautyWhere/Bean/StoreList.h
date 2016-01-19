//
//  StoreList.h
//  BeautyWhere
//
//  Created by lizhiwei on 16/1/8.
//  Copyright © 2016年 Michael. All rights reserved.
//

#ifndef StoreList_h
#define StoreList_h

#import <Foundation/Foundation.h>

@interface StoreList : NSObject

@property (nonatomic, strong)NSString *PartnerID;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *location;
@property (nonatomic, strong)NSString *phone;
@property (nonatomic, strong)NSString *distance;
@property (nonatomic, strong)NSString *image;

-(instancetype)initWithDic:(NSDictionary *)dic;

@end

#endif /* StoreList_h */
