//
//  RechargeTableViewController.m
//  BeautyWhere
//
//  Created by lizhiwei on 16/1/14.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import "RechargeTableViewController.h"
#import "UIImageView+AFNetworking.h"
#import "PayBillTableViewController.h"
#import "Pingpp.h"
#import "MorePageNetwork.h"

@interface RechargeTableViewController ()

@property (nonatomic, strong)GoodsBean *goods;
@property (nonatomic, assign)BOOL hideBuy;
@property (nonatomic, strong)NSString *price;
@property (nonatomic, strong)UITextField *input;
@property (nonatomic, strong)UILabel *label;
@end

@implementation RechargeTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setScrollEnabled:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MorePageNetwork refleshUserInfoWithUserID:User.userID withSuccessBlock:^(BOOL finished)
     {
         if (!finished)
         {
             NSLog(@"获取不了新用户信息的json数据");
         }
         else
         {
             //[ProgressHUD showText:@"臭美币更新成功" Interaction:YES Hide:YES];
         }
     } withErrorBlock:^(NSError *err)
     {
         NSLog(@"更新用户信息有误:%@",err);
         NSError *error = nil;
         BOOL removeFinished;
         removeFinished = [[NSFileManager defaultManager] removeItemAtPath:UserInfoFilePath error:&error];
         if (error)
         {
             NSLog(@"删除用户信息文件有误:%@",error);
         }
         else if (removeFinished)
         {
             User = nil;
         }
         [ProgressHUD showText:@"获取不了新的用户数据，请重新登录" Interaction:YES Hide:YES];
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section==0?1:3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (!cell) {
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
                    /*UIButton *czbt50 = [[UIButton alloc]initWithFrame:CGRectMake(10,10,self.view.frame.size.width/2-15,40)];
                    czbt50.layer.cornerRadius = 5;
                    czbt50.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:58.0/255.0 blue:99.0/255.0 alpha:1.0];
                    [czbt50 setTitle:@"50元(50个)" forState:UIControlStateNormal];
                    [cell addSubview:czbt50];
                    
                    UIButton *czbt100 = [[UIButton alloc]initWithFrame:CGRectMake(5+self.view.frame.size.width/2,10,self.view.frame.size.width/2-15,40)];
                    czbt100.layer.cornerRadius = 5;
                    czbt100.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:58.0/255.0 blue:99.0/255.0 alpha:1.0];
                    [czbt100 setTitle:@"100元(100个)" forState:UIControlStateNormal];
                    [cell addSubview:czbt100];*/
                    
                    NSArray *colorNames = @[@"50元(50个)",@"100元(100个)", @"200元(200个)", @"300元(300个)", @"500元(500个)", @"1000元(1000个)"];
                    NSArray *buttonColors = @[[UIColor clearColor], [UIColor clearColor], [UIColor clearColor], [UIColor clearColor], [UIColor clearColor], [UIColor clearColor]];
                    NSInteger i = 0;
                    
                    //NSArray *GroupIds = @[@"1",@"2", @"3", @"4", @"5", @"6"];
                    
                    for (UIColor *buttonColor in buttonColors)
                    {
                        // customize this button
                        int j = 150;
                        NSInteger k = i;
                        if (i%2==0)
                        {
                            j=0;
                        }
                        
                        if (k%2!=0)
                        {
                            k = k - 1;
                        }
                        
                        QRadioButton *_radio1 = [[QRadioButton alloc] initWithDelegate:self groupId:@"group"];
                        _radio1.frame = CGRectMake(j+10, 10+30*k, 140, 30);
                        [_radio1 setTitle:colorNames[i] forState:UIControlStateNormal];
                        [_radio1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                        [_radio1.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
                        [self.view addSubview:_radio1];
                        [_radio1 setBackgroundColor:buttonColor];
                        if (i==0)
                        {
                            [_radio1 setChecked:YES];
                        }
                        [cell addSubview:_radio1];
                        i++;
                    }
                }
                    break;
                case 1:
                {
                    UIButton *czbt200 = [[UIButton alloc]initWithFrame:CGRectMake(10,10,self.view.frame.size.width/2-15,40)];
                    czbt200.layer.cornerRadius = 5;
                    czbt200.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:58.0/255.0 blue:99.0/255.0 alpha:1.0];
                    [czbt200 setTitle:@"200元(200个)" forState:UIControlStateNormal];
                    [cell addSubview:czbt200];
                    
                    UIButton *czbt300 = [[UIButton alloc]initWithFrame:CGRectMake(5+self.view.frame.size.width/2,10,self.view.frame.size.width/2-15,40)];
                    czbt300.layer.cornerRadius = 5;
                    czbt300.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:58.0/255.0 blue:99.0/255.0 alpha:1.0];
                    [czbt300 setTitle:@"300元(300个)" forState:UIControlStateNormal];
                    [cell addSubview:czbt300];
                }
                    break;
            case 2:
            {
                UIButton *czbt500 = [[UIButton alloc]initWithFrame:CGRectMake(10,10,self.view.frame.size.width/2-15,40)];
                czbt500.layer.cornerRadius = 5;
                czbt500.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:58.0/255.0 blue:99.0/255.0 alpha:1.0];
                [czbt500 setTitle:@"500元(500个)" forState:UIControlStateNormal];
                [cell addSubview:czbt500];
                
                UIButton *czbt1000 = [[UIButton alloc]initWithFrame:CGRectMake(5+self.view.frame.size.width/2,10,self.view.frame.size.width/2-15,40)];
                czbt1000.layer.cornerRadius = 5;
                czbt1000.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:58.0/255.0 blue:99.0/255.0 alpha:1.0];
                [czbt1000 setTitle:@"1000元(1000个)" forState:UIControlStateNormal];
                [cell addSubview:czbt1000];
            }
                break;
            }
            break;
        case 1:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, self.view.frame.size.width, 10)];
                    label.text = @"请输入充值金额：1元=1个臭美币";
                    label.textColor = [UIColor colorWithRed:3.0/255.0 green:67.0/255.0 blue:132.0/255.0 alpha:1.0];
                    label.font = [UIFont systemFontOfSize:15.0];
                    [cell addSubview:label];
                }
                    break;
                case 1:
                {
                    self.input = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, 150, 30)];
                    self.input.delegate = self;
                    self.input.text = self.price;
                    self.input.textColor = [UIColor lightGrayColor];
                    self.input.layer.borderWidth = 0.5;
                    self.input.layer.borderColor = NavBarColor.CGColor;
                    self.input.layer.cornerRadius = 3;
                    self.input.font = [UIFont systemFontOfSize:16];
                    self.input.textAlignment = NSTextAlignmentCenter;
                    self.input.returnKeyType = UIReturnKeyDone;
                    self.input.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                    [cell addSubview:self.input];
                    
                    self.label = [[UILabel alloc] initWithFrame:CGRectMake(170, 30, self.view.frame.size.width, 10)];
                    NSString * desc = [NSString stringWithFormat:@"元 = %@个",self.price];
                    self.label.text = desc;
                    self.label.textColor = [UIColor colorWithRed:3.0/255.0 green:67.0/255.0 blue:132.0/255.0 alpha:1.0];
                    self.label.font = [UIFont systemFontOfSize:15.0];
                    [cell addSubview:self.label];
                }
                    break;
                case 2:
                {
                    UIButton * zfbbtn = [[UIButton alloc]initWithFrame:CGRectMake(70, 20, 75,75)];
                    [zfbbtn setImage:[UIImage imageNamed:@"zfb.png"] forState:UIControlStateNormal];
                    [zfbbtn addTarget:self action:@selector(pressedZfbBuy) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:zfbbtn];
                    
                    UILabel * zfblabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 100, self.view.frame.size.width, 10)];
                    zfblabel.text = @"支付宝支付";
                    zfblabel.textColor = [UIColor colorWithRed:3.0/255.0 green:67.0/255.0 blue:132.0/255.0 alpha:1.0];
                    zfblabel.font = [UIFont systemFontOfSize:15.0];
                    [cell addSubview:zfblabel];
                    
                    UIButton * wxbtn = [[UIButton alloc]initWithFrame:CGRectMake(180, 20, 75,75)];
                    [wxbtn setImage:[UIImage imageNamed:@"wx.png"] forState:UIControlStateNormal];
                    [wxbtn addTarget:self action:@selector(pressedWxBuy) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:wxbtn];
                    
                    UILabel * wxlabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 100, self.view.frame.size.width, 10)];
                    wxlabel.text = @"微信支付";
                    wxlabel.textColor = [UIColor colorWithRed:3.0/255.0 green:67.0/255.0 blue:132.0/255.0 alpha:1.0];
                    wxlabel.font = [UIFont systemFontOfSize:15.0];
                    [cell addSubview:wxlabel];
                }
                    break;
            }
            
        }
        break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section==0?@"选择充值金额":nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    return 148;
                    break;
                case 1:
                    return 48;
                    break;
                case 2:
                    return 48;
                    break;
                default:
                    return 0;
                    break;
            }
            break;
        case 1:
            switch (indexPath.row)
        {
                case 0:
                    return 48;
                    break;
                case 1:
                    return 48;
                    break;
                case 2:
                    return 100;
                    break;
                default:
                    return 0;
                    break;
            }
            break;
        default:
            return 0;
            break;
    }
}

#pragma mark - Button Response
- (void)pressedWxBuy
{
    /*[ProgressHUD show:nil];
    [HomePageNetwork GetNewOrder:self.goods.goodsID withUserId:GetAppDelegate.user.userID withGoodsType:self.goods.goodsType withSuccessBlock:^(NSString *message)
     {
         NSLog(@"message===============%@",message);
         [ProgressHUD showText:message Interaction:YES Hide:YES];
     } withErrBlock:^(NSError *err)
     {
         [ProgressHUD showText:@"充值失败" Interaction:YES Hide:YES];
     }];*/
    
    if(self.input.text.length<=0)
    {
        [ProgressHUD showText:@"请输入内容" Interaction:YES Hide:YES];
        return;
    }
    
    if ([self.price floatValue]<=0)
    {
        [ProgressHUD showText:@"请输入的臭美币不正确" Interaction:YES Hide:YES];
        return;
    }
    
    NSInteger fen = 0;
    NSString *sellType = @"";
    fen = [self.price floatValue]*100;
    NSString *payChannel = @"wx";
    NSString *mobile = [User.mobile integerValue]==0?@"0":User.mobile;
    [HomePageNetwork getPingPPChargeWithGoodsID:@"" withGoodsType:sellType withUserID:User.userID withPartnerID:@"" withAmount:[NSString stringWithFormat:@"%li",(long)fen] withSubject:@"" withMobile:mobile withChannel:payChannel withBody:@"" withSuccessBlock:^(NSDictionary *pingPPCharge)
     {
         if (pingPPCharge)
         {
             GetAppDelegate.openURLHandlerViewController = self;
             [Pingpp createPayment:pingPPCharge appURLScheme:@"paybillppp" withCompletion:^(NSString *result, PingppError *error)
             {
                 if (error)
                 {
                     [ProgressHUD showText:@"充值失败" Interaction:YES Hide:YES];
                 }
                 else
                 {
                     [Pingpp createPayment:pingPPCharge viewController:self appURLScheme:@"paybillppp" withCompletion:^(NSString *result, PingppError *error)
                     {
                         if (error)
                         {
                             [ProgressHUD showText:@"充值失败" Interaction:YES Hide:YES];
                         }
                         else
                         {
                             [ProgressHUD showText:@"充值成功" Interaction:YES Hide:YES];
                             [self.navigationController popToRootViewControllerAnimated:YES];
                             
                         }
                     }];
                 }
             }];
         }
         else
         {
             [ProgressHUD showText:@"充值失败" Interaction:YES Hide:YES];
         }
     } withErrorBlock:^(NSError *err)
     {
         [ProgressHUD showError:err.localizedFailureReason Interaction:YES Hide:YES];
     }];
}


- (void)pressedZfbBuy
{
    /*[ProgressHUD show:nil];
     [HomePageNetwork GetNewOrder:self.goods.goodsID withUserId:GetAppDelegate.user.userID withGoodsType:self.goods.goodsType withSuccessBlock:^(NSString *message)
     {
     NSLog(@"message===============%@",message);
     [ProgressHUD showText:message Interaction:YES Hide:YES];
     } withErrBlock:^(NSError *err)
     {
     [ProgressHUD showText:@"充值失败" Interaction:YES Hide:YES];
     }];*/
    
    if(self.input.text.length<=0)
    {
        [ProgressHUD showText:@"请输入内容" Interaction:YES Hide:YES];
        return;
    }
    
    if ([self.price floatValue]<=0)
    {
        [ProgressHUD showText:@"请输入的臭美币不正确" Interaction:YES Hide:YES];
        return;
    }
    
    NSInteger fen = 0;
    NSString *sellType = @"";
    fen = [self.price floatValue]*100;
    NSString *payChannel = @"alipay";
    NSString *mobile = [User.mobile integerValue]==0?@"0":User.mobile;
    [HomePageNetwork getPingPPChargeWithGoodsID:@"" withGoodsType:sellType withUserID:User.userID withPartnerID:@"" withAmount:[NSString stringWithFormat:@"%li",(long)fen] withSubject:@"" withMobile:mobile withChannel:payChannel withBody:@"" withSuccessBlock:^(NSDictionary *pingPPCharge)
     {
         NSLog(@"pingPPCharge========%@",pingPPCharge);
         if (pingPPCharge)
         {
             GetAppDelegate.openURLHandlerViewController = self;
             [Pingpp createPayment:pingPPCharge appURLScheme:@"paybillppp" withCompletion:^(NSString *result, PingppError *error)
             {
                 if (error)
                 {
                     [ProgressHUD showText:@"充值失败" Interaction:YES Hide:YES];
                 }
                 else
                 {
                     [Pingpp createPayment:pingPPCharge viewController:self appURLScheme:@"paybillppp" withCompletion:^(NSString *result, PingppError *error)
                     {
                         if (error)
                         {
                             [ProgressHUD showText:@"充值失败" Interaction:YES Hide:YES];
                         }
                         else
                         {
                             [ProgressHUD showText:@"充值成功" Interaction:YES Hide:YES];
                             [self.navigationController popToRootViewControllerAnimated:YES];
                         }
                     }];
                 }
             }];
         }
         else
         {
             [ProgressHUD showText:@"充值失败" Interaction:YES Hide:YES];
         }
     } withErrorBlock:^(NSError *err)
     {
         [ProgressHUD showError:err.localizedFailureReason Interaction:YES Hide:YES];
     }];
}

#pragma mark - QRadioButtonDelegate

- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId
{
    if ([radio.titleLabel.text isEqualToString:@"50元(50个)"])
    {
        self.price = @"50";
    }
    
    if ([radio.titleLabel.text isEqualToString:@"200元(200个)"])
    {
        self.price = @"200";
    }
    
    if ([radio.titleLabel.text isEqualToString:@"100元(100个)"])
    {
        self.price = @"100";
    }
    
    if ([radio.titleLabel.text isEqualToString:@"300元(300个)"])
    {
        self.price = @"300";
    }
    
    if ([radio.titleLabel.text isEqualToString:@"500元(500个)"])
    {
        self.price = @"500";
    }
    
    if ([radio.titleLabel.text isEqualToString:@"1000元(1000个)"])
    {
        self.price = @"1000";
    }
    [self.input setText:self.price];
    NSString * desc = [NSString stringWithFormat:@"元 = %@个",self.price];
    self.label.text = desc;
}

#pragma mark - UITextViewDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textView
{
    if ([textView.text isEqualToString:self.price])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textView
{
    if (textView.text.length < 1)
    {
        textView.text = self.price;
        textView.textColor = [UIColor lightGrayColor];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //输入完成隐藏键
    self.price = textField.text;
    NSString * desc = [NSString stringWithFormat:@"元 = %@个",self.price];
    self.label.text = desc;
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    NSLog(@"======================000");
    
    if (textField == self.input)
    {
        if (textField.text.length > 5)
        {
            textField.text = [textField.text substringToIndex:5];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.input)
    {
        if (textField.text.length > 5)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return YES;
}

#pragma mark - Tool
- (void)hideBuyBtn
{
    self.hideBuy = YES;
}

#pragma mark - Setter & Getter
- (void)passInfoBean:(GoodsBean *)infoBean
{
    self.goods = infoBean;
}

@end

