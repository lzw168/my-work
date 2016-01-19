//
//  NearbyStoreListCell.h
//  BeautyWhere
//
//  Created by Michael on 15/8/17.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "SlideTableViewCell.h"
#import "StoreBean.h"
#import "TQStarRatingView.h"

@interface NearbyStoreListCell : SlideTableViewCell <StarRatingViewDelegate>

@property (nonatomic, strong) StoreBean *infoBean;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withStoreBean:(StoreBean *)infoBean withCellHeight:(CGFloat)cellHeight;
-(void)customCell;

@end
