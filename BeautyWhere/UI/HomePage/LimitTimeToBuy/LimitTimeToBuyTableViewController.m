//
//  LimitTimeToBuyTableViewController.m
//  BeautyWhere
//
//  Created by Michael Chan on 15/8/11.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "LimitTimeToBuyTableViewController.h"
#import "LimitTimeToBuyTableViewCell.h"
#import "HomePageNetwork.h"
#import "OrderDetailTableViewController.h"

@interface LimitTimeToBuyTableViewController ()

@property (nonatomic, assign) PageType pageType;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) NSMutableArray *InfosArr;
@property (atomic, copy) LoadDataComplete loadDataFinishedBlock;
@property (atomic, copy) RefreshDataComplete refreshDataFinishedBlock;
@property (nonatomic, strong) CustomTableView *table;
@property (nonatomic, assign) BOOL hasShowSeckillListNetErr;
@property (nonatomic, strong) GoodsBean *infoBean;
@property (nonatomic, strong) UIImageView *imageview;
@property (nonatomic, strong) UILabel *tip;

@end

@implementation LimitTimeToBuyTableViewController

- (instancetype)initWithPageType:(PageType)type {
    if (self = [super init]) {
        self.pageType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [ProgressHUD show:@"加载中..." Interaction:YES Hide:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    self.pageNum = 1;
    self.loadDataFinishedBlock = nil;
    self.refreshDataFinishedBlock = nil;
    self.InfosArr = [[NSMutableArray alloc] init];
    self.table = [[CustomTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.bounds.size.height-self.navigationController.navigationBar.frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height)];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.hidden = YES;
    self.table.homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.table];
    [self startNetWithNeedReload:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.table.homeTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [ProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Net
- (void)startNetWithNeedReload:(BOOL)needReload {
    switch (self.pageType) {
        case PageTypeSecKill:
            [self seckillNetworkRequestWithNeedReload:needReload];
            break;
        case PageTypeShopping:
            [self shoppingNetworkRequestWithNeedReload:needReload];
            break;
        case PageTypeLimitFactory:
            [self limitFactoryNetworkRequestWithNeedReload:needReload];
            break;
        default:
            NSLog(@"%li 没有该页面类型",(long)self.pageType);
            break;
    }
}

- (void)limitFactoryNetworkRequestWithNeedReload:(BOOL)needReload {
    __weak typeof(self) wself = self;
    [HomePageNetwork getLimitFactoryInfoWithStartTime:@"10" withPageNum:[NSString stringWithFormat:@"%li",(long)wself.pageNum] withSuccessBlock:^(NSMutableArray *goodsArr) {
        __strong RefreshDataComplete refreshCompleteBlock = wself.refreshDataFinishedBlock;
        __strong LoadDataComplete loadMoreCompleteBlock = wself.loadDataFinishedBlock;
        if (wself.pageNum == 1) {
            [wself.InfosArr removeAllObjects];
        }
        NSInteger originalCount = wself.InfosArr.count;
        [wself.InfosArr addObjectsFromArray:goodsArr];
        if (wself.InfosArr && wself.InfosArr.count > 0) {
            if (needReload) {
//                [wself.table reloadTableViewDataSource];
                [wself.table.homeTableView reloadData];
            }
            if (refreshCompleteBlock) {
                refreshCompleteBlock();
            }
            if (loadMoreCompleteBlock && wself.InfosArr.count - originalCount != 0) {
                loadMoreCompleteBlock((int)(wself.InfosArr.count - originalCount));
            }
            if (wself.table.hidden) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [wself showNoDataTip:NO];
                    wself.table.hidden = NO;
                    [ProgressHUD dismiss];
                });
            }
        }
        else {
            [ProgressHUD dismiss];
            [wself showNoDataTip:YES];
            wself.table.hidden = YES;
        }
    } withErrorBlock:^(NSError *err) {
        NSLog(@"limitFactory err:%@",err);
        if (err.code == -1009) {
            [wself showNetErrorTip];
        }
        else {
            [ProgressHUD showText:@"获取失败，请检查网络后重试" Interaction:YES Hide:YES];
        }
    }];
}

- (void)shoppingNetworkRequestWithNeedReload:(BOOL)needReload {
    __weak typeof(self) wself = self;
    [HomePageNetwork getShoppingInfoWithStartTime:@"10" withPageNum:[NSString stringWithFormat:@"%li",(long)wself.pageNum] withSuccessBlock:^(NSMutableArray *goodsArr)
     {
        __strong RefreshDataComplete refreshCompleteBlock = wself.refreshDataFinishedBlock;
        __strong LoadDataComplete loadMoreCompleteBlock = wself.loadDataFinishedBlock;
        if (wself.pageNum == 1) {
            [wself.InfosArr removeAllObjects];
        }
        NSInteger originalCount = wself.InfosArr.count;
        [wself.InfosArr addObjectsFromArray:goodsArr];
        if (wself.InfosArr && wself.InfosArr.count > 0) {
            if (needReload) {
//                [wself.table reloadTableViewDataSource];
                [wself.table.homeTableView reloadData];
            }
            if (refreshCompleteBlock) {
                refreshCompleteBlock();
            }
            if (loadMoreCompleteBlock && wself.InfosArr.count - originalCount != 0)
            {
                loadMoreCompleteBlock((int)(wself.InfosArr.count - originalCount));
            }
            if (wself.table.hidden)
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [ProgressHUD dismiss];
                    [wself showNoDataTip:NO];
                    wself.table.hidden = NO;
                });
            }
        }
        else {
            [ProgressHUD dismiss];
            [wself showNoDataTip:YES];
            wself.table.hidden = YES;
        }
    } withErrorBlock:^(NSError *err) {
        NSLog(@"getShoppingInfo err:%@",err);
        if (err.code == -1009) {
            [wself showNetErrorTip];
        }
        else {
            [ProgressHUD showText:@"获取失败，请检查网络后重试" Interaction:YES Hide:YES];
        }
    }];
}

- (void)seckillNetworkRequestWithNeedReload:(BOOL)needReload {
    [GetAppDelegate startLocate];
    __weak typeof(self) wself = self;
    GetAppDelegate.locateBlock = ^(NSString *lng, NSString *lat) {
        [HomePageNetwork getLimitTimeToBuyListWithStartTime:@"10" withLng:lng withLat:lat withCurrentPage:[NSString stringWithFormat:@"%li",(long)wself.pageNum] withSuccessBlock:^(NSMutableArray *goodsArr) {
            __strong RefreshDataComplete refreshCompleteBlock = wself.refreshDataFinishedBlock;
            __strong LoadDataComplete loadMoreCompleteBlock = wself.loadDataFinishedBlock;
            if (wself.pageNum == 1) {
                [wself.InfosArr removeAllObjects];
            }
            NSLog(@"goodsArr===========%@,%@",lng,lat);
            NSInteger originalCount = wself.InfosArr.count;
            [wself.InfosArr addObjectsFromArray:goodsArr];
            if (wself.InfosArr && wself.InfosArr.count > 0) {
                if (needReload) {
//                    [wself.table reloadTableViewDataSource];
                    [wself.table.homeTableView reloadData];
                }
                if (refreshCompleteBlock) {
                    refreshCompleteBlock();
                }
                if (loadMoreCompleteBlock && wself.InfosArr.count - originalCount != 0) {
                    loadMoreCompleteBlock((int)(wself.InfosArr.count - originalCount));
                }
                if (wself.table.hidden) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                    {
                        [wself showNoDataTip:NO];
                        wself.table.hidden = NO;
                        [ProgressHUD dismiss];
                    });
                }
            }
            else
            {
                [ProgressHUD dismiss];
                [wself showNoDataTip:YES];
                wself.table.hidden = YES;
            }
        } withErrorBlock:^(NSError *err) {
            NSLog(@"seckillNetwork err:%@",err);
            if (wself.InfosArr.count == 0 && !self.hasShowSeckillListNetErr) {
                self.hasShowSeckillListNetErr = YES;
                if (err.code == -1009) {
                    [wself showNetErrorTip];
                }
                else {
                    [ProgressHUD showText:@"获取失败，请检查网络后重试" Interaction:YES Hide:YES];
                }
            }
        }];
    };
}

#pragma mark - CustomTableViewDataSource
-(NSInteger)numberOfRowsInTableView:(UITableView *)aTableView InSection:(NSInteger)section FromView:(CustomTableView *)aView {
    NSLog(@"self.InfosArr.count:%lu",(unsigned long)self.InfosArr.count);
    return self.InfosArr.count;
}

-(SlideTableViewCell *)cellForRowInTableView:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView {
    CGSize cellSize = [aTableView rectForRowAtIndexPath:aIndexPath].size;
    static NSString *vCellIdentify = @"sliderCell";
    LimitTimeToBuyTableViewCell *vCell = [aTableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil)
    {
        vCell = [[LimitTimeToBuyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vCellIdentify withGoodsBean:[self.InfosArr objectAtIndex:aIndexPath.row] withCellHeight:[aTableView rectForRowAtIndexPath:aIndexPath].size.height withPageType:self.pageType];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, cellSize.height-0.5, ScreenWidth, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [vCell.contentView addSubview:line];
    }
    else
    {
        vCell.infoBean = [self.InfosArr objectAtIndex:aIndexPath.row];
        [vCell customCell];
    }
    return vCell;
}

#pragma mark - CustomTableViewDelegate
-(float)heightForRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView {
    return 90;
}

-(void)didSelectedRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView
{
    CheckGoodsOnSellsType goodsOnSellsType;
    switch (self.pageType)
    {
        case PageTypeInStore:
            goodsOnSellsType = CheckGoodsOnSellsTypeInStore;
            break;
        case PageTypeLimitFactory:
            goodsOnSellsType = CheckGoodsOnSellsTypeLimitToFactory;
            break;
        case PageTypeShopping:
            goodsOnSellsType = CheckGoodsOnSellsTypeShopping;
            break;
        default:
            NSLog(@"%li 没有该页面类型",(long)self.pageType);
            break;
    }
    _infoBean = [self.InfosArr objectAtIndex:aIndexPath.row];
    if ([_infoBean.goodsSeckillState isEqualToString:@"late"])
    {
        //seckillState.text = @"已过期";
        [ProgressHUD showText:@"已过期,请稍后再试!" Interaction:YES Hide:YES];
        return;
    }
    else if ([self.infoBean.goodsSeckillState isEqualToString:@"early"])
    {
        //seckillState.text = @"即将开始";
        [ProgressHUD showText:@"即将开始,请耐心等待!" Interaction:YES Hide:YES];
        return;
    }
    else
    {
        //seckillState.text = @"立即抢购";
    }
    OrderDetailTableViewController *store = [[OrderDetailTableViewController alloc] init];
    [store passInfoBean:[self.InfosArr objectAtIndex:aIndexPath.row]];
    store.goodsOnSellsType = goodsOnSellsType;
    store.edgesForExtendedLayout = UIRectEdgeNone;
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    [self.navigationController pushViewController:store animated:YES];
}

-(void)loadData:(void(^)(int aAddedRowCount))complete FromView:(CustomTableView *)aView {
    self.pageNum++;
    self.refreshDataFinishedBlock = nil;
    self.loadDataFinishedBlock = complete;
    [self startNetWithNeedReload:NO];
}

-(void)refreshData:(void(^)())complete FromView:(CustomTableView *)aView {
    self.pageNum = 1;
    self.loadDataFinishedBlock = nil;
    self.refreshDataFinishedBlock = complete;
    [self startNetWithNeedReload:NO];
}

#pragma mark - Button Response
- (void)restartNet:(UIButton *)b {
    [b removeFromSuperview];
    [self startNetWithNeedReload:YES];
}

#pragma mark - Private & Tool
- (void)showNoDataTip:(BOOL)show {
    [ProgressHUD dismiss];
    if (show)
    {
        /*UILabel *tip = [[UILabel alloc] initWithFrame:self.view.bounds];
        tip.text = @"还没商品";
        tip.textAlignment = NSTextAlignmentCenter;
        tip.center = self.view.center;
        [self.view addSubview:tip];*/
        if (!self.imageview)
        {
            self.imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
            self.imageview.image = [UIImage imageNamed:@"nodata"];
            self.imageview.center = self.view.center;
            [self.view addSubview:self.imageview];
        }
        
        if (!self.tip)
        {
            self.tip = [[UILabel alloc] initWithFrame:CGRectMake(self.imageview.frame.origin.x-50, self.imageview.frame.origin.y+70, 200, 100)];
            self.tip.text = @"还没商品";
            self.tip.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:self.tip];
        }
    }
    else {
        [self.view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
        {
            if ([obj isKindOfClass:[UILabel class]] && [((UILabel*)obj).text isEqualToString:@"还没商品"])
            {
                [obj removeFromSuperview];
            }
        }];
    }
}

- (void)showNetErrorTip
{
    [ProgressHUD dismiss];
    UIButton *btn = [[UIButton alloc] initWithFrame:self.view.bounds];
    [btn setTitle:@"网络好像有点问题，点击屏幕重试吧~" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(restartNet:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

@end
