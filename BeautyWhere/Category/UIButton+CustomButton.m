//
//  UIButton+CustomButton.m
//  BeautyWhere
//
//  Created by Michael on 15/7/23.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "UIButton+CustomButton.h"

@implementation UIButton (UIButton_CustomButton)

+ (UIButton *)createButtonWithTitle:(NSString *)buttonTitle withImg:(UIImage *)image withButtonHeight:(CGFloat)btnHeight {
    NSString *title = buttonTitle;
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = title;
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake(0, 0, titleLabel.frame.size.width, titleLabel.frame.size.height);
    titleLabel.center = CGPointMake(titleLabel.center.x, btnHeight/2.0);
    
    UIImage *img = image;
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    imgView.frame = CGRectMake(titleLabel.frame.origin.x+titleLabel.frame.size.width+5, 0, imgView.frame.size.width, imgView.frame.size.height);
    imgView.center = CGPointMake(imgView.center.x, btnHeight/2.0);
    
    __autoreleasing UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, titleLabel.frame.size.width+imgView.frame.size.width+5, btnHeight)];
    [btn addSubview:imgView];
    [btn addSubview:titleLabel];
    return btn;
}

@end
