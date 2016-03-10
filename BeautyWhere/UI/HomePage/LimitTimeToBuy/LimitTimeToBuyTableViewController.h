//
//  LimitTimeToBuyTableViewController.h
//  BeautyWhere
//
//  Created by Michael Chan on 15/8/11.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

typedef NS_ENUM(NSInteger, PageType)
{
    PageTypeInStore,
    PageTypeLimitFactory,
    PageTypeShopping,
    PageTypeSecKill
};

#import <UIKit/UIKit.h>
#import "CustomTableView.h"

@interface LimitTimeToBuyTableViewController : UIViewController <CustomTableViewDataSource,CustomTableViewDelegate>

- (instancetype)initWithPageType:(PageType)type;

@end
