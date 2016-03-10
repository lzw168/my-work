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
#import "RankPageNetwork.h"

@interface RankingListViewController ()

@property (nonatomic, weak) UserBean *user;
@property (nonatomic, strong) NSMutableArray *nickname;
@property (nonatomic, strong) NSMutableArray *moneycount;
@property (nonatomic, strong) NSMutableArray *orderArray;
@property (nonatomic, strong) UIImageView *imageview;
@property (nonatomic, strong) UILabel *tip;
@end

@implementation RankingListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nickname = [[NSMutableArray alloc] init];
    self.moneycount = [[NSMutableArray alloc] init];
    self.orderArray = [[NSMutableArray alloc] init];
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
    
    NSUserDefaults *rank_visitor = [NSUserDefaults standardUserDefaults];
    NSString *rankvisitor= [rank_visitor objectForKey:@"rank_visitor"];
    NSLog(@"rankvisitor=============%@",rankvisitor);
    if([GetAppDelegate.rank_visitor isEqualToString:@"1"])
    {
        if([GetAppDelegate.rank_visitor isEqualToString:rankvisitor])
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"加入排行榜需要收集用户数据，是否加入排行榜？" preferredStyle:  UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"rank_visitor"];
                [[NSUserDefaults standardUserDefaults] synchronize];

                //点击按钮的响应事件
                NSLog(@"User:%@",User);
                NSLog(@"User.userID---------4:%@",User.userID);
                if (!User || !User.userID)
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
                }
            }]];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
            {
                //点击按钮的响应事件
                [alert removeFromParentViewController];
                [self.navigationController popToRootViewControllerAnimated:YES];
                return;
            }]];
            
            //弹出提示框:
            [self presentViewController:alert animated:true completion:nil];
            return;
        }
    }
    
    NSLog(@"User:%@",User);
    NSLog(@"User.userID---------4:%@",User.userID);
    if (!User || !User.userID)
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
    }
    //[self.tableView reloadData];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.nickname removeAllObjects];
    [self.orderArray removeAllObjects];
    [self.moneycount removeAllObjects];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.nickname count];
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
        [cell.contentView addSubview:line];
    }
    
    UIView *content = [[UIView alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth-30, 38)];
    content.backgroundColor = [UIColor whiteColor];
    UILabel *numlabel = [[UILabel alloc]init];
    [numlabel setFrame:CGRectMake(10, 14, 10, 10)];
    [numlabel setFont:[UIFont systemFontOfSize:13.0]];
    [numlabel setText:[self.orderArray objectAtIndex:indexPath.row]];
    [content addSubview:numlabel];
    
    UILabel *nicknamelabel = [[UILabel alloc]init];
    [nicknamelabel setFrame:CGRectMake(30, 12, 100, 15)];
    [nicknamelabel setFont:[UIFont systemFontOfSize:13.0]];
    [nicknamelabel setText:[self.nickname objectAtIndex:indexPath.row]];
    [content addSubview:nicknamelabel];
    
    UILabel *moneycountlabel = [[UILabel alloc]init];
    [moneycountlabel setFrame:CGRectMake(140, 14, 120, 10)];
    [moneycountlabel setFont:[UIFont systemFontOfSize:13.0]];
    [moneycountlabel setText:[self.moneycount objectAtIndex:indexPath.row]];
    [content addSubview:moneycountlabel];
    
    if (indexPath.row == 0)
    {
        UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(content.frame.size.width-30, 6, 52/2, 52/2)];
        [pic setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",GetAppDelegate.img_path,GetAppDelegate.img1]] placeholderImage:[UIImage imageNamed:@"champion.png"]];
        [content addSubview:pic];
    }
    
    if (indexPath.row == 1)
    {
        UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(content.frame.size.width-30, 6, 52/2, 52/2)];
        [pic setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",GetAppDelegate.img_path,GetAppDelegate.img2]] placeholderImage:[UIImage imageNamed:@"champion.png"]];
        [content addSubview:pic];
    }
    
    if (indexPath.row == 2)
    {
        UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(content.frame.size.width-30, 6, 52/2, 52/2)];
        [pic setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",GetAppDelegate.img_path,GetAppDelegate.img3]] placeholderImage:[UIImage imageNamed:@"champion.png"]];
        [content addSubview:pic];
    }
    
    [cell.contentView addSubview:content];
    
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
    return;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 40;
    }
    else
    {
        return 40;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 425*RatioWidth;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    __autoreleasing UIView *view = [[UIView alloc] init];
    UIImageView *rankimage = [[UIImageView alloc]init];
    UIImage * image = [UIImage imageNamed:@"rankimg.png"];
    [rankimage setFrame:CGRectMake(30*RatioWidth, 10*RatioHeight, image.size.width*RatioWidth, image.size.height*RatioHeight)];
    rankimage.image = image;
    [view addSubview:rankimage];
    return view;
}

-(void)pressedAdd
{
    //[ProgressHUD showText:@"弹出新增界面" Interaction:YES Hide:YES];
    AddMyAddressViewController * addmyaddr = [[AddMyAddressViewController alloc]init];
    addmyaddr.title = @"新建收货地址";
    [self.navigationController pushViewController:addmyaddr animated:YES];
}

#pragma mark - Net
- (void)startNet
{
    __weak typeof(self) wself = self;
    [RankPageNetwork showRank:^(NSMutableDictionary *RankDic)
     {
         [ProgressHUD dismiss];
         /*[self.nickname removeAllObjects];
         [self.orderArray removeAllObjects];
         [self.moneycount removeAllObjects];*/
         [self.nickname addObject:[NSString stringWithFormat:@"%@",[RankDic objectForKey:@"name"]]];
         [self.moneycount addObject:[NSString stringWithFormat:@"臭美币%0.1f个",[[RankDic objectForKey:@"money"]intValue]/100.00]];
         [self.orderArray addObject:[NSString stringWithFormat:@"%d",[[RankDic objectForKey:@"order"]intValue]]];
         NSLog(@"排行榜===================%@",[RankDic objectForKey:@"name"]);
         [wself.tableView reloadData];
     } withErrorBlock:^(NSError *err)
     {
         //[ProgressHUD showText:@"获取失败，请检查网络后稍后再试" Interaction:YES Hide:YES];
         [self showNoDataTip:YES];
     }];
}

#pragma mark - Private & Tool
- (void)showNoDataTip:(BOOL)show
{
    [ProgressHUD dismiss];
    if (show)
    {
        if (!self.imageview)
        {
            self.imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
            self.imageview.image = [UIImage imageNamed:@"nodata"];
            self.imageview.center = self.view.center;
            [self.view addSubview:self.imageview];
        }
        
        if (!self.tip)
        {
            self.tip = [[UILabel alloc] initWithFrame:CGRectMake(self.imageview.frame.origin.x-50, self.imageview.frame.origin.y+70, 200, 100)];
            self.tip.text = @"亲,没有内容哦~";
            self.tip.textAlignment = NSTextAlignmentCenter;
            [self.tip setTextColor:[UIColor colorWithRed:129.0/255.0 green:129.0/255.0 blue:129.0/255.0 alpha:1.0]];
            [self.view addSubview:self.tip];
        }
    }
    else
    {
        [self.view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
         {
             if ([obj isKindOfClass:[UILabel class]] && [((UILabel*)obj).text isEqualToString:@"亲,没有内容哦~"]) {
                 [obj removeFromSuperview];
             }
         }];
    }
}

@end
