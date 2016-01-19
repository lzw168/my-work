//
//  InfoTableViewController.m
//  BeautyWhere
//
//  Created by Michael on 15/8/5.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "InfoTableViewController.h"
#import "HomePageNetwork.h"
#import "InfoListCell.h"
#import "InfoDetailTableViewController.h"

@interface InfoTableViewController ()

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) NSMutableArray *InfosArr;
@property (atomic, copy) LoadDataComplete loadDataFinishedBlock;
@property (atomic, copy) RefreshDataComplete refreshDataFinishedBlock;
@property (nonatomic, strong) CustomTableView *table;

@end

@implementation InfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [ProgressHUD show:@"加载中..." Interaction:NO Hide:NO];
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

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self.table.homeTableView reloadData];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Net
- (void)startNetWithNeedReload:(BOOL)needReload
{
    __weak typeof(self) wself = self;
    [HomePageNetwork getInfoWithPageNum:[NSString stringWithFormat:@"%li",(long)self.pageNum] withSuccessBlock:^(NSArray *infoArr) {
        __strong RefreshDataComplete refreshCompleteBlock = wself.refreshDataFinishedBlock;
        __strong LoadDataComplete loadMoreCompleteBlock = wself.loadDataFinishedBlock;
        if (wself.pageNum == 1) {
            [wself.InfosArr removeAllObjects];
        }
        NSInteger originalCount = wself.InfosArr.count;
        [wself.InfosArr addObjectsFromArray:infoArr];
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
                    wself.table.hidden = NO;
                });
            }
        }
        else {
            wself.table.hidden = YES;
        }
        [ProgressHUD dismiss];
    } withErrBlock:^(NSError *err) {
        NSLog(@"getInfoWithPageNum err:%@",err);
        if (err.code == -1009) {
            [wself showNetErrorTip];
        }
        else {
            [ProgressHUD showText:@"获取失败，请检查网络后重试" Interaction:YES Hide:YES];
        }
    }];
}

#pragma mark - CustomTableViewDataSource
-(NSInteger)numberOfRowsInTableView:(UITableView *)aTableView InSection:(NSInteger)section FromView:(CustomTableView *)aView
{
    return self.InfosArr.count;
}

-(SlideTableViewCell *)cellForRowInTableView:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView
{
    CGSize cellSize = [aTableView rectForRowAtIndexPath:aIndexPath].size;
    static NSString *vCellIdentify = @"sliderCell";
    InfoListCell *vCell = [aTableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil)
    {
        vCell = [[InfoListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vCellIdentify withStoreBean:[self.InfosArr objectAtIndex:aIndexPath.row] withCellHeight:[aTableView rectForRowAtIndexPath:aIndexPath].size.height];
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
-(float)heightForRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView
{
    return 90;
}

-(void)didSelectedRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView
{
    InfoDetailTableViewController *store = [[InfoDetailTableViewController alloc] init];
    store.title = @"资讯详情";
    [store passInfoBean:[self.InfosArr objectAtIndex:aIndexPath.row]];
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

-(void)refreshData:(void(^)())complete FromView:(CustomTableView *)aView {
    self.pageNum = 1;
    self.loadDataFinishedBlock = nil;
    self.refreshDataFinishedBlock = complete;
    [self startNetWithNeedReload:NO];
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
        tip.text = @"没有资讯";
        tip.textAlignment = NSTextAlignmentCenter;
        tip.center = self.view.center;
        [self.view addSubview:tip];
    }
    else {
        [self.view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
        {
            if ([obj isKindOfClass:[UILabel class]] && [((UILabel*)obj).text isEqualToString:@"没有资讯"])
            {
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
