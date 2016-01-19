//
//  UIButton+CustomButton.h
//  BeautyWhere
//
//  Created by Michael on 15/7/23.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (UIButton_CustomButton)

+ (UIButton *)createButtonWithTitle:(NSString *)buttonTitle withImg:(UIImage *)image withButtonHeight:(CGFloat)btnHeight;

@end
