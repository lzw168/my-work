//
//  CollectionDetailListCell.h
//  BeautyWhere
//
//  Created by Michael on 15/8/4.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "SlideTableViewCell.h"
#import "StoreBean.h"
#import "TQStarRatingView.h"

@interface CollectionDetailListCell : SlideTableViewCell <StarRatingViewDelegate>

@property (nonatomic, strong) StoreBean *store;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withStoreBean:(StoreBean *)store withCellHeight:(CGFloat)cellHeight;

-(void)customCell;

@end
