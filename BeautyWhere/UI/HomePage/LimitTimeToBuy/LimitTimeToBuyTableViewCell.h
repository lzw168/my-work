//
//  LimitTimeToBuyTableViewCell.h
//  BeautyWhere
//
//  Created by Michael Chan on 15/8/11.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "SlideTableViewCell.h"
#import "GoodsBean.h"
#import "LimitTimeToBuyTableViewController.h"

@interface LimitTimeToBuyTableViewCell : SlideTableViewCell

@property (nonatomic, strong) GoodsBean *infoBean;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withGoodsBean:(GoodsBean *)infoBean withCellHeight:(CGFloat)cellHeight withPageType:(PageType)pageType;
-(void)customCell;

@end
