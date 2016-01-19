//
//  ChangeNameViewController.m
//  BeautyWhere
//
//  Created by Michael Chan on 15/8/1.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "ChangeNameViewController.h"
#import "PersonalPageNetwork.h"

@interface ChangeNameViewController ()

@property (nonatomic, strong) UITextField *input;

@end

@implementation ChangeNameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *send = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-NavHeight(self), 0, NavHeight(self), NavHeight(self))];
    [send setTitle:@"确定" forState:UIControlStateNormal];
    [send addTarget:self action:@selector(pressedSend) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:send];
    [self.view addSubview:self.input];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Button Response
- (void)pressedSend {
    [ProgressHUD show:nil];
    if (self.input.text && ![self.input.text isEqualToString:@""]) {
        __weak typeof(self) wself = self;
        [PersonalPageNetwork changeUserName:self.input.text headerImg:nil withUserID:User.userID withMobileNumber:User.mobile withSuccessBlock:^(NSString *userName, NSString *imgURL) {
            NSMutableDictionary *userInfoDic = [NSKeyedUnarchiver unarchiveObjectWithFile:UserInfoFilePath];
            [userInfoDic setObject:userName forKey:@"username"];
            [NSKeyedArchiver archiveRootObject:userInfoDic toFile:UserInfoFilePath];
            User.userName = userName;
            [ProgressHUD showText:@"修改成功" Interaction:YES Hide:YES];
            [wself.navigationController popToRootViewControllerAnimated:YES];
        } withErrorBlock:^(NSError *err) {
            NSLog(@"change username err:%@",err);
            [ProgressHUD showText:@"修改出错，请稍后重试" Interaction:YES Hide:YES];
        }];
    }
    else {
        [ProgressHUD showText:@"你好像还没写新昵称吧～" Interaction:YES Hide:YES];
    }
}

#pragma mark - Setter & Getter
- (UITextField *)input {
    if (!_input) {
        _input = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, ScreenWidth-20, 44)];
        _input.borderStyle = UITextBorderStyleRoundedRect;
        _input.placeholder = @"请输入新的昵称";
        _input.layer.borderWidth = .5;
        _input.layer.borderColor = NavBarColor.CGColor;
        _input.layer.cornerRadius = 3;
    }
    return _input;
}

@end
