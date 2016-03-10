//
//  NearbyStoreListCell.m
//  BeautyWhere
//
//  Created by Michael on 15/8/17.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "NearbyStoreListCell.h"
#import "UIImageView+AFNetworking.h"

@interface NearbyStoreListCell ()

@property (nonatomic, assign) CGFloat cellHeight;

@end

@implementation NearbyStoreListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withStoreBean:(StoreBean *)infoBean withCellHeight:(CGFloat)cellHeight {
    if (self = [super init]) {
        self.infoBean = infoBean;
        self.cellHeight = cellHeight;
        [self customCell];
    }
    return self;
}

-(void)customCell {
    UIImageView *imgView = (UIImageView *)[self.moveContentView viewWithTag:nearbyStoreIconTag];
    if (!imgView)
    {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.cellHeight-20, self.cellHeight-20)];
        imgView.tag = nearbyStoreIconTag;
        [self.moveContentView addSubview:imgView];
    }
    NSLog(@" self.infoBean.storeImage]=====%@", self.infoBean.storeImageThumb);
    [imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",GetAppDelegate.img_path, self.infoBean.storeImageThumb]] placeholderImage:[UIImage imageNamed:@"pic_2loading.png"]];
    
    UILabel *title = (UILabel *)[self.moveContentView viewWithTag:nearbyStoreTitleTag];
    if (!title) {
        title = [[UILabel alloc] initWithFrame:CGRectMake(imgView.frame.origin.x+imgView.frame.size.width+10, 10, ScreenWidth-(imgView.frame.origin.x+imgView.frame.size.width+20), 13)];
        title.tag = nearbyStoreTitleTag;
        [self.moveContentView addSubview:title];
    }
    title.text = self.infoBean.storeTitle;
    [title setFont:[UIFont systemFontOfSize:13.0]];
    
    TQStarRatingView *starRatingView = (TQStarRatingView *)[self.moveContentView viewWithTag:nearbyStoreStarTag];
    if (!starRatingView)
    {
        starRatingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(title.frame.origin.x, title.frame.origin.y+title.frame.size.height+16, 65, 10) numberOfStar:5 withState:MarkStateFullScore withStarImgWith:9 touch:NO];NSLog(@"self.store.storeStar:%@",self.infoBean.storeStar);
        starRatingView.tag = nearbyStoreStarTag;
        starRatingView.delegate = self;
        [self.moveContentView addSubview:starRatingView];
    }
    [starRatingView setScore:[self.infoBean.storeStar floatValue]/5 withAnimation:NO];
    
    UILabel *address = (UILabel *)[self.moveContentView viewWithTag:nearbyStoreAddressTag];
    if (!address) {
        address = [[UILabel alloc] initWithFrame:CGRectMake(starRatingView.frame.origin.x, self.cellHeight-23, ScreenWidth-(imgView.frame.origin.x+imgView.frame.size.width+20), 13)];
        address.tag = nearbyStoreAddressTag;
        [self.moveContentView addSubview:address];
    }
    if (self.infoBean.storeStreet == nil)
    {
        self.infoBean.storeStreet = @"";
        address.text = [NSString stringWithFormat:@"%@%@",self.infoBean.storeDistrict, self.infoBean.storeStreet];
    }
    else
    {
        address.text = [NSString stringWithFormat:@"%@/%@",self.infoBean.storeDistrict, self.infoBean.storeStreet];
    }
    [address setFont:[UIFont systemFontOfSize:13.0]];
    
    CGFloat distanceNum = [self.infoBean.storeDistance floatValue];
    NSString *distanceStr = [NSString stringWithFormat:@"%.1fkm",distanceNum/1000];
    NSLog(@"distanceStr:%@ distanceNum:%f",distanceStr, distanceNum);
    if (distanceNum/1000<0.5) {
        distanceStr = @"<500m";
    }
    else if (distanceNum/1000<1 && distanceNum/1000>=0.5) {
        distanceStr = [NSString stringWithFormat:@"%fm",(distanceNum/1000)];
    }
    UILabel *distance = (UILabel *)[self.moveContentView viewWithTag:nearbyStoreDistanceTag];
    if (!distance)
    {
        distance = [[UILabel alloc] init];
        distance.tag = nearbyStoreDistanceTag;
        distance.textColor = [UIColor lightGrayColor];
        //[self.moveContentView addSubview:distance];
    }
    distance.text = distanceStr;
    [distance sizeToFit];
    distance.frame = CGRectMake(ScreenWidth-distance.frame.size.width-10, self.cellHeight-distance.frame.size.height-10, distance.frame.size.width, distance.frame.size.height);
    
    [self.contentView.gestureRecognizers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
        [self.contentView removeGestureRecognizer:obj];
    }];
}

@end
