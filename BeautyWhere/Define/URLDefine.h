//
//  URLDefine.h
//  BeautyWhere
//
//  Created by Michael on 15-7-21.
//  Copyright (c) 2015年 Michael. All rights reserved.
//
#import "ViewController.h"
#ifndef BeautyWhere_URLDefine_h
#define BeautyWhere_URLDefine_h

#define NetworkRequestTimeout 30
//商用服务器地址：snm.7-mmm.com
//测试服务器地址(外包公司：甲鸟网络)：shnm.vba8.com
//本地测试：192.168.2.1:8080
#pragma mark - Host
#define Server_ImgHost              @"http://snm.7-mmm.com/Uploads/"
#define Server_RequestHost          @"http://snm.7-mmm.com/Home/"

#pragma mark - HomePage
#define Server_ADInfo               @"Advert/index"
#define Server_ProviceList          @"Index/getPro"
#define Server_TuCao                @"Tucao/index"
#define Server_HomeServerStore      @"Partner/shangmen"
#define Server_ShowComment          @"Partner/showComment"
#define Server_WriteComment         @"Partner/comment"
#define Server_GoodsInStore         @"Partner/goods"
#define Server_BussinessArea        @"Partner/getdis"
#define Server_StoreList            @"Partner/selePartner"

#pragma mark - Info
#define Server_InfoList             @"News/index"
#define Server_GetInfo              @"News/showOneNews"
#define Server_CouponInfo           @"Coupon/index"
#define Server_StoreInfo            @"Partner/showPartner"

#pragma mark - User
#define Server_UpdateUserInfo       @"User/updateUser"
#define Server_GetCollectionList    @"User/getCollect"
#define Server_GetCoupon            @"Coupon/getCoupon"
#define Server_ShowMyCoupon         @"User/myCoupon"
#define Server_LoginAndRegister     @"User/testcode"
#define Server_RequestMessageCode   @"User/zhuce"
#define Server_CollectInfo          @"News/collect"
#define Server_CollectStore         @"Partner/collect"
#define Server_GetSingleUserInfo    @"User/getUserMassage"
#define Server_AddScore             @"User/addScore"
#define Server_LoginByThird         @"User/tlogin"

#pragma mark - Buy
#define Server_ShowLimitedEdition   @"Goods/showFlash"
#define Server_BuyLimitedEdition    @"Goods/buyFlash"
#define Server_ShowSeckillList      @"Goods/showSeckill"
#define Server_BuySeckill           @"Goods/buySeckill"
#define Server_ShowShoppingList     @"Goods/showluojia"
#define Server_OrderPay             @"Order/pay"
#define Server_BuyShopping          @"Goods/buyluojia"
#define Server_ShowOrder            @"Order/showOrder"

#pragma mark - More
#define Server_CheckUpGrade         @"Upgrade/getVersion"
#define Server_FeedBack             @"Vote/index"

#define Server_Sub                  @"Partner/sub"
#define Server_NewOrder             @"Order/newOrder"

#endif
