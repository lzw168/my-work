//
//  BillDetailTableViewController.m
//  BeautyWhere
//
//  Created by Michael on 15/8/25.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "BillDetailTableViewController.h"
#import "UIImageView+AFNetworking.h"
#import "GoodsDetailTableViewController.h"

@interface BillDetailTableViewController ()

@end

@implementation BillDetailTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

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
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return @"订单信息";
            break;
            
        default:
            return @"商品详情";
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if([self.bill.billGoodsType isEqualToString:@"1"]||[self.bill.billGoodsType isEqualToString:@"2"])
    {
        return section==0?5:1;
    }
    return section==0?4:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reuseIdentifier"];
    }
    // Configure the cell...
    switch (indexPath.section)
    {
        case 0:
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:13.0];
            switch (indexPath.row)
        {
                case 0:
                    cell.textLabel.text = [NSString stringWithFormat:@"订单号:%@",self.bill.billOrderID];
                    break;
                case 1:
                {
                    //unpay未支付，cancel支付取消，pay 已支付，done 已使用。
                    NSString *stateStr = @"未知";
                    if ([self.bill.billState isEqualToString:@"unpay"])
                    {
                        stateStr = @"未支付";
                    }
                    else if ([self.bill.billState isEqualToString:@"cancel"])
                    {
                        stateStr = @"支付取消";
                    }
                    else if ([self.bill.billState isEqualToString:@"pay"])
                    {
                        stateStr = @"已支付";
                    }
                    else if([self.bill.billState isEqualToString:@"shipped"])
                    {
                        stateStr = @"已发货";
                    }
                    else if ([self.bill.billState isEqualToString:@"done"])
                    {
                        stateStr = @"已完成";
                    }
                    else if([self.bill.billState isEqualToString:@"returning"])
                    {
                        stateStr = @"退货中";
                    }
                    else if([self.bill.billState isEqualToString:@"returned"])
                    {
                        stateStr = @"已退货";
                    }
                    cell.textLabel.text = [NSString stringWithFormat:@"订单状态:%@",stateStr];
                }
                    break;
                case 2:
                {
                    //限时seckill，限量flash，普通comment，直购luojia
                    NSString *type = @"线下特惠";
                    if ([self.bill.billGoodsType isEqualToString:@"3"])
                    {
                        type = @"限时闪购";
                    }
                    else if ([self.bill.billGoodsType isEqualToString:@"0"])
                    {
                        type = @"线下特惠";
                    }
                    else if ([self.bill.billGoodsType isEqualToString:@"1"])
                    {
                        type = @"爆款专区";
                    }
                    else if ([self.bill.billGoodsType isEqualToString:@"2"])
                    {
                        type = @"工厂直卖";
                    }
                    cell.textLabel.text = [NSString stringWithFormat:@"商品类型:%@",type];
                }
                    break;
                case 4:
                    cell.textLabel.text = [NSString stringWithFormat:@"快递名称:%@",self.bill.express_name];
                    break;
                case 3:
                    if([self.bill.billGoodsType isEqualToString:@"1"]||[self.bill.billGoodsType isEqualToString:@"2"])
                    {
                        if(self.bill.express_no == nil)
                        {
                            self.bill.express_no = @"";
                        }
                        cell.textLabel.text = [NSString stringWithFormat:@"快递单号:%@",self.bill.express_no];
                    }
                    else
                    {
                        cell.textLabel.text = [NSString stringWithFormat:@"是否已领取:%@",self.bill.billIsUse?@"已领取":@"未领取"];
                    }
                    break;
            }
            break;
        default:
            [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",GetAppDelegate.img_path, self.bill.billImgURLLaxtComponent]] placeholderImage:[UIImage imageNamed:@"pic_2loading.png"]];
            cell.textLabel.text = self.bill.billOrderTitle;
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"原价:￥%@",self.bill.billPrice];
            UILabel *nowPriceLabel = [[UILabel alloc] init];
            nowPriceLabel.textColor = BottomMenuSelectedColor;
            nowPriceLabel.font = [UIFont systemFontOfSize:13];
            nowPriceLabel.text = [NSString stringWithFormat:@"现价:￥%@",self.bill.billNowPrice];
            [nowPriceLabel sizeToFit];
            nowPriceLabel.frame = CGRectMake(ScreenWidth-nowPriceLabel.frame.size.width-10, CellHeight/2, nowPriceLabel.frame.size.width, nowPriceLabel.frame.size.height);
            [cell.contentView addSubview:nowPriceLabel];
            UILabel *stock = [[UILabel alloc] init];
            stock.font = [UIFont systemFontOfSize:13];
            stock.text = [NSString stringWithFormat:@"库存:%@",self.bill.billTotalNum];
            [stock sizeToFit];
            stock.frame = CGRectMake(ScreenWidth-stock.frame.size.width-10, nowPriceLabel.frame.origin.y+nowPriceLabel.frame.size.height, stock.frame.size.width, stock.frame.size.height);
            //[cell.contentView addSubview:stock];
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1)
    {
        GoodsDetailTableViewController *store = [[GoodsDetailTableViewController alloc] init];
//        [store hideBuyBtn];
        GoodsBean *goods = [[GoodsBean alloc] init];
        goods.goodsID = self.bill.billGoodsID;
        goods.goodsName = self.bill.billOrderTitle;
        goods.goodsImgLastComponentURL = self.bill.billImgURLLaxtComponent;
        goods.goodsNowPrice = self.bill.billNowPrice;
        goods.goodsContent = self.bill.billContent;
        goods.goodsPartnerID = self.bill.billPartnerID;
        [store passInfoBean:goods];
        store.goodsOnSellsType = CheckGoodsOnSellsTypeInStore;
        store.edgesForExtendedLayout = UIRectEdgeNone;
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
        [self.navigationController pushViewController:store animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section==0?44:70;
}

@end
