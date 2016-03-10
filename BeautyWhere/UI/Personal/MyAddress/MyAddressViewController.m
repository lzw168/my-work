//
//  PersonalViewController.m
//  BeautyWhere
//
//  Created by Michael on 15-7-21.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "MyAddressViewController.h"
#import "UserBean.h"
#import "UIImageView+AFNetworking.h"
#import "ChangeUserInfoViewController.h"
#import "CouponDetailViewController.h"
#import "CollectionDetailViewController.h"
#import "PersonalPageNetwork.h"
#import "IntegralTableViewController.h"
#import "InformationViewController.h"
#import "AddMyAddressViewController.h"
#import "AddressPageNetwork.h"
#import "AddressBean.h"

@interface MyAddressViewController ()

@property (nonatomic, weak) UserBean *user;
@property (nonatomic, strong) NSMutableArray *detailArr;
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, strong) NSMutableArray *mobileArr;
@property (nonatomic, strong) NSMutableArray *addressidArr;
@property (nonatomic, strong) NSMutableArray *regionArr;
@end

@implementation MyAddressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.detailArr = [[NSMutableArray alloc]init];
    self.titleArr = [[NSMutableArray alloc]init];
    self.mobileArr = [[NSMutableArray alloc]init];
    self.addressidArr = [[NSMutableArray alloc]init];
    self.regionArr = [[NSMutableArray alloc]init];
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tableView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    //self.tableView.tableFooterView.backgroundColor = [UIColor whiteColor];
    
    UIButton *send = [[UIButton  alloc] initWithFrame:CGRectMake(0, 0, 45/2, 45/2)];
    //[send setTitle:@"添加新地址" forState:UIControlStateNormal];
    //send.layer.cornerRadius = 5;
    //send.backgroundColor = [UIColor clearColor];
    [send setImage:[UIImage imageNamed:@"add_address.png"] forState:UIControlStateNormal];
    //[UIColor colorWithRed:255.0/255.0 green:79.0/255.0 blue:3.0/255.0 alpha:1.0];
    send.titleLabel.font = [UIFont systemFontOfSize:13];
    [send addTarget:self action:@selector(pressedAdd) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:send];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"User:%@",User);
    NSLog(@"User.userID----2:%@",User.userID);
    if (!User || !User.userID)
    {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.edgesForExtendedLayout = UIRectEdgeNone;
        login.backItemType = BackItemTypeNone;
        login.enterType = EnterTypePush;
        [self.navigationController pushViewController:login animated:NO];
    }
    //[self.tableView reloadData];
    [self.titleArr removeAllObjects];
    [self.mobileArr removeAllObjects];
    [self.detailArr removeAllObjects];
    [self.addressidArr removeAllObjects];
    [self.regionArr removeAllObjects];
    [self startNet];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentify"];
    CGSize cellSize = [tableView rectForRowAtIndexPath:indexPath].size;
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reuseIdentify"];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, cellSize.height-0.5, ScreenWidth, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:line];
        //UIImageView *number = [[UIImageView alloc] init];
        //number.tag = numberLabelTag;
    }
    
    NSString * NameAndMob = [NSString stringWithFormat:@"%@(%@)",[self.titleArr objectAtIndex:indexPath.row],[self.mobileArr objectAtIndex:indexPath.row]];
    cell.detailTextLabel.text= [self.detailArr objectAtIndex:indexPath.row];
    cell.textLabel.text = NameAndMob;
    
    /*UIImageView *Image = (UIImageView*)[cell.contentView viewWithTag:numberLabelTag];
    UIImage *logoImg = [UIImage imageNamed:@"icon_circle_ok.png"];
    Image.image = logoImg;
    [Image sizeToFit];
    Image.frame = CGRectMake(cellSize.width-Image.frame.size.width-50, (cellSize.height-Image.frame.size.height)/2, Image.frame.size.width, Image.frame.size.height);
    [cell.contentView addSubview:Image];*/
    
    if (indexPath.row == 0)
    {
        UIColor *color = [[UIColor alloc]initWithRed:92/255.0 green:106/255.0 blue:133/255.0 alpha:1];
        //通过RGB来定义自己的颜色
        cell.backgroundColor = color;
        
        GetAppDelegate.receiver = [self.titleArr objectAtIndex:indexPath.row];
        GetAppDelegate.mobile = [self.mobileArr objectAtIndex:indexPath.row];
        GetAppDelegate.location = [self.detailArr objectAtIndex:indexPath.row];
        GetAppDelegate.addressid = [self.addressidArr objectAtIndex:indexPath.row];
        
        [[NSUserDefaults standardUserDefaults] setObject:GetAppDelegate.receiver forKey:Reciver];
        [[NSUserDefaults standardUserDefaults] setObject:GetAppDelegate.mobile forKey:Mobile];
        [[NSUserDefaults standardUserDefaults] setObject:GetAppDelegate.location forKey:Location];
        [[NSUserDefaults standardUserDefaults] setObject:GetAppDelegate.addressid forKey:AddressID];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
    else
    {
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    if (indexPath.row == 0)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddMyAddressViewController *targetViewController = nil;
    targetViewController = [[AddMyAddressViewController alloc] init];
    targetViewController.editstatus = @"1";
    targetViewController.title = @"修改收货地址";
    targetViewController.addressid = [self.addressidArr objectAtIndex:indexPath.row];
    targetViewController.mobile = [self.mobileArr objectAtIndex:indexPath.row];
    targetViewController.location = [self.detailArr objectAtIndex:indexPath.row];
    targetViewController.reciver = [self.titleArr objectAtIndex:indexPath.row];
    targetViewController.MyAddress = [self.regionArr objectAtIndex:indexPath.row];
    if (indexPath.row == 0)
    {
        targetViewController.is_default = @"1";
    }
    else
    {
        targetViewController.is_default = @"0";
    }
    targetViewController.edgesForExtendedLayout = UIRectEdgeNone;
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
        [self.navigationController pushViewController:targetViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 62;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 85;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[ProgressHUD showText:@"删除操作" Interaction:YES Hide:YES];
    //[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    if ([self.addressidArr count] == 0)
    {
        [self.tableView reloadData];
        return;
    }
    [self deladdress:[self.addressidArr objectAtIndex:indexPath.row]];
    return;
}

-(void)pressedAdd
{
    //[ProgressHUD showText:@"弹出新增界面" Interaction:YES Hide:YES];
    AddMyAddressViewController * addmyaddr = [[AddMyAddressViewController alloc]init];
    addmyaddr.editstatus = @"0";
    addmyaddr.title = @"新建收货地址";
    addmyaddr.hidesBottomBarWhenPushed = YES;
    addmyaddr.edgesForExtendedLayout = UIRectEdgeNone;
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    [self.navigationController pushViewController:addmyaddr animated:YES];
}

#pragma mark - Net
- (void)startNet
{
    __weak typeof(self) wself = self;
    [AddressPageNetwork showAddress:^(NSMutableDictionary *RankDic)
     {
         [ProgressHUD dismiss];
         if (RankDic == nil || RankDic == NULL)
         {
             //[ProgressHUD showText:@"请设置收货地址" Interaction:YES Hide:YES];
             [self.tableView reloadData];
             return;
         }
         
         AddressBean *address = [[AddressBean alloc] initWithDic:RankDic];
         [self.detailArr addObject:[NSString stringWithFormat:@"%@",[RankDic objectForKey:@"location"]]];
         [self.titleArr addObject:[NSString stringWithFormat:@"%@",[RankDic objectForKey:@"receiver"]]];
         [self.mobileArr addObject:[NSString stringWithFormat:@"%@",[RankDic objectForKey:@"mobile"]]];
         [self.addressidArr addObject:[NSString stringWithFormat:@"%d",address.addressid]];
         [self.regionArr addObject:address.region];
         NSLog(@"addressidArr===============%d",address.addressid);
         [wself.tableView reloadData];
     } withErrorBlock:^(NSError *err)
     {
         [ProgressHUD showText:@"获取失败，请检查网络后稍后再试" Interaction:YES Hide:YES];
     }];
}

#pragma mark - Net
- (void)deladdress:(NSString *)AddressId
{
    [AddressPageNetwork DelAddressWithAddressId:[AddressId intValue] withSuccessBlock:^(BOOL finished)
     {
         if (finished)
         {
             //[ProgressHUD showText:@"删除收货地址成功" Interaction:YES Hide:YES];
             [self.titleArr removeAllObjects];
             [self.mobileArr removeAllObjects];
             [self.detailArr removeAllObjects];
             [self.addressidArr removeAllObjects];
             [self.regionArr removeAllObjects];
             [self startNet];
         }
         else
         {
             [ProgressHUD showText:@"删除收货地址失败" Interaction:YES Hide:YES];
         }
     } withErrorBlock:^(NSError *err)
     {
         [ProgressHUD showText:@"获取失败，请检查网络后稍后再试" Interaction:YES Hide:YES];
     }];
}

@end
