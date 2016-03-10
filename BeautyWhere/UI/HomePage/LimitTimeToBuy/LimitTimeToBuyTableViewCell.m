//
//  LimitTimeToBuyTableViewCell.m
//  BeautyWhere
//
//  Created by Michael Chan on 15/8/11.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "LimitTimeToBuyTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface LimitTimeToBuyTableViewCell ()

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) PageType pageType;

@end

@implementation LimitTimeToBuyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withGoodsBean:(GoodsBean *)infoBean withCellHeight:(CGFloat)cellHeight withPageType:(PageType)pageType
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.cellHeight = cellHeight;
        self.infoBean = infoBean;
        self.pageType = pageType;
        [self customCell];
    }
    return self;
}

-(void)customCell
{
    UIImageView *imgView = (UIImageView *)[self.moveContentView viewWithTag:limitTimeIconTag];
    if (!imgView)
    {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.cellHeight-20, self.cellHeight-20)];
        imgView.tag = limitTimeIconTag;
        [self.moveContentView addSubview:imgView];
    }
    
    [imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",GetAppDelegate.img_path, self.infoBean.self.img_thumb]] placeholderImage:[UIImage imageNamed:@"pic_2loading.png"]];
    
    UILabel *title = (UILabel *)[self.moveContentView viewWithTag:limitTimeGoodsNameTag];
    if (!title)
    {
        title = [[UILabel alloc] initWithFrame:CGRectMake(imgView.frame.origin.x+imgView.frame.size.width+10, 10, ScreenWidth-(imgView.frame.origin.x+imgView.frame.size.width+20), 13)];
        title.tag = limitTimeGoodsNameTag;
        [self.moveContentView addSubview:title];
    }
    title.text = self.infoBean.goodsName;
    [title setFont:[UIFont systemFontOfSize:13.0]];
    
    UILabel *originalPrice = (UILabel *)[self.moveContentView viewWithTag:limitTimeOriginalPriceTag];
    if (!originalPrice) {
        originalPrice = [[UILabel alloc] initWithFrame:CGRectMake(title.frame.origin.x, 9+title.frame.origin.y+title.frame.size.height, ScreenWidth-(imgView.frame.origin.x+imgView.frame.size.width+20), 13)];
        originalPrice.tag = limitTimeOriginalPriceTag;
        originalPrice.textColor = [UIColor lightGrayColor];
        originalPrice.font = [UIFont systemFontOfSize:13];
        [self.moveContentView addSubview:originalPrice];
    }
    originalPrice.text = [NSString stringWithFormat:@"原价￥%@",self.infoBean.goodsPrice];
  
    UILabel *stock = (UILabel *)[self.moveContentView viewWithTag:limitTimeStockTag];
    if (!stock) {
        stock = [[UILabel alloc] initWithFrame:CGRectMake(title.frame.origin.x, imgView.frame.origin.y+imgView.frame.size.height-16, title.frame.size.width, 13)];
        stock.tag = limitTimeStockTag;
        [self.moveContentView addSubview:stock];
    }
    stock.text = [NSString stringWithFormat:@"库存:%@",self.infoBean.goodsTotalNum];
    [stock setFont:[UIFont systemFontOfSize:13.0]];
    
    UILabel *nowPrice = (UILabel *)[self.moveContentView viewWithTag:limitTimeNowPriceTag];
    if (!nowPrice) {
        nowPrice = [[UILabel alloc] init];
        nowPrice.tag = limitTimeNowPriceTag;
        nowPrice.textColor = NavBarColor;
        nowPrice.font = [UIFont systemFontOfSize:16];
        [self.moveContentView addSubview:nowPrice];
    }
    switch (self.pageType)
    {
        case PageTypeLimitFactory:
        case PageTypeSecKill:
            nowPrice.text = [NSString stringWithFormat:@"现价￥%@",self.infoBean.activity_price];
            break;
        case PageTypeShopping:
            nowPrice.text = [NSString stringWithFormat:@"现价￥%@",self.infoBean.activity_price];
            break;
    }
    [nowPrice sizeToFit];
    nowPrice.frame = CGRectMake(ScreenWidth-nowPrice.frame.size.width-5, (self.cellHeight-nowPrice.frame.size.height)/2, nowPrice.frame.size.width, nowPrice.frame.size.height);
    
    UILabel *seckillState = (UILabel *)[self.moveContentView viewWithTag:limitTimeSeckillStateTag];
    if (!seckillState)
    {
        seckillState = [[UILabel alloc] init];
        seckillState.tag = limitTimeSeckillStateTag;
        [self.moveContentView addSubview:seckillState];
    }
    if ([self.infoBean.goodsSeckillState isEqualToString:@"late"])
    {
        seckillState.text = @"已过期";
    }
    else if ([self.infoBean.goodsSeckillState isEqualToString:@"early"])
    {
        seckillState.text = @"即将开始";
    }
    else {
        seckillState.text = @"立即抢购";
    }
    [seckillState sizeToFit];
    [seckillState setFont:[UIFont systemFontOfSize:13.0]];
    seckillState.frame = CGRectMake(ScreenWidth-10-seckillState.frame.size.width, self.cellHeight-seckillState.frame.size.height-10, seckillState.frame.size.width, seckillState.frame.size.height);
    
    [self.contentView.gestureRecognizers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
        [self.contentView removeGestureRecognizer:obj];
    }];
}

@end
