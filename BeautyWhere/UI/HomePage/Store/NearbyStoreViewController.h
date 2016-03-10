//
//  NearbyStoreViewController.h
//  BeautyWhere
//
//  Created by Michael on 15/8/17.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTableView.h"
#import "MXPullDownMenu.h"

@interface NearbyStoreViewController : UIViewController <CustomTableViewDataSource,CustomTableViewDelegate,MXPullDownMenuDelegate>

@property (nonatomic, strong) NSString *locatedCity;
@property (nonatomic, strong) NSString * StoreType;

@end
