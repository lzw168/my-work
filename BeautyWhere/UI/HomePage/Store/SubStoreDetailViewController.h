//
//  StoreDetailViewController.h
//  BeautyWhere
//
//  Created by Michael on 15/8/4.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreBean.h"

@interface SubStoreDetailViewController : UITableViewController

@property (nonatomic, weak) UIViewController *preViewController;

- (void)passInfoBean:(StoreBean *)infoBean;
@end
