//
//  CouponDetailViewController.m
//  BeautyWhere
//
//  Created by Michael on 15/8/3.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "CouponDetailViewController.h"
#import "CouponCell.h"
#import "PersonalPageNetwork.h"

typedef NS_ENUM(NSInteger, PersonalPageType) {
    PersonalPageTypeWorkingCoupon,
    PersonalPageTypeOverdueCoupon
};

@interface CouponDetailViewController ()

@property (nonatomic, strong) CustomTableView *workTable;
@property (nonatomic, strong) CustomTableView *overdueTable;
@property (nonatomic, assign) PersonalPageType pageType;
@property (nonatomic, assign) NSInteger workPageNum;
@property (nonatomic, assign) NSInteger overduePageNum;
@property (nonatomic, strong) NSMutableArray *workInfosArr;
@property (nonatomic, strong) NSMutableArray *overdueInfosArr;
@property (atomic, copy) LoadDataComplete loadDataFinishedBlock;
@property (atomic, copy) RefreshDataComplete refreshDataFinishedBlock;
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation CouponDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.pageType = PersonalPageTypeWorkingCoupon;
    self.workPageNum = 1;
    self.overduePageNum = 1;
    self.workInfosArr = [[NSMutableArray alloc] init];
    self.overdueInfosArr = [[NSMutableArray alloc] init];
    self.workTable = [[CustomTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.bounds.size.height-self.navigationController.navigationBar.frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height-44)];
    self.workTable.dataSource = self;
    self.workTable.delegate = self;
    self.workTable.userInteractionEnabled = NO;
    self.workTable.homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.overdueTable = [[CustomTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.bounds.size.height-self.navigationController.navigationBar.frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height-44)];
    self.overdueTable.dataSource = self;
    self.overdueTable.delegate = self;
    self.overdueTable.userInteractionEnabled = NO;
    self.overdueTable.homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSArray *views = @[self.workTable, self.overdueTable];
    NSArray *names = @[@"未使用",@"已失效"];
    XLScrollViewer *scroll =[XLScrollViewer scrollWithFrame:self.view.bounds withViews:views withButtonNames:names withThreeAnimation:221];
    scroll.delegate = self;
    scroll.xl_buttonColorNormal = [UIColor grayColor];
    scroll.xl_buttonColorSelected = [UIColor blackColor];
    scroll.xl_topBackColor = BottomMenuBackgroundColor;
    scroll.xl_sliderColor = NavBarColor;
    [self.view addSubview:scroll];
    [ProgressHUD show:@"加载中..." Interaction:YES Hide:NO];
    [self startNet];
    [self initliazeOverList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Net
- (void)startNet {
    __weak typeof(self) wself = self;
    NSString *type = self.pageType == PersonalPageTypeWorkingCoupon?@"1":@"0";
    NSString *pageNum = self.pageType == PersonalPageTypeWorkingCoupon?[NSString stringWithFormat:@"%li",(long)self.workPageNum]:[NSString stringWithFormat:@"%li",(long)self.overduePageNum];
    [PersonalPageNetwork getMyCouponWithUserID:User.userID withType:type withPageNum:pageNum withSuccessBlock:^(NSArray *coupons)
     {
        __strong RefreshDataComplete refreshCompleteBlock = wself.refreshDataFinishedBlock;
        __strong LoadDataComplete loadMoreCompleteBlock = wself.loadDataFinishedBlock;
        NSMutableArray *targetArr = self.pageType == PersonalPageTypeWorkingCoupon?self.workInfosArr:self.overdueInfosArr;
        CustomTableView *targetTable = self.pageType == PersonalPageTypeWorkingCoupon?self.workTable:self.overdueTable;
        if ([pageNum isEqualToString:@"1"])
        {
            [targetArr removeAllObjects];
        }
        NSInteger originalCount = targetArr.count;
        [targetArr addObjectsFromArray:coupons];
        if (refreshCompleteBlock) {
            refreshCompleteBlock();
        }
        if (loadMoreCompleteBlock && targetArr.count - originalCount > 0) {
            loadMoreCompleteBlock((int)(targetArr.count - originalCount));
        }
        if (!refreshCompleteBlock && !loadMoreCompleteBlock)
        {
            [targetTable.homeTableView reloadData];
        }
        [ProgressHUD dismiss];
    } withErrorBlock:^(NSError *err) {
        NSLog(@"getMyCoupon err:%@",err);
        if (err.code == -1009) {
            [wself showNetErrorTip];
        }
        else {
            [ProgressHUD showText:@"获取失败，请检查网络后重试" Interaction:YES Hide:YES];
        }
    }];
}

- (void)initliazeOverList {
    __weak typeof(self) wself = self;
    [PersonalPageNetwork getMyCouponWithUserID:User.userID withType:@"0" withPageNum:@"1" withSuccessBlock:^(NSArray *coupons) {
        [wself.overdueInfosArr removeAllObjects];
        [wself.overdueInfosArr addObjectsFromArray:coupons];
    } withErrorBlock:^(NSError *err) {
        NSLog(@"initliazeOverList err:%@",err);
    }];
}

#pragma mark - CustomTableViewDataSource
-(NSInteger)numberOfRowsInTableView:(UITableView *)aTableView InSection:(NSInteger)section FromView:(CustomTableView *)aView {
    NSLog(@"cell num:%lu",(unsigned long)(self.pageType == PersonalPageTypeWorkingCoupon ? self.workInfosArr.count : self.overdueInfosArr.count));
    if (self.pageType == PersonalPageTypeWorkingCoupon && self.workInfosArr.count == 0) {
        self.workTable.hidden = YES;
        UIView *fatherView = self.workTable.superview;
        UILabel *tip = (UILabel*)[fatherView viewWithTag:workTableNoDataTipTag];
        if (!tip) {
            tip = [[UILabel alloc] initWithFrame:self.workTable.frame];
            tip.text = @"没有优惠券信息";
            tip.textAlignment = NSTextAlignmentCenter;
            tip.textColor = [UIColor lightGrayColor];
            tip.tag = workTableNoDataTipTag;
            [fatherView addSubview:tip];
        }
    }
    if (self.pageType == PersonalPageTypeWorkingCoupon && self.workInfosArr.count > 0) {
        UIView *fatherView = self.workTable.superview;
        UILabel *tip = (UILabel*)[fatherView viewWithTag:workTableNoDataTipTag];
        [tip removeFromSuperview];
        self.workTable.hidden = NO;
    }
    if (self.pageType == PersonalPageTypeOverdueCoupon && self.overdueInfosArr.count == 0) {
        self.overdueTable.hidden = YES;
        UIView *fatherView = self.overdueTable.superview;
        UILabel *tip = (UILabel*)[fatherView viewWithTag:overdueTableNoDataTipTag];
        if (!tip) {
            tip = [[UILabel alloc] initWithFrame:self.overdueTable.frame];
            tip.text = @"没有优惠券信息";
            tip.textAlignment = NSTextAlignmentCenter;
            tip.textColor = [UIColor lightGrayColor];
            tip.tag = overdueTableNoDataTipTag;
            [fatherView addSubview:tip];
        }
    }
    if (self.pageType == PersonalPageTypeOverdueCoupon && self.overdueInfosArr.count > 0) {
        UIView *fatherView = self.overdueTable.superview;
        UILabel *tip = (UILabel*)[fatherView viewWithTag:overdueTableNoDataTipTag];
        [tip removeFromSuperview];
        self.overdueTable.hidden = NO;
    }
    return self.pageType == PersonalPageTypeWorkingCoupon ? self.workInfosArr.count : self.overdueInfosArr.count;
}

-(SlideTableViewCell *)cellForRowInTableView:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView {
    NSMutableArray *dataArr = self.pageType == PersonalPageTypeWorkingCoupon ? self.workInfosArr : self.overdueInfosArr;
    CGSize cellSize = [aTableView rectForRowAtIndexPath:aIndexPath].size;
    NSString *vCellIdentify = self.pageType == PersonalPageTypeWorkingCoupon ? @"workSliderCell" : @"overdueSliderCell";
    CouponCell *vCell = [aTableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[CouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vCellIdentify withCouponBean:[dataArr objectAtIndex:aIndexPath.row] withCellHeight:[aTableView rectForRowAtIndexPath:aIndexPath].size.height];
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

-(void)didSelectedRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView
{
    return;
}

-(void)loadData:(void(^)(int aAddedRowCount))complete FromView:(CustomTableView *)aView {
    self.pageType == PersonalPageTypeWorkingCoupon ? self.workPageNum++ : self.overduePageNum++;
    self.refreshDataFinishedBlock = nil;
    self.loadDataFinishedBlock = complete;
    [self startNet];
}

-(void)refreshData:(void(^)())complete FromView:(CustomTableView *)aView {
    self.pageType == PersonalPageTypeWorkingCoupon ? (self.workPageNum = 1) : (self.overduePageNum = 1);
    self.loadDataFinishedBlock = nil;
    self.refreshDataFinishedBlock = complete;
    [self startNet];
    [ProgressHUD dismiss];
}

#pragma mark - XLScrollViewDelegate
- (void)xlscrollviewChangeCurrentPageIndex:(NSInteger)currentPageIndex {
    self.pageType = currentPageIndex;
    if (self.overdueInfosArr.count > 0 && [self.overdueTable.homeTableView visibleCells].count == 1)
    {
        [self.overdueTable.homeTableView reloadData];
    }
}

#pragma mark - Button Response
- (void)restartNet:(UIButton *)b
{
    [b removeFromSuperview];
    [self startNet];
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
