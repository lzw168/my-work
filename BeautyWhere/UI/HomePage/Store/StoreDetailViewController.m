//
//  StoreDetailViewController.m
//  BeautyWhere
//
//  Created by Michael on 15/8/4.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "StoreDetailViewController.h"
#import "CollectionDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "GoodsBean.h"
#import "CommentBean.h"
#import "HomePageNetwork.h"
#import "WriteCommentViewController.h"
#import "MapViewController.h"
#import "GoodsDetailTableViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "StoreList.h"
#import "SubStoreDetailViewController.h"

@interface StoreDetailViewController ()

@property (nonatomic, assign) BOOL isCollected;
@property (nonatomic, strong) StoreBean *infoBean;
@property (nonatomic, strong) NSArray *goodsArr;
@property (nonatomic, strong) NSArray *shopsArr;
@property (nonatomic, strong) NSArray *commentArr;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIImage *Img;
@property (nonatomic, strong) UIButton *shareBtn;
@end

@implementation StoreDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    UIImage *rightBtnImg = [UIImage imageNamed:@"nav-btn-shouchang.png"];
    self.rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, rightBtnImg.size.width, rightBtnImg.size.height)];
    if (self.infoBean.storeCollected)
    {
        self.isCollected = YES;
        [self.rightBtn setImage:[UIImage imageNamed:@"nav-btn-shouchang-pre.png"] forState:UIControlStateNormal];
    }
    else
    {
        self.isCollected = NO;
        [self.rightBtn setImage:rightBtnImg forState:UIControlStateNormal];
    }
    [self.rightBtn addTarget:self action:@selector(pressedRightBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage * shareBtnImg = [UIImage imageNamed:@"fenxiang.png"];
    self.shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, shareBtnImg.size.width/2, shareBtnImg.size.height/2)];
    [self.shareBtn setImage:shareBtnImg forState:UIControlStateNormal];
    [self.shareBtn addTarget:self action:@selector(ShareBtn) forControlEvents:UIControlEventTouchUpInside];
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    UIBarButtonItem *anotherButton1 = [[UIBarButtonItem alloc] initWithCustomView:self.shareBtn];
    
    NSArray* buttons = [NSArray arrayWithObjects:anotherButton,anotherButton1,nil];
    //UIBarButtonItem *myBtn = [[UIBarButtonItem alloc] initWithCustomView:tools];
    self.navigationItem.rightBarButtonItems = buttons;
    
    if ([self.preViewController isKindOfClass:[CollectionDetailViewController class]])
    {
        self.isCollected = YES;
        [self setRightBtn];
    }
    //[self getGoodsInfo];
    [self getShopsInfo];
    self.Img = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getCommentInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Net
- (void)getGoodsInfo
{
    [HomePageNetwork getGoodsInStoreDetailPageWithPartnerID:self.infoBean.storeID withSuccessBlock:^(NSArray *goodsArr)
    {
        self.goodsArr = goodsArr;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    } withErrorBlock:^(NSError *err)
    {
        NSLog(@"getGoodsInStoreDetailPage err:%@",err);
    }];
}

- (void)getShopsInfo
{
    [HomePageNetwork getStoreListPageWithPartnerID:self.infoBean.storeID withSuccessBlock:^(NSArray *shopsArr)
     {
         self.shopsArr = shopsArr;
         [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
     } withErrorBlock:^(NSError *err)
     {
         NSLog(@"getGoodsInStoreDetailPage err:%@",err);
     }];
}

- (void)getCommentInfo
{
    [HomePageNetwork getStoreCommentWithPartnerID:self.infoBean.storeID withSuccessBlock:^(NSArray *commentArr)
    {
        self.commentArr = commentArr;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
    } withErrorBlock:^(NSError *err)
    {
        NSLog(@"getStoreCommen err:%@",err);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return (self.infoBean.storeMobile && ![self.infoBean.storeMobile isEqualToString:@""])?4:3;
            break;
        case 3:
            return self.goodsArr.count;
            break;
        case 1:
            return self.shopsArr.count;
            break;
        case 2:
            return self.commentArr.count;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, CellHeight)];
                    [pic setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Server_ImgHost, self.infoBean.storeImage]] placeholderImage:[UIImage imageNamed:@"pic_2loading.png"]];
                    self.Img = [pic image];
                    [cell.contentView addSubview:pic];
                }
                    break;
                case 1:
                case 2:
                {
                    NSString *iconImgStr = indexPath.row==1?@"dengwei.png":@"lianxidianhua.png";
                    cell.imageView.image = [UIImage imageNamed:iconImgStr];
                    NSString *context = indexPath.row==1?self.infoBean.storeAddress:self.infoBean.storePhone;
                    cell.textLabel.text = context;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                    break;
                case 3:
                    cell.imageView.image = [UIImage imageNamed:@"lianxidianhua.png"];
                    cell.textLabel.text = self.infoBean.storeMobile;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
            }
        }
            break;
        case 3:
        {
            [self section1UIWithCell:cell withCellHeight:CellHeight withRow:indexPath.row];
        }
            break;
        case 1:
        {
            [self section3UIWithCell:cell withCellHeight:CellHeight withRow:indexPath.row];
        }
            break;
        case 2:
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [self section2UIWithCell:cell withCellHeight:CellHeight withRow:indexPath.row];
        }
            break;
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    return cell;
}

- (void)section1UIWithCell:(UITableViewCell *)cell withCellHeight:(CGFloat)cellHeight withRow:(NSInteger)row
{
    GoodsBean *goods = [self.goodsArr objectAtIndex:row];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, cellHeight-20, cellHeight-20)];
    [imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Server_ImgHost, goods.goodsImgLastComponentURL]] placeholderImage:[UIImage imageNamed:@"pic_2loading.png"]];
    [cell.contentView addSubview:imgView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(imgView.frame.origin.x+imgView.frame.size.width+10, 10, ScreenWidth-(imgView.frame.origin.x+imgView.frame.size.width+20), 13)];
    title.text = goods.goodsName;
    [cell.contentView addSubview:title];
    
    UILabel *originalPrice = [[UILabel alloc] initWithFrame:CGRectMake(title.frame.origin.x, 9+title.frame.origin.y+title.frame.size.height, ScreenWidth-(imgView.frame.origin.x+imgView.frame.size.width+20), 13)];
    originalPrice.text = [NSString stringWithFormat:@"原价￥%@",goods.goodsPrice];
    originalPrice.textColor = [UIColor lightGrayColor];
    originalPrice.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:originalPrice];
    
    UILabel *selled = [[UILabel alloc] initWithFrame:CGRectMake(title.frame.origin.x, 9+originalPrice.frame.origin.y+originalPrice.frame.size.height, title.frame.size.width, 13)];
    selled.text = [NSString stringWithFormat:@"已售：%@件",goods.goodsSellsCount];
    [cell.contentView addSubview:selled];
    
    UILabel *nowPrice = [[UILabel alloc] init];
    nowPrice.text = [NSString stringWithFormat:@"现价￥%@",goods.goodsNowPrice];
    nowPrice.textColor = NavBarColor;
    nowPrice.font = [UIFont systemFontOfSize:16];
    [nowPrice sizeToFit];
    nowPrice.frame = CGRectMake(ScreenWidth-nowPrice.frame.size.width-5, (cellHeight-nowPrice.frame.size.height)/2, nowPrice.frame.size.width, nowPrice.frame.size.height);
    [cell.contentView addSubview:nowPrice];
}

- (void)section2UIWithCell:(UITableViewCell *)cell withCellHeight:(CGFloat)cellHeight withRow:(NSInteger)row
{
    CommentBean *comment = [self.commentArr objectAtIndex:row];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, cellHeight-20, cellHeight-20)];
    [imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Server_ImgHost, comment.commentAvatar]] placeholderImage:[UIImage imageNamed:@"pic_2loading.png"]];
    [cell.contentView addSubview:imgView];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(imgView.frame.origin.x+imgView.frame.size.width+10, 10, ScreenWidth-(imgView.frame.origin.x+imgView.frame.size.width+20), 13)];
    name.text = comment.commentUserName;
    [cell.contentView addSubview:name];
    
    CGSize contentSize = [comment.commentContent boundingRectWithSize:CGSizeMake(ScreenWidth-name.frame.origin.x, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil].size;
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(name.frame.origin.x, 9+name.frame.origin.y+name.frame.size.height, ScreenWidth-(imgView.frame.origin.x+imgView.frame.size.width+20), contentSize.height)];
    content.text = comment.commentContent;
    content.textColor = [UIColor lightGrayColor];
    content.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:content];
}

- (void)section3UIWithCell:(UITableViewCell *)cell withCellHeight:(CGFloat)cellHeight withRow:(NSInteger)row
{
    StoreBean *goods = [self.shopsArr objectAtIndex:row];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, cellHeight-20, cellHeight-20)];
    [imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Server_ImgHost, goods.storeImageThumb]] placeholderImage:[UIImage imageNamed:@"pic_2loading.png"]];
    [cell.contentView addSubview:imgView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(imgView.frame.origin.x+imgView.frame.size.width+10, 10, ScreenWidth-(imgView.frame.origin.x+imgView.frame.size.width+20), 13)];
    title.text = goods.storeTitle;
    [cell.contentView addSubview:title];
    
    UILabel *location = [[UILabel alloc] initWithFrame:CGRectMake(title.frame.origin.x, 19+title.frame.origin.y+title.frame.size.height, ScreenWidth-(imgView.frame.origin.x+imgView.frame.size.width+20), 13)];
    location.text = [NSString stringWithFormat:@"%@",goods.storeLocation];
    location.textColor = [UIColor lightGrayColor];
    location.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:location];
    
    /*UILabel *selled = [[UILabel alloc] initWithFrame:CGRectMake(title.frame.origin.x, 9+originalPrice.frame.origin.y+originalPrice.frame.size.height, title.frame.size.width, 13)];
    selled.text = [NSString stringWithFormat:@"已售：%@件",goods.goodsSellsCount];
    [cell.contentView addSubview:selled];
    
    UILabel *nowPrice = [[UILabel alloc] init];
    nowPrice.text = [NSString stringWithFormat:@"现价￥%@",goods.goodsNowPrice];
    nowPrice.textColor = NavBarColor;
    nowPrice.font = [UIFont systemFontOfSize:16];
    [nowPrice sizeToFit];
    nowPrice.frame = CGRectMake(ScreenWidth-nowPrice.frame.size.width-5, (cellHeight-nowPrice.frame.size.height)/2, nowPrice.frame.size.width, nowPrice.frame.size.height);
    [cell.contentView addSubview:nowPrice];*/
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 1:
                {
                    MapViewController *map = [[MapViewController alloc] init];
                    map.title = @"商家定位";
                    map.store = self.infoBean;
                    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
                    map.edgesForExtendedLayout = UIRectEdgeNone;
                    [self.navigationController pushViewController:map animated:YES];
                }
                    break;
                case 2:
                case 3:
                {
                    NSString *telStr = [NSString stringWithFormat:@"tel://%@",indexPath.row==3?self.infoBean.storeMobile:self.infoBean.storePhone];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
                }
                    break;
            }
        }
            break;
        case 3:
        {
            GoodsBean *goods = [self.goodsArr objectAtIndex:indexPath.row];
            GoodsDetailTableViewController *store = [[GoodsDetailTableViewController alloc] init];
            [store passInfoBean:goods];
            store.goodsOnSellsType = CheckGoodsOnSellsTypeInStore;
            store.edgesForExtendedLayout = UIRectEdgeNone;
            [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
            [self.navigationController pushViewController:store animated:YES];
        }
            break;
        case 1:
        {
            NSLog(@"888888888888888888888888888888888");
            NSLog(@"=========%@",self.shopsArr);
            StoreBean *storedInfo = [self.shopsArr objectAtIndex:indexPath.row];
            SubStoreDetailViewController *store = [[SubStoreDetailViewController alloc] init];
            store.title = storedInfo.storeTitle;
            [store passInfoBean:storedInfo];
            [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
            [self.navigationController pushViewController:store animated:YES];
        }
            break;
        case 2:
        {
            ;
        }
            break;
    };
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return indexPath.row==0?ScreenWidth*3/4:44;
            break;
        case 3:
            return 70;
            break;
        case 1:
            return 70;
            break;
        case 2:
        {
            CommentBean *comment = [self.commentArr objectAtIndex:indexPath.row];
            CGFloat commentHeight = [comment.commentContent boundingRectWithSize:CGSizeMake(ScreenWidth-45, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height;NSLog(@"commentHeight:%f",commentHeight);
            return commentHeight+33;
        }
            break;
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section!=0?44:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return (section==1||section==0)?10:0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        bg.backgroundColor = [UIColor whiteColor];
        UIImageView *icon = [[UIImageView alloc] init];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(icon.frame.size.width+10+icon.frame.origin.x, 0, ScreenWidth-(icon.frame.size.width+10+icon.frame.origin.x), bg.frame.size.height)];
        //title.text = section==1?@"商品列表":@"评论列表";
        if (section == 3)
        {
            title.text = @"商品列表";
        }
        
        if (section == 1)
        {
            title.text = @"分店列表";
        }
        
        if (section == 2)
        {
            title.text = @"评论列表";
        }
        
        title.center = CGPointMake(title.center.x, bg.frame.size.height/2.0);
        [bg addSubview:icon];
        [bg addSubview:title];
        if (section == 2) {
            UILabel *comment = [[UILabel alloc] init];
            comment.userInteractionEnabled = YES;
            comment.text = @"去评论";
            [comment sizeToFit];
            comment.frame = CGRectMake(ScreenWidth-comment.frame.size.width-5, 0, comment.frame.size.width, comment.frame.size.height);
            comment.center = CGPointMake(comment.center.x, bg.frame.size.height/2.0);
            [bg addSubview:comment];
            UIButton *gotoComment = [[UIButton alloc] initWithFrame:comment.bounds];
            [gotoComment addTarget:self action:@selector(pressedGoToComment) forControlEvents:UIControlEventTouchUpInside];
            [comment addSubview:gotoComment];
        }
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, bg.frame.size.height-0.5, ScreenWidth, .5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [bg addSubview:line];
        return bg;
    }
    return nil;
}

#pragma mark - Button Response
- (void)pressedRightBtn
{
    //if ([self.presentedViewController isKindOfClass:[CollectionDetailViewController class]]) {
    [ProgressHUD show:@"请稍后..." Interaction:YES Hide:NO];
    [HomePageNetwork collectStoreWithUserID:User.userID withPartnerID:self.infoBean.storeID withType:self.isCollected?@"cancel":@"collect" withSuccessBlock:^(BOOL finished)
    {
        if (finished)
        {
            if (self.isCollected)
            {
                self.isCollected = NO;
                [self setRightBtn];
                self.infoBean.storeCollected = NO;//返回成功后写
            }
            else
            {
                self.isCollected = YES;
                [self setRightBtn];
                self.infoBean.storeCollected = YES;//返回成功后写
            }
            [ProgressHUD dismiss];
        }
        else {
            [ProgressHUD showText:@"操作失败，请检查网络稍后重试" Interaction:YES Hide:YES];
        }
    } withErrorBlock:^(NSError *err)
    {
        NSLog(@"collectStore type:%@ err:%@",self.isCollected?@"cancel":@"collect", err);
        if (err.code == -1009)
        {
            [ProgressHUD showText:@"网络超时，请检查网络稍后重试" Interaction:YES Hide:YES];
        }
        else {
            [ProgressHUD showText:@"操作失败，请检查网络后重试" Interaction:YES Hide:YES];
        }
    }];
//    }
}

- (void)pressedGoToComment
{
    WriteCommentViewController *commentView = [[WriteCommentViewController alloc] init];
    commentView.title = @"评论";
    commentView.edgesForExtendedLayout = UIRectEdgeNone;
    commentView.store = self.infoBean;
    [self.navigationController pushViewController:commentView animated:YES];
}

#pragma mark - Tool & Private
- (void)setRightBtn {
    UIImage *rightBtnImg = nil;
//    if ([self.presentedViewController isKindOfClass:[CollectionDetailViewController class]]) {
        if (self.isCollected)
        {
            rightBtnImg = [UIImage imageNamed:@"nav-btn-shouchang-pre.png"];
        }
        else
        {
            rightBtnImg = [UIImage imageNamed:@"nav-btn-shouchang.png"];
        }
    [self.rightBtn setImage:rightBtnImg forState:UIControlStateNormal];
//    }
}

#pragma mark - Setter & Getter
- (void)passInfoBean:(StoreBean *)infoBean
{
    self.infoBean = infoBean;
}

#pragma mark - Button Response
- (void)ShareBtn
{
    UIImage *image = [self getNormalImage:self.parentViewController.view];
    //[UIImage imageNamed:@"sharelogo.png"]
    //[NSURL URLWithString:@"http://a.app.qq.com/o/simple.jsp?pkgname=com.jianiao.shangnamei"]
    //self.infoBean.storeAddress
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:nil images:@[image] url:nil title:self.title type:SSDKContentTypeAuto];
    
    //__weak typeof(self)wself = self;
    SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:self.view items:@[@(SSDKPlatformTypeSinaWeibo), @(SSDKPlatformSubTypeQQFriend), @(SSDKPlatformSubTypeWechatSession), @(SSDKPlatformSubTypeWechatTimeline)] shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end)
    {
        NSLog(@"platformType:%lu",(unsigned long)platformType);
        switch (state) {
            case SSDKResponseStateBegin:
                [ProgressHUD show:nil Interaction:NO Hide:NO];
                break;
            case SSDKResponseStateSuccess:
            {
                NSMutableArray *shared = [[NSUserDefaults standardUserDefaults] objectForKey:sharedItem];
                BOOL sharedContain = NO;
                for (NSNumber *item in shared) {
                    if (platformType == [item integerValue]) {
                        sharedContain = YES;
                        break;
                    }
                }
                if (!shared || !sharedContain)
                {
                    [ProgressHUD showText:@"分享成功，正在获取臭美币" Interaction:NO Hide:NO];
                    
                }
                else {
                    [ProgressHUD showText:@"分享成功" Interaction:YES Hide:YES];
                }
            }
                break;
            case SSDKResponseStateFail:
                [ProgressHUD showText:@"分享失败" Interaction:YES Hide:YES];
                break;
            default:
                [ProgressHUD showText:@"取消分享" Interaction:YES Hide:YES];
                break;
        }
    }];
    [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];
}

//获取当前屏幕内容
- (UIImage *)getNormalImage:(UIView *)view
{
    float width = [UIScreen mainScreen].bounds.size.width;
    float height = [UIScreen mainScreen].bounds.size.height;
    NSLog(@"width===%f,height===%f",width,height);
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    /*UIGraphicsBeginImageContext(view.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext: context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;*/
}

@end
