//
//  GoodsBean.h
//  BeautyWhere
//
//  Created by Michael on 15/8/12.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsBean : NSObject

@property (nonatomic, strong) NSString *goodsSeckillState;//三个状态，early时间未到，late 超过时间，now 可以购买
@property (nonatomic, strong) NSString *goodsID;//仅作识别用
@property (nonatomic, strong) NSString *actID;
@property (nonatomic, strong) NSString *goodsName;//商品名
@property (nonatomic, strong) NSString *goodsPartnerID;//商店 ID
@property (nonatomic, strong) NSString *goodsCity;
@property (nonatomic, strong) NSString *goodsCityPlaceRegion;
@property (nonatomic, strong) NSString *goodsCityPlaceStreet;
@property (nonatomic, strong) NSString *goodsPrice;
@property (nonatomic, strong) NSString *goodsNowPrice;
@property (nonatomic, strong) NSString *goodsFundPrice;
@property (nonatomic, strong) NSString *goodsImgLastComponentURL;
@property (nonatomic, strong) NSString *goodsIntro;//简介
@property (nonatomic, strong) NSString *goodsContent;//详情
@property (nonatomic, strong) NSString *goodsUseTime;
@property (nonatomic, strong) NSString *goodsKeepTime;
@property (nonatomic, strong) NSString *goodsBeginTime;
@property (nonatomic, strong) NSString *goodsOverTime;
@property (nonatomic, strong) NSString *goodsType;
@property (nonatomic, strong) NSString *goodsSuccessNum;
@property (nonatomic, strong) NSString *goodsVirtualNum;
@property (nonatomic, strong) NSString *goodsMaxNum;
@property (nonatomic, strong) NSString *goodsOnceMax;//一次最多能买多少
@property (nonatomic, strong) NSString *goodsOnceMin;//最少买多少
@property (nonatomic, assign) BOOL goodsMultiBuy;
@property (nonatomic, assign) BOOL goodsAllInOne;
@property (nonatomic, strong) NSString *goodsTotalNum;//库存
@property (nonatomic, strong) NSString *goodsDisplay;//这商品在商店中是否显示
@property (nonatomic, strong) NSString *goodsAddTime;
@property (nonatomic, strong) NSString *goodsStatus;
@property (nonatomic, strong) NSString *goodsOrder;
@property (nonatomic, strong) NSString *goodsSellsCount;
@property (nonatomic, strong) NSString *goodsLongitude;
@property (nonatomic, strong) NSString *goodsLatitude;
@property (nonatomic, strong) NSString *goodsScore;
@property (nonatomic, strong) NSString *goodsLinkID;
@property (nonatomic, assign) BOOL goodsHotEnabled;
@property (nonatomic, strong) NSString *goodsSecKillPrice;
@property (nonatomic, strong) NSString *goodsLuoJiaPrice;
@property (nonatomic, strong) NSString *goodsTitle;
@property (nonatomic, assign) BOOL goodsCanBuy;
@property (nonatomic, strong) NSString *goodsAddress;
@property (nonatomic, strong) NSString *activity_price;
@property (nonatomic, strong) NSString *img_thumb;
@property (nonatomic, strong) NSString *goods_price;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *good_id;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
