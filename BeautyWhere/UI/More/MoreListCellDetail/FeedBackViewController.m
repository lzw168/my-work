//
//  FeedBackViewController.m
//  BeautyWhere
//
//  Created by Michael Chan on 15/7/24.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "FeedBackViewController.h"
#import "MorePageNetwork.h"

static NSString * const inputPlaceHold = @"说点什么";

@interface FeedBackViewController ()

@property (nonatomic, strong) UITextView *input;
@property (nonatomic, assign) BOOL hasShowLoginPage;

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *send = [[UIButton  alloc] initWithFrame:CGRectMake(0, 0, NavHeight(self), NavHeight(self))];
    [send setTitle:@"发送" forState:UIControlStateNormal];
    [send addTarget:self action:@selector(pressedSend) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:send];
    [self.view addSubview:self.input];
//    [self addNotification];
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!User || !User.userID || [User.userID isEqualToString:@""]) {
        if (self.hasShowLoginPage)
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
        self.hasShowLoginPage = YES;
        LoginViewController *login = [[LoginViewController alloc] init];
        login.edgesForExtendedLayout = UIRectEdgeNone;
        login.backItemType = BackItemTypeBackImg;
        login.enterType = EnterTypePush;
        [self.navigationController pushViewController:login animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:inputPlaceHold]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length < 1) {
        textView.text = inputPlaceHold;
        textView.textColor = [UIColor lightGrayColor];
    }
}

#pragma mark Notification
- (void)keyboardWillShow:(NSNotification *)n
{
    NSLog(@"keyboardWillShow n:%@",n);
    if ([[n.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] > 0.0)
    {
        NSLog(@"n.userInfo:%@",n.userInfo);
        [UIView animateWithDuration:0.25 animations:^{
            [UIApplication sharedApplication].keyWindow.frame = CGRectMake(0, [UIApplication sharedApplication].keyWindow.frame.origin.y-NavHeight(self)-self.input.frame.origin.y, [UIApplication sharedApplication].keyWindow.frame.size.width, [UIApplication sharedApplication].keyWindow.frame.size.height);
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)n
{
    NSLog(@"hide n:%@",n);
    [UIView animateWithDuration:0.25 animations:^{
        [UIApplication sharedApplication].keyWindow.frame = [UIApplication sharedApplication].keyWindow.bounds;
    }];
}

#pragma mark - Button Response
- (void)pressedSend {
    if (User && User.userID && ![User.userID isEqualToString:@""]) {
        if (!self.input.text || [self.input.text isEqualToString:@""] || self.input.text.length<2) {
            [ProgressHUD showText:@"字数太少啦，写多点吧~" Interaction:YES Hide:YES];
        }
        else {
            [ProgressHUD show:nil Interaction:NO Hide:YES];
            [MorePageNetwork sendFeedBackWithUserName:User.userName withUserID:User.userID withContent:self.input.text withSuccessBlock:^(BOOL finished) {
                [ProgressHUD showText:@"发送成功" Interaction:YES Hide:YES];
                [self.navigationController popViewControllerAnimated:YES];
            } withErrorBlock:^(NSError *err) {
                [ProgressHUD showText:@"发送失败，请稍后再试" Interaction:YES Hide:YES];
            }];
        }
    }
}

#pragma mark - Setter & Getter
- (UITextView *)input {
    if (!_input) {
        _input = [[UITextView alloc] initWithFrame:CGRectMake(10, 20, ScreenWidth-20, (self.view.frame.size.height-40)/3)];
        _input.delegate = self;
        _input.text = inputPlaceHold;
        _input.textColor = [UIColor lightGrayColor];
        _input.layer.borderWidth = 0.5;
        _input.layer.borderColor = NavBarColor.CGColor;
        _input.layer.cornerRadius = 3;
        _input.font = [UIFont systemFontOfSize:16];
    }
    return _input;
}

@end
