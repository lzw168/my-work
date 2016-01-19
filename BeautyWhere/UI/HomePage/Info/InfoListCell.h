//
//  InfoListCell.h
//  BeautyWhere
//
//  Created by Michael on 15/8/6.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "SlideTableViewCell.h"
#import "InfoBean.h"

@interface InfoListCell : SlideTableViewCell

@property (nonatomic, strong) InfoBean *infoBean;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withStoreBean:(InfoBean *)infoBean withCellHeight:(CGFloat)cellHeight;
-(void)customCell;

@end
