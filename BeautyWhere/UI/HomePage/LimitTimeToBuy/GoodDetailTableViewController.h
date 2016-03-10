//
//  GoodDetailTableViewController.h
//  BeautyWhere
//
//  Created by Michael on 15/8/21.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodBean.h"
#import "HomePageNetwork.h"
#import "CustomTableView.h"
#import "GoodsBean.h"

@interface GoodDetailTableViewController : UITableViewController<UITableViewDelegate,UIWebViewDelegate>

@property (nonatomic, assign)CheckGoodsOnSellsType goodsOnSellsType;
@property (nonatomic, strong) GoodBean *goods;
@property (nonatomic, strong) GoodsBean *siglegoods;
@property (nonatomic, strong) NSString * activity_id;
- (void)passInfoBean:(GoodsBean *)infoBean;
- (void)hideBuyBtn;

@end
