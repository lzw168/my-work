//
//  BillListCell.h
//  BeautyWhere
//
//  Created by Michael on 15/8/24.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "SlideTableViewCell.h"
#import "BillBean.h"

@interface LectureHallListCell : SlideTableViewCell

@property (nonatomic, strong) BillBean *infoBean;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withBillBean:(BillBean *)infoBean withCellHeight:(CGFloat)cellHeight;
-(void)customCell;

@end
