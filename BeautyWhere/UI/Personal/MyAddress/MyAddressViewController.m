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

@interface MyAddressViewController ()

@property (nonatomic, weak) UserBean *user;
@property (nonatomic, strong) NSArray *detailArr;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *mobileArr;
@end

@implementation MyAddressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.detailArr = @[@"广州市越秀区龟岗大马路江岭东", @"广州市越秀区龟岗大马路江岭东",@"广州市越秀区龟岗大马路江岭东",@"广州市越秀区龟岗大马路江岭东",@"广州市越秀区龟岗大马路江岭东"];
    self.titleArr = @[@"steven", @"steven",@"steven", @"steven",@"steven"];
    self.mobileArr = @[@"13560242703",@"13560242703",@"13560242703",@"13560242703",@"13560242703"];
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
    NSLog(@"User.userID:%@",User.userID);
    if (!User || !User.userID) {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.edgesForExtendedLayout = UIRectEdgeNone;
        login.backItemType = BackItemTypeNone;
        login.enterType = EnterTypePush;
        [self.navigationController pushViewController:login animated:NO];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    UIViewController *targetViewController = nil;
    targetViewController = [[AddMyAddressViewController alloc] init];
    targetViewController.title = @"修改收货地址";
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
    [ProgressHUD showText:@"删除操作" Interaction:YES Hide:YES];
    //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    return;
}

-(void)pressedAdd
{
    //[ProgressHUD showText:@"弹出新增界面" Interaction:YES Hide:YES];
    AddMyAddressViewController * addmyaddr = [[AddMyAddressViewController alloc]init];
    addmyaddr.title = @"新建收货地址";
    addmyaddr.edgesForExtendedLayout = UIRectEdgeNone;
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    [self.navigationController pushViewController:addmyaddr animated:YES];
}

@end
