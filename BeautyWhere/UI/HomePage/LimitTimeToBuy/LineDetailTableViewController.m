//
//  LineDetailTableViewController.m
//  BeautyWhere
//
//  Created by Michael on 15/8/21.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "LineDetailTableViewController.h"
#import "UIImageView+AFNetworking.h"
#import "PayBillTableViewController.h"
#import "IntegralTableViewController.h"
#import "RechargeTableViewController.h"

@interface LineDetailTableViewController ()

@property (nonatomic, strong) GoodsBean *goods;
@property (nonatomic, assign) BOOL hideBuy;
@property (nonatomic) int goodnum;
@property (nonatomic, strong) UILabel *num;
@property (nonatomic, strong) UILabel *textlabel;
@property (nonatomic) float total;
@property (nonatomic, strong) NSString *AddressId;
@property (nonatomic, strong) UILabel *Deslabel;
@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, strong) UIWebView *provision;

@end

@implementation LineDetailTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"购买确认";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.delegate = self;
    self.goodnum = 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section==0?2:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.textLabel.text = @"";
    switch (indexPath.section)
    {
        case 0:
            switch (indexPath.row)
        {
            case 0:
            {
                UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, CellHeight-20, CellHeight-20)];
                [pic setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",GetAppDelegate.img_path, self.goods.img_thumb]] placeholderImage:[UIImage imageNamed:@"pic_2loading.png"]];
                [cell.contentView addSubview:pic];
                
                UILabel *pricelab = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 100, 20)];
                pricelab.text = [NSString stringWithFormat:@"%@",self.goods.name];
                pricelab.textColor = [UIColor grayColor];
                [cell.contentView addSubview:pricelab];
                
                UIButton *reduce = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-75, 20, 25, 25)];
                [reduce setTitle:@"-" forState:UIControlStateNormal];
                [reduce setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                reduce.backgroundColor = [UIColor orangeColor];
                [reduce addTarget:self action:@selector(ReduceBtn) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:reduce];
                
                self.num = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-50, 25, 20, 20)];
                [self.num setText:[NSString stringWithFormat:@"%d",self.goodnum]];
                [self.num setFont:[UIFont systemFontOfSize:13.0]];
                [self.num setTextAlignment:NSTextAlignmentCenter];
                [cell.contentView addSubview:self.num];
                
                UIButton *add = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-30, 20, 25, 25)];
                [add setTitle:@"+" forState:UIControlStateNormal];
                [add setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                add.backgroundColor = [UIColor orangeColor];
                [add addTarget:self action:@selector(AddBtn) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:add];
            }
                switch (self.goodsOnSellsType)
            {
                case CheckGoodsOnSellsTypeLimitToFactory:
                {
                    UILabel *pricelab = [[UILabel alloc]initWithFrame:CGRectMake(50, 30, ScreenWidth-25, 20)];
                    pricelab.text = [NSString stringWithFormat:@"￥%@个臭美币",self.goods.goods_price];
                    pricelab.font = [UIFont systemFontOfSize:13.0];
                    [cell.contentView addSubview:pricelab];
                }
                    break;
                default:
                {
                    UILabel *pricelab = [[UILabel alloc]initWithFrame:CGRectMake(50, 30, ScreenWidth-25, 20)];
                    pricelab.text = [NSString stringWithFormat:@"￥%@个臭美币",self.goods.goods_price];
                    pricelab.font = [UIFont systemFontOfSize:13.0];
                    pricelab.textColor = [UIColor redColor];
                    [cell.contentView addSubview:pricelab];
                }
                    break;
            }
                cell.textLabel.textColor = BottomMenuSelectedColor;
                break;
            case 1:
            {
                self.textlabel = [[UILabel alloc]init];
                [self.textlabel setFrame:CGRectMake(25, CellHeight/2-25, ScreenWidth-25, 30)];
                self.total = [self.goods.goods_price floatValue]* self.goodnum;
                NSString *Totaltext = [NSString stringWithFormat: @"合计:￥%0.1f个臭美币",self.total];
                self.textlabel.text = Totaltext;
                [cell.contentView addSubview:self.textlabel];
                
                UILabel *deslabel = [[UILabel alloc]init];
                [deslabel setFrame:CGRectMake(25, CellHeight/2-5, ScreenWidth-25, 30)];
                deslabel.font = [UIFont systemFontOfSize:13.0];
                deslabel.textColor = [UIColor grayColor];
                deslabel.text = @"(1个臭美币等于1元人民币)";
                [cell.contentView addSubview:deslabel];
            }
                cell.textLabel.textColor = BottomMenuSelectedColor;
                if (!self.hideBuy)
                {
                    UIButton *buy = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-5-(CellHeight+20), 15, (CellHeight-20)*2, CellHeight-30)];
                    [buy setTitle:@"立即购买" forState:UIControlStateNormal];
                    [buy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    buy.backgroundColor = [UIColor orangeColor];
                    [buy addTarget:self action:@selector(pressedBuy) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:buy];
                }
                break;
        }
            break;
        case 1:
            /*cell.textLabel.text = self.goods.goodsIntro;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.font = [UIFont systemFontOfSize:13.0];*/
        {
            cell.contentView.backgroundColor = [UIColor whiteColor];
            [ProgressHUD show:nil Interaction:YES Hide:NO];
            self.provision = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 10)];
            self.provision.scalesPageToFit = YES;
            self.provision.scrollView.bounces = NO;
            self.provision.scrollView.showsHorizontalScrollIndicator = NO;
            self.provision.scrollView.scrollEnabled = NO;
            self.provision.delegate = self;
            //[self.view addSubview:self.provision];
            if (!self.urlStr)
            {
                self.urlStr = [NSString stringWithFormat:@"%@%@%@",Server_RequestHost, @"Index/showGoodsPage?goods_id=",self.goods.goodsID];
            }
            [self.provision loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
            [cell.contentView addSubview:self.provision];
        }
            break;
    }
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section==0?nil:@"商品详情";
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
            switch (indexPath.row)
        {
            case 0:
                return 60;
                break;
            case 1:
                return 60;
                break;
            default:
                return 60;
                break;
        }
            break;
        case 1:
            return ScreenHeight*2.38;
            //return self.provision.scrollView.contentSize.height;
            break;
        default:
            return 10+[self.goods.goodsIntro boundingRectWithSize:CGSizeMake(ScreenWidth-20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                }
                break;
            }
        }
            break;
    };
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Button Response
- (void)pressedBuy
{
    /*if (self.goodsOnSellsType == CheckGoodsOnSellsTypeInStore)
    {
        PayBillTableViewController *payBill = [[PayBillTableViewController alloc] initWithGoods:self.goods withGoodsOnSellsType:self.goodsOnSellsType];
        payBill.edgesForExtendedLayout = UIRectEdgeNone;
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
        [self.navigationController pushViewController:payBill animated:YES];
    }
    else
    {
        [ProgressHUD show:nil];
        NSString * type = @"1";
        if(self.goodsOnSellsType == CheckGoodsOnSellsTypeLimitToFactory)
        {
            type = @"2";
        }
        NSLog(@"self.goods.actID===========%@",self.goods.actID);
        [HomePageNetwork checkGoodsOnSellOrNotWithGoodsID:self.goods.actID withType:self.goodsOnSellsType withSuccessBlock:^(BOOL finished)
         {
             if (finished)
             {
                 [ProgressHUD dismiss];
                 PayBillTableViewController *payBill = [[PayBillTableViewController alloc] initWithGoods:self.goods withGoodsOnSellsType:self.goodsOnSellsType];
                 payBill.edgesForExtendedLayout = UIRectEdgeNone;
                 [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
                 [self.navigationController pushViewController:payBill animated:YES];
             }
             else
             {
                 [ProgressHUD showText:@"不能购买" Interaction:YES Hide:YES];
             }
         } withErrorBlock:^(NSError *err)
         {
             [ProgressHUD showText:@"购买失败" Interaction:YES Hide:YES];
         }];
    }*/
    [ProgressHUD show:nil];
    [HomePageNetwork checkGoodsOnSellOrNotWithGoodsID:self.goods.goodsID withType:self.goodsOnSellsType withGoodsNum:[NSString stringWithFormat:@"%d",self.goodnum] withSuccessBlock:^(BOOL finished)
     {
         if (finished)
         {
             [ProgressHUD dismiss];
             /*PayBillTableViewController *payBill = [[PayBillTableViewController alloc] initWithGoods:self.siglegoods withGoodsOnSellsType:self.goodsOnSellsType];
              payBill.edgesForExtendedLayout = UIRectEdgeNone;
              [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
              [self.navigationController pushViewController:payBill animated:YES];*/
             UIViewController *recharge = [[RechargeTableViewController alloc] init];
             recharge.title = @"臭美币充值";
             //[self.navigationController pushViewController:recharge animated:YES];
             recharge.edgesForExtendedLayout = UIRectEdgeNone;
             [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
             [self.navigationController pushViewController:recharge animated:YES];

         }
         else
         {
             [ProgressHUD showText:@"不能购买" Interaction:YES Hide:YES];
         }
     } withErrorBlock:^(NSError *err)
     {
         [ProgressHUD showText:@"购买失败" Interaction:YES Hide:YES];
     }];
}

#pragma mark - Tool
- (void)hideBuyBtn
{
    self.hideBuy = YES;
}

- (void)AddBtn
{
    self.goodnum ++;
    self.num.text = [NSString stringWithFormat:@"%d",self.goodnum];
    float total = [self.goods.goods_price floatValue]* self.goodnum;
    NSString *Totaltext = [NSString stringWithFormat: @"合计:￥%0.1f元",total];
    self.textlabel.text = Totaltext;
    NSString *des = @"快递 包邮";
    if(self.goodnum<[GetAppDelegate.fee_shipping_num intValue])
    {
        des = @"邮费到付";
    }
    self.Deslabel.text = des;
}

- (void)ReduceBtn
{
    if (self.goodnum == 1)
    {
        return;
    }
    self.goodnum --;
    self.num.text = [NSString stringWithFormat:@"%d",self.goodnum];
    float total = [self.goods.goods_price floatValue]* self.goodnum;
    NSString *Totaltext = [NSString stringWithFormat: @"合计:￥%0.1f元",total];
    self.textlabel.text = Totaltext;
    NSString *des = @"快递 包邮";
    if(self.goodnum<[GetAppDelegate.fee_shipping_num intValue])
    {
        des = @"邮费到付";
    }
    self.Deslabel.text = des;
}

#pragma mark - Setter & Getter
- (void)passInfoBean:(GoodsBean *)infoBean
{
    self.goods = infoBean;
}

#pragma mark - UIWebviewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [ProgressHUD dismiss];
    CGRect frame = self.provision.frame;
    frame.size.width = self.view.frame.size.width;
    frame.size.height = 1;
    
    // wb.scrollView.scrollEnabled = NO;
    self.provision.frame = frame;
    
    frame.size.height = self.provision.scrollView.contentSize.height;
    
    NSLog(@"frame = %@", [NSValue valueWithCGRect:frame]);
    self.provision.frame = frame;
    //[self.tableView beginUpdates];
    //[self.tableView endUpdates];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    [ProgressHUD showText:error.localizedFailureReason Interaction:YES Hide:YES];
    [self.provision reload];
}

@end
