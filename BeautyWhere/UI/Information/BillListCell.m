//
//  BillListCell.m
//  BeautyWhere
//
//  Created by Michael on 15/8/24.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "BillListCell.h"
#import "UIImageView+AFNetworking.h"

@interface BillListCell ()

@property (nonatomic, assign) CGFloat cellHeight;

@end

@implementation BillListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withBillBean:(BillBean *)infoBean withCellHeight:(CGFloat)cellHeight {
    if (self = [super init]) {
        self.infoBean = infoBean;
        self.cellHeight = cellHeight;
        [self customCell];
    }
    return self;
}

-(void)customCell {
    UIImageView *imgView = (UIImageView *)[self.moveContentView viewWithTag:billListIconTag];
    if (!imgView) {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.cellHeight-20, self.cellHeight-20)];
        imgView.tag = billListIconTag;
        [self.moveContentView addSubview:imgView];
    }
    [imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Server_ImgHost, self.infoBean.billImgURLLaxtComponent]] placeholderImage:[UIImage imageNamed:@"pic_2loading.png"]];
    
    UILabel *billID = (UILabel *)[self.moveContentView viewWithTag:billListBillIDTag];
    if (!billID) {
        billID = [[UILabel alloc] initWithFrame:CGRectMake(imgView.frame.origin.x+imgView.frame.size.width+10, 10, ScreenWidth-(imgView.frame.origin.x+imgView.frame.size.width+20), 13)];
        billID.tag = billListBillIDTag;
        [self.moveContentView addSubview:billID];
    }
    billID.text = self.infoBean.billOrderID;
    billID.font = [UIFont systemFontOfSize:13];
    
    UILabel *goodsName = (UILabel *)[self.moveContentView viewWithTag:billListGoodsNameTag];
    if (!goodsName) {
        goodsName = [[UILabel alloc] initWithFrame:CGRectMake(billID.frame.origin.x, 15+billID.frame.origin.y+billID.frame.size.height, billID.frame.size.width, 13)];
        goodsName.tag = billListGoodsNameTag;
        goodsName.font = [UIFont systemFontOfSize:13];
        [self.moveContentView addSubview:goodsName];
    }
    if(self.infoBean.billOrderTitle.length==0)
    {
        self.infoBean.billOrderTitle = @"";
    }
    goodsName.text = [NSString stringWithFormat:@"产品名称:%@",self.infoBean.billOrderTitle];
    
    UILabel *payState = (UILabel *)[self.moveContentView viewWithTag:billListPayStateTag];
    if (!payState) {
        payState = [[UILabel alloc] initWithFrame:CGRectMake(billID.frame.origin.x, 15+goodsName.frame.origin.y+goodsName.frame.size.height, billID.frame.size.width, 13)];
        payState.tag = billListPayStateTag;
        [self.moveContentView addSubview:payState];
    }
    NSString *payStateStr = self.infoBean.billState;
    if ([payStateStr isEqualToString:@"unpay"]) {
        payState.text = @"未支付";
    }
    else if ([payStateStr isEqualToString:@"cancel"]) {
        payState.text = @"支付取消";
    }
    else if ([payStateStr isEqualToString:@"pay"]) {
        payState.text = @"已支付";
    }
    else if ([payStateStr isEqualToString:@"done"]) {
        payState.text = @"已使用";
    }
    payState.font = [UIFont systemFontOfSize:13];
    payState.textColor = [UIColor grayColor];
    
    [self.contentView.gestureRecognizers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.contentView removeGestureRecognizer:obj];
    }];
}

@end
