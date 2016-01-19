//
//  CouponCell.m
//  BeautyWhere
//
//  Created by Michael on 15/8/17.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "CouponCell.h"

@interface CouponCell ()

@property (nonatomic, assign) CGFloat cellHeight;

@end

@implementation CouponCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCouponBean:(CouponBean *)infoBean withCellHeight:(CGFloat)cellHeight {
    if (self = [super init]) {
        self.infoBean = infoBean;
        self.cellHeight = cellHeight;
        [self customCell];
    }
    return self;
}

-(void)customCell {
    UIView *bg = (UIView *)[self.moveContentView viewWithTag:couponDetailBgTag];
    if (!bg) {
        bg = [[UIView alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth-20, self.cellHeight-20)];
        bg.tag = couponDetailBgTag;
        bg.backgroundColor = [UIColor colorWithRed:21.0/255.0 green:174.0/255.0 blue:103.0/255.0 alpha:1.0];
        [self.moveContentView addSubview:bg];
    }
    
    UILabel *title = (UILabel *)[bg viewWithTag:couponDetailTitleTag];
    if (!title) {
        title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth, 17)];
        title.tag = couponDetailTitleTag;
        title.textColor = [UIColor whiteColor];
        [bg addSubview:title];
    }
    
    title.text = self.infoBean.couponTitle;
    [title sizeToFit];
    title.frame = CGRectMake(10, 10, bg.frame.size.width, title.frame.size.height);
    
    UILabel *condiction = (UILabel *)[bg viewWithTag:couponDetailCondictionTag];
    if (!condiction) {
        condiction = [[UILabel alloc] init];
        condiction.tag = couponDetailCondictionTag;
        condiction.textColor = [UIColor whiteColor];
        [bg addSubview:condiction];
    }
    
    //condiction.text = [NSString stringWithFormat:@"满%@元可用",self.infoBean.couponTerms];
    condiction.text = [NSString stringWithFormat:@"附近美容院可用"];
    [condiction sizeToFit];
    condiction.frame = CGRectMake(title.frame.origin.x, self.cellHeight-condiction.frame.size.height-20, condiction.frame.size.width, condiction.frame.size.height);
    
    UILabel *workDate = (UILabel *)[bg viewWithTag:couponDetailWorkDataTag];
    if (!workDate) {
        workDate = [[UILabel alloc] init];
        workDate.tag = couponDetailWorkDataTag;
        workDate.textColor = [UIColor whiteColor];
        [bg addSubview:workDate];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];//设置要显示的格式
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[self.infoBean.couponExpireTime intValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    workDate.text = [NSString stringWithFormat:@"有效期：%@",confromTimespStr];
    [workDate sizeToFit];
    workDate.frame = CGRectMake(bg.frame.size.width-10-workDate.frame.size.width, condiction.frame.origin.y, workDate.frame.size.width, workDate.frame.size.height);
    
    [self.contentView.gestureRecognizers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.contentView removeGestureRecognizer:obj];
    }];
}

@end
