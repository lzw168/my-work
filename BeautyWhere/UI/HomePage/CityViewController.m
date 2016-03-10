//
//  CityViewController.m
//  BeautyWhere
//
//  Created by Michael on 15/8/3.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "CityViewController.h"
#import "HomePageNetwork.h"
#import "CityBean.h"

@interface CityViewController ()

@property (nonatomic, strong) NSArray *cityListFromServer;

@end

@implementation CityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = NavBarColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIImage *backImg = [UIImage imageNamed:@"nav-btn-fanhui.png"];
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, backImg.size.width, backImg.size.height)];
    [back setImage:backImg forState:UIControlStateNormal];
    [back addTarget:self action:@selector(pressedBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navBack = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = navBack;
    [self startNet];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Net
- (void)startNet
{
    [ProgressHUD showText:@"获取中...." Interaction:YES Hide:NO];
    __weak typeof(self) wself = self;
    NSLog(@"self.Province===========%@",self.Province);
    [HomePageNetwork getCityListWithSuccessBlock:self.Province withSuccessBlock:^(NSArray *cityArr)
    {
        [ProgressHUD dismiss];
        NSLog(@"cityArr===========%@",cityArr);
        self.cityListFromServer = cityArr;
        [wself.tableView reloadData];
    } withErrorBlock:^(NSError *err)
    {
        NSLog(@"网络获取省份列表出错：%@",err);
        [ProgressHUD showText:@"获取失败，请检查网络后稍后再试" Interaction:YES Hide:YES];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3+self.cityListFromServer.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Reuse"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Reuse"];
    }
    if (row == 0 || row == 2)
    {
        cell.backgroundColor = [UIColor lightGrayColor];
        cell.textLabel.text = row==0?@"GPS定位城市:":@"已开通服务的城市:";
    }
    else if (row == 1) {
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.text = self.locatedCity;
    }
    else {
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.text = ((CityBean*)[self.cityListFromServer objectAtIndex:row-3]).cityName;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row==0||indexPath.row==2)?32:44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell.textLabel.text || [cell.textLabel.text isEqualToString:@""] || indexPath.row == 0 || indexPath.row == 2)
    {
        return;
    }
    NSLog(@"cell.textLabel.text===========%@",cell.textLabel.text);
    [[NSUserDefaults standardUserDefaults] setObject:cell.textLabel.text forKey:@"useraddress"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.controller updatePositionBtnTitle:cell.textLabel.text];
    [self pressedBack];
}

#pragma mark - Button Response
- (void)pressedBack
{
    [ProgressHUD dismiss];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private & Tool
- (void)updateLocatedCity:(NSString *)city
{
    self.locatedCity = city;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

@end
