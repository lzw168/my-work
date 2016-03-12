//
//  PersonalViewController.m
//  BeautyWhere
//
//  Created by Michael on 15-7-21.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "PersonalViewController.h"
#import "UserBean.h"
#import "UIImageView+AFNetworking.h"
#import "ChangeUserInfoViewController.h"
#import "CouponDetailViewController.h"
#import "CollectionDetailViewController.h"
#import "PersonalPageNetwork.h"
#import "IntegralTableViewController.h"
#import "InformationViewController.h"
#import "MyAddressViewController.h"
#import "MorePageNetwork.h"

@interface PersonalViewController ()

@property (nonatomic, weak) UserBean *user;
@property (nonatomic, strong) NSArray *iconArr;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) UIImageView *header;
@end

@implementation PersonalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.iconArr = @[@"gerenxinxi-youhuijun.png", @"gerenxinxi-shoucang.png",@"order_48.png",@"gerenzhongxin-icon-jifen.png",@"icon_address.png",@"icon_call.png"];
    self.titleArr = @[@"优惠券", @"我的收藏",@"我的订单", @"我的臭美币",@"我的收货地址",@"联系客服"];
    self.tableView.scrollEnabled = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"User:%@",User);
    NSLog(@"User.userID------3:%@",User.userID);
    if (!User || !User.userID||User == nil)
    {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.edgesForExtendedLayout = UIRectEdgeNone;
        login.backItemType = BackItemTypeNone;
        login.enterType = EnterTypePush;
        [self.navigationController pushViewController:login animated:NO];
    }
    else
    {
        [MorePageNetwork refleshUserInfoWithUserID:User.userID withSuccessBlock:^(BOOL finished)
         {
             if (!finished)
             {
                 NSLog(@"获取不了新用户信息的json 数据");
             }
             else
             {
                 //[ProgressHUD showText:@"臭美币更新成功" Interaction:YES Hide:YES];
                 [self.header setImageWithURL:[NSURL URLWithString:User.avatar] placeholderImage:[UIImage imageNamed:@"touxiang.png"]];
             }
         } withErrorBlock:^(NSError *err)
         {
             NSLog(@"更新用户信息有误:%@",err);
             NSError *error = nil;
             BOOL removeFinished;
             removeFinished = [[NSFileManager defaultManager] removeItemAtPath:UserInfoFilePath error:&error];
             if (error)
             {
                 NSLog(@"删除用户信息文件有误:%@",error);
             }
             else if (removeFinished)
             {
                 User = nil;
             }
             [ProgressHUD showText:@"获取不了新的用户数据，请重新登录" Interaction:YES Hide:YES];
         }];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentify"];
    CGSize cellSize = [tableView rectForRowAtIndexPath:indexPath].size;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentify"];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, cellSize.height-0.5, ScreenWidth, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:line];
        UILabel *number = [[UILabel alloc] init];
        number.tag = numberLabelTag;
        [cell.contentView addSubview:number];
    }
    cell.imageView.image = [UIImage imageNamed:[self.iconArr objectAtIndex:indexPath.row]];
    cell.textLabel.text = [self.titleArr objectAtIndex:indexPath.row];
    UILabel *number = (UILabel*)[cell.contentView viewWithTag:numberLabelTag];
    switch (indexPath.row) {
        case 0:
            number.text = @"";
            break;
        case 1:
            number.text = @"";
            break;
        case 2:
            number.text = @"";
            break;
        case 3:
            number.text = User.money;
            number.font = [UIFont systemFontOfSize:13.0];
            break;
        case 4:
            number.text = @"";
            break;
    }
    [number sizeToFit];
    number.frame = CGRectMake(cellSize.width-number.frame.size.width-50, (cellSize.height-number.frame.size.height)/2, number.frame.size.width, number.frame.size.height);
//    if (indexPath.row != 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *targetViewController = nil;
    switch (indexPath.row)
    {
        case 0:
            targetViewController = [[CouponDetailViewController alloc] init];
            targetViewController.title = @"优惠券";
            break;
            
        case 1:
            targetViewController = [[CollectionDetailViewController alloc] init];
            targetViewController.title = @"我的收藏";
            break;
            
        case 2:
            targetViewController = [[InformationViewController alloc] init];
            targetViewController.title = @"我的订单";
            [self.navigationController.view viewWithTag:homeTitleTag].hidden = YES;
            targetViewController.hidesBottomBarWhenPushed = YES;
            [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
            targetViewController.edgesForExtendedLayout = UIRectEdgeNone;
            [self.navigationController pushViewController:targetViewController animated:YES];
            return;
            break;

        case 3:
            targetViewController = [[IntegralTableViewController alloc] init];
            targetViewController.title = @"臭美币获取";
            ((IntegralTableViewController*)targetViewController).point = User.money;
            break;
        case 4:
            targetViewController = [[MyAddressViewController alloc] init];
            targetViewController.title = @"收货地址";
            [self.navigationController.view viewWithTag:homeTitleTag].hidden = YES;
            targetViewController.hidesBottomBarWhenPushed = YES;
            [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
            targetViewController.edgesForExtendedLayout = UIRectEdgeNone;
            [self.navigationController pushViewController:targetViewController animated:YES];
            return;
            break;
        case 5:
            {
                NSString *telStr = [NSString stringWithFormat:@"tel://%@",GetAppDelegate.service_tel];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
            }
            break;
    }
    if (targetViewController)
    {
        targetViewController.edgesForExtendedLayout = UIRectEdgeNone;
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
        [self.navigationController pushViewController:targetViewController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 62;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 100;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 85;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    __autoreleasing UIButton *changeInfo = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    changeInfo.backgroundColor = KMainBackgroundColor;
    [changeInfo addTarget:self action:@selector(changeUserInfo) forControlEvents:UIControlEventTouchUpInside];
    UIImage *headerImg = [UIImage imageNamed:@"touxiang.png"];
    if (GetAppDelegate.cacheHeaderImg)
    {
        headerImg = GetAppDelegate.cacheHeaderImg;
    }
//  UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-15-headerImg.size.width, (changeInfo.frame.size.height-headerImg.size.height)/2, headerImg.size.width, headerImg.size.height)];
    self.header = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-60, 0, 60, 60)];
    self.header.layer.cornerRadius = self.header.frame.size.width/2;
    self.header.clipsToBounds = YES;
    self.header.center = CGPointMake(self.header.center.x, changeInfo.center.y);
    //[header setImageWithURL:[NSURL URLWithString:User.avatar] placeholderImage:headerImg];
    self.header.image = headerImg;
    
    UILabel *name = [[UILabel alloc] init];
    name.text = User.userName;
    name.font = [UIFont systemFontOfSize:13.0];
    name.frame = CGRectMake(self.header.frame.size.width+self.header.frame.origin.x+10, self.header.frame.origin.y+5, ScreenWidth-(self.header.frame.size.width+self.header.frame.origin.x+10)-10, 18);
    
    UILabel *phone = [[UILabel alloc] init];
    phone.text = User.mobile;
    phone.font = [UIFont systemFontOfSize:13.0];
    [phone sizeToFit];
    phone.frame = CGRectMake(name.frame.origin.x, name.frame.size.height+name.frame.origin.y+10, phone.frame.size.width, phone.frame.size.height);
    
//    UIImageView *vipCard = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"meifenka_pre.png"]];
    CGFloat maxTextWidth = MAX(name.frame.size.width, phone.frame.size.width);
    CGFloat totalWidth = maxTextWidth +self.header.frame.size.width;
    self.header.frame = CGRectMake((ScreenWidth-totalWidth)/2, self.header.frame.origin.y, self.header.frame.size.width, self.header.frame.size.height);
    name.frame = CGRectMake(self.header.frame.size.width+self.header.frame.origin.x+10, name.frame.origin.y, name.frame.size.width, name.frame.size.height);
    phone.frame = CGRectMake(name.frame.origin.x, phone.frame.origin.y, phone.frame.size.width, phone.frame.size.height);
    [changeInfo addSubview:self.header];
    [changeInfo addSubview:name];
    [changeInfo addSubview:phone];
    
    return changeInfo;
}
/*
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    BOOL canAddUserMarkByLogin = [[NSUserDefaults standardUserDefaults] boolForKey:addUserMarkByLogin];
    UIButton *singUp = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, ScreenWidth-20, 52.5)];
    [singUp setTitle:@"签到" forState:UIControlStateNormal];
//    singUp.enabled = canAddUserMarkByLogin;
    singUp.backgroundColor = canAddUserMarkByLogin?NavBarColor:[UIColor lightGrayColor];
    singUp.layer.cornerRadius = 10;
    [singUp addTarget:self action:@selector(pressedSignUp:) forControlEvents:UIControlEventTouchUpInside];
    __autoreleasing UIView *view = [[UIView alloc] init];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, ScreenWidth, 0.5)];
    line.backgroundColor = [UIColor grayColor];
//    [view addSubview:line];
    [view addSubview:singUp];
    return view;
}
*/
#pragma mark - Button Response
- (void)changeUserInfo
{
    ChangeUserInfoViewController *change = [[ChangeUserInfoViewController alloc] init];
    change.title = @"个人资料";
    change.personalPage = self;
    self.navigationController.hidesBottomBarWhenPushed = YES;
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    [self.navigationController pushViewController:change animated:YES];
}

@end
