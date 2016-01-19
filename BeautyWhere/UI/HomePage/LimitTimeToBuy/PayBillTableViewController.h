//
//  PayBillTableViewController.h
//  BeautyWhere
//
//  Created by Michael on 15/8/22.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageNetwork.h"
#import "GoodsBean.h"

@interface PayBillTableViewController : UITableViewController

- (instancetype)initWithGoods:(GoodsBean *)good withGoodsOnSellsType:(CheckGoodsOnSellsType)type;

@end
