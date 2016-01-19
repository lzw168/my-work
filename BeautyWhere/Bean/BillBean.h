//
//  BillBean.h
//  BeautyWhere
//
//  Created by Michael on 15/8/24.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillBean : NSObject

@property (nonatomic, strong)NSString *billGoodsID;
@property (nonatomic, strong)NSString *billPayID;
@property (nonatomic, strong)NSString *billBuyID;
@property (nonatomic, strong)NSString *billUserID;
@property (nonatomic, strong)NSString *billTeamID;//序列号，使用的时候出示，支付完成才有
@property (nonatomic, strong)NSString *billCityID;
@property (nonatomic, strong)NSString *billCardID;
@property (nonatomic, strong)NSString *billID;
@property (nonatomic, strong)NSString *billOrderID;//订单 ID
@property (nonatomic, strong)NSString *billGoodsType;
@property (nonatomic, strong)NSString *billState;// 状态：unpay未支付，cancel支付取消，pay 已支付，done 已使用。
@property (nonatomic, strong)NSString *billTradeNum;
@property (nonatomic, assign)BOOL billAllowRefund;
@property (nonatomic, strong)NSString *billRstate;
@property (nonatomic, strong)NSString *billRereason;
@property (nonatomic, strong)NSString *billRetime;
@property (nonatomic, strong)NSString *billOrderBuyNum;
@property (nonatomic, strong)NSString *billRealName;
@property (nonatomic, strong)NSString *billMobile;
@property (nonatomic, strong)NSString *billAddress;
@property (nonatomic, strong)NSString *billServerTime;
@property (nonatomic, strong)NSString *billOrderTitle;
@property (nonatomic, strong)NSString *billOrderPrice;
@property (nonatomic, strong)NSString *billOrderFee;
@property (nonatomic, strong)NSString *billPaymentType;
@property (nonatomic, strong)NSString *billPaymentTradeNum;
@property (nonatomic, strong)NSString *billPaymentTradeStatus;
@property (nonatomic, strong)NSString *billOrigin;
@property (nonatomic, strong)NSString *billCredit;
@property (nonatomic, strong)NSString *billCard;
@property (nonatomic, strong)NSString *billFare;
@property (nonatomic, strong)NSString *billCondBuy;
@property (nonatomic, strong)NSString *billRemark;
@property (nonatomic, strong)NSString *billCreateTime;
@property (nonatomic, strong)NSString *billPayTime;
@property (nonatomic, strong)NSString *billCommentContent;
@property (nonatomic, assign)BOOL billCommentDisplay;
@property (nonatomic, strong)NSString *billCommentGrade;
@property (nonatomic, strong)NSString *billCommentWantMore;
@property (nonatomic, strong)NSString *billCommentTime;
@property (nonatomic, strong)NSString *billPartnerID;
@property (nonatomic, assign)BOOL billSMSExpress;
@property (nonatomic, assign)BOOL billIsUse;
@property (nonatomic, strong)NSString *billUsingTime;
@property (nonatomic, strong)NSString *billName;//商品用户名
@property (nonatomic, strong)NSString *billCity;
@property (nonatomic, strong)NSString *billCityPlaceRegion;
@property (nonatomic, strong)NSString *billCityPlaceStreet;
@property (nonatomic, strong)NSString *billPrice;
@property (nonatomic, strong)NSString *billNowPrice;
@property (nonatomic, strong)NSString *billFundPrice;
@property (nonatomic, strong)NSString *billImgURLLaxtComponent;
@property (nonatomic, strong)NSString *billIntro;//简介
@property (nonatomic, strong)NSString *billContent;//详细描述
@property (nonatomic, strong)NSString *billUseTime;
@property (nonatomic, strong)NSString *billKeepTime;
@property (nonatomic, strong)NSString *billBeginTime;
@property (nonatomic, strong)NSString *billOverTime;
@property (nonatomic, strong)NSString *billType;
@property (nonatomic, strong)NSString *billSuccessNum;
@property (nonatomic, strong)NSString *billVirtualNum;
@property (nonatomic, strong)NSString *billMaxNum;
@property (nonatomic, strong)NSString *billOnceMax;
@property (nonatomic, strong)NSString *billOnceMin;
@property (nonatomic, strong)NSString *billMultibuy;
@property (nonatomic, strong)NSString *billAllInOne;
@property (nonatomic, strong)NSString *billTotalNum;
@property (nonatomic, strong)NSString *billDisplay;
@property (nonatomic, strong)NSString *billAddTime;
@property (nonatomic, strong)NSString *billStatus;
@property (nonatomic, strong)NSString *billOrder;
@property (nonatomic, strong)NSString *billSellsCount;
@property (nonatomic, strong)NSString *billLongitude;
@property (nonatomic, strong)NSString *billLatitude;
@property (nonatomic, strong)NSString *billScore;
@property (nonatomic, strong)NSString *billLinkID;
@property (nonatomic, assign)BOOL billHotenabled;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
