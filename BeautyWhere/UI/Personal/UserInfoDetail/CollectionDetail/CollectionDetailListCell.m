//
//  CollectionDetailListCell.m
//  BeautyWhere
//
//  Created by Michael on 15/8/4.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "CollectionDetailListCell.h"
#import "UIImageView+AFNetworking.h"

@interface CollectionDetailListCell ()

@property (nonatomic, assign) CGFloat cellHeight;

@end

@implementation CollectionDetailListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withStoreBean:(StoreBean *)store withCellHeight:(CGFloat)cellHeight {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.cellHeight = cellHeight;
        self.store = store;
        [self customCell];
    }
    return self;
}

-(void)customCell {
    UIImageView *imgView = (UIImageView *)[self.moveContentView viewWithTag:collectionDetailIconTag];
    if (!imgView) {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.cellHeight-20, self.cellHeight-20)];
        imgView.tag = collectionDetailIconTag;
        [self.moveContentView addSubview:imgView];
    }
    [imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Server_ImgHost, self.store.storeImage]] placeholderImage:[UIImage imageNamed:@"pic_2loading.png"]];
    
    UILabel *title = (UILabel *)[self.moveContentView viewWithTag:collectionDetailNameTag];
    if (!title) {
        title = [[UILabel alloc] initWithFrame:CGRectMake(imgView.frame.origin.x+imgView.frame.size.width+10, 10, ScreenWidth-(imgView.frame.origin.x+imgView.frame.size.width+20), 13)];
        title.tag = collectionDetailNameTag;
        [self.moveContentView addSubview:title];
    }
    title.text = self.store.storeTitle;
    
    TQStarRatingView *starRatingView = (TQStarRatingView *)[self.moveContentView viewWithTag:collectionDetailStarTag];
    if (!starRatingView) {
        starRatingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(title.frame.origin.x, title.frame.origin.y+title.frame.size.height+9, 65, 10) numberOfStar:5 withState:MarkStateFullScore withStarImgWith:9 touch:NO];NSLog(@"self.store.storeStar:%@",self.store.storeStar);
        starRatingView.tag = collectionDetailStarTag;
        starRatingView.delegate = self;
        [self.moveContentView addSubview:starRatingView];
    }
    [starRatingView setScore:[self.store.storeStar floatValue]/5 withAnimation:NO];
    
    UILabel *address = (UILabel *)[self.moveContentView viewWithTag:collectionDetailAddressTag];
    if (!address) {
        address = [[UILabel alloc] initWithFrame:CGRectMake(starRatingView.frame.origin.x, 9+starRatingView.frame.origin.y+starRatingView.frame.size.height, ScreenWidth-(imgView.frame.origin.x+imgView.frame.size.width+20), 13)];
        address.tag = collectionDetailAddressTag;
        [self.moveContentView addSubview:address];
    }
    address.text = self.store.storeAddress;
    
    [self.contentView.gestureRecognizers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.contentView removeGestureRecognizer:obj];
    }];
}

@end
