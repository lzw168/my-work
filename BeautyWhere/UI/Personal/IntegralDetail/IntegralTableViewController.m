//
//  IntegralTableViewController.m
//  BeautyWhere
//
//  Created by Michael on 15/9/12.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "IntegralTableViewController.h"
#import "PersonalPageNetwork.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "RechargeTableViewController.h"

@interface IntegralTableViewController ()

@end

@implementation IntegralTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
    }
    // Configure the cell...
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CellHeight-.5, ScreenWidth, .5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:line];
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"我的臭美币总数";
            UILabel *pointLabel = [[UILabel alloc] init];
            pointLabel.text = self.point;
            pointLabel.font = [UIFont systemFontOfSize:13.0];
            [pointLabel sizeToFit];
            pointLabel.frame = CGRectMake(ScreenWidth-20-pointLabel.frame.size.width, (CellHeight-pointLabel.frame.size.height)/2, pointLabel.frame.size.width, pointLabel.frame.size.height);
            [cell.contentView addSubview:pointLabel];
        }
            break;
        case 11:
            cell.textLabel.text = @"臭美币获取";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 1:
        {
            UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gerenzhongxin-icon-jifen.png"]];
            icon.frame = CGRectMake(10, 10, icon.frame.size.width, icon.frame.size.height);
            [cell.contentView addSubview:icon];
            UILabel *title = [[UILabel alloc] init];
            title.text = @"臭美币获取:";
            [title sizeToFit];
            title.frame = CGRectMake(icon.frame.size.width+icon.frame.origin.x+10, icon.frame.origin.y, title.frame.size.width, title.frame.size.height);
            [cell.contentView addSubview:title];
            UILabel *item1 = [[UILabel alloc] initWithFrame:CGRectMake(icon.frame.size.width/2+icon.frame.origin.x, icon.frame.size.height+icon.frame.origin.y+10, ScreenWidth, 13)];
            item1.textColor = [UIColor lightGrayColor];
            item1.text = @"1.可以通过充值来获取臭美币";
            item1.font = [UIFont systemFontOfSize:13];
            UILabel *item2 = [[UILabel alloc] initWithFrame:CGRectMake(item1.frame.origin.x, 10+item1.frame.origin.y+item1.frame.size.height, item1.frame.size.width, item1.frame.size.height)];
            item2.textColor = [UIColor lightGrayColor];
            item2.text = @"2.每天分享一个平台得两个臭美币";
            item2.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:item1];
            //[cell.contentView addSubview:item2];
        }
            break;
        case 2:
        {
            CGFloat btnPadding = (ScreenWidth-134)/2;
            UIButton *sign = [[UIButton alloc] initWithFrame:CGRectMake(btnPadding/2.5, 10, 77, 30)];
            sign.layer.cornerRadius = 5;
            sign.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:58.0/255.0 blue:99.0/255.0 alpha:1.0];
            [sign setTitle:@"充值" forState:UIControlStateNormal];
            sign.titleLabel.font = [UIFont systemFontOfSize:13];
            [sign setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sign addTarget:self action:@selector(pressedSignUp) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:sign];
            UIButton *share = [[UIButton alloc] initWithFrame:CGRectMake(sign.frame.size.width+sign.frame.origin.x+btnPadding, sign.frame.origin.y, sign.frame.size.width, sign.frame.size.height)];
            share.layer.cornerRadius = 5;
            share.backgroundColor = sign.backgroundColor;
            [share setTitle:@"分享" forState:UIControlStateNormal];
            share.titleLabel.font = [UIFont systemFontOfSize:13];
            [share setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [share addTarget:self action:@selector(pressedShare) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:share];
        }
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 1:
            return 40+3*[UIImage imageNamed:@"gerenzhongxin-icon-jifen.png"].size.height;
            break;
        case 2:
            return 50;
            break;
        default:
            return 44;
            break;
    }
}

#pragma mark - Button Response
- (void)pressedShare
{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:ShareContent images:@[[UIImage imageNamed:@"sharelogo.png"]] url:[NSURL URLWithString:@"http://a.app.qq.com/o/simple.jsp?pkgname=com.jianiao.shangnamei"] title:@"上哪美，一家专门为女性消费者做美容特惠的APP服务运营商。" type:SSDKContentTypeAuto];
    __weak typeof(self)wself = self;
    SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:self.view items:@[@(SSDKPlatformTypeSinaWeibo), @(SSDKPlatformSubTypeQQFriend), @(SSDKPlatformSubTypeWechatSession), @(SSDKPlatformSubTypeWechatTimeline)] shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        NSLog(@"platformType:%lu",(unsigned long)platformType);
        switch (state)
        {
            case SSDKResponseStateBegin:
                [ProgressHUD show:nil Interaction:NO Hide:NO];
                break;
            case SSDKResponseStateSuccess:
            {
                NSMutableArray *shared = [[NSUserDefaults standardUserDefaults] objectForKey:sharedItem];
                BOOL sharedContain = NO;
                for (NSNumber *item in shared)
                {
                    if (platformType == [item integerValue])
                    {
                        sharedContain = YES;
                        break;
                    }
                }
                if (!shared || !sharedContain)
                {
                    [ProgressHUD showText:@"分享成功" Interaction:YES Hide:YES];
                    //[wself addMarkByShare:platformType];
                }
                else
                {
                    [ProgressHUD showText:@"分享成功" Interaction:YES Hide:YES];
                }
            }
                break;
            case SSDKResponseStateFail:
                [ProgressHUD showText:@"分享失败" Interaction:YES Hide:YES];
                break;
            default:
                [ProgressHUD showText:@"取消分享" Interaction:YES Hide:YES];
                break;
        }
    }];
    [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];
}

- (void)pressedSignUp
{
    /*BOOL addMark = [[NSUserDefaults standardUserDefaults] boolForKey:addUserMarkByLogin];
    if (!addMark) {
        [ProgressHUD showText:@"你已获取签到臭美币，不能重复获取" Interaction:YES Hide:YES];
        return;
    }
    [ProgressHUD show:nil Interaction:NO Hide:NO];
    __weak typeof(self)wself = self;
    [PersonalPageNetwork addScoreWithType:@"login" withUserID:User.userID withSuccessBlock:^(BOOL finished, NSString *score) {
        if (finished) {
            User.score = score;
            [wself.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            NSMutableDictionary *userInfoDic = [NSKeyedUnarchiver unarchiveObjectWithFile:UserInfoFilePath];
            [userInfoDic setObject:score forKey:@"score"];
            [NSKeyedArchiver archiveRootObject:userInfoDic toFile:UserInfoFilePath];
            [wself.tableView reloadData];
            [ProgressHUD showText:@"签到成功" Interaction:YES Hide:YES];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:addUserMarkByLogin];
        }
        else {
            [ProgressHUD showText:@"你已获取签到臭美币，不能重复获取" Interaction:YES Hide:YES];
        }
    } withErrBlock:^(NSError *err) {
        [ProgressHUD showText:@"增加臭美币失败" Interaction:YES Hide:YES];
    }];*/
    
    UIViewController *recharge = [[RechargeTableViewController alloc] init];
    recharge.title = @"臭美币充值";
    //[self.navigationController pushViewController:recharge animated:YES];
    recharge.edgesForExtendedLayout = UIRectEdgeNone;
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    [self.navigationController pushViewController:recharge animated:YES];
}

- (void)addMarkByShare:(SSDKPlatformType)platformType
{
    __weak typeof(self)wself = self;
    [PersonalPageNetwork addScoreWithType:@"share" withUserID:User.userID withSuccessBlock:^(BOOL finished, NSString *score)
    {
        if (finished)
        {
            User.money = score;
            wself.point = User.money;
            [wself.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            NSMutableDictionary *userInfoDic = [NSKeyedUnarchiver unarchiveObjectWithFile:UserInfoFilePath];
            [userInfoDic setObject:score forKey:@"score"];
            [NSKeyedArchiver archiveRootObject:userInfoDic toFile:UserInfoFilePath];
            //[ProgressHUD showText:@"分享臭美币获取成功" Interaction:YES Hide:YES];
            NSMutableArray *shared = [[NSUserDefaults standardUserDefaults] objectForKey:sharedItem];
            if (!shared) {
                shared = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInteger:platformType], nil];
            }
            else {
                [shared addObject:[NSNumber numberWithInteger:platformType]];
            }
            [[NSUserDefaults standardUserDefaults] setObject:shared forKey:sharedItem];
        }
        else
        {
            [ProgressHUD showText:@"你的分享臭美币已全部获取，不能重复获取" Interaction:YES Hide:YES];
        }
    } withErrBlock:^(NSError *err) {
        [ProgressHUD showText:@"增加臭美币失败" Interaction:YES Hide:YES];
    }];
}

@end
