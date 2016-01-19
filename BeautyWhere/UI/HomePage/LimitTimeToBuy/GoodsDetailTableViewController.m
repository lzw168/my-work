//
//  GoodsDetailTableViewController.m
//  BeautyWhere
//
//  Created by Michael on 15/8/21.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "GoodsDetailTableViewController.h"
#import "UIImageView+AFNetworking.h"
#import "PayBillTableViewController.h"

@interface GoodsDetailTableViewController ()

@property (nonatomic, strong)GoodsBean *goods;
@property (nonatomic, assign)BOOL hideBuy;

@end

@implementation GoodsDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.goods.goodsName;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section==0?2:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.textLabel.text = @"";
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                {
                    UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, CellHeight)];
                    [pic setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Server_ImgHost, self.goods.goodsImgLastComponentURL]] placeholderImage:[UIImage imageNamed:@"pic_2loading.png"]];
                    [cell.contentView addSubview:pic];
                }
                    break;
                case 1:
                    switch (self.goodsOnSellsType) {
                        case CheckGoodsOnSellsTypeLimitToFactory:
                        case CheckGoodsOnSellsTypeSeckill:
                            cell.textLabel.text = [NSString stringWithFormat:@"￥%@元",self.goods.goodsSecKillPrice];
                            break;
                        default:
                            cell.textLabel.text = [NSString stringWithFormat:@"￥%@元",self.goods.goodsNowPrice];
                            break;
                    }
                    cell.textLabel.textColor = BottomMenuSelectedColor;
                    if (!self.hideBuy) {
                        UIButton *buy = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-5-(CellHeight-10)*3, 5, (CellHeight-10)*3, CellHeight-10)];
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
            cell.textLabel.text = self.goods.goodsContent;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.font = [UIFont systemFontOfSize:13.0];
            break;
    }
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section==0?nil:@"商品详情";
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    return ScreenWidth*0.75;
                    break;
                case 1:
                    return 44;
                    break;
                default:
                    return 0;
                    break;
            }
            break;
        case 1:
            return 10+[self.goods.goodsContent boundingRectWithSize:CGSizeMake(ScreenWidth-20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height;
            break;
        default:
            return 0;
            break;
    }
}

#pragma mark - Button Response
- (void)pressedBuy
{
    if (self.goodsOnSellsType == CheckGoodsOnSellsTypeInStore)
    {
        PayBillTableViewController *payBill = [[PayBillTableViewController alloc] initWithGoods:self.goods withGoodsOnSellsType:self.goodsOnSellsType];
        payBill.edgesForExtendedLayout = UIRectEdgeNone;
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
        [self.navigationController pushViewController:payBill animated:YES];
    }
    else
    {
        [ProgressHUD show:nil];
        [HomePageNetwork checkGoodsOnSellOrNotWithGoodsID:self.goods.goodsID withType:self.goodsOnSellsType withSuccessBlock:^(BOOL finished) {
            if (finished) {
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
    }
}

#pragma mark - Tool
- (void)hideBuyBtn {
    self.hideBuy = YES;
}

#pragma mark - Setter & Getter
- (void)passInfoBean:(GoodsBean *)infoBean {
    self.goods = infoBean;
}

@end
