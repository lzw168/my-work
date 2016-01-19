//
//  LocationViewController.h
//  BeautyWhere
//
//  Created by Michael on 15/8/3.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

@interface LocationViewController : UITableViewController

@property (nonatomic, strong) NSString *locatedCity;
@property (nonatomic, assign) HomeViewController *controller;

- (void)updateLocatedCity:(NSString *)city;

@end
