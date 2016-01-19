//
//  CouponCell.h
//  BeautyWhere
//
//  Created by Michael on 15/8/17.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "SlideTableViewCell.h"
#import "CouponBean.h"

@interface CouponCell : SlideTableViewCell

@property (nonatomic, strong) CouponBean *infoBean;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCouponBean:(CouponBean *)infoBean withCellHeight:(CGFloat)cellHeight;
-(void)customCell;

@end
