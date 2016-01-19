//
//  NearbyStoreViewController.m
//  BeautyWhere
//
//  Created by Michael on 15/8/17.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "NearbyStoreViewController.h"
#import "HomePageNetwork.h"
#import "NearbyStoreListCell.h"
#import "StoreDetailViewController.h"

@interface NearbyStoreViewController ()

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) NSMutableArray *infosArr;
@property (atomic, copy) LoadDataComplete loadDataFinishedBlock;
@property (atomic, copy) RefreshDataComplete refreshDataFinishedBlock;
@property (nonatomic, strong) CustomTableView *table;
@property (nonatomic, strong) NSString *serviceClass;//int 1美甲2美发3美容4整形
@property (nonatomic, strong) NSString *sortByItem;//star:口碑； renqi：人气；  lowprice:价格；  jisu：技术  distance：距离
@property (nonatomic, strong) NSArray *businessZoneArr;
@property (nonatomic, strong) NSString *chosenDistrict;

@end

@implementation NearbyStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    /*NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *BusinessZone= [accountDefaults objectForKey:@"businessZone"];*/
    
    if (!GetAppDelegate.businessZone || GetAppDelegate.businessZone.count<2)
    {
        [ProgressHUD showText:@"获取附近商家信息失败，请稍后再试" Interaction:YES Hide:YES];
    }
    else
    {
        [ProgressHUD show:@"加载中..." Interaction:YES Hide:NO];
        self.view.backgroundColor = KMainBackgroundColor;
        self.pageNum = 1;
        self.loadDataFinishedBlock = nil;
        self.refreshDataFinishedBlock = nil;
        self.infosArr = [[NSMutableArray alloc] init];
        NSArray *itemsArr = @[GetAppDelegate.businessZone, @[@"全部类型", @"美甲", @"美发", @"美容", @"整形"], @[@"默认排序", @"口碑", @"人气", @"价格", @"技术", @"距离"]];
        MXPullDownMenu *menu = [[MXPullDownMenu alloc] initWithArray:itemsArr selectedColor:[UIColor blackColor]];
        menu.delegate = self;
        menu.frame = CGRectMake(0, 0, ScreenWidth, 44);
        menu.backgroundColor = BottomMenuBackgroundColor;
        [self.view addSubview:menu];
        self.table = [[CustomTableView alloc] initWithFrame:CGRectMake(0, 24, ScreenWidth, self.view.bounds.size.height-self.navigationController.navigationBar.frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height-44)];
        self.table.dataSource = self;
        self.table.delegate = self;
        self.table.hidden = YES;
        self.table.homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.table];
        [self startNetWithNeedReload:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Net
- (void)startNetWithNeedReload:(BOOL)needReload
{
    __weak typeof(self) wself = self;
    [HomePageNetwork getNearbyStoreWithUserID:User.userID withCity:self.locatedCity withDistrict:self.chosenDistrict withLng:GetAppDelegate.lng withLat:GetAppDelegate.lat withPageNum:[NSString stringWithFormat:@"%li",(long)self.pageNum] withGroupID:self.serviceClass withTerm:self.sortByItem withSuccessBlock:^(NSArray *storeArr) {
        __strong RefreshDataComplete refreshCompleteBlock = wself.refreshDataFinishedBlock;
        __strong LoadDataComplete loadMoreCompleteBlock = wself.loadDataFinishedBlock;
        if (wself.pageNum == 1) {
            [wself.infosArr removeAllObjects];
        }
        NSInteger originalCount = wself.infosArr.count;
        [wself.infosArr addObjectsFromArray:storeArr];
        if (wself.infosArr && wself.infosArr.count > 0) {
            [self showNoDataTip:NO];
            if (needReload) {
                [wself.table.homeTableView reloadData];
//                [wself.table reloadTableViewDataSource];
//                [wself.table forceToFreshData];
            }
            if (refreshCompleteBlock) {
                refreshCompleteBlock();
            }
            if (loadMoreCompleteBlock && wself.infosArr.count - originalCount != 0) {
                loadMoreCompleteBlock((int)(wself.infosArr.count - originalCount));
            }
            if (wself.table.hidden) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    wself.table.hidden = NO;
                    [ProgressHUD dismiss];
                });
            }
            else {
                [ProgressHUD dismiss];
            }
        }
        else
        {
            wself.table.hidden = YES;
//          [ProgressHUD showText:@"该城市地区没有商店" Interaction:YES Hide:YES];
//          [ProgressHUD dismiss];
            [self showNoDataTip:YES];
        }
    } withErrorBlock:^(NSError *err)
    {
        NSLog(@"getNearbyStore err:%@",err);
        if (err.code == -1009)
        {
            if (self.table.hidden)
            {
                [wself showNetErrorTip];
            }
            else
            {
                [ProgressHUD showText:@"网络超时，请检查网络稍后重试" Interaction:YES Hide:YES];
            }
        }
        else {
            [ProgressHUD showText:@"获取失败，请检查网络后重试" Interaction:YES Hide:YES];
        }
    }];
}

#pragma mark - MXPullDownMenuDelegate

- (void)PullDownMenu:(MXPullDownMenu *)pullDownMenu didSelectRowAtColumn:(NSInteger)column row:(NSInteger)row
{
    NSLog(@"%d ----%d", column, row);
    if (column==0)
    {
        if (row==0)
        {
            self.chosenDistrict = nil;
        }
        else
        {
            self.chosenDistrict = [GetAppDelegate.businessZone objectAtIndex:row];
        }
    }
    else if (column==1) {
        if (row==0) {
            self.serviceClass = nil;
        }
        else {
            self.serviceClass = [NSString stringWithFormat:@"%li",(long)row];
        }
    }
    else {
        if (row==0) {
            self.sortByItem = nil;
        }
        else {
            NSArray *sortedTermArr = @[@"口碑", @"人气", @"价格", @"技术", @"距离"];
            NSDictionary *sortByItemDic = @{@"口碑":@"star", @"人气":@"renqi", @"价格":@"lowprice", @"技术":@"jisu", @"距离":@"distance"};
            self.sortByItem = [sortByItemDic objectForKey:[sortedTermArr objectAtIndex:(row-1)]];
        }
    }
    [ProgressHUD show:@"加载中..." Interaction:YES Hide:NO];
    [self.table reloadTableViewDataSource];
}

#pragma mark - CustomTableViewDataSource
-(NSInteger)numberOfRowsInTableView:(UITableView *)aTableView InSection:(NSInteger)section FromView:(CustomTableView *)aView
{
    NSLog(@"self.InfosArr.count:%lu",(unsigned long)self.infosArr.count);
    return self.infosArr.count;
}

-(SlideTableViewCell *)cellForRowInTableView:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView
{
    CGSize cellSize = [aTableView rectForRowAtIndexPath:aIndexPath].size;
    static NSString *vCellIdentify = @"sliderCell";
    NearbyStoreListCell *vCell = [aTableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil)
    {
        vCell = [[NearbyStoreListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vCellIdentify withStoreBean:[self.infosArr objectAtIndex:aIndexPath.row] withCellHeight:[aTableView rectForRowAtIndexPath:aIndexPath].size.height];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, cellSize.height-0.5, ScreenWidth, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [vCell.contentView addSubview:line];
    }
    else
    {
        vCell.infoBean = [self.infosArr objectAtIndex:aIndexPath.row];
        [vCell customCell];
    }
    return vCell;
}

#pragma mark - CustomTableViewDelegate
-(float)heightForRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView
{
    return 90;
}

-(void)didSelectedRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView
{
    StoreBean *storedInfo = [self.infosArr objectAtIndex:aIndexPath.row];
    StoreDetailViewController *store = [[StoreDetailViewController alloc] init];
    store.title = storedInfo.storeTitle;
    [store passInfoBean:storedInfo];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    [self.navigationController pushViewController:store animated:YES];
}

-(void)loadData:(void(^)(int aAddedRowCount))complete FromView:(CustomTableView *)aView
{
    self.pageNum++;
    self.refreshDataFinishedBlock = nil;
    self.loadDataFinishedBlock = complete;
    [self startNetWithNeedReload:NO];
}

-(void)refreshData:(void(^)())complete FromView:(CustomTableView *)aView
{
    self.pageNum = 1;
    self.loadDataFinishedBlock = nil;
    self.refreshDataFinishedBlock = complete;
    [self startNetWithNeedReload:NO];
//    [ProgressHUD dismiss];
}

#pragma mark - Button Response
- (void)restartNet:(UIButton *)b
{
    [b removeFromSuperview];
    [self startNetWithNeedReload:YES];
}

#pragma mark - Private & Tool
- (void)showNoDataTip:(BOOL)show
{
    [ProgressHUD dismiss];
    if (show) {
        UILabel *tip = [[UILabel alloc] initWithFrame:self.view.bounds];
        tip.text = @"没有商店";
        tip.textAlignment = NSTextAlignmentCenter;
        tip.center = self.view.center;
        tip.backgroundColor = KMainBackgroundColor;
        [self.view addSubview:tip];
    }
    else {
        [self.view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[UILabel class]] && [((UILabel*)obj).text isEqualToString:@"没有商店"]) {
                [obj removeFromSuperview];
            }
        }];
    }
}

- (void)showNetErrorTip {
    [ProgressHUD dismiss];
    UIButton *btn = [[UIButton alloc] initWithFrame:self.view.bounds];
    [btn setTitle:@"网络好像有点问题，点击屏幕重试吧~" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(restartNet:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

@end