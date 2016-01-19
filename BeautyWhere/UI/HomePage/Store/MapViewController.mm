//
//  MapViewController.m
//  BeautyWhere
//
//  Created by Michael on 15/8/20.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if (!GetAppDelegate.mapManagerIsOK)
    {
        NSLog(@"manager start failed!");
        [ProgressHUD showText:@"地图启动失败，无法显示" Interaction:YES Hide:YES];
    }
    else {
        BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
        mapView.delegate = self;
        [mapView showMapScaleBar];
        self.view = mapView;
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = [self.store.storeLAT floatValue];
        coor.longitude = [self.store.storeLNG floatValue];
//        coor.longitude = [self.store.storeLAT floatValue];
//        coor.latitude = [self.store.storeLNG floatValue];
        annotation.coordinate = coor;
        annotation.title = self.store.storeTitle;
        [mapView addAnnotation:annotation];
        [mapView showAnnotations:@[annotation] animated:YES];
        [mapView selectAnnotation:annotation animated:YES];
        [mapView setCenterCoordinate:coor];
        [mapView setRegion:BMKCoordinateRegionMake(coor, BMKCoordinateSpanMake(0.01, 0.01))];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    BMKMapView* _mapView = (BMKMapView*)self.view;
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    BMKMapView* _mapView = (BMKMapView*)self.view;
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

@end
