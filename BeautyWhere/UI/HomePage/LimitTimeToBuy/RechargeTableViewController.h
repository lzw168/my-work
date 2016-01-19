//
//  RechargeTableViewController.h
//  BeautyWhere
//
//  Created by lizhiwei on 16/1/14.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageNetwork.h"
#import "GoodsBean.h"
#import "QRadioButton.h"

@interface RechargeTableViewController : UITableViewController<QRadioButtonDelegate,UITextFieldDelegate>

@property (nonatomic, assign)CheckGoodsOnSellsType goodsOnSellsType;

- (void)passInfoBean:(GoodsBean *)infoBean;
- (void)hideBuyBtn;

@end