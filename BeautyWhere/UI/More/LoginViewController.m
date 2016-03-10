//
//  LoginViewController.m
//  BeautyWhere
//
//  Created by Michael on 15/7/24.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "LoginViewController.h"
#import "MorePageNetwork.h"
#import "PersonalViewController.h"
#import "UserProtocolDetailViewController.h"
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import "WXApi.h"

static const NSInteger defaultCountDown = 59;

@interface LoginViewController ()

@property (nonatomic, strong) UITextField *phoneNum;
@property (nonatomic, strong) UITextField *checkCode;
@property (nonatomic, strong) UIButton *getCodeBtn;
@property (nonatomic, assign) NSInteger countDown;
@property (nonatomic, strong) SSDKUser *socialUser;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.countDown = defaultCountDown;
    self.title= self.pageType==LoginPageTypeLogin?@"快速登录":@"手机号码绑定";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = NavBarColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    if (self.backItemType == BackItemTypeBackImg)
    {
        UIImage *backImg = [UIImage imageNamed:@"nav-btn-fanhui.png"];
        UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, backImg.size.width, backImg.size.height)];
        [back setImage:backImg forState:UIControlStateNormal];
        [back addTarget:self action:@selector(pressedBack) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *navBack = [[UIBarButtonItem alloc] initWithCustomView:back];
        self.navigationItem.leftBarButtonItem = navBack;
    }
    else if (self.backItemType == BackItemTypeNone)
    {
        self.navigationItem.hidesBackButton = YES;
    }
    [self setUI];
}

- (void)setUI
{
    [self.view addSubview:self.phoneNum];
    [self.view addSubview:self.checkCode];
    [self.view addSubview:self.getCodeBtn];
    UILabel *describ = [[UILabel alloc] init];
    describ.font = [UIFont systemFontOfSize:9];
    describ.textColor = [UIColor lightGrayColor];
    describ.text = @"登录并同意-";
    [describ sizeToFit];
    [describ setFrame:CGRectMake(self.phoneNum.frame.origin.x, self.checkCode.frame.origin.y+self.checkCode.frame.size.height+20, describ.frame.size.width, describ.frame.size.height)];
    [self.view addSubview:describ];
    UIButton *userProtocol = [[UIButton alloc] init];
    userProtocol.titleLabel.font = [UIFont systemFontOfSize:9];
    [userProtocol setTitle:@"用户使用协议" forState:UIControlStateNormal];
    [userProtocol.titleLabel sizeToFit];
    [userProtocol setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    userProtocol.frame = CGRectMake(describ.frame.origin.x+describ.frame.size.width, describ.frame.origin.y, describ.frame.size.width+5, describ.frame.size.height);
    [userProtocol addTarget:self action:@selector(showUserProtocol) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:userProtocol];
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.phoneNum.frame.origin.x, describ.frame.origin.y+describ.frame.size.height+20, self.phoneNum.frame.size.width, self.phoneNum.frame.size.height)];
    [loginBtn setTitle:self.pageType==LoginPageTypeLogin?@"登录":@"绑定" forState:UIControlStateNormal];
    loginBtn.backgroundColor = NavBarColor;
    loginBtn.layer.cornerRadius = 5;
    [loginBtn addTarget:self action:@selector(pressedLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    BOOL hasWXClient = [ShareSDK isClientInstalled:SSDKPlatformTypeWechat];
    BOOL hasQQClient = [ShareSDK isClientInstalled:SSDKPlatformTypeQQ];
    if (self.pageType == LoginPageTypeLogin && (hasWXClient || hasQQClient))
    {
        UILabel *loginByTencentTitle = [[UILabel alloc] init];
        loginByTencentTitle.text = @"其他方式登录";
        loginByTencentTitle.textColor = [UIColor lightGrayColor];
        [loginByTencentTitle sizeToFit];
        CGSize loginByTencentTitleSize = loginByTencentTitle.frame.size;
        loginByTencentTitle.frame = CGRectMake(0, loginBtn.frame.origin.y+loginBtn.frame.size.height+25-loginByTencentTitleSize.height/2, loginByTencentTitleSize.width, loginByTencentTitleSize.height);
        loginByTencentTitle.center = CGPointMake(self.view.center.x, loginByTencentTitle.center.y);
        [self.view addSubview:loginByTencentTitle];
        UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(loginBtn.frame.origin.x, loginBtn.frame.origin.y+loginBtn.frame.size.height+25, loginByTencentTitle.frame.origin.x-7.5-loginBtn.frame.origin.x, .5)];
        leftLine.backgroundColor = NavBarColor;
        [self.view addSubview:leftLine];
        UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(loginByTencentTitle.frame.origin.x+loginByTencentTitleSize.width+7.5, leftLine.frame.origin.y, leftLine.frame.size.width, .5)];
        rightLine.backgroundColor = NavBarColor;
        [self.view addSubview:rightLine];
        
        CGRect qqBtnRect = CGRectZero;
        if (hasQQClient)
        {
            UIImage *loginByQQBtnImg = [UIImage imageNamed:@"denglu-icon-qq.png"];
            UIButton *loginByQQBtn = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth-68.5-2*loginByQQBtnImg.size.width)/2.0, 10+leftLine.frame.size.height+leftLine.frame.origin.y, loginByQQBtnImg.size.width, loginByQQBtnImg.size.height)];
            [loginByQQBtn setImage:loginByQQBtnImg forState:UIControlStateNormal];
            [loginByQQBtn addTarget:self action:@selector(pressedLoginByQQ) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:loginByQQBtn];
            qqBtnRect = loginByQQBtn.frame;
            if (!hasWXClient)
            {
                loginByQQBtn.center = CGPointMake(ScreenWidth/2, loginByQQBtn.center.y);
            }
        }
        else
        {
            UIImage *loginByQQBtnImg = [UIImage imageNamed:@"denglu-icon-qq.png"];
            UIButton *loginByQQBtn = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth-68.5-2*loginByQQBtnImg.size.width)/2.0, 10+leftLine.frame.size.height+leftLine.frame.origin.y, loginByQQBtnImg.size.width, loginByQQBtnImg.size.height)];
            [loginByQQBtn setImage:loginByQQBtnImg forState:UIControlStateNormal];
            [loginByQQBtn addTarget:self action:@selector(pressedLoginByQQ) forControlEvents:UIControlEventTouchUpInside];
            qqBtnRect = loginByQQBtn.frame;
        }
        CGRect wxBtnRect = CGRectZero;
        if (hasWXClient)
        {
            UIButton *loginByWeChat = [[UIButton alloc] initWithFrame:CGRectMake(qqBtnRect.size.width+qqBtnRect.origin.x+68.5, qqBtnRect.origin.y, qqBtnRect.size.width, qqBtnRect.size.height)];
            [loginByWeChat setImage:[UIImage imageNamed:@"denglu-icon-weixin.png"] forState:UIControlStateNormal];
            [loginByWeChat addTarget:self action:@selector(pressedLoginByWeChat) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:loginByWeChat];
            wxBtnRect = loginByWeChat.frame;
        }
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(leftLine.frame.origin.x, 10+wxBtnRect.origin.y+wxBtnRect.size.height, loginBtn.frame.size.width, .5)];
        bottomLine.backgroundColor = NavBarColor;
        [self.view addSubview:bottomLine];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (User) {
        [self pressedBack];
    }
    if (ScreenHeight < 568)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.topViewController isKindOfClass:[PersonalViewController class]]) {
        PersonalViewController *preViewController = (PersonalViewController*)self.navigationController.topViewController;
        [preViewController.tableView reloadData];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.checkCode resignFirstResponder];
    [self.phoneNum resignFirstResponder];
    NSLog(@"login disappear:%@",self.navigationController.topViewController);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"LoginViewController dealloc");
}

#pragma mark - Noti
- (void)showKeyboard:(NSNotification *)n {
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:0.25 animations:^{
        wself.view.frame = CGRectMake(0, wself.view.frame.origin.y-44, ScreenWidth, wself.view.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            UIButton *dismissKeyboard = [[UIButton alloc] initWithFrame:self.view.bounds];
            dismissKeyboard.tag = 1000000;
            [dismissKeyboard addTarget:self action:@selector(removeKeyboard:) forControlEvents:UIControlEventTouchUpInside];
            [wself.view addSubview:dismissKeyboard];
        }
    }];
}

- (void)dismissKeyboard:(NSNotification *)n {
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:0.25 animations:^{
        wself.view.frame = CGRectMake(0, wself.view.frame.origin.y+44, ScreenWidth, wself.view.frame.size.height);
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *phoneRegex = @"[0-9]";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    if (![string isEqualToString:@""])
    {
        if (textField.text.length >= 11 || ![phoneTest evaluateWithObject:string]) {
            return NO;
        }
        else {
            return YES;
        }
    }
    else {
        return YES;
    }
}

#pragma mark - Net
- (void)loginWithThirdParty:(NSString *)type {
    //1、获取用户信息；2、用接口
    __weak typeof(self) wself = self;
    if ([type isEqualToString:ThirdPartyLoginWithQQ])
    {
        [ShareSDK getUserInfo:SSDKPlatformTypeQQ onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
        {
            wself.socialUser = user;
            NSLog(@"SSDKUser:%@",user);
            [MorePageNetwork loginWithThirdPartyNickName:user.uid withType:ThirdPartyLoginWithQQ withSuccessBlock:^(BOOL finished)
             {
                if (!finished)
                {/*
                  LoginViewController *bind = [[LoginViewController alloc] init];
                  bind.backItemType = BackItemTypeBackImg;
                  bind.enterType = EnterTypePresent;
                  bind.pageType = LoginPageTypeBindPhoneNum;
                  bind.edgesForExtendedLayout = UIRectEdgeNone;
                  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:bind];
                 [wself presentViewController:nav animated:YES completion:^{
                 [ProgressHUD dismiss];
                }];*/
                    [ProgressHUD showText:@"登录失败，服务器好像有点问题哦~" Interaction:YES Hide:YES];
                }
                else {
                    [ProgressHUD showText:@"登录成功" Interaction:YES Hide:YES];
                    [wself pressedBack];
                }
            } withErrorBlock:^(NSError *err) {
                [ProgressHUD showText:@"登录失败" Interaction:YES Hide:YES];
            }];
        }];
    }
    else {
        [ShareSDK getUserInfo:SSDKPlatformTypeWechat onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
            wself.socialUser = user;
            [MorePageNetwork loginWithThirdPartyNickName:user.uid withType:ThirdPartyLoginWithWX withSuccessBlock:^(BOOL finished) {
                if (!finished) {/*
                                 LoginViewController *bind = [[LoginViewController alloc] init];
                                 bind.backItemType = BackItemTypeBackImg;
                                 bind.enterType = EnterTypePresent;
                                 bind.pageType = LoginPageTypeBindPhoneNum;
                                 bind.edgesForExtendedLayout = UIRectEdgeNone;
                                 UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:bind];
                                 [wself presentViewController:nav animated:YES completion:^{
                                 [ProgressHUD dismiss];
                                 }];*/
                    [ProgressHUD showText:@"登录失败，服务器好像有点问题哦~" Interaction:YES Hide:YES];
                }
                else {
                    [ProgressHUD showText:@"登录成功" Interaction:YES Hide:YES];
                    [wself pressedBack];
                }
            } withErrorBlock:^(NSError *err) {
                [ProgressHUD showText:@"登录失败" Interaction:YES Hide:YES];
            }];
        }];
    }
}

#pragma mark - Button Response
- (void)pressedLoginByQQ
{
    [ProgressHUD show:nil Interaction:NO Hide:NO];
    GetAppDelegate.openURLHandlerViewController = self;
    [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeQQ onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
        NSLog(@"QQ SSDKUser:%@",user);
        self.socialUser = user;
        associateHandler (user.uid, user, user);
    } onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error)
    {
        if (state == SSDKResponseStateSuccess)
        {NSLog(@"QQ SSEBaseUser:%@",user);
            [self loginWithThirdParty:ThirdPartyLoginWithQQ];
        }
        else if (state == SSDKResponseStateFail) {
            NSLog(@"QQ SSDKResponseStateFail:%@",error.localizedFailureReason);
            [ProgressHUD showText:@"QQ授权失败" Interaction:YES Hide:YES];
        }
        else {
            [ProgressHUD showText:@"QQ授权失败" Interaction:YES Hide:YES];
        }
    }];
}

- (void)pressedLoginByWeChat {
    [ProgressHUD show:nil Interaction:NO Hide:NO];
    GetAppDelegate.openURLHandlerViewController = self;
    [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeWechat onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
        NSLog(@"Wx SSDKUser:%@",user);
        self.socialUser = user;
        associateHandler (user.uid, user, user);
    } onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess)
        {NSLog(@"WX SSEBaseUser:%@",user);
            [self loginWithThirdParty:ThirdPartyLoginWithWX];
        }
        else if (state == SSDKResponseStateFail) {
            NSLog(@"WX SSDKResponseStateFail:%@",error.localizedFailureReason);
            [ProgressHUD showText:@"微信授权失败" Interaction:YES Hide:YES];
        }
        else {
            [ProgressHUD showText:@"微信授权失败" Interaction:YES Hide:YES];
        }
    }];
}

- (void)pressedBack {
    switch (self.enterType) {
        case EnterTypeAdd:
            [self.view removeFromSuperview];
            break;
        case EnterTypePush:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case EnterTypePresent:
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            break;
    }
}

- (void)pressedGetCode:(UIButton *)btn {
    if (!self.phoneNum.text || [self.phoneNum.text isEqualToString:@""])
    {
        [ProgressHUD showText:@"手机号码不能为空，请填写" Interaction:YES Hide:YES];
    }
    else {
        btn.enabled = NO;
        btn.backgroundColor = [UIColor lightGrayColor];
        [btn setTitle:[NSString stringWithFormat:@"%li秒",(long)self.countDown] forState:UIControlStateDisabled];
        __weak typeof(self) wself = self;
        [MorePageNetwork getCheckCodeWithPhoneNum:self.phoneNum.text withSuccessBlock:^(BOOL finished)
        {
            if (!finished)
            {
                [NSObject cancelPreviousPerformRequestsWithTarget:self];
                [ProgressHUD showText:@"验证码获取失败，请重新获取" Interaction:YES Hide:YES];
                wself.getCodeBtn.enabled = YES;
                wself.getCodeBtn.backgroundColor = NavBarColor;
                wself.countDown = defaultCountDown;
            }
        } withErrorBlock:^(NSError *err)
        {
            NSLog(@"getCheckCodeWithPhoneNum err:%@",err);
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [ProgressHUD showText:@"验证码获取失败，请检查网络后重新获取" Interaction:YES Hide:YES];
            wself.getCodeBtn.enabled = YES;
            wself.getCodeBtn.backgroundColor = NavBarColor;
            wself.countDown = defaultCountDown;
        }];
        [self performSelector:@selector(countDown2RegetCode) withObject:nil afterDelay:1];
    }
}

- (void)pressedLoginBtn:(UIButton *)btn {
    if (!self.phoneNum || [self.phoneNum.text isEqualToString:@""] || !self.phoneNum.text) {
        [ProgressHUD showText:@"手机号码不能为空，请填写" Interaction:YES Hide:YES];
    }
    else if (!self.checkCode || [self.checkCode.text isEqualToString:@""] || !self.checkCode.text) {
        [ProgressHUD showText:@"验证码不能为空，请填写" Interaction:YES Hide:YES];
    }
    else {
        [ProgressHUD show:nil Interaction:NO Hide:NO];
        __weak typeof(self) wself = self;
        [MorePageNetwork loginWithPhoneNum:self.phoneNum.text withCheckCode:self.checkCode.text withNickName:self.socialUser.nickname withSuccessBlock:^(BOOL finished) {
            if (finished) {
                [ProgressHUD showText:@"登录成功" Interaction:YES Hide:YES];
                [wself pressedBack];
            }
            else {
                [ProgressHUD showText:@"验证码错误，请核对或重新获取" Interaction:YES Hide:YES];
            }
        } withErrorBlock:^(NSError *err) {
            NSLog(@"err:%@", err);
        }];
    }
}

- (void)showUserProtocol {
    UserProtocolDetailViewController *userProtocol = [[UserProtocolDetailViewController alloc] init];
    userProtocol.title = @"用户使用协议";
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    userProtocol.edgesForExtendedLayout = UIRectEdgeNone;
    userProtocol.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userProtocol animated:YES];
}

- (void)removeKeyboard:(UIButton *)btn {
    [btn removeFromSuperview];
    [self.phoneNum resignFirstResponder];
    [self.checkCode resignFirstResponder];
}

#pragma mark - Private
- (void)countDown2RegetCode {
    self.countDown--;
    if (self.countDown >= 0)
    {
        [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%li秒",(long)self.countDown] forState:UIControlStateDisabled];
        [self performSelector:@selector(countDown2RegetCode) withObject:nil afterDelay:1];
    }
    else {
        self.countDown = defaultCountDown;
        self.getCodeBtn.enabled = YES;
        self.getCodeBtn.backgroundColor = NavBarColor;
    }
}

#pragma mark - Setter & Getter
- (UITextField *)phoneNum {
    if (!_phoneNum) {
        _phoneNum = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, ScreenWidth-40, 50)];
        _phoneNum.borderStyle = UITextBorderStyleRoundedRect;
        _phoneNum.layer.borderWidth = .5;
        _phoneNum.layer.borderColor = [NavBarColor CGColor];
        _phoneNum.layer.cornerRadius = 3;
        _phoneNum.placeholder = @"手机号码";
        _phoneNum.tag = phoneNumInputTag;
        _phoneNum.delegate = self;
        _phoneNum.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _phoneNum;
}

- (UITextField *)checkCode {
    if (!_checkCode) {
        _checkCode = [[UITextField alloc] initWithFrame:CGRectMake(self.phoneNum.frame.origin.x, self.phoneNum.frame.origin.y+self.phoneNum.frame.size.height+20, self.phoneNum.frame.size.width/2+10, self.phoneNum.frame.size.height)];
        _checkCode.borderStyle = UITextBorderStyleRoundedRect;
        _checkCode.layer.borderWidth = .5;
        _checkCode.layer.borderColor = [NavBarColor CGColor];
        _checkCode.layer.cornerRadius = 3;
        _checkCode.placeholder = @"验证码";
        _checkCode.tag = checkCodeInputTag;
        _checkCode.delegate = self;
        _checkCode.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _checkCode;
}

- (UIButton *)getCodeBtn {
    if (!_getCodeBtn) {
        CGFloat getCodeBtnX = self.checkCode.frame.origin.x+self.checkCode.frame.size.width+10;
        _getCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(getCodeBtnX, self.checkCode.frame.origin.y, ScreenWidth-getCodeBtnX-20, self.checkCode.frame.size.height)];
        _getCodeBtn.backgroundColor = NavBarColor;
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getCodeBtn.layer.cornerRadius = 5;
        [_getCodeBtn addTarget:self action:@selector(pressedGetCode:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getCodeBtn;
}

@end
