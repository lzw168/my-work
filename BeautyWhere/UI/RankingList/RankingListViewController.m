//
//  RankingList.m
//  BeautyWhere
//
//  Created by Michael on 15-7-21.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "RankingListViewController.H"
#import "UserBean.h"
#import "UIImageView+AFNetworking.h"
#import "ChangeUserInfoViewController.h"
#import "CouponDetailViewController.h"
#import "CollectionDetailViewController.h"
#import "PersonalPageNetwork.h"
#import "IntegralTableViewController.h"
#import "InformationViewController.h"
#import "AddMyAddressViewController.h"

@interface RankingListViewController ()

@property (nonatomic, weak) UserBean *user;
@property (nonatomic, strong) NSArray *nickname;
@property (nonatomic, strong) NSArray *moneycount;
@end

@implementation RankingListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nickname = @[@"steven", @"steven",@"steven",@"steven",@"steven",@"steven", @"steven",@"steven",@"steven",@"steven"];
    self.moneycount = @[@"臭美币88888个", @"臭美币88888个",@"臭美币88888个", @"臭美币88888个",@"臭美币88888个",@"臭美币88888个", @"臭美币88888个",@"臭美币88888个", @"臭美币88888个",@"臭美币88888个"];
    self.tableView.scrollEnabled = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tableView.backgroundColor = [UIColor whiteColor];
    UIColor *color = [[UIColor alloc]initWithRed:242/255.0 green:243/255.0 blue:238/255.0 alpha:1];
    self.view.backgroundColor = color;
    //self.tableView.tableFooterView.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"User:%@",User);
    NSLog(@"User.userID:%@",User.userID);
    if (!User || !User.userID)
    {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.edgesForExtendedLayout = UIRectEdgeNone;
        login.backItemType = BackItemTypeNone;
        login.enterType = EnterTypePush;
        [self.navigationController pushViewController:login animated:NO];
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentify"];
    CGSize cellSize = [tableView rectForRowAtIndexPath:indexPath].size;
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reuseIdentify"];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, cellSize.height-2, ScreenWidth-30, 2)];
        UIColor *color = [[UIColor alloc]initWithRed:242/255.0 green:243/255.0 blue:238/255.0 alpha:1];
        line.backgroundColor = color;
        if (indexPath.row == 0)
        {
            UIImageView *rankimage = [[UIImageView alloc]init];
            UIImage * image = [UIImage imageNamed:@"rankimg.png"];
            [rankimage setFrame:CGRectMake(30, 10, image.size.width/4, image.size.height/4)];
            rankimage.image = image;
            [cell.contentView addSubview:rankimage];
        }
        [cell.contentView addSubview:line];
    }
    
    if (indexPath.row == 0)
    {
    }
    else
    {
        UIView *content = [[UIView alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth-30, 38)];
        content.backgroundColor = [UIColor whiteColor];
        UILabel *numlabel = [[UILabel alloc]init];
        [numlabel setFrame:CGRectMake(10, 14, 10, 10)];
        [numlabel setFont:[UIFont systemFontOfSize:13.0]];
        [numlabel setText:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        [content addSubview:numlabel];
        
        UILabel *nicknamelabel = [[UILabel alloc]init];
        [nicknamelabel setFrame:CGRectMake(50, 14, 50, 10)];
        [nicknamelabel setFont:[UIFont systemFontOfSize:13.0]];
        [nicknamelabel setText:[self.nickname objectAtIndex:indexPath.row]];
        [content addSubview:nicknamelabel];
        
        UILabel *moneycountlabel = [[UILabel alloc]init];
        [moneycountlabel setFrame:CGRectMake(130, 14, 100, 10)];
        [moneycountlabel setFont:[UIFont systemFontOfSize:13.0]];
        [moneycountlabel setText:[self.moneycount objectAtIndex:indexPath.row]];
        [content addSubview:moneycountlabel];
        
        if (indexPath.row == 1||indexPath.row == 2|| indexPath.row == 3)
        {
            UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(content.frame.size.width-30, 6, 52/2, 52/2)];
            [pic setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"",@""]] placeholderImage:[UIImage imageNamed:@"champion.png"]];
            [content addSubview:pic];
        }
        
       [cell.contentView addSubview:content];
    }
    
    /*UIImageView *Image = (UIImageView*)[cell.contentView viewWithTag:numberLabelTag];
    UIImage *logoImg = [UIImage imageNamed:@"icon_circle_ok.png"];
    Image.image = logoImg;
    [Image sizeToFit];
    Image.frame = CGRectMake(cellSize.width-Image.frame.size.width-50, (cellSize.height-Image.frame.size.height)/2, Image.frame.size.width, Image.frame.size.height);
    [cell.contentView addSubview:Image];*/
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
            break;

        case 3:
            targetViewController = [[IntegralTableViewController alloc] init];
            targetViewController.title = @"臭美币获取";
            ((IntegralTableViewController*)targetViewController).point = User.score;
            break;
        case 4:
            targetViewController = [[InformationViewController alloc] init];
            targetViewController.title = @"我的收货地址";
            break;
    }
    if (targetViewController)
    {
        targetViewController.edgesForExtendedLayout = UIRectEdgeNone;
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
        [self.navigationController pushViewController:targetViewController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 108;
    }
    else
    {
        return 40;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [ProgressHUD showText:@"删除操作" Interaction:YES Hide:YES];
    //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    return;
}

-(void)pressedAdd
{
    //[ProgressHUD showText:@"弹出新增界面" Interaction:YES Hide:YES];
    AddMyAddressViewController * addmyaddr = [[AddMyAddressViewController alloc]init];
    addmyaddr.title = @"新建收货地址";
    [self.navigationController pushViewController:addmyaddr animated:YES];
}

@end
