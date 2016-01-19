//
//  HomePageNetwork.h
//  BeautyWhere
//
//  Created by Michael on 15/8/3.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

typedef NS_ENUM(NSInteger, CheckGoodsOnSellsType) {
    CheckGoodsOnSellsTypeSeckill,
    CheckGoodsOnSellsTypeShopping,
    CheckGoodsOnSellsTypeLimitToFactory,
    CheckGoodsOnSellsTypeInStore
};

#import <Foundation/Foundation.h>

@interface HomePageNetwork : NSObject

+ (void)getProvinceListWithSuccessBlock:(void(^)(NSArray *provinceArr))successBlock withErrorBlock:(void(^)(NSError *err))errBlock;

+ (void)getInfoWithPageNum:(NSString *)pageNum withSuccessBlock:(void(^)(NSArray *infoArr))successBlock withErrBlock:(void(^)(NSError *err))errBlock;

+ (void)getCouponInfoWithSuccessBlock:(void(^)(NSDictionary *couponArr))successBlock withErrorBlock:(void(^)(NSError *err))errBlock;

+ (void)getCouponWithUserID:(NSString *)userID withCouponID:(NSString *)couponID withCouponImage:(NSString *)couponImage withCouponPrice:(NSString *)couponPrice withSuccessBlock:(void(^)(NSString *message))successBlock withErrBlock:(void(^)(NSError *err))errBlock;

+ (void)getLimitTimeToBuyListWithStartTime:(NSString *)startTime withLng:(NSString *)lng withLat:(NSString *)lat withCurrentPage:(NSString *)pageNum withSuccessBlock:(void (^)(NSMutableArray *goodsArr))successBlock withErrorBlock:(void(^)(NSError *err))errBlock;

+ (void)getShoppingInfoWithStartTime:(NSString *)startTime withPageNum:(NSString *)pageNum withSuccessBlock:(void (^)(NSMutableArray *goodsArr))successBlock withErrorBlock:(void(^)(NSError *err))errBlock;

+ (void)getLimitFactoryInfoWithStartTime:(NSString *)startTime withPageNum:(NSString *)pageNum withSuccessBlock:(void (^)(NSMutableArray *goodsArr))successBlock withErrorBlock:(void(^)(NSError *err))errBlock;

+ (void)getBusinessZoneWithCity:(NSString *)city withSuccessBlock:(void (^)(NSArray *storeArr))successBlock withErrorBlock:(void(^)(NSError *err))errBlock;

+ (void)getNearbyStoreWithUserID:(NSString *)userID withCity:(NSString *)city withDistrict:(NSString *)district withLng:(NSString *)lng withLat:(NSString *)lat withPageNum:(NSString *)pageNum withGroupID:(NSString *)groupID withTerm:(NSString *)term withSuccessBlock:(void (^)(NSArray *storeArr))successBlock withErrorBlock:(void(^)(NSError *err))errBlock;

+ (void)sendStoreCommentWithUserID:(NSString *)userID withPartnerID:(NSString *)partnerID withStarMark:(NSString *)starMark withJiSuMark:(NSString *)jiSuMark withContent:(NSString *)content withSuccessBlock:(void (^)(BOOL finished))successBlock withErrorBlock:(void(^)(NSError *err))errBlock;

+ (void)getStoreCommentWithPartnerID:(NSString *)partnerID withSuccessBlock:(void (^)(NSArray *commentArr))successBlock withErrorBlock:(void(^)(NSError *err))errBlock;

+ (void)getGoodsInStoreDetailPageWithPartnerID:(NSString *)partnerID withSuccessBlock:(void (^)(NSArray *goodsArr))successBlock withErrorBlock:(void(^)(NSError *err))errBlock;

+ (void)collectStoreWithUserID:(NSString *)userID withPartnerID:(NSString *)partnerID withType:(NSString *)collectOrNot withSuccessBlock:(void (^)(BOOL finished))successBlock withErrorBlock:(void(^)(NSError *err))errBlock;

+ (void)checkGoodsOnSellOrNotWithGoodsID:(NSString *)goodsID withType:(CheckGoodsOnSellsType)type withSuccessBlock:(void (^)(BOOL finished))successBlock withErrorBlock:(void(^)(NSError *err))errBlock;

+ (void)getPingPPChargeWithGoodsID:(NSString *)goodsID withGoodsType:(NSString *)goodsType withUserID:(NSString *)userID withPartnerID:(NSString *)partnerID withAmount:(NSString *)amount withSubject:(NSString *)subject withMobile:(NSString *)mobile withChannel:(NSString *)channel withBody:(NSString *)body withSuccessBlock:(void (^)(NSDictionary *pingPPCharge))successBlock withErrorBlock:(void(^)(NSError *err))errBlock;

+ (void)getStoreListPageWithPartnerID:(NSString *)partnerID withSuccessBlock:(void (^)(NSArray *goodsArr))successBlock withErrorBlock:(void(^)(NSError *err))errBlock;

+(void)GetNewOrder:(NSString *)goodsID withUserId:(NSString *)userID withGoodsType:(NSString *)goodsType withSuccessBlock:(void(^)(NSString *message))successBlock withErrBlock:(void(^)(NSError *err))errBlock;
@end
