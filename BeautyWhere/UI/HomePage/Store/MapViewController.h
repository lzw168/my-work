//
//  MapViewController.h
//  BeautyWhere
//
//  Created by Michael on 15/8/20.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>
#import "StoreBean.h"

@interface MapViewController : UIViewController <BMKMapViewDelegate>

@property (nonatomic, strong)StoreBean *store;

@end
