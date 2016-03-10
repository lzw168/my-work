//
//  HomeViewController.h
//  BeautyWhere
//
//  Created by Michael on 15-7-21.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AdScrollView.h"

@interface HomeViewController : UITableViewController
<
    CLLocationManagerDelegate,
    AdScrollViewDelegate
>

- (void)updatePositionBtnTitle:(NSString *)position;
- (void)showGoods:(NSString *)GoodId;
- (void)showGoodsWithActivity:(NSString *)ActivityId;
@end
