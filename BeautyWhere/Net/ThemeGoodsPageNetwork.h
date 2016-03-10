//
//  ThemeGoodsPageNetwork.h
//  BeautyWhere
//
//  Created by lizhiwei on 16/1/20.
//  Copyright © 2016年 Michael. All rights reserved.
//

#ifndef ThemeGoodsPageNetwork_h
#define ThemeGoodsPageNetwork_h

@interface ThemeGoodsPageNetwork : NSObject

+ (void)showThemeGoods:(void(^)(NSMutableDictionary *ThemeGoodsDic))successdBlock withErrorBlock:(void(^)(NSError *err))errBlock;

@end

#endif /* ThemeGoodsPageNetwork_h */
