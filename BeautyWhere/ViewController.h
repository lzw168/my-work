//
//  ViewController.h
//  BeautyWhere
//
//  Created by Michael on 15-7-21.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "EAIntroPage.h"
#import "EAIntroView.h"

@interface ViewController : UIViewController <UIScrollViewDelegate,EAIntroDelegate>

+ (void)presentLoginViewWithViewController:(UIViewController *)vc backItemType:(BackItemType)type;

@end

