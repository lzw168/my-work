//
//  InfoListCell.m
//  BeautyWhere
//
//  Created by Michael on 15/8/6.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "InfoListCell.h"
#import "UIImageView+AFNetworking.h"

@interface InfoListCell ()

@property (nonatomic, assign) CGFloat cellHeight;

@end

@implementation InfoListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withStoreBean:(InfoBean *)infoBean withCellHeight:(CGFloat)cellHeight
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.cellHeight = cellHeight;
        self.infoBean = infoBean;
        [self customCell];
    }
    return self;
}

-(void)customCell
{
    UIImageView *imgView = (UIImageView*)[self.moveContentView viewWithTag:infoListIconViewTag];
    if (!imgView)
    {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.cellHeight-20, self.cellHeight-20)];
        imgView.tag = infoListIconViewTag;
        [self.moveContentView addSubview:imgView];
    }
    [imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Server_ImgHost, self.infoBean.infoImage]] placeholderImage:[UIImage imageNamed:@"pic_2loading.png"]];
    
    UILabel *title = (UILabel*)[self.moveContentView viewWithTag:infoListTitleTag];
    if (!title)
    {
        title = [[UILabel alloc] initWithFrame:CGRectMake(imgView.frame.origin.x+imgView.frame.size.width+10, 15, ScreenWidth-(imgView.frame.origin.x+imgView.frame.size.width+30), 15)];
        //title.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
        title.font = [UIFont systemFontOfSize:13.0];
        title.tag = infoListTitleTag;
        [self.moveContentView addSubview:title];
    }
    title.text = self.infoBean.infoTitle;
    
    UILabel *intro = (UILabel*)[self.moveContentView viewWithTag:infoListSummaryTag];
    if (!intro)
    {
        intro = [[UILabel alloc] initWithFrame:CGRectMake(title.frame.origin.x, 19+title.frame.origin.y+title.frame.size.height, ScreenWidth-(imgView.frame.origin.x+imgView.frame.size.width+60), self.cellHeight/2)];
        intro.tag = infoListSummaryTag;
        [self.moveContentView addSubview:intro];
    }
    intro.text = self.infoBean.infoIntro;
    intro.font = [UIFont systemFontOfSize:11.0];
    intro.textColor = [UIColor grayColor];
    
    UILabel *date = (UILabel*)[self.moveContentView viewWithTag:infoListDateTag];
    if (!date) {
        date = [[UILabel alloc] init];
        date.tag = infoListDateTag;
        date.font = [UIFont systemFontOfSize:9];
        [self.moveContentView addSubview:date];
    }
    date.text = [[self.infoBean.infoCreateTime componentsSeparatedByString:@" "] firstObject];
    [date sizeToFit];
    date.frame = CGRectMake(ScreenWidth-date.frame.size.width-5, (self.cellHeight-date.frame.size.height)/2, date.frame.size.width, date.frame.size.height);
    
    [self.contentView.gestureRecognizers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
        [self.contentView removeGestureRecognizer:obj];
    }];
}

@end
