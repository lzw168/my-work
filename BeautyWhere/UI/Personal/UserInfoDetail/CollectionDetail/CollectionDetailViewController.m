//
//  CollectionDetailViewController.m
//  BeautyWhere
//
//  Created by Michael on 15/8/3.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "CollectionDetailViewController.h"
#import "PersonalPageNetwork.h"
#import "StoreBean.h"
#import "StoreDetailViewController.h"
#import "CollectionDetailListCell.h"

@interface CollectionDetailViewController ()

@property (nonatomic, assign) NSInteger pageNum;
@property (atomic, copy) LoadDataComplete loadDataFinishedBlock;
@property (atomic, copy) RefreshDataComplete refreshDataFinishedBlock;
@property (nonatomic, strong) CustomTableView *table;

@end

@implementation CollectionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.pageNum = 1;
    self.loadDataFinishedBlock = nil;
    self.refreshDataFinishedBlock = nil;
    self.collectedStoreArr = [[NSMutableArray alloc] init];
    self.table = [[CustomTableView alloc] initWithFrame:self.view.bounds];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.hidden = YES;
    self.table.homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.table];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startNetWithLoadingTip:YES];
    [self.table.homeTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Net
- (void)startNetWithLoadingTip:(BOOL)need {
    if (need) {
        [ProgressHUD show:@"加载中..." Interaction:NO Hide:NO];
    }
    if (self.pageNum == 1) {
        [self.collectedStoreArr removeAllObjects];
    }
    __weak typeof(self) wself = self;
    [PersonalPageNetwork getCollectionDetailWithUserID:User.userID withPageNum:[NSString stringWithFormat:@"%li",(long)self.pageNum] withSuccessBlock:^(NSArray *collectionArr) {
        __strong RefreshDataComplete refreshCompleteBlock = wself.refreshDataFinishedBlock;
        __strong LoadDataComplete loadMoreCompleteBlock = wself.loadDataFinishedBlock;
        [ProgressHUD dismiss];
        NSInteger originalCollectionArrCount = wself.collectedStoreArr.count;
        [wself.collectedStoreArr addObjectsFromArray:collectionArr];
        if (!wself.collectedStoreArr || wself.collectedStoreArr.count == 0) {
            [wself showNoDataTip:YES];
            wself.table.hidden = YES;
        }
        else {
            wself.table.hidden = NO;
            if (need) {
//                [wself.table reloadTableViewDataSource];
                [wself.table.homeTableView reloadData];
            }
            if (refreshCompleteBlock) {
                refreshCompleteBlock();
            }
            if (loadMoreCompleteBlock && wself.collectedStoreArr.count-originalCollectionArrCount != 0) {
                loadMoreCompleteBlock((int)(wself.collectedStoreArr.count-originalCollectionArrCount));
            }
        }
    } withErrBlock:^(NSError *err) {
        NSLog(@"获取收藏信息失败：%@",err);
        if (err.code == -1009) {
            [wself showNetErrorTip];
        }
        else {
            [ProgressHUD showText:@"获取失败，请检查网络后再试" Interaction:YES Hide:YES];
        }
    }];
}

#pragma mark - CustomTableViewDataSource
-(NSInteger)numberOfRowsInTableView:(UITableView *)aTableView InSection:(NSInteger)section FromView:(CustomTableView *)aView {
    return self.collectedStoreArr.count;
}

-(SlideTableViewCell *)cellForRowInTableView:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView {
    CGSize cellSize = [aTableView rectForRowAtIndexPath:aIndexPath].size;
    static NSString *vCellIdentify = @"sliderCell";
    CollectionDetailListCell *vCell = [aTableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[CollectionDetailListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vCellIdentify withStoreBean:[self.collectedStoreArr objectAtIndex:aIndexPath.row] withCellHeight:[aTableView rectForRowAtIndexPath:aIndexPath].size.height];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, cellSize.height-0.5, ScreenWidth, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [vCell.contentView addSubview:line];
    }
    else {
        vCell.store = [self.collectedStoreArr objectAtIndex:aIndexPath.row];
        [vCell customCell];
    }
    return vCell;
}

#pragma mark - CustomTableViewDelegate
-(float)heightForRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView {
    return 90;
}

-(void)didSelectedRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView {
    StoreDetailViewController *store = [[StoreDetailViewController alloc] init];
    [store passInfoBean:[self.collectedStoreArr objectAtIndex:aIndexPath.row]];
    store.preViewController = self;
    store.title = ((StoreBean*)[self.collectedStoreArr objectAtIndex:aIndexPath.row]).storeTitle;
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    [self.navigationController pushViewController:store animated:YES];
}

-(void)loadData:(void(^)(int aAddedRowCount))complete FromView:(CustomTableView *)aView {
    self.pageNum++;
    self.refreshDataFinishedBlock = nil;
    self.loadDataFinishedBlock = complete;
    [self startNetWithLoadingTip:NO];
}

-(void)refreshData:(void(^)())complete FromView:(CustomTableView *)aView {
    self.pageNum = 1;
    self.loadDataFinishedBlock = nil;
    self.refreshDataFinishedBlock = complete;
    [self startNetWithLoadingTip:NO];
}

#pragma mark - Button Response
- (void)restartNet:(UIButton *)b {
    [b removeFromSuperview];
    [self startNetWithLoadingTip:YES];
}

#pragma mark - Private & Tool
- (void)showNoDataTip:(BOOL)show {
    [ProgressHUD dismiss];
    if (show) {
        UILabel *tip = [[UILabel alloc] initWithFrame:self.view.bounds];
        tip.text = @"你好像还没收藏吧~";
        tip.textAlignment = NSTextAlignmentCenter;
        tip.center = self.view.center;
        [self.view addSubview:tip];
    }
    else {
        [self.view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[UILabel class]] && [((UILabel*)obj).text isEqualToString:@"你好像还没收藏吧~"]) {
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

- (void)delCollectionStoreWithStoreID:(NSString *)storeID {
    [self.collectedStoreArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([((StoreBean*)obj).storeID isEqualToString:storeID]) {
            [self.collectedStoreArr removeObjectAtIndex:idx];
        }
    }];
}

@end
