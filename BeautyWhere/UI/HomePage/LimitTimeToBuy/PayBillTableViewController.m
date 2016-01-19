//
//  PayBillTableViewController.m
//  BeautyWhere
//
//  Created by Michael on 15/8/22.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "PayBillTableViewController.h"
#import "Pingpp.h"

@interface PayBillTableViewController ()

@property (nonatomic, strong)GoodsBean *goods;
@property (nonatomic, assign)CheckGoodsOnSellsType goodsOnSellsType;
@property (nonatomic, strong) UISwitch *switchButton;

@end

@implementation PayBillTableViewController

- (instancetype)initWithGoods:(GoodsBean *)good withGoodsOnSellsType:(CheckGoodsOnSellsType)type {
    if (self = [super init]) {
        self.goods = good;
        self.goodsOnSellsType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付";
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([GetAppDelegate.paySource isEqualToString:@"0"])
    {
        return section==0?2:2;
    }
    return section==0?1:2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //return section==0?nil:@"请选择支付方式";
    if([self.goods.goodsNowPrice floatValue]>[GetAppDelegate.user.money floatValue])
    {
        return @"选择充值臭美币方式";
    }
    else
    {
        return @"臭美币支付";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CellHeight-.5, ScreenWidth, .5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:line];
    }
//    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // Configure the cell...
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 2:
                {
                    cell.textLabel.text = @"护理代金劵(52元)";
                    self.switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(cell.frame.size.width-80, 7.5, 20, 10)];
                    [self.switchButton setOn:YES];
                    [self.switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
                    [cell addSubview:self.switchButton];
                    
                }
                break;
                case 0:
                {
                    int price = [self.goods.goodsNowPrice floatValue]-[GetAppDelegate.user.money floatValue];
                    NSString *TakePrice = [NSString stringWithFormat:@"%d",price];
                    NSLog(@"总臭美币===============%@",GetAppDelegate.user.money);
                    if([self.goods.goodsNowPrice floatValue]>[GetAppDelegate.user.money floatValue])
                    {
                        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"您的臭美币不够,应充值金额:%@元",TakePrice]];
                        [attributeStr addAttribute:NSForegroundColorAttributeName value:BottomMenuSelectedColor range:NSMakeRange(14,TakePrice.length+1)];
                        cell.textLabel.attributedText = attributeStr;
                    }
                    else
                    {
                        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"应支付金额:%@元",self.goods.goodsNowPrice]];
                        [attributeStr addAttribute:NSForegroundColorAttributeName value:BottomMenuSelectedColor range:NSMakeRange(6,self.goods.goodsNowPrice.length+1)];
                        cell.textLabel.attributedText = attributeStr;
                        
                    }
                    
                }
                break;
                case 1:
                {
                    cell.textLabel.text = @"亲:一个臭美币相当于1元(解释权归我司)";
                    cell.textLabel.textColor = [UIColor grayColor];
                    cell.textLabel.font = [UIFont systemFontOfSize:13.0];
                }
                break;

            }
        }
            break;
        case 1:
            switch (indexPath.row)
            {
                case 0:
                    //cell.textLabel.text = @"支付宝支付";
                {
                    if([self.goods.goodsNowPrice floatValue]>[GetAppDelegate.user.money floatValue])
                    {
                        cell.textLabel.text = @"支付宝充值";
                    }
                    else
                    {
                        UIButton * buy = [[UIButton alloc] initWithFrame:CGRectMake(cell.frame.size.width-100, 7.5, (CellHeight-10)*2.5, CellHeight-10)];
                        [buy setTitle:@"立即支付" forState:UIControlStateNormal];
                        [buy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        buy.backgroundColor = [UIColor orangeColor];
                        [buy addTarget:self action:@selector(pressedBuy) forControlEvents:UIControlEventTouchUpInside];
                        [cell addSubview:buy];
                    }
                }
                    break;
                case 1:
                    if([self.goods.goodsNowPrice floatValue]>[GetAppDelegate.user.money floatValue])
                    {
                        cell.textLabel.text = @"微信充值";
                    }
                    break;
                case 2:
                    cell.textLabel.text = @"护理代金券支付(520元)";//银联支付
                    break;
            }
            break;
            
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn)
    {
        [self.switchButton removeFromSuperview];
        self.goods.goodsNowPrice = @"90";
        [self.tableView reloadData];
        //[self.switchButton setOn:YES];
    }else
    {
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [ProgressHUD show:nil Interaction:NO Hide:NO];
        [HomePageNetwork checkGoodsOnSellOrNotWithGoodsID:self.goods.goodsID withType:self.goodsOnSellsType withSuccessBlock:^(BOOL finished)
        {
            if (finished)
            {
                NSString *sellType = nil;
                switch (self.goodsOnSellsType)
                {
                    case CheckGoodsOnSellsTypeInStore:
                        sellType = @"comment";
                        break;
                    case CheckGoodsOnSellsTypeLimitToFactory:
                        sellType = @"flash";
                        break;
                    case CheckGoodsOnSellsTypeSeckill:
                        sellType = @"seckill";
                        break;
                    case CheckGoodsOnSellsTypeShopping:
                        sellType = @"luojia";
                        break;
                }
                NSString *payChannel = nil;
                switch (indexPath.row)
                {
                    case 0:
                        payChannel = @"alipay";
                        break;
                    case 1:
                        payChannel = @"wx";
                        break;
                    case 2:
                        payChannel = @"upacp";
                        break;
                }
                NSInteger fen = 0;
                if([self.goods.goodsNowPrice floatValue]>[GetAppDelegate.user.money floatValue])
                {
                    fen = [self.goods.goodsNowPrice floatValue]*100;
                }
                else
                {
                    fen = ([self.goods.goodsNowPrice floatValue]-[GetAppDelegate.user.money floatValue])*100;
                }
                
                NSString *mobile = [User.mobile integerValue]==0?@"0":User.mobile;
                [HomePageNetwork getPingPPChargeWithGoodsID:self.goods.goodsID withGoodsType:sellType withUserID:User.userID withPartnerID:self.goods.goodsPartnerID withAmount:[NSString stringWithFormat:@"%li",(long)fen] withSubject:self.goods.goodsName withMobile:mobile withChannel:payChannel withBody:self.goods.goodsContent withSuccessBlock:^(NSDictionary *pingPPCharge)
                 {
                    if (pingPPCharge)
                    {
                        GetAppDelegate.openURLHandlerViewController = self;
                        [Pingpp createPayment:pingPPCharge appURLScheme:@"paybillppp" withCompletion:^(NSString *result, PingppError *error) {
                            if (error) {
                                [ProgressHUD showText:@"购买失败" Interaction:YES Hide:YES];
                            }
                            else {
                                [Pingpp createPayment:pingPPCharge viewController:self appURLScheme:@"paybillppp" withCompletion:^(NSString *result, PingppError *error) {
                                    if (error) {
                                        [ProgressHUD showText:@"购买失败" Interaction:YES Hide:YES];
                                    }
                                    else {
                                        [ProgressHUD showText:@"购买成功，可到订单页查看" Interaction:YES Hide:YES];
                                        [self.navigationController popToRootViewControllerAnimated:YES];
                                    }
                                }];
                            }
                        }];
                    }
                    else
                    {
                        [ProgressHUD showText:@"购买失败" Interaction:YES Hide:YES];
                    }
                } withErrorBlock:^(NSError *err)
                {
                    [ProgressHUD showError:err.localizedFailureReason Interaction:YES Hide:YES];
                }];
            }
            else
            {
                [ProgressHUD showText:@"购买失败，请与客服联系" Interaction:YES Hide:YES];
            }
        } withErrorBlock:^(NSError *err)
        {
            [ProgressHUD showError:err.localizedFailureReason Interaction:YES Hide:YES];
        }];
    }
}

- (void)pressedBuy
{
    //[ProgressHUD showText:@"建设中。。。" Interaction:YES Hide:YES];
    [ProgressHUD show:nil];
    [HomePageNetwork GetNewOrder:self.goods.goodsID withUserId:GetAppDelegate.user.userID withGoodsType:self.goods.goodsType withSuccessBlock:^(NSString *message)
     {
         NSLog(@"message===============%@",message);
         [ProgressHUD showText:message Interaction:YES Hide:YES];
     } withErrBlock:^(NSError *err)
     {
         [ProgressHUD showText:@"充值失败" Interaction:YES Hide:YES];
     }];
    return;
}

@end
