//
//  LoginViewController.h
//  BeautyWhere
//
//  Created by Michael on 15/7/24.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BackItemType) {
    BackItemTypeNormal,
    BackItemTypeBackImg,
    BackItemTypeNone
};

typedef NS_ENUM(NSInteger, EnterType) {
    EnterTypePush,
    EnterTypePresent,
    EnterTypeAdd
};

typedef NS_ENUM(NSInteger, LoginPageType) {
    LoginPageTypeLogin,
    LoginPageTypeBindPhoneNum
};

@interface LoginViewController : UIViewController
<
    UITextFieldDelegate,
    UINavigationControllerDelegate
>

@property (nonatomic, assign) BackItemType backItemType;
@property (nonatomic, assign) EnterType enterType;
@property (nonatomic, assign) LoginPageType pageType;

- (void)loginWithThirdParty:(NSString *)type;

@end
