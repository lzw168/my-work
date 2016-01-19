//
//  ViewController.m
//  BeautyWhere
//
//  Created by Michael on 15-7-21.
//  Copyright (c) 2015年 Michael. All rights reserved.


#import "ViewController.h"
#import "HomeViewController.h"
#import "InformationViewController.h"
#import "PersonalViewController.h"
#import "MoreViewController.h"
#import "NearbyStoreViewController.h"
#import "RankingListViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    HomeViewController *homePage = [[HomeViewController alloc] init];
    homePage.title = @"上哪美";
    RankingListViewController *infoPage = [[RankingListViewController alloc] init];
    infoPage.title = @"臭美排行榜";//@"资讯";
    PersonalViewController *personalPage = [[PersonalViewController alloc] init];
    personalPage.title = @"臭美档案";
    
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    NSString *gameuseradd= [accountDefaults objectForKey:@"useraddress"];
    NSLog(@"保存的城市===============%@",gameuseradd);
    
    NearbyStoreViewController *morePage = [[NearbyStoreViewController alloc] init];
    morePage.title = @"附近美容";
    ((NearbyStoreViewController*)morePage).locatedCity = gameuseradd;
    GetAppDelegate.paySource = @"0";
    
    morePage.hidesBottomBarWhenPushed = NO;
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    morePage.edgesForExtendedLayout = UIRectEdgeNone;
    
    NSMutableArray *navArr = [[NSMutableArray alloc] init];
    NSArray *firstLevelPage = @[homePage, infoPage, personalPage, morePage];
    for (int i =0; i < firstLevelPage.count; i++)
    {
        UIViewController *viewController = [firstLevelPage objectAtIndex:i];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        navController.navigationBar.tintColor = [UIColor whiteColor];
        navController.navigationBar.barTintColor = NavBarColor;
        [navController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        switch (i)
        {
            case 0:
            {
                /*UIImageView *title = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shouye-biaoti.png"]];
                title.center = CGPointMake(navController.view.center.x, navController.navigationBar.frame.size.height/2+[UIApplication sharedApplication].statusBarFrame.size.height);*/
                UILabel * title = [[UILabel alloc]init];
                title.text = @"上哪美";
                title.tag = homeTitleTag;
                [viewController.navigationController.view addSubview:title];
                navController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[[UIImage imageNamed:@"tab-home-pre.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tab-home.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            }
             break;
             case 1:
                navController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"臭美排行" image:[[UIImage imageNamed:@"tab-ranking-pre.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tab-ranking.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
             break;
             case 2:
                navController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"臭美档案" image:[[UIImage imageNamed:@"tab-my-pre.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tab-my.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
             break;
             case 3:
                navController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"附近美容" image:[[UIImage imageNamed:@"tab-more-pre.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tab-more.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
             break;
         }
        [navArr addObject:navController];
    }
    UITabBarController *bottomMenu = [[UITabBarController alloc] init];
    bottomMenu.tabBar.backgroundColor = BottomMenuBackgroundColor;
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:10], NSFontAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:BottomMenuSelectedColor, NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:10], NSFontAttributeName, nil] forState:UIControlStateSelected];
    bottomMenu.viewControllers = navArr;
    [self addChildViewController:bottomMenu];
    [self.view addSubview:bottomMenu.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"guide"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"guide"];
        NSArray *guideImgNameArr = @[@"yindaoye-1.png", @"yindaoye-2.png", @"yindaoye-3.png", @"yindaoye-4.png"];
        UIScrollView *guide = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        guide.pagingEnabled = YES;
        guide.contentSize = CGSizeMake(guideImgNameArr.count*ScreenWidth, ScreenHeight);
        for (int i = 0; i < guideImgNameArr.count; i++)
        {
            NSString *imgName = [guideImgNameArr objectAtIndex:i];
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*ScreenWidth, 0, ScreenWidth, ScreenHeight)];
            imgView.image = [UIImage imageNamed:imgName];
            [guide addSubview:imgView];
        }
        guide.delegate = self;
        [self.view addSubview:guide];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegateß
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.x > scrollView.contentSize.width-ScreenWidth)
    {
        [UIView animateWithDuration:1 animations:^
        {
            scrollView.frame = CGRectMake(-ScreenWidth, 0, ScreenWidth, ScreenHeight);
        } completion:^(BOOL finished)
        {
            if (finished)
            {
                [scrollView removeFromSuperview];
            }
        }];
    }
}

#pragma mark - CommalTool
+ (void)presentLoginViewWithViewController:(UIViewController *)vc backItemType:(BackItemType)type
{
    LoginViewController *login = [[LoginViewController alloc] init];
    UINavigationController *navLogin = [[UINavigationController alloc] initWithRootViewController:login];
    login.backItemType = type;
    login.enterType = EnterTypePresent;
    login.edgesForExtendedLayout = UIRectEdgeNone;
    [vc.navigationController presentViewController:navLogin animated:YES completion:nil];
}

@end
