//
//  UserProtocolDetailViewController.m
//  BeautyWhere
//
//  Created by Michael on 15/9/17.
//  Copyright © 2015年 Michael. All rights reserved.
//

#import "UserProtocolDetailViewController.h"

@interface UserProtocolDetailViewController ()

@end

@implementation UserProtocolDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [ProgressHUD show:nil Interaction:YES Hide:NO];
    UIWebView *provision = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44)];
    provision.delegate = self;
    [self.view addSubview:provision];
    if (!self.urlStr) {
        self.urlStr = @"http://shnm.vba8.com/Home/Index/showCommunity";
    }
    [provision loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
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

#pragma mark - UIWebviewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [ProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    [ProgressHUD showText:error.localizedFailureReason Interaction:YES Hide:YES];
}

@end
