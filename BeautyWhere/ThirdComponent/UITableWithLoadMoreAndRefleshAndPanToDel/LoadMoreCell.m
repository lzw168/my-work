//
//  LoadMoreCell.m
//  ShowProduct
//
//  Created by klbest1 on 14-5-22.
//  Copyright (c) 2014年 @"". All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "LoadMoreCell.h"

@implementation LoadMoreCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
//    NSLog(@"LoadMoreCell layoutSubviews frame:%@",NSStringFromCGRect(self.frame));
//    NSLog(@"LoadMoreCell contentView subviews:%@",self.contentView.subviews);
    for (id item in self.contentView.subviews)
    {
        if ([item isKindOfClass:[UILabel class]])
        {
            UILabel *obj = (UILabel*)item;
            if ([obj.text isEqualToString:@"点击加载更多"])
            {
                obj.frame = CGRectMake((ScreenWidth-obj.frame.size.width)/2, obj.frame.origin.y, obj.frame.size.width, obj.frame.size.height);
            }
            break;
        }
    }
}

- (void)dealloc {
    [_indicatorView release];
    [super dealloc];
}
@end
