//
//  CollectionDetailViewController.h
//  BeautyWhere
//
//  Created by Michael on 15/8/3.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTableView.h"

@interface CollectionDetailViewController : UIViewController <CustomTableViewDataSource,CustomTableViewDelegate>

@property (nonatomic, strong) NSMutableArray *collectedStoreArr;

@end
