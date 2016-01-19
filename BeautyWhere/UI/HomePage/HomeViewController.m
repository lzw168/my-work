//
//  HomeViewController.m
//  BeautyWhere
//
//  Created by Michael on 15-7-21.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "HomeViewController.h"
#import "UIButton+CustomButton.h"
#import "ADNetwork.h"
#import "ADBean.h"
#import "LocationViewController.h"
#import "InfoTableViewController.h"
#import "LuckyMoneyViewController.h"
#import "LimitTimeToBuyTableViewController.h"
#import "NearbyStoreViewController.h"
#import "HomePageNetwork.h"

static const NSInteger tableHeaderViewHeight = 120;

@interface HomeViewController ()

@property (nonatomic, strong) NSArray *ADInfoArr;
@property (nonatomic, assign) BOOL reloadADWall;
@property (nonatomic, strong) NSFileManager *fm;
@property (nonatomic, strong) NSMutableArray *imgPathArr;
@property (nonatomic, strong) NSString *newestADImgPath;
@property (nonatomic, strong) NSString *ADImgPath;
@property (nonatomic, strong) AdScrollView * adscrollView;
@property (nonatomic, assign) BOOL restartNet;
@property (nonatomic, strong) UIButton *positionBtn;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) NSString *gpsCity;
@property (nonatomic, strong) UIButton *MenuBtn;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fm = [NSFileManager defaultManager];
    self.imgPathArr = [[NSMutableArray alloc] init];
    self.newestADImgPath = [NSTemporaryDirectory() stringByAppendingString:@"NewADImg"];
    self.ADImgPath = [NSTemporaryDirectory() stringByAppendingString:@"ADImg"];
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    NSString *gameuseradd= [accountDefaults objectForKey:@"useraddress"];
    NSLog(@"保存的城市===============%@",gameuseradd);
    if(gameuseradd.length==0)
    {
        gameuseradd = @"广州市";
    }
    self.positionBtn = [UIButton createButtonWithTitle:gameuseradd withImg:[UIImage imageNamed:@"nav-icon-xiala.png"] withButtonHeight:NavHeight(self)];
    self.city = gameuseradd;
    [self getBusinessZoneWithCity:gameuseradd];
    
    [self.positionBtn addTarget:self action:@selector(pressedPosition:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.positionBtn];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//  self.tableView.backgroundColor = [UIColor cyanColor];
    self.tableView.scrollEnabled = NO;
    CGFloat gapH = 0.0;
    if (ScreenHeight > 700)
    {
        gapH = 15.0;
    }
    self.adscrollView = [[AdScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, tableHeaderViewHeight/(568/ScreenHeight)+gapH)];
    self.adscrollView.PageControlShowStyle = UIPageControlShowStyleCenter;
    self.adscrollView.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.adscrollView.imageNameArray = @[@"pic_2loading.png"];
    self.adscrollView.buttonDelegate = self;
    self.tableView.tableHeaderView = self.adscrollView;
    NSError *err = nil;
    if ([self.fm fileExistsAtPath:self.newestADImgPath])
    {
        [self.fm removeItemAtPath:self.newestADImgPath error:&err];
        if (err) {
            NSLog(@"viewDidLoad remove NewADImg dir err:%@",err);
        }
    }
    if ([self.fm fileExistsAtPath:self.ADImgPath])
    {
        NSArray *fileNames = [self.fm contentsOfDirectoryAtPath:self.ADImgPath error:nil];
        __block NSMutableArray *tmpImgPathArr = [[NSMutableArray alloc] init];
        __weak HomeViewController *wself = self;
        [fileNames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
        {
            [tmpImgPathArr addObject:[wself.ADImgPath stringByAppendingPathComponent:obj]];
            if (idx == fileNames.count - 1) {
                [tmpImgPathArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
                 {
                    if (idx == tmpImgPathArr.count - 1)
                    {
                        [wself.imgPathArr insertObject:obj atIndex:0];
                    }
                    else
                    {
                        [wself.imgPathArr addObject:obj];
                    }
                }];
                [wself.tableView beginUpdates];
                wself.tableView.tableHeaderView = wself.adscrollView;
                wself.adscrollView.imageNameArray = wself.imgPathArr;
                NSLog(@"广告的数量======%lu",(unsigned long)wself.imgPathArr.count);
                wself.adscrollView.pageControl.numberOfPages = wself.imgPathArr.count;
                CGRect pageRect = wself.adscrollView.pageControl.frame;
                wself.adscrollView.pageControl.frame = CGRectMake(pageRect.origin.x, pageRect.origin.y, pageRect.size.height*wself.imgPathArr.count, pageRect.size.height);
                wself.adscrollView.pageControl.center = CGPointMake(ScreenWidth/2.0, wself.adscrollView.frame.size.height - 10);
                wself.tableView.bounces = YES;
                [wself.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                [wself.tableView endUpdates];
            }
        }];
    }
    [self startNetwork];
    [self startLocate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideCustomNavTitle:NO];
    if (self.restartNet) {
        self.restartNet = NO;
        [self startNetwork];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startNetwork) object:nil];
    }
    if (self.reloadADWall)
    {
        self.reloadADWall = NO;
        [self.tableView beginUpdates];
        self.tableView.tableHeaderView = self.adscrollView;
        self.adscrollView.pageControl.numberOfPages = self.imgPathArr.count;
        CGRect pageRect = self.adscrollView.pageControl.frame;
        self.adscrollView.pageControl.frame = CGRectMake(pageRect.origin.x, pageRect.origin.y, pageRect.size.height*self.imgPathArr.count, pageRect.size.height);
        self.adscrollView.pageControl.center = CGPointMake(ScreenWidth/2.0, self.adscrollView.frame.size.height - 10);
        self.adscrollView.imageNameArray = self.imgPathArr;
        self.tableView.bounces = YES;
        [self.tableView reloadData];
        [self.tableView endUpdates];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hideCustomNavTitle:YES];
    if (self.navigationController.tabBarController.selectedIndex != 0)
    {
        self.restartNet = YES;
    }
    if ([self.fm fileExistsAtPath:self.newestADImgPath])
    {
        NSError *removeADImgErr = nil;
        if ([self.fm removeItemAtPath:self.ADImgPath error:&removeADImgErr] || (![self.fm fileExistsAtPath:self.ADImgPath]))
        {
            NSError *copyErr = nil;
            if ([self.fm copyItemAtPath:self.newestADImgPath toPath:self.ADImgPath error:&copyErr])
            {
                NSError *removeNewADImgErr = nil;
                [self.fm removeItemAtPath:self.newestADImgPath error:&removeNewADImgErr];
                if (removeNewADImgErr)
                {
                    NSLog(@"removeNewADImgErr:%@",removeNewADImgErr);
                }
                else
                {
                    self.reloadADWall = YES;
                }
            }
            if (copyErr)
            {
                NSLog(@"NewADImg copy to ADImg err:%@",copyErr);
            }
        }
        if (removeADImgErr)
        {
            NSLog(@"remove ADImg Dir err:%@",removeADImgErr);
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Network
- (void)startLocate {
    if (!self.locationManager)
    {
        if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
        {
            [ProgressHUD showText:@"您关闭了的定位功能，将无法收到位置信息，建议您到系统设置打开定位功能!" Interaction:YES Hide:YES];
        }
        else
        {
            //开启定位
            self.locationManager = [[CLLocationManager alloc] init];//创建位置管理器
            self.locationManager.delegate=self;
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
                [self.locationManager requestAlwaysAuthorization];
            }
            self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
            self.locationManager.distanceFilter=1000.0f;
            //启动位置更新
            [self.locationManager startUpdatingLocation];
        }
    }
}

- (void)startNetwork
{
    __weak HomeViewController *wself = self;
    [ADNetwork getADListWithSuccessBlock:^(NSArray *ADArr)
    {
         NSLog(@"更新广告的数量======%lu",(unsigned long)ADArr.count);
        if (![wself.ADInfoArr isEqualToArray:ADArr])
        {
//            NSLog(@"ADArr:%@",ADArr);
            wself.ADInfoArr = ADArr;
            NSError *err = nil;
            __block NSMutableDictionary *downloadFinishedFileNameDic = [[NSMutableDictionary alloc] init];
            if (![wself.fm fileExistsAtPath:wself.ADImgPath]) {
                [wself.fm createDirectoryAtPath:wself.ADImgPath withIntermediateDirectories:YES attributes:nil error:&err];
                if (err) {
                    NSLog(@"ADImg目录创建出错：%@",err);
                }
                [ADArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    ADBean *ad=(ADBean*)obj;
                    NSString *fileName = [NSString stringWithFormat:@"%lu_%@",(unsigned long)idx, [[ad.imgURL componentsSeparatedByString:@"/"] lastObject]];
                    [NetworkEngine downloadFileWithoutProgressWithURL:ad.imgURL withFilePath:[wself.ADImgPath stringByAppendingPathComponent:fileName] withSuccessBlock:^(NSString *fileName)
                     {
                        NSLog(@"fileName:%@",fileName);
                        [downloadFinishedFileNameDic setObject:[wself.ADImgPath stringByAppendingPathComponent:fileName] forKey:[NSString stringWithFormat:@"%lu",(unsigned long)idx]];
                        if (downloadFinishedFileNameDic.count == ADArr.count) {
                            __block NSMutableArray *downloadFinishedFileNameArr = [[NSMutableArray alloc] init];
                            [downloadFinishedFileNameDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
                            {
                                [downloadFinishedFileNameArr addObject:[downloadFinishedFileNameDic objectForKey:key]];
                                if (downloadFinishedFileNameArr.count == downloadFinishedFileNameDic.count) {
                                    [downloadFinishedFileNameArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                        if (idx == downloadFinishedFileNameArr.count - 1) {
                                            [wself.imgPathArr insertObject:obj atIndex:0];
                                        }
                                        else {
                                            [wself.imgPathArr addObject:obj];
                                        }
                                    }];
                                    [wself.tableView beginUpdates];
                                    wself.tableView.tableHeaderView = wself.adscrollView;
                                    wself.adscrollView.pageControl.numberOfPages = wself.imgPathArr.count;
                                    CGRect pageRect = wself.adscrollView.pageControl.frame;
                                    wself.adscrollView.pageControl.frame = CGRectMake(pageRect.origin.x, pageRect.origin.y, pageRect.size.height*wself.imgPathArr.count, pageRect.size.height);
                                    wself.adscrollView.imageNameArray = wself.imgPathArr;
                                    wself.adscrollView.pageControl.center = CGPointMake(ScreenWidth/2.0, wself.adscrollView.frame.size.height - 10);
                                    wself.tableView.bounces = YES;
                                    [wself.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                                    [wself.tableView endUpdates];
                                }
                            }];
                        }
                    } withErrorBlock:^(NSError *err) {
                        NSLog(@"downloadFileWithoutProgressWithURL err:%@",err);
                    }];
                }];
            }
            else {
                if (![wself.fm fileExistsAtPath:wself.newestADImgPath]) {
                    [wself.fm createDirectoryAtPath:wself.newestADImgPath withIntermediateDirectories:YES attributes:nil error:&err];
                    if (err) {
                        NSLog(@"newADImgDirPath目录创建出错：%@",err);
                    }
                }
                [ADArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    ADBean *ad=(ADBean*)obj;
                    NSString *fileName = [NSString stringWithFormat:@"%lu_%@",(unsigned long)idx, [[ad.imgURL componentsSeparatedByString:@"/"] lastObject]];
                    [NetworkEngine downloadFileWithoutProgressWithURL:ad.imgURL withFilePath:[wself.newestADImgPath stringByAppendingPathComponent:fileName] withSuccessBlock:^(NSString *fileName) {
                        NSLog(@"new fileName:%@",fileName);
                    } withErrorBlock:^(NSError *err) {
                        ;
                    }];
                }];
            }
        }
    } withErrorBlock:^(NSError *err) {
        NSLog(@"getADList err:%@",err);
        wself.restartNet = YES;
    }];
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //得到newLocation
    CLLocation *cloc = [locations lastObject];
    // 获取经纬度
    NSLog(@"纬度:%f",cloc.coordinate.latitude);
    NSLog(@"经度:%f",cloc.coordinate.longitude);
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:cloc completionHandler:^(NSArray *placemarks, NSError *error)
    {
        if (!error)
        {
            for (CLPlacemark * placemark in placemarks)
            {
                NSDictionary *test = [placemark addressDictionary];
                NSLog(@"定位：%@",test);
                //  Country(国家)  State(省) City（市） SubLocality(区)
                NSLog(@"城市========%@", [test objectForKey:@"City"]);
                
                self.gpsCity = [test objectForKey:@"City"];
                [[NSUserDefaults standardUserDefaults] setObject: self.gpsCity forKey:@"useraddress"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            
                
                [self updatePositionBtnTitle:[test objectForKey:@"City"]];
                if (self.presentingViewController && [self.presentingViewController isKindOfClass:[LocationViewController class]])
                {
                    [((LocationViewController*)self.presentingViewController) updateLocatedCity:[test objectForKey:@"City"]];
                }
            }
        }
        else
        {
            NSLog(@"定位错误==========%@",error);
        }
        [self.locationManager stopUpdatingLocation];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger gap = row%2==0?1:0;
    NSInteger hGap = 0;
    if (ScreenHeight > 568) {
        hGap = 5;
    }
    CGFloat cellHeight = CellHeight;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentify"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentify"];
        UITapGestureRecognizer *bigTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedListBtn:)];
        UITapGestureRecognizer *small1Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedListBtn:)];
        UITapGestureRecognizer *small2Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedListBtn:)];
        UITapGestureRecognizer *small3Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedListBtn:)];
        UITapGestureRecognizer *small4Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedListBtn:)];
        CGFloat bigHeight = cellHeight-5-1.75*hGap;
        if (ThreePointFiveScreen) {
            bigHeight -= 5;
        }
        UIImageView *big = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, (ScreenWidth-15)/2, bigHeight*3/4-5)];
        big.tag = bigViewTag;
        big.userInteractionEnabled = YES;
        big.layer.cornerRadius = 3;
        [big addGestureRecognizer:bigTap];
        UIImageView *bigBT = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home-btn-bantouming.png"]];//右下角小三角形
        bigBT.frame = CGRectMake(big.frame.size.width-bigBT.frame.size.width, big.frame.size.height-bigBT.frame.size.height, bigBT.frame.size.width, bigBT.frame.size.height);
        bigBT.alpha = 0.5;
        bigBT.tag = big.tag+1000;
        [big addSubview:bigBT];
        UIImageView *bigCenterIcon = [[UIImageView alloc] init];//icon
        bigCenterIcon.tag = bigCenterIconViewTag;
        [big addSubview:bigCenterIcon];
        UILabel *bigCHNLabel = [[UILabel alloc] init];
        bigCHNLabel.tag = bigCHNLabelTag;
        bigCHNLabel.font = [UIFont systemFontOfSize:18];
        bigCHNLabel.textColor = [UIColor whiteColor];
        bigCHNLabel.frame = CGRectMake(10, big.frame.size.height-45, 18, 18);
        UILabel *bigENGLabel = [[UILabel alloc] init];
        bigENGLabel.tag = bigENGLabelTag;
        bigENGLabel.font = [UIFont systemFontOfSize:12];
        bigENGLabel.textColor = [UIColor whiteColor];
        bigENGLabel.frame = CGRectMake(bigCHNLabel.frame.origin.x, bigCHNLabel.frame.origin.y+bigCHNLabel.frame.size.height+5, 12, 12);
        [big addSubview:bigCHNLabel];
        [big addSubview:bigENGLabel];
        CGFloat small1Height = CellHeight/4-5-hGap;
        if (ThreePointFiveScreen)
        {
            small1Height -= 3;
        }
        UIImageView *small1 = [[UIImageView alloc] initWithFrame:CGRectMake(5+gap*(big.frame.size.width+big.frame.origin.x), 5, (ScreenWidth-15)/2, small1Height)];//77.5
        small1.tag = small1ViewTag;
        small1.userInteractionEnabled = YES;
        small1.layer.cornerRadius = 3;
        UIImageView *small1BT = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home-btn-bantouming.png"]];//右下角小三角形
        small1BT.frame = CGRectMake(small1.frame.size.width-small1BT.frame.size.width, small1.frame.size.height-small1BT.frame.size.height, small1BT.frame.size.width, small1BT.frame.size.height);
        small1BT.alpha = 0.5;
        small1BT.tag = small1.tag + 1000;
        [small1 addSubview:small1BT];
        [small1 addGestureRecognizer:small1Tap];
        UIImageView *small1Icon = [[UIImageView alloc] init];//icon
        small1Icon.tag = small1IconViewTag;
        [small1 addSubview:small1Icon];
        UILabel *small1CHNLabel = [[UILabel alloc] init];
        small1CHNLabel.tag = small1CHNLabelTag;
        small1CHNLabel.font = [UIFont systemFontOfSize:18];
        small1CHNLabel.textColor = [UIColor whiteColor];
        UILabel *small1ENGLabel = [[UILabel alloc] init];
        small1ENGLabel.tag = small1ENGLabelTag;
        small1ENGLabel.font = [UIFont systemFontOfSize:12];
        small1ENGLabel.textColor = [UIColor whiteColor];
        [small1 addSubview:small1CHNLabel];
        [small1 addSubview:small1ENGLabel];
        
        UIImageView *small2 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5+bigHeight*3/4, (ScreenWidth-15)/2, small1.frame.size.height)];
        small2.tag = small2ViewTag;
        small2.userInteractionEnabled = YES;
        small2.layer.cornerRadius = 3;
        [small2 addGestureRecognizer:small2Tap];
        UIImage *small2BTImg = [UIImage imageNamed:@"home-btn-bantouming.png"];
        UIImageView *small2BT = [[UIImageView alloc] initWithImage:small2BTImg];//右下角小三角形
        small2BT.frame = CGRectMake(small2.frame.size.width-small2BTImg.size.width, small2.frame.size.height-small2BTImg.size.height, small2BTImg.size.width, small2BTImg.size.height);
        small2BT.alpha = 0.5;
        [small2 addSubview:small2BT];
        UIImageView *small2Icon = [[UIImageView alloc] init];//icon
        small2Icon.tag = small2IconViewTag;
        [small2 addSubview:small2Icon];
        UILabel *small2CHNLabel = [[UILabel alloc] init];
        small2CHNLabel.tag = small2CHNLabelTag;
        small2CHNLabel.font = [UIFont systemFontOfSize:18];
        small2CHNLabel.textColor = [UIColor whiteColor];
        UILabel *small2ENGLabel = [[UILabel alloc] init];
        small2ENGLabel.tag = small2ENGLabelTag;
        small2ENGLabel.font = [UIFont systemFontOfSize:12];
        small2ENGLabel.textColor = [UIColor whiteColor];
        [small2 addSubview:small2CHNLabel];
        [small2 addSubview:small2ENGLabel];
        
        UIImageView *small4 = [[UIImageView alloc] initWithFrame:CGRectMake(5+gap*(big.frame.size.width+big.frame.origin.x), 5+small1.frame.origin.y+small1.frame.size.height, (ScreenWidth-15)/2, small1.frame.size.height)];
        small4.tag = small4ViewTag;
        small4.userInteractionEnabled = YES;
        small4.layer.cornerRadius = 3;
        [small4 addGestureRecognizer:small4Tap];
        UIImage *small4BTImg = [UIImage imageNamed:@"home-btn-bantouming.png"];
        UIImageView *small4BT = [[UIImageView alloc] initWithImage:small2BTImg];//右下角小三角形
        small4BT.frame = CGRectMake(small4.frame.size.width-small4BTImg.size.width, small4.frame.size.height-small4BTImg.size.height, small4BTImg.size.width, small4BTImg.size.height);
        small4BT.alpha = 0.5;
        [small4 addSubview:small4BT];
        UIImageView *small4Icon = [[UIImageView alloc] init];//icon
        small4Icon.tag = small4IconViewTag;
        [small4 addSubview:small4Icon];
        UILabel *small4CHNLabel = [[UILabel alloc] init];
        small4CHNLabel.tag = small4CHNLabelTag;
        small4CHNLabel.font = [UIFont systemFontOfSize:18];
        small4CHNLabel.textColor = [UIColor whiteColor];
        UILabel *small4ENGLabel = [[UILabel alloc] init];
        small4ENGLabel.tag = small4ENGLabelTag;
        small4ENGLabel.font = [UIFont systemFontOfSize:12];
        small4ENGLabel.textColor = [UIColor whiteColor];
        [small4 addSubview:small4CHNLabel];
        [small4 addSubview:small4ENGLabel];
        
        
        UIImageView *small3 = [[UIImageView alloc] initWithFrame:CGRectMake(5+gap*(big.frame.size.width+big.frame.origin.x), 5+small4.frame.origin.y+small4.frame.size.height, (ScreenWidth-15)/2, bigHeight-small1.frame.size.height-small4.frame.size.height-13)];
        small3.tag = small3ViewTag;
        small3.userInteractionEnabled = YES;
        small3.layer.cornerRadius = 3;
        [small3 addGestureRecognizer:small3Tap];
        UIImage *small3BTImg = [UIImage imageNamed:@"home-btn-bantouming.png"];
        UIImageView *small3BT = [[UIImageView alloc] initWithImage:small2BTImg];//右下角小三角形
        small3BT.frame = CGRectMake(small3.frame.size.width-small3BTImg.size.width, small3.frame.size.height-small3BTImg.size.height, small3BTImg.size.width, small3BTImg.size.height);
        small3BT.alpha = 0.5;
        [small3 addSubview:small3BT];
        UIImageView *small3Icon = [[UIImageView alloc] init];//icon
        small3Icon.tag = small3IconViewTag;
        [small3 addSubview:small3Icon];
        UILabel *small3CHNLabel = [[UILabel alloc] init];
        small3CHNLabel.tag = small3CHNLabelTag;
        small3CHNLabel.font = [UIFont systemFontOfSize:18];
        small3CHNLabel.textColor = [UIColor whiteColor];
        UILabel *small3ENGLabel = [[UILabel alloc] init];
        small3ENGLabel.tag = small3ENGLabelTag;
        small3ENGLabel.font = [UIFont systemFontOfSize:12];
        small3ENGLabel.textColor = [UIColor whiteColor];
        [small3 addSubview:small3CHNLabel];
        [small3 addSubview:small3ENGLabel];
        
        
        [cell.contentView addSubview:big];
        [cell.contentView addSubview:small1];
        //[cell.contentView addSubview:small2];
        //[cell.contentView addSubview:small3];
        //[cell.contentView addSubview:small4];
    }
    
    /*UIImageView *big = (UIImageView*)[cell.contentView viewWithTag:bigViewTag];
    UIImageView *bigIconView = (UIImageView*)[big viewWithTag:bigCenterIconViewTag];
    UILabel *bigCHNLabel = (UILabel*)[big viewWithTag:bigCHNLabelTag];
    UILabel *bigENGLabel = (UILabel*)[big viewWithTag:bigENGLabelTag];
    UIImageView *small1 = (UIImageView*)[cell.contentView viewWithTag:small1ViewTag];
    UIImageView *small1IconView = (UIImageView*)[small1 viewWithTag:small1IconViewTag];
    UILabel *small1CHNLabel = (UILabel*)[small1 viewWithTag:small1CHNLabelTag];
    UILabel *small1ENGLabel = (UILabel*)[small1 viewWithTag:small1ENGLabelTag];
    UIImageView *small2 = (UIImageView*)[cell.contentView viewWithTag:small2ViewTag];
    UIImageView *small2IconView = (UIImageView*)[small2 viewWithTag:small2IconViewTag];
    UILabel *small2CHNLabel = (UILabel*)[small2 viewWithTag:small2CHNLabelTag];
    UILabel *small2ENGLabel = (UILabel*)[small2 viewWithTag:small2ENGLabelTag];
    
    UIImageView *small3 = (UIImageView*)[cell.contentView viewWithTag:small3ViewTag];
    UIImageView *small3IconView = (UIImageView*)[small3 viewWithTag:small3IconViewTag];
    UILabel *small3CHNLabel = (UILabel*)[small3 viewWithTag:small3CHNLabelTag];
    UILabel *small3ENGLabel = (UILabel*)[small3 viewWithTag:small3ENGLabelTag];
    
    UIImageView *small4 = (UIImageView*)[cell.contentView viewWithTag:small4ViewTag];
    UIImageView *small4IconView = (UIImageView*)[small4 viewWithTag:small4IconViewTag];
    UILabel *small4CHNLabel = (UILabel*)[small4 viewWithTag:small4CHNLabelTag];
    UILabel *small4ENGLabel = (UILabel*)[small4 viewWithTag:small4ENGLabelTag];
    
    if (row%3==0)
    {
        big.frame = CGRectMake(big.frame.origin.x, big.frame.origin.y, big.frame.size.width, big.frame.size.height+hGap/2);
        big.backgroundColor = [UIColor colorWithRed:254/255.0 green:196/255.0 blue:57/255.0 alpha:1.0];
        UIView *bigBT = [big viewWithTag:big.tag+1000];
        bigBT.frame = CGRectMake(bigBT.frame.origin.x, bigBT.frame.origin.y+hGap/2, bigBT.frame.size.width, bigBT.frame.size.height);
        bigIconView.image = [UIImage imageNamed:@"home-btn-around.png"];
        
        CGFloat bigIconViewCenterY = big.frame.size.height/2;
        if (ThreePointFiveScreen)
        {
            bigIconViewCenterY -= 20;
        }
        bigIconView.frame = CGRectMake(0, 0, bigIconView.image.size.width, bigIconView.image.size.height);
        bigIconView.center = CGPointMake(big.frame.size.width/2, bigIconViewCenterY);
        bigCHNLabel.text = @"附近特惠美容";
        [bigCHNLabel sizeToFit];
        bigENGLabel.text = @"Beauty parlor around";
        [bigENGLabel sizeToFit];
        
        small1.frame = CGRectMake(small1.frame.origin.x, small1.frame.origin.y, small1.frame.size.width, small1.frame.size.height+hGap/2);
        small3.backgroundColor = [UIColor colorWithRed:111/255.0 green:87/255.0 blue:206/255.0 alpha:1.0];
        UIView *small1BT = [small1 viewWithTag:small1.tag+1000];
        small1BT.frame = CGRectMake(small1BT.frame.origin.x, small1BT.frame.origin.y+hGap/2, small1BT.frame.size.width, small1BT.frame.size.height);
        small1IconView.image = [UIImage imageNamed:@"home-btn-hongbao.png"];
        CGFloat gap = 0;
        if (ThreePointFiveScreen)
        {
            gap = 19;
        }
        small1IconView.frame = CGRectMake(small1.frame.size.width-small1IconView.image.size.width-20, 22 - gap, small1IconView.image.size.width, small1IconView.image.size.height);
        small1CHNLabel.text = @"新手红包";
        [small1CHNLabel sizeToFit];
        small1CHNLabel.frame = CGRectMake(small1IconView.frame.origin.x-small1CHNLabel.frame.size.width-20, small1.frame.size.height-40, small1CHNLabel.frame.size.width, small1CHNLabel.frame.size.height);
        small1ENGLabel.text = @"Open the wallet";
        small1ENGLabel.frame = CGRectMake(small1CHNLabel.frame.origin.x, small1CHNLabel.frame.origin.y+small1CHNLabel.frame.size.height, 12, 12);
        [small1ENGLabel sizeToFit];
        
        small2.frame = CGRectMake(small2.frame.origin.x, small2.frame.origin.y+hGap/2, small2.frame.size.width, small2.frame.size.height);
        small2.backgroundColor = [UIColor colorWithRed:200/255.0 green:91/255.0 blue:244/255.0 alpha:1.0];
        small2IconView.image = [UIImage imageNamed:@"home-btn-bbs.png"];
        small2IconView.frame = CGRectMake(20, 30 - gap, small2IconView.image.size.width, small2IconView.image.size.height);
        small2CHNLabel.text = @"爆款专区";
        small2ENGLabel.text = @"Explosion zone";
        small2CHNLabel.frame = CGRectMake(small2IconView.frame.size.width+small2IconView.frame.origin.x+5, small2IconView.frame.origin.y, 18, 18);
        small2ENGLabel.frame = CGRectMake(small2CHNLabel.frame.origin.x, small2CHNLabel.frame.origin.y+small2CHNLabel.frame.size.height+5, 12, 12);
        [small2CHNLabel sizeToFit];
        [small2ENGLabel sizeToFit];
        
        small3.frame = CGRectMake(small3.frame.origin.x, small3.frame.origin.y+hGap/2, small3.frame.size.width, small3.frame.size.height);
        small1.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:58.0/255.0 blue:98.0/255.0 alpha:1.0];
        //UIColor colorWithRed:218/255.0 green:38/255.0 blue:131/255.0 alpha:1.0
        small3IconView.image = [UIImage imageNamed:@"home-btn-daily.png"];
        small3IconView.frame = CGRectMake(small3.frame.size.width-20-1.5*small3IconView.image.size.width, small3.frame.size.height/2-20, 1.5*small3IconView.image.size.width, 1.5*small3IconView.image.size.height);
        small3CHNLabel.text = @"工厂直卖";
        small3ENGLabel.text = @"Set limit to the factory";
        small3CHNLabel.frame = CGRectMake(10, 40-gap+small3.frame.size.height/2, 18, 18);
        small3ENGLabel.frame = CGRectMake(small3CHNLabel.frame.origin.x, small3CHNLabel.frame.origin.y+small3CHNLabel.frame.size.height+5, 12, 12);
        [small3CHNLabel sizeToFit];
        [small3ENGLabel sizeToFit];
        
        //增加每日秒购
        small4.frame = CGRectMake(small4.frame.origin.x, small4.frame.origin.y+hGap/2, small4.frame.size.width, small4.frame.size.height);
        small4.backgroundColor = [UIColor colorWithRed:243/255.0 green:111/255.0 blue:115/255.0 alpha:1.0];
        small4IconView.image = [UIImage imageNamed:@"home-btn-dsp.png"];
        small4IconView.frame = CGRectMake(small4.frame.size.width-small4IconView.image.size.width-20, 22 - gap, small4IconView.image.size.width, small4IconView.image.size.height);
        small4CHNLabel.text = @"每日秒购";
        small4ENGLabel.text = @"Daily second purchase";
        small4CHNLabel.frame = CGRectMake(small4IconView.frame.origin.x-small4CHNLabel.frame.size.width-20, small4.frame.size.height-40, small4CHNLabel.frame.size.width, small4CHNLabel.frame.size.height);
        small4ENGLabel.frame = CGRectMake(small4CHNLabel.frame.origin.x, small4CHNLabel.frame.origin.y+small4CHNLabel.frame.size.height, 12, 12);
        [small4CHNLabel sizeToFit];
        [small4ENGLabel sizeToFit];
    }
    else
    {
        CGFloat gap = 0;
        if (ThreePointFiveScreen)
        {
            gap = 10;
        }
        big.frame = CGRectMake(5+small1.frame.origin.x+small1.frame.size.width, big.frame.origin.y-hGap, big.frame.size.width, big.frame.size.height);
        bigIconView.image = [UIImage imageNamed:@"home-btn-shop.png"];//home-btn-tequanka.png
        bigIconView.frame = CGRectMake(0, 10, bigIconView.image.size.width, bigIconView.image.size.height);
        CGFloat bigIconViewCenterY = big.frame.size.height/2;
        if (ThreePointFiveScreen)
        {
            bigIconViewCenterY -= 20;
        }
        bigIconView.center = CGPointMake(big.frame.size.width/2, bigIconViewCenterY);//bigIconView.center.y
        bigCHNLabel.text = @"裸价代购";//@"美分特权卡";
        [bigCHNLabel sizeToFit];
        bigCHNLabel.frame = CGRectMake(bigCHNLabel.frame.origin.x, bigCHNLabel.frame.origin.y, bigCHNLabel.frame.size.width, bigCHNLabel.frame.size.height);
        bigENGLabel.text = @"Shopping";//@"The powder privilege card";
        bigENGLabel.numberOfLines = 0;
        bigENGLabel.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize bigENGLabelTextSize = [bigENGLabel.text boundingRectWithSize:CGSizeMake(big.frame.size.width-2*bigCHNLabel.frame.origin.x, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        bigENGLabel.frame = CGRectMake(bigCHNLabel.frame.origin.x, bigENGLabel.frame.origin.y, bigENGLabelTextSize.width, bigENGLabelTextSize.height);
        big.backgroundColor = [UIColor colorWithRed:239/255.0 green:140/255.0 blue:132/255.0 alpha:1.0];
        
        small1.frame = CGRectMake(small1.frame.origin.x, small1.frame.origin.y-hGap, small1.frame.size.width, small1.frame.size.height);
        small1.backgroundColor = [UIColor colorWithRed:237/255.0 green:87/255.0 blue:96/255.0 alpha:1.0];
        small1IconView.image = [UIImage imageNamed:@"home-btn-service.png"];
        small1IconView.frame = CGRectMake(20, 25-gap, small1IconView.image.size.width, small1IconView.image.size.height);
        small1CHNLabel.text = @"限时闪购";
        small1CHNLabel.frame = CGRectMake(small1IconView.frame.origin.x+small1IconView.frame.size.width+5, small1IconView.frame.origin.y-gap/2, 18, 18);
        [small1CHNLabel sizeToFit];
        small1ENGLabel.text = @"Flash flash sales";
        CGFloat small1ENGLabelY = small1CHNLabel.frame.origin.y+small1CHNLabel.frame.size.height+5;
        if (ThreePointFiveScreen)
        {
            small1ENGLabelY -= 5;
        }
        small1ENGLabel.frame = CGRectMake(small1CHNLabel.frame.origin.x, small1ENGLabelY, 12, 12);
        [small1ENGLabel sizeToFit];
        
        small2.frame = CGRectMake(small1.frame.origin.x, small2.frame.origin.y-hGap, small2.frame.size.width, small2.frame.size.height);
        small2.backgroundColor = [UIColor colorWithRed:218/255.0 green:38/255.0 blue:131/255.0 alpha:1.0];
        small2IconView.image = [UIImage imageNamed:@"home-btn-daily.png"];
        small2IconView.frame = CGRectMake(small2.frame.size.width-20-small2IconView.image.size.width, 15, small2IconView.image.size.width, small2IconView.image.size.height);
        small2CHNLabel.text = @"工厂直卖";
        small2ENGLabel.text = @"Set limit to the factory";
        small2CHNLabel.frame = CGRectMake(10, 30-gap, 18, 18);
        small2ENGLabel.frame = CGRectMake(small2CHNLabel.frame.origin.x, small2CHNLabel.frame.origin.y+small2CHNLabel.frame.size.height+5, 12, 12);
        [small2CHNLabel sizeToFit];
        [small2ENGLabel sizeToFit];
    }*/
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat result = 0;
    if (ScreenHeight > 568)
    {
        result = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    CGFloat h = 165/(568/ScreenHeight)+result;
    if (ThreePointFiveScreen)
    {
        h -= 10;
    }
    return 2*h;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    __autoreleasing UIView *bg = [[UIView alloc] init];
    bg.backgroundColor = tableView.backgroundColor;
    return bg;
}

#pragma mark - AdScrollViewDelegate
- (void)pressedShowedAD
{
    if (self.adscrollView.pageControl.currentPage == self.adscrollView.pageControl.numberOfPages-1)
    {
        NSLog(@"lucky");
        LuckyMoneyViewController *targetViewController = [[LuckyMoneyViewController alloc] init];
        targetViewController.title = @"猜红包";
        [self hideCustomNavTitle:YES];
        targetViewController.hidesBottomBarWhenPushed = YES;
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
        targetViewController.edgesForExtendedLayout = UIRectEdgeNone;
        [self.navigationController pushViewController:targetViewController animated:YES];
    }
    else
    {
        ADBean *ad = [self.ADInfoArr objectAtIndex:self.adscrollView.pageControl.currentPage];
        NSString *link = ad.buttonLink;
        if (link && ![link isEqualToString:@""])
        {
            if ([link rangeOfString:@"http://"].length == 0)
            {
                link = [NSString stringWithFormat:@"http://%@",link];
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
        }
    }
}

#pragma mark - Button Response
- (void)pressedPosition:(id)sender {
    LocationViewController *l = [[LocationViewController alloc] init];
    l.title = @"选择城市";
    l.locatedCity = self.gpsCity;
    l.controller = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:l];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)pressedListBtn:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded) {
        NSLog(@"tap state:%li view:%@",(long)tap.state, tap.view);
        if (!User || !User.userID || [User.userID isEqualToString:@""]) {
            LoginViewController *login = [[LoginViewController alloc] init];
            login.edgesForExtendedLayout = UIRectEdgeNone;
            login.backItemType = BackItemTypeBackImg;
            login.enterType = EnterTypePush;
            [self.navigationController pushViewController:login animated:NO];
            return;
        }
        UIViewController *targetViewController = nil;
        switch (tap.view.tag) {
            case small2ViewTag:
            {
                UILabel *small2CHNLabel = (UILabel*)[tap.view viewWithTag:small2CHNLabelTag];
                if ([small2CHNLabel.text isEqualToString:@"爆款专区"])
                {
                    /*targetViewController = [[InfoTableViewController alloc] init];
                    targetViewController.title = @"爆款专区";*/
                    targetViewController = [[LimitTimeToBuyTableViewController alloc] initWithPageType:PageTypeShopping];
                    targetViewController.title = @"爆款专区";
                }
                else if ([small2CHNLabel.text isEqualToString:@"工厂直卖"])
                {
                    targetViewController = [[LimitTimeToBuyTableViewController alloc] initWithPageType:PageTypeLimitFactory];
                    targetViewController.title = @"工厂直卖";
                }
            }
                break;
            case small1ViewTag:
            {
                UILabel *small1CHNLabel = (UILabel*)[tap.view viewWithTag:small1CHNLabelTag];
                if ([small1CHNLabel.text isEqualToString:@"新手红包"]) {
                    targetViewController = [[LuckyMoneyViewController alloc] init];
                    targetViewController.title = @"领取红包";
                }
                else if ([small1CHNLabel.text isEqualToString:@"限时闪购"]) {
                    targetViewController = [[LimitTimeToBuyTableViewController alloc] initWithPageType:PageTypeSecKill];
                    targetViewController.title = @"限时闪购";
                }
            }
                break;
            case bigViewTag:
            {
                UILabel *bigCHNLabel = (UILabel*)[tap.view viewWithTag:bigCHNLabelTag];
                if ([bigCHNLabel.text isEqualToString:@"附近特惠美容"])
                {
                    targetViewController = [[NearbyStoreViewController alloc] init];
                    targetViewController.title = @"上哪美";//@"附近特惠";
                    ((NearbyStoreViewController*)targetViewController).locatedCity = self.city;
                    GetAppDelegate.paySource = @"0";
                }
                else if ([bigCHNLabel.text isEqualToString:@"裸价代购"]) {
                    targetViewController = [[LimitTimeToBuyTableViewController alloc] initWithPageType:PageTypeShopping];
                    targetViewController.title = @"裸价代购";
                }
            }
                break;
            case small3ViewTag:
            {
                UILabel *small3CHNLabel = (UILabel*)[tap.view viewWithTag:small3CHNLabelTag];
                if ([small3CHNLabel.text isEqualToString:@"工厂直卖"]) {
                    targetViewController = [[LimitTimeToBuyTableViewController alloc] initWithPageType:PageTypeLimitFactory];
                    targetViewController.title = @"工厂直卖";
                    GetAppDelegate.paySource = @"1";
                }
            }
                break;
            case small4ViewTag:
            {
                UILabel *small4CHNLabel = (UILabel*)[tap.view viewWithTag:small4CHNLabelTag];
                if ([small4CHNLabel.text isEqualToString:@"每日秒购"]) {
                    targetViewController = [[LimitTimeToBuyTableViewController alloc] initWithPageType:PageTypeSecKill];
                    targetViewController.title = @"每日秒购";
                    GetAppDelegate.paySource = @"1";
                }
            }
                break;
        }
        if (targetViewController)
        {
            [self hideCustomNavTitle:YES];
            targetViewController.hidesBottomBarWhenPushed = YES;
            [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
            targetViewController.edgesForExtendedLayout = UIRectEdgeNone;
            [self.navigationController pushViewController:targetViewController animated:YES];
        }
    }
}

#pragma mark - Private & Tool
- (void)updatePositionBtnTitle:(NSString *)position
{
    self.positionBtn = [UIButton createButtonWithTitle:position withImg:[UIImage imageNamed:@"nav-icon-xiala.png"] withButtonHeight:NavHeight(self)];
    [self.positionBtn addTarget:self action:@selector(pressedPosition:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.positionBtn];
    self.city = position;
    [self getBusinessZoneWithCity:position];
}

- (void)getBusinessZoneWithCity:(NSString *)city {
    __weak typeof(self)wself = self;
    [HomePageNetwork getBusinessZoneWithCity:city withSuccessBlock:^(NSArray *storeArr)
    {
        [GetAppDelegate.businessZone addObjectsFromArray:storeArr];
    } withErrorBlock:^(NSError *err)
    {
        NSLog(@"getBusinessZone err:%@",err);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [wself getBusinessZoneWithCity:city];
        });
    }];
}

- (void)hideCustomNavTitle:(BOOL)hide {
    [self.navigationController.view viewWithTag:homeTitleTag].hidden = hide;
}

@end
