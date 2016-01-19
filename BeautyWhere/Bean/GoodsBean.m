//
//  GoodsBean.m
//  BeautyWhere
//
//  Created by Michael on 15/8/12.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "GoodsBean.h"

@implementation GoodsBean

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.goodsSeckillState = [dic valueNull2NilForKey:@"state"];
        self.goodsVirtualNum = [dic valueNull2NilForKey:@"virtualnum"];
        self.goodsUseTime = [dic valueNull2NilForKey:@"usetime"];
        self.goodsType = [dic valueNull2NilForKey:@"type"];
        self.goodsTotalNum = [dic valueNull2NilForKey:@"totalnum"];
        self.goodsSuccessNum = [dic valueNull2NilForKey:@"successnum"];
        self.goodsStatus = [dic valueNull2NilForKey:@"status"];
        self.goodsSellsCount = [dic valueNull2NilForKey:@"sells_count"];
        self.goodsSecKillPrice = [dic valueNull2NilForKey:@"seckillprice"];
        self.goodsScore = [dic valueNull2NilForKey:@"score"];
        self.goodsPrice = [dic valueNull2NilForKey:@"price"];
        self.goodsPartnerID = [dic valueNull2NilForKey:@"partner_id"];
        self.goodsOverTime = [dic valueNull2NilForKey:@"overtime"];
        self.goodsOrder = [dic valueNull2NilForKey:@"order"];
        self.goodsOnceMin = [dic valueNull2NilForKey:@"oncemin"];
        self.goodsOnceMax = [dic valueNull2NilForKey:@"oncemax"];
        self.goodsNowPrice = [dic valueNull2NilForKey:@"nowprice"];
        self.goodsName = [dic valueNull2NilForKey:@"name"];
        self.goodsMultiBuy = [[dic valueNull2NilForKey:@"multibuy"] boolValue];
        self.goodsMaxNum = [dic valueNull2NilForKey:@"maxnum"];
        self.goodsLongitude = [dic valueNull2NilForKey:@"longitude"];
        self.goodsLinkID = [dic valueNull2NilForKey:@"linkid"];
        self.goodsLatitude = [dic valueNull2NilForKey:@"latitude"];
        self.goodsKeepTime = [dic valueNull2NilForKey:@"keeptime"];
        self.goodsIntro = [dic valueNull2NilForKey:@"intro"];
        self.goodsImgLastComponentURL = [dic valueNull2NilForKey:@"img"];
        self.goodsID = [dic valueNull2NilForKey:@"id"];
        self.goodsHotEnabled = [[dic valueNull2NilForKey:@"hotenabled"] boolValue];
        self.goodsFundPrice = [dic valueNull2NilForKey:@"fundprice"];
        self.goodsDisplay = [dic valueNull2NilForKey:@"display"];
        self.goodsContent = [dic valueNull2NilForKey:@"content"];
        self.goodsCityPlaceStreet = [dic valueNull2NilForKey:@"city_place_street"];
        self.goodsCityPlaceRegion = [dic valueNull2NilForKey:@"city_place_region"];
        self.goodsCity = [dic valueNull2NilForKey:@"city"];
        self.goodsBeginTime = [dic valueNull2NilForKey:@"begintime"];
        self.goodsAllInOne = [[dic valueNull2NilForKey:@"allinone"] boolValue];
        self.goodsAddTime = [dic valueNull2NilForKey:@"addtime"];
        self.goodsLuoJiaPrice = [dic valueNull2NilForKey:@"luojiaprice"];
        self.goodsTitle = [dic valueNull2NilForKey:@"title"];
        self.goodsAddress = [dic valueNull2NilForKey:@"address"];
        self.goodsCanBuy = [[dic valueNull2NilForKey:@"canbuy"] boolValue];
    }
    return self;
}

@end
