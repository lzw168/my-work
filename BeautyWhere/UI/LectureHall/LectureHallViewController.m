//
//  InformationViewController.m
//  BeautyWhere
//
//  Created by Michael on 15-7-21.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "LectureHallViewController.h"
#import "BillListCell.h"
#import "BillPageNetwork.h"
#import "BillDetailTableViewController.h"

typedef NS_ENUM(NSInteger, InformationPageType) {
    InformationPageTypeSeckill,
    InformationPageTypeLimitFactory,
    InformationPageTypeArround,
    InformationPageTypeShopping
};

@interface LectureHallViewController ()

@property (nonatomic, strong) CustomTableView *seckillTable;
@property (nonatomic, strong) CustomTableView *limitFactoryTable;
@property (nonatomic, strong) CustomTableView *arroundTable;
@property (nonatomic, strong) CustomTableView *shoppingTable;
@property (nonatomic, assign) InformationPageType pageType;
@property (nonatomic, assign) NSInteger seckillPageNum;
@property (nonatomic, assign) NSInteger limitFactoryPageNum;
@property (nonatomic, assign) NSInteger arroundPageNum;
@property (nonatomic, assign) NSInteger shoppingPageNum;
@property (nonatomic, strong) NSMutableArray *seckillInfosArr;
@property (nonatomic, strong) NSMutableArray *limitFactoryInfosArr;
@property (nonatomic, strong) NSMutableArray *arroundInfosArr;
@property (nonatomic, strong) NSMutableArray *shoppingInfosArr;
@property (atomic, copy) LoadDataComplete loadDataFinishedBlock;
@property (atomic, copy) RefreshDataComplete refreshDataFinishedBlock;

@end

@implementation LectureHallViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initializeVariable];
    NSArray *views = @[self.seckillTable, self.limitFactoryTable, self.arroundTable];//, self.shoppingTable
    NSArray *names = @[@"每日秒购",@"工厂直卖",@"附近美容"];//,@"裸价代购"
    XLScrollViewer *scroll =[XLScrollViewer scrollWithFrame:self.view.bounds withViews:views withButtonNames:names withThreeAnimation:221];
    scroll.xl_buttonColorNormal = [UIColor grayColor];
    scroll.xl_buttonColorSelected = [UIColor blackColor];
    scroll.xl_topBackColor = BottomMenuBackgroundColor;
    scroll.xl_sliderColor = NavBarColor;
    scroll.delegate = self;
    [self.view addSubview:scroll];
//    if (![[AFHTTPRequestOperationManager manager].reachabilityManager isReachable]) {
//        UIButton *withoutNet = [[UIButton alloc] initWithFrame:self.view.bounds];
//        [withoutNet addTarget:self action:@selector(relink) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:withoutNet];
//    }
//    else {
//        [ProgressHUD show:@"请稍后..." Interaction:NO Hide:NO];
//        [self startNet];
//    }
//    [self initializeOther];
}

- (void)initializeVariable {
    self.seckillPageNum = 1;
    self.limitFactoryPageNum = 1;
    self.arroundPageNum = 1;
    self.shoppingPageNum = 1;
    self.seckillInfosArr = [[NSMutableArray alloc] init];
    self.limitFactoryInfosArr = [[NSMutableArray alloc] init];
    self.arroundInfosArr = [[NSMutableArray alloc] init];
    self.shoppingInfosArr = [[NSMutableArray alloc] init];
    CGRect tableRect = CGRectMake(0, 0, ScreenWidth, self.view.bounds.size.height-self.navigationController.navigationBar.frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height-44);
    self.seckillTable = [[CustomTableView alloc] initWithFrame:tableRect];
    self.seckillTable.dataSource = self;
    self.seckillTable.delegate = self;
    self.seckillTable.homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.seckillTable.hidden = YES;
    self.limitFactoryTable = [[CustomTableView alloc] initWithFrame:tableRect];
    self.limitFactoryTable.dataSource = self;
    self.limitFactoryTable.delegate = self;
    self.limitFactoryTable.homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.limitFactoryTable.hidden = YES;
    self.arroundTable = [[CustomTableView alloc] initWithFrame:tableRect];
    self.arroundTable.dataSource = self;
    self.arroundTable.delegate = self;
    self.arroundTable.homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.arroundTable.hidden = YES;
    self.shoppingTable = [[CustomTableView alloc] initWithFrame:tableRect];
    self.shoppingTable.dataSource = self;
    self.shoppingTable.delegate = self;
    self.shoppingTable.homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.shoppingTable.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!User || !User.userID || [User.userID isEqualToString:@""])
    {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.edgesForExtendedLayout = UIRectEdgeNone;
        login.backItemType = BackItemTypeNone;
        login.enterType = EnterTypePush;
        [self.navigationController pushViewController:login animated:NO];
    }
    else
    {
        [ProgressHUD show:@"请稍后..." Interaction:NO Hide:NO];
        [self startNet];
        [self initializeOther];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CustomTableViewDataSource
-(NSInteger)numberOfRowsInTableView:(UITableView *)aTableView InSection:(NSInteger)section FromView:(CustomTableView *)aView {
    switch (self.pageType) {
        case InformationPageTypeArround:
            if (self.arroundInfosArr.count > 0) {
                UIView *fatherView = self.arroundTable.superview;
                UILabel *tip = (UILabel*)[fatherView viewWithTag:arroundTableNoDataTipTag];
                [tip removeFromSuperview];
                self.arroundTable.hidden = NO;
            }
            else {
                self.arroundTable.hidden = YES;
                UIView *fatherView = self.arroundTable.superview;
                UILabel *tip = (UILabel*)[fatherView viewWithTag:arroundTableNoDataTipTag];
                if (!tip) {
                    tip = [[UILabel alloc] initWithFrame:self.arroundTable.frame];
                    tip.text = @"没有订单信息";
                    tip.textAlignment = NSTextAlignmentCenter;
                    tip.textColor = [UIColor lightGrayColor];
                    tip.tag = arroundTableNoDataTipTag;
                    [fatherView addSubview:tip];
                }
            }
            return self.arroundInfosArr.count;
            break;
        case InformationPageTypeLimitFactory:
            if (self.limitFactoryInfosArr.count > 0) {
                UIView *fatherView = self.limitFactoryTable.superview;
                UILabel *tip = (UILabel*)[fatherView viewWithTag:limitFactoryTableNoDataTipTag];
                [tip removeFromSuperview];
                self.limitFactoryTable.hidden = NO;
            }
            else {
                self.limitFactoryTable.hidden = YES;
                UIView *fatherView = self.limitFactoryTable.superview;
                UILabel *tip = (UILabel*)[fatherView viewWithTag:limitFactoryTableNoDataTipTag];
                if (!tip) {
                    tip = [[UILabel alloc] initWithFrame:self.limitFactoryTable.frame];
                    tip.text = @"没有订单信息";
                    tip.textAlignment = NSTextAlignmentCenter;
                    tip.textColor = [UIColor lightGrayColor];
                    tip.tag = limitFactoryTableNoDataTipTag;
                    [fatherView addSubview:tip];
                }
            }
            return self.limitFactoryInfosArr.count;
            break;
        case InformationPageTypeSeckill:
            if (self.seckillInfosArr.count > 0)
            {
                UIView *fatherView = self.seckillTable.superview;
                UILabel *tip = (UILabel*)[fatherView viewWithTag:seckillTableNoDataTipTag];
                [tip removeFromSuperview];
                self.seckillTable.hidden = NO;
            }
            else
            {
                self.seckillTable.hidden = YES;
                UIView *fatherView = self.seckillTable.superview;
                UILabel *tip = (UILabel*)[fatherView viewWithTag:seckillTableNoDataTipTag];
                if (!tip) {
                    tip = [[UILabel alloc] initWithFrame:self.seckillTable.frame];
                    tip.text = @"没有订单信息";
                    tip.textAlignment = NSTextAlignmentCenter;
                    tip.textColor = [UIColor lightGrayColor];
                    tip.tag = seckillTableNoDataTipTag;
                    [fatherView addSubview:tip];
                }
            }
            return self.seckillInfosArr.count;
            break;
        case InformationPageTypeShopping:
            if (self.shoppingInfosArr.count > 0) {
                UIView *fatherView = self.shoppingTable.superview;
                UILabel *tip = (UILabel*)[fatherView viewWithTag:shoppingTableNoDataTipTag];
                [tip removeFromSuperview];
                self.shoppingTable.hidden = NO;
            }
            else {
                self.shoppingTable.hidden = YES;
                UIView *fatherView = self.shoppingTable.superview;
                UILabel *tip = (UILabel*)[fatherView viewWithTag:shoppingTableNoDataTipTag];
                if (!tip)
                {
                    tip = [[UILabel alloc] initWithFrame:self.shoppingTable.frame];
                    tip.text = @"没有订单信息";
                    tip.textAlignment = NSTextAlignmentCenter;
                    tip.textColor = [UIColor lightGrayColor];
                    tip.tag = shoppingTableNoDataTipTag;
                    [fatherView addSubview:tip];
                }
            }
            return self.shoppingInfosArr.count;
            break;
    }
}

-(SlideTableViewCell *)cellForRowInTableView:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView
{
    NSMutableArray *dataArr = nil;
    NSString *vCellIdentify = nil;
    switch (self.pageType)
    {
        case InformationPageTypeArround:
            dataArr = self.arroundInfosArr;
            vCellIdentify = @"arroundStoreReuseCell";
            break;
        case InformationPageTypeLimitFactory:
            dataArr = self.limitFactoryInfosArr;
            vCellIdentify = @"limitFactoryReuseCell";
            break;
        case InformationPageTypeSeckill:
            dataArr = self.seckillInfosArr;
            vCellIdentify = @"seckillReuseCell";
            break;
        case InformationPageTypeShopping:
            dataArr = self.shoppingInfosArr;
            vCellIdentify = @"shoppingReuseCell";
            break;
    }
    CGSize cellSize = [aTableView rectForRowAtIndexPath:aIndexPath].size;
    BillListCell *vCell = [aTableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[BillListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vCellIdentify withBillBean:[dataArr objectAtIndex:aIndexPath.row] withCellHeight:[aTableView rectForRowAtIndexPath:aIndexPath].size.height];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, cellSize.height-0.5, ScreenWidth, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [vCell.contentView addSubview:line];
    }
    else {
        vCell.infoBean = [dataArr objectAtIndex:aIndexPath.row];
        [vCell customCell];
    }
    return vCell;
}

#pragma mark - CustomTableViewDelegate
-(float)heightForRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView {
    return 90;
}

-(void)didSelectedRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView {
    NSMutableArray *currentArr = nil;
    switch (self.pageType) {
        case InformationPageTypeArround:
            currentArr = self.arroundInfosArr;
            break;
        case InformationPageTypeLimitFactory:
            currentArr = self.limitFactoryInfosArr;
            break;
        case InformationPageTypeSeckill:
            currentArr = self.seckillInfosArr;
            break;
        case InformationPageTypeShopping:
            currentArr = self.shoppingInfosArr;
            break;
    }
    BillDetailTableViewController *bill = [[BillDetailTableViewController alloc] init];
    bill.title = @"订单详情";
    bill.bill = [currentArr objectAtIndex:aIndexPath.row];
    bill.edgesForExtendedLayout = UIRectEdgeNone;
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    [self.navigationController pushViewController:bill animated:YES];
}

-(void)loadData:(void(^)(int aAddedRowCount))complete FromView:(CustomTableView *)aView {
    switch (self.pageType) {
        case InformationPageTypeArround:
            self.arroundPageNum++;
            break;
        case InformationPageTypeLimitFactory:
            self.limitFactoryPageNum++;
            break;
        case InformationPageTypeSeckill:
            self.seckillPageNum++;
            break;
        case InformationPageTypeShopping:
            self.shoppingPageNum++;
            break;
    }
    self.refreshDataFinishedBlock = nil;
    self.loadDataFinishedBlock = complete;
    [self startNet];
}

-(void)refreshData:(void(^)())complete FromView:(CustomTableView *)aView {
    switch (self.pageType) {
        case InformationPageTypeArround:
            self.arroundPageNum=1;
            break;
        case InformationPageTypeLimitFactory:
            self.limitFactoryPageNum=1;
            break;
        case InformationPageTypeSeckill:
            self.seckillPageNum=1;
            break;
        case InformationPageTypeShopping:
            self.shoppingPageNum=1;
            break;
    }
    self.loadDataFinishedBlock = nil;
    self.refreshDataFinishedBlock = complete;
    [self startNet];
    [ProgressHUD dismiss];
}

#pragma mark - XLScrollViewDelegate
- (void)xlscrollviewChangeCurrentPageIndex:(NSInteger)currentPageIndex {
    self.pageType = currentPageIndex;
    CustomTableView *table = nil;
    NSMutableArray *currentArr = nil;
    switch (self.pageType) {
        case InformationPageTypeArround:
            currentArr = self.arroundInfosArr;
            table = self.arroundTable;
            break;
        case InformationPageTypeLimitFactory:
            currentArr = self.limitFactoryInfosArr;
            table = self.limitFactoryTable;
            break;
        case InformationPageTypeSeckill:
            currentArr = self.seckillInfosArr;
            table = self.seckillTable;
            break;
        case InformationPageTypeShopping:
            currentArr = self.shoppingInfosArr;
            table = self.shoppingTable;
            break;
    }
    NSLog(@"[table.homeTableView visibleCells].count:%lu",(unsigned long)[table.homeTableView visibleCells].count);
//    if (currentArr.count > 0 && [table.homeTableView visibleCells].count == 1) {
        [table.homeTableView reloadData];
//    }
}

#pragma mark - Net
- (void)startNet {
    CheckGoodsOnSellsType sellsType = 0;
    NSString *currentPage = nil;
    switch (self.pageType) {
        case InformationPageTypeArround:
            sellsType = CheckGoodsOnSellsTypeInStore;
            currentPage = [NSString stringWithFormat:@"%li",(long)self.arroundPageNum];
            break;
        case InformationPageTypeLimitFactory:
            sellsType = CheckGoodsOnSellsTypeLimitToFactory;
            currentPage = [NSString stringWithFormat:@"%li",(long)self.limitFactoryPageNum];
            break;
        case InformationPageTypeSeckill:
            sellsType = CheckGoodsOnSellsTypeSeckill;
            currentPage = [NSString stringWithFormat:@"%li",(long)self.seckillPageNum];
            break;
        case InformationPageTypeShopping:
            sellsType = CheckGoodsOnSellsTypeShopping;
            currentPage = [NSString stringWithFormat:@"%li",(long)self.shoppingPageNum];
            break;
    }
    __weak typeof(self) wself = self;
    [BillPageNetwork showOrderWithUserID:User.userID withType:sellsType withPageNum:currentPage withSucceedBlock:^(NSMutableArray *orderArr) {
        CustomTableView *table = nil;
        NSMutableArray *currentArr = nil;
        switch (wself.pageType) {
            case InformationPageTypeArround:
                currentArr = wself.arroundInfosArr;
                table = wself.arroundTable;
                break;
            case InformationPageTypeLimitFactory:
                currentArr = wself.limitFactoryInfosArr;
                table = wself.limitFactoryTable;
                break;
            case InformationPageTypeSeckill:
                currentArr = wself.seckillInfosArr;
                table = wself.seckillTable;
                break;
            case InformationPageTypeShopping:
                currentArr = wself.shoppingInfosArr;
                table = wself.shoppingTable;
                break;
        }
        if ([currentPage isEqualToString:@"1"]) {
            [currentArr removeAllObjects];
        }
        NSInteger originalCount = currentArr.count;
        [currentArr addObjectsFromArray:orderArr];
        __strong RefreshDataComplete refreshCompleteBlock = wself.refreshDataFinishedBlock;
        __strong LoadDataComplete loadMoreCompleteBlock = wself.loadDataFinishedBlock;
        if (refreshCompleteBlock) {
            refreshCompleteBlock();
        }
        if (loadMoreCompleteBlock && currentArr.count - originalCount > 0) {
            loadMoreCompleteBlock((int)(currentArr.count - originalCount));
        }
        [table.homeTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        [ProgressHUD dismiss];
    } withErrorBlock:^(NSError *err)
    {
        [ProgressHUD showText:@"获取失败，请保持网络通畅" Interaction:YES Hide:YES];
    }];
}

- (void)initializeOther {
    __weak typeof(self)wself = self;
    NSArray *tmpTypeArr = @[@(CheckGoodsOnSellsTypeLimitToFactory),@(CheckGoodsOnSellsTypeInStore),@(CheckGoodsOnSellsTypeShopping)];
    [tmpTypeArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [BillPageNetwork showOrderWithUserID:User.userID withType:[obj integerValue] withPageNum:@"1" withSucceedBlock:^(NSMutableArray *orderArr) {
            CustomTableView *table = nil;
            NSMutableArray *currentArr = nil;
            switch (idx) {
                case 0:
                    table = wself.limitFactoryTable;
                    currentArr = wself.limitFactoryInfosArr;
                    break;
                case 1:
                    table = wself.arroundTable;
                    currentArr = wself.arroundInfosArr;
                    break;
                case 2:
                    table = wself.shoppingTable;
                    currentArr = wself.shoppingInfosArr;
                    break;
            }
            [currentArr removeAllObjects];
            [currentArr addObjectsFromArray:orderArr];
        } withErrorBlock:^(NSError *err) {
            NSLog(@"initializeOther err:%@",err);
        }];
    }];
}

#pragma mark - Button Response
- (void)relink {
    if (![[AFHTTPRequestOperationManager manager].reachabilityManager isReachable]) {
        return;
    }
    else {
        [ProgressHUD show:@"连接在，请稍后..." Interaction:NO Hide:NO];
        [self startNet];
    }
}

@end
