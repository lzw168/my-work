//
//  MoreViewController.m
//  BeautyWhere
//
//  Created by Michael on 15-7-21.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "MoreViewController.h"
#import "MorePageNetwork.h"
#import "LoginViewController.h"
#import "AboutViewController.h"
#import "FeedBackViewController.h"
//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKUI/ShareSDKUI.h>
//#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>

@interface MoreViewController ()

@property (nonatomic, strong) NSArray *settingItems;
@property (nonatomic, assign) CGFloat contentViewHeight;
@property (nonatomic, assign) BOOL isLogined;
@property (nonatomic, strong) NSString *upgradeVersionURL;

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.settingItems = @[@"检查更新", @"意见反馈", @"分享给朋友", @"关于我们"];
//    self.settingItems = @[@"检查更新", @"意见反馈", @"关于我们"];
    self.settingItems = @[@"意见反馈", @"关于我们"];
    self.contentViewHeight = self.tableView.frame.size.height;
    self.tableView.frame = CGRectMake(0, 0, ScreenWidth, self.contentViewHeight-55);
    self.tableView.scrollEnabled = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[NSFileManager defaultManager] fileExistsAtPath:UserInfoFilePath]) {
        User = [[UserBean alloc] initWithUserInfoDic:[NSKeyedUnarchiver unarchiveObjectWithFile:UserInfoFilePath]];
    }
    else {
        User = nil;
    }
    if (!self.isLogined && User && User.userID && ![User.userID isEqualToString:@""]) {
        self.isLogined = YES;
        [self.tableView reloadData];
    }
    if (self.isLogined && (!User || !User.userID || [User.userID isEqualToString:@""])) {
        self.isLogined = NO;
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.settingItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentify"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentify"];
    }
    cell.textLabel.text = [self.settingItems objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 62;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 85;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    __autoreleasing UIView *view = [[UIView alloc] init];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, [tableView rectForHeaderInSection:0].size.height-0.5, ScreenWidth, 0.5)];
    line.backgroundColor = [UIColor grayColor];
    [view addSubview:line];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIButton *logout = [[UIButton alloc] initWithFrame:CGRectMake(20, 30, ScreenWidth-40, 52.5)];
    if (!self.isLogined)
    {//没登陆
        [logout setTitle:@"快速登录" forState:UIControlStateNormal];
    }
    else
    {
        [logout setTitle:@"退出登录" forState:UIControlStateNormal];
    }
    logout.backgroundColor = NavBarColor;
    logout.layer.cornerRadius = 10;
    [logout addTarget:self action:@selector(pressedLogout:) forControlEvents:UIControlEventTouchUpInside];
    __autoreleasing UIView *view = [[UIView alloc] init];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, ScreenWidth, 0.5)];
    line.backgroundColor = [UIColor grayColor];
    [view addSubview:line];
    [view addSubview:logout];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *pressedCell = [tableView cellForRowAtIndexPath:indexPath];
    UIViewController *targetViewController = nil;
    if ([pressedCell.textLabel.text isEqualToString:@"关于我们"]) {
        targetViewController = [[AboutViewController alloc] init];
    }/*
    else if ([pressedCell.textLabel.text isEqualToString:@"分享给朋友"]) {
        [ShareSDK showShareActionSheet:self.view items:@[@(SSDKPlatformTypeSinaWeibo), @(SSDKPlatformSubTypeQQFriend), @(SSDKPlatformSubTypeWechatSession), @(SSDKPlatformSubTypeWechatTimeline)] shareParams:nil onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
            ;
        }];
    }*/
    else if ([pressedCell.textLabel.text isEqualToString:@"意见反馈"]) {
        targetViewController = [[FeedBackViewController alloc] init];
    }
    else if ([pressedCell.textLabel.text isEqualToString:@"检查更新"]) {
        [ProgressHUD show:@"正在检查" Interaction:NO Hide:NO];//exit(0);用户退出
        [MorePageNetwork checkUpdateWithSuccessBlock:^(NSString *version, NSString *tip, NSString *downloadURL, BOOL mustUpdate)
        {
            if (![version isEqualToString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]) {
                self.upgradeVersionURL = downloadURL;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:tip delegate:self cancelButtonTitle:@"不要" otherButtonTitles:@"去下载", nil];
                [alert show];
            }
            else
            {
                [ProgressHUD showText:@"已经是最新版本了" Interaction:YES Hide:YES];
            }
        } withErrorBlock:^(NSError *err)
        {
            NSLog(@"checkUpdate err:%@",err);
        }];
    }
    if (targetViewController) {
        targetViewController.title = pressedCell.textLabel.text;
        targetViewController.hidesBottomBarWhenPushed = YES;
        targetViewController.edgesForExtendedLayout = UIRectEdgeNone;
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
        [self.navigationController pushViewController:targetViewController animated:YES];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 && self.upgradeVersionURL && ![self.upgradeVersionURL isEqualToString:@""])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.upgradeVersionURL]];
    }
}

#pragma mark - UIButton Response
- (void)pressedLogout:(id)snder
{
    if (self.isLogined)
    {
        NSError *err = nil;
        if ([[NSFileManager defaultManager] removeItemAtPath:UserInfoFilePath error:&err]) {
            if (!err) {
                User = nil;
                self.isLogined = NO;
                [self.tableView reloadData];
                [ProgressHUD showText:@"已退出登录" Interaction:YES Hide:YES];
                [SSEThirdPartyLoginHelper logout:[SSEThirdPartyLoginHelper currentUser]];
                [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
                [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
                [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
            }
            else {
                NSLog(@"removeItemAtPath:UserInfoFilePath err:%@",err);
                [ProgressHUD showError:err.localizedFailureReason Interaction:YES Hide:YES];
            }
        }
    }
    else
    {
        [ViewController presentLoginViewWithViewController:self backItemType:BackItemTypeBackImg];
    }
}

@end
