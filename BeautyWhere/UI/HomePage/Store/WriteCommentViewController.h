//
//  WriteCommentViewController.h
//  BeautyWhere
//
//  Created by Michael on 15/8/20.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreBean.h"
#import "TQStarRatingView.h"

@interface WriteCommentViewController : UIViewController
<
    UITextViewDelegate,
    StarRatingViewDelegate
>

@property (nonatomic, strong)StoreBean *store;

@end
