//
//  BillBean.m
//  BeautyWhere
//
//  Created by Michael on 15/8/24.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "BillBean.h"

@implementation BillBean

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        self.billID = [dic valueNull2NilForKey:@"id"];
        self.billPayID = [dic valueNull2NilForKey:@"pay_id"];
        self.billBuyID = [dic valueNull2NilForKey:@"buy_id"];
        self.billUserID = [dic valueNull2NilForKey:@"user_id"];
        self.billTeamID = [dic valueNull2NilForKey:@"team_id"];
        self.billCityID = [dic valueNull2NilForKey:@"city_id"];
        self.billCardID = [dic valueNull2NilForKey:@"card_id"];
        self.billGoodsID = [dic valueNull2NilForKey:@"goods_id"];
        self.billOrderID = [dic valueNull2NilForKey:@"order_id"];
        self.billGoodsType = [dic valueNull2NilForKey:@"goods_type"];
        self.billState = [dic valueNull2NilForKey:@"state"];
        self.billTradeNum = [dic valueNull2NilForKey:@"trade_no"];
        self.billAllowRefund = [[dic valueNull2NilForKey:@"allowrefund"] boolValue];
        self.billRstate = [dic valueNull2NilForKey:@"rstate"];
        self.billRereason = [dic valueNull2NilForKey:@"rereason"];
        self.billRetime = [dic valueNull2NilForKey:@"retime"];
        self.billOrderBuyNum = [dic valueNull2NilForKey:@"orderbuynum"];
        self.billRealName = [dic valueNull2NilForKey:@"realname"];
        self.billMobile = [dic valueNull2NilForKey:@"mobile"];
        self.billAddress = [dic valueNull2NilForKey:@"address"];
        self.billServerTime = [dic valueNull2NilForKey:@"servertime"];
        self.billOrderTitle = [dic valueNull2NilForKey:@"ordertitle"];
        self.billOrderPrice = [dic valueNull2NilForKey:@"orderprice"];
        self.billOrderFee = [dic valueNull2NilForKey:@"orderfee"];
        self.billPaymentType = [dic valueNull2NilForKey:@"payment_type"];
        self.billPaymentTradeNum = [dic valueNull2NilForKey:@"payment_trade_no"];
        self.billPaymentTradeStatus = [dic valueNull2NilForKey:@"payment_trade_status"];
        self.billOrigin = [dic valueNull2NilForKey:@"origin"];
        self.billCredit = [dic valueNull2NilForKey:@"credit"];
        self.billCard = [dic valueNull2NilForKey:@"card"];
        self.billFare = [dic valueNull2NilForKey:@"fare"];
        self.billCondBuy = [dic valueNull2NilForKey:@"condbuy"];
        self.billRemark = [dic valueNull2NilForKey:@"remark"];
        self.billCreateTime = [dic valueNull2NilForKey:@"create_time"];
        self.billPayTime = [dic valueNull2NilForKey:@"pay_time"];
        self.billCommentContent = [dic valueNull2NilForKey:@"comment_content"];
        self.billCommentDisplay = [[dic valueNull2NilForKey:@"comment_display"] boolValue];
        self.billCommentGrade = [dic valueNull2NilForKey:@"comment_grade"];
        self.billCommentWantMore = [dic valueNull2NilForKey:@"comment_wantmore"];
        self.billCommentTime = [dic valueNull2NilForKey:@"comment_time"];
        self.billPartnerID = [dic valueNull2NilForKey:@"partner_id"];
        self.billSMSExpress = [[dic valueNull2NilForKey:@"sms_express"] boolValue];
        self.billIsUse = [[dic valueNull2NilForKey:@"is_use"] boolValue];
        self.billUsingTime = [dic valueNull2NilForKey:@"using_time"];
        self.billName = [dic valueNull2NilForKey:@"name"];
        self.billCity = [dic valueNull2NilForKey:@"city"];
        self.billCityPlaceRegion = [dic valueNull2NilForKey:@"city_place_region"];
        self.billCityPlaceStreet = [dic valueNull2NilForKey:@"city_place_street"];
        self.billPrice = [dic valueNull2NilForKey:@"price"];
        self.billNowPrice = [dic valueNull2NilForKey:@"nowprice"];
        self.billFundPrice = [dic valueNull2NilForKey:@"fundprice"];
        self.billImgURLLaxtComponent = [dic valueNull2NilForKey:@"img"];
        self.billIntro = [dic valueNull2NilForKey:@"intro"];
        self.billContent = [dic valueNull2NilForKey:@"content"];
        self.billUseTime = [dic valueNull2NilForKey:@"usetime"];
        self.billKeepTime = [dic valueNull2NilForKey:@"keeptime"];
        self.billOverTime = [dic valueNull2NilForKey:@"overtime"];
        self.billType = [dic valueNull2NilForKey:@"type"];
        self.billSuccessNum = [dic valueNull2NilForKey:@"successnum"];
        self.billVirtualNum = [dic valueNull2NilForKey:@"virtualnum"];
        self.billMaxNum = [dic valueNull2NilForKey:@"maxnum"];
        self.billOnceMax = [dic valueNull2NilForKey:@"oncemax"];
        self.billOnceMin = [dic valueNull2NilForKey:@"oncemin"];
        self.billMultibuy = [dic valueNull2NilForKey:@"multibuy"];
        self.billAllInOne = [dic valueNull2NilForKey:@"allinone"];
        self.billTotalNum = [dic valueNull2NilForKey:@"totalnum"];
        self.billDisplay = [dic valueNull2NilForKey:@"display"];
        self.billAddTime = [dic valueNull2NilForKey:@"addtime"];
        self.billStatus = [dic valueNull2NilForKey:@"status"];
        self.billOrder = [dic valueNull2NilForKey:@"order"];
        self.billSellsCount = [dic valueNull2NilForKey:@"sells_count"];
        self.billLongitude = [dic valueNull2NilForKey:@"longitude"];
        self.billLatitude = [dic valueNull2NilForKey:@"latitude"];
        self.billScore = [dic valueNull2NilForKey:@"score"];
        self.billLinkID = [dic valueNull2NilForKey:@"linkid"];
        self.billHotenabled = [[dic valueNull2NilForKey:@"hotenabled"] boolValue];
    }
    return self;
}

@end
