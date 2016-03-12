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
#import "ThemeGoodsBean.h"
#import "ThemeGoodsPageNetwork.h"
#import "UIImageView+AFNetworking.h"
#import "LineStoreDetailViewController.h"
#import "CityViewController.h"
#import "OrderDetailTableViewController.h"
#import "GoodBean.h"
#import "GoodDetailTableViewController.h"
#import "NSObject+SBJson.h"
#import "LineDetailTableViewController.h"

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
@property (nonatomic, strong) NSMutableArray * imageArr;
@property (nonatomic, strong) NSMutableArray * typeArr;
@property (nonatomic, strong) NSMutableArray * goodidArr;
@property (nonatomic, strong) UIImageView *shopimg1;
@property (nonatomic, strong) UIImageView *shopimg2;
@property (nonatomic, strong) NSString * image1;
@property (nonatomic, strong) NSString * image2;
@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageArr = [[NSMutableArray alloc]init];
    self.goodidArr = [[NSMutableArray alloc] init];
    self.typeArr = [[NSMutableArray alloc]init];
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
    self.tableView.backgroundColor = [UIColor colorWithRed:((float) 224/ 255.0f)
                                                     green:((float) 220/ 255.0f)
                                                      blue:((float) 220 / 255.0f)
                                                     alpha:1.0f];
    //self.tableView.backgroundColor = [UIColor clearColor];
    if (ScreenHeight == 480)
    {
        self.tableView.scrollEnabled = YES;
    }
    else
    {
        self.tableView.scrollEnabled = YES;
    }
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
        if (err)
        {
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
            if (idx == fileNames.count - 1)
            {
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
    [self getThemeGoods];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideCustomNavTitle:NO];
    if (self.restartNet)
    {
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
    NSLog(@"self.newestADImgPath==========%@",self.newestADImgPath);
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
- (void)startLocate
{
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
            wself.ADInfoArr = ADArr;
            NSError *err = nil;
            __block NSMutableDictionary *downloadFinishedFileNameDic = [[NSMutableDictionary alloc] init];
            if (![wself.fm fileExistsAtPath:wself.ADImgPath])
            {
                [wself.fm createDirectoryAtPath:wself.ADImgPath withIntermediateDirectories:YES attributes:nil error:&err];
                if (err)
                {
                    NSLog(@"ADImg目录创建出错：%@",err);
                }
                [ADArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
                 {
                    ADBean *ad=(ADBean*)obj;
                    NSString *fileName = [NSString stringWithFormat:@"%lu_%@",(unsigned long)idx, [[ad.imgURL componentsSeparatedByString:@"/"] lastObject]];
                    [NetworkEngine downloadFileWithoutProgressWithURL:ad.imgURL withFilePath:[wself.ADImgPath stringByAppendingPathComponent:fileName] withSuccessBlock:^(NSString *fileName)
                     {
                        NSLog(@"fileName:%@",fileName);
                        [downloadFinishedFileNameDic setObject:[wself.ADImgPath stringByAppendingPathComponent:fileName] forKey:[NSString stringWithFormat:@"%lu",(unsigned long)idx]];
                        if (downloadFinishedFileNameDic.count == ADArr.count)
                        {
                            __block NSMutableArray *downloadFinishedFileNameArr = [[NSMutableArray alloc] init];
                            [downloadFinishedFileNameDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
                            {
                                [downloadFinishedFileNameArr addObject:[downloadFinishedFileNameDic objectForKey:key]];
                                if (downloadFinishedFileNameArr.count == downloadFinishedFileNameDic.count)
                                {
                                    [downloadFinishedFileNameArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
                                    {
                                        if (idx == downloadFinishedFileNameArr.count - 1)
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
                    } withErrorBlock:^(NSError *err)
                     {
                        NSLog(@"downloadFileWithoutProgressWithURL err:%@",err);
                    }];
                }];
            }
            else
            {
                if (![wself.fm fileExistsAtPath:wself.newestADImgPath])
                {
                    [wself.fm createDirectoryAtPath:wself.newestADImgPath withIntermediateDirectories:YES attributes:nil error:&err];
                    if (err)
                    {
                        NSLog(@"newADImgDirPath目录创建出错：%@",err);
                    }
                }
                [ADArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
                 {
                    ADBean *ad=(ADBean*)obj;
                    NSString *fileName = [NSString stringWithFormat:@"%lu_%@",(unsigned long)idx, [[ad.imgURL componentsSeparatedByString:@"/"] lastObject]];
                    [NetworkEngine downloadFileWithoutProgressWithURL:ad.imgURL withFilePath:[wself.newestADImgPath stringByAppendingPathComponent:fileName] withSuccessBlock:^(NSString *fileName)
                    {
                        NSLog(@"new fileName:%@",fileName);
                        /*[downloadFinishedFileNameDic setObject:[wself.newestADImgPath stringByAppendingPathComponent:fileName] forKey:[NSString stringWithFormat:@"%lu",(unsigned long)idx]];
                        if (downloadFinishedFileNameDic.count == ADArr.count)
                        {
                            __block NSMutableArray *downloadFinishedFileNameArr = [[NSMutableArray alloc] init];
                            [downloadFinishedFileNameDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
                             {
                                 [downloadFinishedFileNameArr addObject:[downloadFinishedFileNameDic objectForKey:key]];
                                 if (downloadFinishedFileNameArr.count == downloadFinishedFileNameDic.count)
                                 {
                                     [downloadFinishedFileNameArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
                                      {
                                         if (idx == downloadFinishedFileNameArr.count - 1)
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
                        }*/
                        
                    } withErrorBlock:^(NSError *err) {
                        ;
                    }];
                }];
            }
        }
    } withErrorBlock:^(NSError *err)
    {
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
                if (self.presentingViewController && [self.presentingViewController isKindOfClass:[CityViewController class]])
                {
                    [((CityViewController*)self.presentingViewController) updateLocatedCity:[test objectForKey:@"City"]];
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
    if ([self.imageArr count]== 0)
    {
        return 3;
    }
    unsigned long count = [self.imageArr count] + 1;
    NSLog(@"count=============%ld",count);
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger hGap = 0;
    CGSize cellSize = [tableView rectForRowAtIndexPath:indexPath].size;
    if (ScreenHeight > 568)
    {
        hGap = 5;
    }
    
    CGFloat cellHeight = CellHeight;
    float highth = 1920/ScreenHeight;
    float width = 1080/ScreenWidth;
    float left = 18/width;
    float linehigh = 10/highth;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentify"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentify"];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, cellSize.height-linehigh, ScreenWidth,linehigh)];
        /*line.backgroundColor = [UIColor colorWithRed:((float) 224/ 255.0f)
                                               green:((float) 220/ 255.0f)
                                                blue:((float) 220 /255.0f)
                                               alpha:1.0f];*/
        line.backgroundColor = [UIColor clearColor];
        
        [cell.contentView addSubview:line];
        
        UITapGestureRecognizer *bigTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedListBtn:)];
        
        UITapGestureRecognizer *bigTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedListBtn:)];
        
        UITapGestureRecognizer *bigTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedListBtn:)];
        
        UITapGestureRecognizer *bigTap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedListBtn:)];
        
        UITapGestureRecognizer *bigTap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedListBtn:)];
        
        CGFloat bigHeight = cellHeight-5-1.75*hGap;
        if (ThreePointFiveScreen)
        {
            bigHeight -= 5;
        }
        
        if (indexPath.row == 0)
        {
            UIImageView *scth = [[UIImageView alloc] initWithFrame:CGRectMake(73*RatioWidth, 56*RatioHeight, 220/width, 220/highth)];
            scth.tag = 101;
            scth.userInteractionEnabled = YES;
            scth.layer.cornerRadius = 0;
            [scth addGestureRecognizer:bigTap1];
            [cell.contentView addSubview:scth];
            
            
            UIImageView *bkzq = [[UIImageView alloc] initWithFrame:CGRectMake(scth.frame.origin.x+scth.frame.size.width+137*RatioWidth, 56*RatioHeight, 220/width, 220/highth)];
            bkzq.tag = 102;
            bkzq.userInteractionEnabled = YES;
            bkzq.layer.cornerRadius = 0;
            [bkzq addGestureRecognizer:bigTap2];
            [cell.contentView addSubview:bkzq];
            
            
            UIImageView *gczm = [[UIImageView alloc] initWithFrame:CGRectMake(73*RatioWidth+2*(220*RatioWidth)+2*137*RatioWidth, 56*RatioHeight, 220/width, 220/highth)];
            gczm.tag = 103;
            gczm.userInteractionEnabled = YES;
            gczm.layer.cornerRadius = 0;
            [gczm addGestureRecognizer:bigTap3];
            [cell.contentView addSubview:gczm];
            
            UIImageView *cztmimg = (UIImageView*)[cell.contentView viewWithTag:103];
            cztmimg.frame = CGRectMake(cztmimg.frame.origin.x, cztmimg.frame.origin.y, cztmimg.frame.size.width, cztmimg.frame.size.height);
            UIImage * image1 = [UIImage imageNamed:@"menu_mall.png"];
            cztmimg.image = image1;
            
            
            UIImageView *bkzqimg = (UIImageView*)[cell.contentView viewWithTag:101];
            bkzqimg.frame = CGRectMake(bkzqimg.frame.origin.x, bkzqimg.frame.origin.y, bkzqimg.frame.size.width, bkzqimg.frame.size.height);
            UIImage * image2 = [UIImage imageNamed:@"menu_special.png"];
            bkzqimg.image = image2;
            
            
            UIImageView *gczmimg = (UIImageView*)[cell.contentView viewWithTag:102];
            gczmimg.frame = CGRectMake(gczmimg.frame.origin.x, gczmimg.frame.origin.y, gczmimg.frame.size.width, gczmimg.frame.size.height);
            UIImage * image3 = [UIImage imageNamed:@"menu_factory.png"];
            gczmimg.image = image3;
        }
        
        if(indexPath.row >= 1)
        {
            UIImageView *shoppic1 = [[UIImageView alloc] initWithFrame:CGRectMake(left, 0, 1044/width, 400/highth+hGap)];
            shoppic1.tag = 103+indexPath.row;
            shoppic1.userInteractionEnabled = YES;
            //shoppic1.layer.cornerRadius = 3;
            [shoppic1 addGestureRecognizer:bigTap4];
            [cell.contentView addSubview:shoppic1];
        }
        
        /*if(indexPath.row == 2)
        {
            UIImageView *shoppic2 = [[UIImageView alloc] initWithFrame:CGRectMake(left, 0, 1004/width, 400/highth+hGap)];
            shoppic2.tag = 105;
            shoppic2.userInteractionEnabled = YES;
            //shoppic1.layer.cornerRadius = 3;
            [shoppic2 addGestureRecognizer:bigTap5];
            [cell.contentView addSubview:shoppic2];
        }*/

    }
    
    
    if(indexPath.row >= 1)
    {
        self.shopimg1 = (UIImageView*)[cell.contentView viewWithTag:103+indexPath.row];
        self.shopimg1.frame = CGRectMake(self.shopimg1.frame.origin.x, self.shopimg1.frame.origin.y, 1044/width, 400/highth+hGap);
        UIImage * image4 = [UIImage imageNamed:@"img_shop01.png"];
        if ([self.imageArr count]>=2)
        {
            self.image1 = [self.imageArr objectAtIndex:indexPath.row-1];
        }
        [self.shopimg1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",GetAppDelegate.img_path,self.image1]] placeholderImage:image4];
    }
    //self.shopimg1.image = image4;
    
    
    /*self.shopimg2 = (UIImageView*)[cell.contentView viewWithTag:105];
    self.shopimg2.frame = CGRectMake(self.shopimg2.frame.origin.x, self.shopimg2.frame.origin.y,1004/width, 400/highth+hGap);
    UIImage * image5 = [UIImage imageNamed:@"img_shop02.png"];
    if ([self.imageArr count]>=2)
    {
        self.image2 = [self.imageArr objectAtIndex:1];
    }
    [self.shopimg2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",GetAppDelegate.img_path,self.image2]] placeholderImage:image5];*/
    //self.shopimg2.image = image5;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        float highth = 1920/ScreenHeight;
        return  320/highth+(10/highth);
    }
    else
    {
        int hGap = 0;
        NSLog(@"ScreenHeight==========%f",ScreenHeight);
        if (ScreenHeight > 568)
        {
            hGap = 5;
        }
        
        float highth = 1920/ScreenHeight;
        return  400/highth+(10/highth)+hGap;
    }
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
        targetViewController.title = @"拆红包";
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
- (void)pressedPosition:(id)sender
{
    LocationViewController *l = [[LocationViewController alloc] init];
    l.title = @"选择省份";
    l.locatedCity = self.gpsCity;
    l.controller = self;
    [self hideCustomNavTitle:YES];
    l.hidesBottomBarWhenPushed = YES;
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    l.edgesForExtendedLayout = UIRectEdgeNone;
    //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:l];
    //[self presentViewController:nav animated:YES completion:nil];
    [self.navigationController pushViewController:l animated:YES];
}

- (void)pressedListBtn:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"tap state:%li view:%@",(long)tap.state, tap.view);
        
        if (!User || !User.userID || [User.userID isEqualToString:@""])
        {
            LoginViewController *login = [[LoginViewController alloc] init];
            login.edgesForExtendedLayout = UIRectEdgeNone;
            login.backItemType = BackItemTypeBackImg;
            login.enterType = EnterTypePush;
            [self.navigationController pushViewController:login animated:NO];
            return;
        }
        
        UIViewController *targetViewController = nil;
        switch (tap.view.tag)
        {
            case 103:
            {
                NearbyStoreViewController *targetViewController = [[NearbyStoreViewController alloc] init];
                targetViewController.title = @"线下特惠";
                targetViewController.StoreType = @"1";
                /*NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
                NSString *gameuseradd= [accountDefaults objectForKey:@"useraddress"];*/
                NSLog(@"self.city==========%@",self.city);
                ((NearbyStoreViewController*)targetViewController).locatedCity = self.city;
                GetAppDelegate.paySource = @"0";
                
                [self hideCustomNavTitle:YES];
                targetViewController.hidesBottomBarWhenPushed = YES;
                [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
                targetViewController.edgesForExtendedLayout = UIRectEdgeNone;
                [self.navigationController pushViewController:targetViewController animated:YES];
                return;
            }
                break;
            case 101:
            {
                targetViewController = [[LimitTimeToBuyTableViewController alloc] initWithPageType:PageTypeShopping];
                targetViewController.title = @"爆款专区";
            }
                break;
            case 102:
            {
                targetViewController = [[LimitTimeToBuyTableViewController alloc] initWithPageType:PageTypeLimitFactory];
                targetViewController.title = @"工厂直卖";
            }
                break;
            case 104:
            {
                /*if ([[self.typeArr objectAtIndex:0] isEqualToString:@"0"])
                {
                    NSString * datastr = [self.goodidArr objectAtIndex:0];
                    NSDictionary * datadic = [datastr JSONValue];
                    NSLog(@"data===========%@",datadic);
                    int good_id = -1;
                    int activity_id = -1;
                    if ([datadic objectForKey:@"activity_id"])
                    {
                        activity_id = [[datadic objectForKey:@"activity_id"]intValue];
                    }
                    
                    if ([datadic objectForKey:@"goods_id"])
                    {
                          good_id = [[datadic objectForKey:@"goods_id"]intValue];
                    }
                    
                    if (activity_id!=-1)
                    {
                        [self showGoodsWithActivity:[NSString stringWithFormat:@"%d",activity_id]];
                    }
                    else
                    {
                        [self showGoods:[NSString stringWithFormat:@"%d",good_id]];
                    }
                }*/
            }
                //break;
            case 105:
            {
                /*if ([[self.typeArr objectAtIndex:1] isEqualToString:@"0"])
                {
                    NSString * datastr = [self.goodidArr objectAtIndex:1];
                    NSDictionary * datadic = [datastr JSONValue];
                    NSLog(@"data===========%@",datadic);
                    int good_id = -1;
                    int activity_id = -1;
                    if ([datadic objectForKey:@"activity_id"])
                    {
                        activity_id = [[datadic objectForKey:@"activity_id"]intValue];
                    }
                    
                    if ([datadic objectForKey:@"goods_id"])
                    {
                        good_id = [[datadic objectForKey:@"goods_id"]intValue];
                    }
                    
                    if (activity_id!=-1)
                    {
                        [self showGoodsWithActivity:[NSString stringWithFormat:@"%d",activity_id]];
                    }
                    else
                    {
                        [self showGoods:[NSString stringWithFormat:@"%d",good_id]];
                    }
                }*/
            }
                //break;
            default:
            {
                if ([[self.typeArr objectAtIndex:tap.view.tag-104] isEqualToString:@"0"])
                {
                    NSString * datastr = [self.goodidArr objectAtIndex:tap.view.tag-104];
                    NSDictionary * datadic = [datastr JSONValue];
                    NSLog(@"data===========%@",datadic);
                    int good_id = -1;
                    int activity_id = -1;
                    int area_type = 0;
                    
                    if ([datadic objectForKey:@"area_type"])
                    {
                        area_type = [[datadic objectForKey:@"area_type"]intValue];
                    }
                    if ([datadic objectForKey:@"activity_id"])
                    {
                        activity_id = [[datadic objectForKey:@"activity_id"]intValue];
                    }
                    
                    if ([datadic objectForKey:@"goods_id"])
                    {
                        good_id = [[datadic objectForKey:@"goods_id"]intValue];
                    }
                    
                    if (area_type == 0)
                    {
                        if (activity_id!=-1)
                        {
                            [self showGoodsWithActivity:[NSString stringWithFormat:@"%d",activity_id]];
                        }
                        else
                        {
                            [self showGoods:[NSString stringWithFormat:@"%d",good_id]];
                        }
                    }
                    else if(area_type == 1)
                    {
                        targetViewController = [[LimitTimeToBuyTableViewController alloc] initWithPageType:PageTypeShopping];
                        targetViewController.title = @"爆款专区";
                        
                    }
                    else if(area_type == 2)
                    {
                        targetViewController = [[LimitTimeToBuyTableViewController alloc] initWithPageType:PageTypeLimitFactory];
                        targetViewController.title = @"工厂直卖";
                    }
                    else if(area_type == 3)
                    {
                        NearbyStoreViewController *targetViewController = [[NearbyStoreViewController alloc] init];
                        targetViewController.title = @"线下特惠";
                        targetViewController.StoreType = @"1";
                        NSLog(@"self.city==========%@",self.city);
                        ((NearbyStoreViewController*)targetViewController).locatedCity = self.city;
                        GetAppDelegate.paySource = @"0";
                        
                        [self hideCustomNavTitle:YES];
                        targetViewController.hidesBottomBarWhenPushed = YES;
                        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
                        targetViewController.edgesForExtendedLayout = UIRectEdgeNone;
                        [self.navigationController pushViewController:targetViewController animated:YES];
                        return;
                    }
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

- (void)getBusinessZoneWithCity:(NSString *)city
{
    __weak typeof(self)wself = self;
    [HomePageNetwork getBusinessZoneWithCity:city withSuccessBlock:^(NSArray *storeArr)
    {
        [GetAppDelegate.businessZone removeAllObjects];
        NSArray *businesszoneTermArr = @[@"全部区域"];
        [GetAppDelegate.businessZone addObjectsFromArray:businesszoneTermArr];
        [GetAppDelegate.businessZone addObjectsFromArray:storeArr];
    } withErrorBlock:^(NSError *err)
    {
        NSLog(@"getBusinessZone err:%@",err);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [wself getBusinessZoneWithCity:city];
        });
    }];
}

- (void)hideCustomNavTitle:(BOOL)hide
{
    [self.navigationController.view viewWithTag:homeTitleTag].hidden = hide;
}

-(void)getThemeGoods
{
    [self.imageArr removeAllObjects];
    __weak typeof(self) wself = self;
    [ThemeGoodsPageNetwork showThemeGoods:^(NSMutableDictionary *ThemeGoodsDic)
     {
         [ProgressHUD dismiss];
         if (ThemeGoodsDic == nil || ThemeGoodsDic == NULL)
         {
             return;
         }
         
         ThemeGoodsBean *themgoods = [[ThemeGoodsBean alloc] initWithDic:ThemeGoodsDic];
         [self.imageArr addObject:themgoods.image];
         [self.goodidArr addObject:themgoods.action];
         [self.typeArr addObject:themgoods.type];
         NSLog(@"image===============%@",themgoods.action);
         [wself.tableView reloadData];
     } withErrorBlock:^(NSError *err)
     {
         [ProgressHUD showText:@"获取失败，请检查网络后稍后再试" Interaction:YES Hide:YES];
     }];
}

-(void)showGoods:(NSString *)GoodId
{
    __weak typeof(self) wself = self;
    [HomePageNetwork showGoodsWithSuccessBlock:GoodId withSuccessBlock:^(NSMutableDictionary *GoodsDic)
     {
         [ProgressHUD dismiss];
         
         if (GoodsDic == nil || GoodsDic == NULL)
         {
             return;
         }
         
         GoodsBean *goods = [[GoodsBean alloc] initWithDic:GoodsDic];
         NSLog(@"goodName===========%@",goods.goodsIntro);
         LineDetailTableViewController *store = [[LineDetailTableViewController alloc] init];
         [store passInfoBean:goods];
         store.goodsOnSellsType = CheckGoodsOnSellsTypeInStore;
         store.edgesForExtendedLayout = UIRectEdgeNone;
         [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
         [self.navigationController pushViewController:store animated:YES];
         //self.cityListFromServer = cityArr;
         [wself.tableView reloadData];
     } withErrorBlock:^(NSError *err)
     {
         [ProgressHUD showText:@"获取失败，请检查网络后稍后再试" Interaction:YES Hide:YES];
     }];
}

- (void)showGoodsWithActivity:(NSString *)ActivityId
{
    __weak typeof(self) wself = self;
    [HomePageNetwork showGoodsWithActivity:ActivityId withSuccessBlock:^(NSMutableDictionary *GoodsDic)
     {
         [ProgressHUD dismiss];
         
         if (GoodsDic == nil || GoodsDic == NULL)
         {
             return;
         }
         
         GoodsBean *good = [[GoodsBean alloc] initWithDic:GoodsDic];
         NSLog(@"goodName===========%@",good.goodsIntro);
         GoodDetailTableViewController *store = [[GoodDetailTableViewController alloc] init];
         store.goodsOnSellsType = 2;
         store.siglegoods = good;
         store.activity_id = ActivityId;
         store.edgesForExtendedLayout = UIRectEdgeNone;
         [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
         [self.navigationController pushViewController:store animated:YES];
         //self.cityListFromServer = cityArr;
         [wself.tableView reloadData];
     } withErrorBlock:^(NSError *err)
     {
         [ProgressHUD showText:@"获取失败，请检查网络后稍后再试" Interaction:YES Hide:YES];
     }];
}

@end
