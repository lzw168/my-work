//
//  LuckyMoneyViewController.m
//  BeautyWhere
//
//  Created by Michael Chan on 15/8/10.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "LuckyMoneyViewController.h"
#import "HomePageNetwork.h"

@interface LuckyMoneyViewController ()

@property (nonatomic, strong) UIButton *redPacket;
@property (nonatomic, assign) BOOL isLoging;

@end

@implementation LuckyMoneyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hongbao-bg.png"]];
    bg.frame = self.view.bounds;
    bg.userInteractionEnabled = YES;
    [self.view addSubview:bg];
    [self.view addSubview:self.redPacket];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!User || !User.userID || [User.userID isEqualToString:@""]) {
        if (!self.isLoging) {
            self.isLoging = YES;
            LoginViewController *login = [[LoginViewController alloc] init];
            login.edgesForExtendedLayout = UIRectEdgeNone;
            login.backItemType = BackItemTypeBackImg;
            login.enterType = EnterTypePush;
            [self.navigationController pushViewController:login animated:YES];
        }
        else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"LuckyMoneyViewController dealloc");
}

#pragma mark - Button Response
- (void)openRedPacket:(UIButton *)btn
{
    [ProgressHUD show:@"加载中..."];
    __weak typeof(self) wself = self;
    [HomePageNetwork getCouponInfoWithSuccessBlock:^(NSDictionary *couponArr)
    {
        NSDictionary *couponArrList = couponArr;
        NSLog(@"----couponArrList-----%@",couponArrList);
        NSString *couponID = [couponArrList valueNull2NilForKey:@"id"];
        NSString *couponimage = [couponArrList valueNull2NilForKey:@"image"];
        NSString *couponcredit = [couponArrList valueNull2NilForKey:@"credit"];
        if (couponID && ![couponID isEqualToString:@""])
        {
            [HomePageNetwork getCouponWithUserID:User.userID withCouponID:couponID withCouponImage:couponimage withCouponPrice:couponcredit withSuccessBlock:^(NSString *message)
            {
                NSLog(@"message===============%@",message);
                [ProgressHUD showText:message Interaction:YES Hide:YES];
                [_redPacket setImage:[UIImage imageNamed:@"lingqu-hongbao-pre.png"] forState:UIControlStateNormal];
                [_redPacket setImage:[UIImage imageNamed:@"lingqu-hongbao-pre.png"] forState:UIControlStateHighlighted];
                [wself.navigationController popViewControllerAnimated:YES];
            } withErrBlock:^(NSError *err)
             {
                NSLog(@"getCoupon err:%@",err);
                [ProgressHUD showText:@"获取红包出错，请检查网络后再试" Interaction:YES Hide:YES];
            }];
        }
        else
        {
            [ProgressHUD showText:@"获取红包信息失败，请检查网络后重试" Interaction:YES Hide:YES];
        }
    } withErrorBlock:^(NSError *err)
    {
        NSLog(@"getCouponInfo err:%@",err);
        [ProgressHUD showText:@"获取红包信息出错，请检查网络后再试" Interaction:YES Hide:YES];
    }];
}

#pragma mark - Setter & Getter
- (UIButton *)redPacket
{
    if (!_redPacket)
    {
        _redPacket = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [UIImage imageNamed:@"lingqu-hongbao.png"].size.width, [UIImage imageNamed:@"lingqu-hongbao.png"].size.height)];
        [_redPacket setImage:[UIImage imageNamed:@"lingqu-hongbao.png"] forState:UIControlStateNormal];
//        [_redPacket addTarget:self action:@selector(openRedPacket:) forControlEvents:UIControlEventTouchUpInside];
        _redPacket.center = self.view.center;
        
        UIImage *openImg = [UIImage imageNamed:@"hongbao-btn.png"];
        UIButton *open = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, openImg.size.width, openImg.size.height)];
        open.center = CGPointMake(_redPacket.frame.size.width/2, _redPacket.frame.size.height/2);
        [open setTitle:@"猜红包" forState:UIControlStateNormal];
        open.titleLabel.font = [UIFont systemFontOfSize:13];
        [open setTitleColor:[UIColor colorWithRed:164.0/255.0 green:14.0/255.0 blue:39.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [open setBackgroundImage:openImg forState:UIControlStateNormal];
        [open addTarget:self action:@selector(openRedPacket:) forControlEvents:UIControlEventTouchUpInside];
        [_redPacket addSubview:open];
    }
    return _redPacket;
}

@end
