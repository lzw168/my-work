//
//  LineDetailTableViewController.h
//  BeautyWhere
//
//  Created by Michael on 15/8/21.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsBean.h"
#import "HomePageNetwork.h"

@interface LineDetailTableViewController : UITableViewController<UIWebViewDelegate>

@property (nonatomic, assign)CheckGoodsOnSellsType goodsOnSellsType;

- (void)passInfoBean:(GoodsBean *)infoBean;
- (void)hideBuyBtn;

@end
