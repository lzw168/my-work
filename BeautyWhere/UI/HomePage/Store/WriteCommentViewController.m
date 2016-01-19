//
//  WriteCommentViewController.m
//  BeautyWhere
//
//  Created by Michael on 15/8/20.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "WriteCommentViewController.h"
#import "HomePageNetwork.h"

@interface WriteCommentViewController ()

@property (nonatomic, strong)NSString *sumMarkScore;
@property (nonatomic, strong)NSString *techMarkScore;

@end

@implementation WriteCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *dismissKeyboardBtn = [[UIButton alloc] initWithFrame:self.view.bounds];
    [dismissKeyboardBtn addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissKeyboardBtn];
    UIButton *send = [[UIButton alloc] init];
    [send setTitle:@"发送" forState:UIControlStateNormal];
    [send sizeToFit];
    [send addTarget:self action:@selector(pressedSend) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:send];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth-20, (ScreenWidth-20)*3/4)];
    textView.tag = commentContentViewTag;
    textView.delegate = self;
    textView.layer.borderWidth=.5;
    textView.layer.borderColor = [BottomMenuSelectedColor CGColor];
    textView.text = @"说点什么";
    textView.textColor = [UIColor lightGrayColor];
    textView.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:textView];
    
    UILabel *sumMark = [[UILabel alloc] init];
    sumMark.text = @"总评：";
    [sumMark sizeToFit];
    sumMark.frame = CGRectMake(20, textView.frame.origin.y+textView.frame.size.height+60, sumMark.frame.size.width,  sumMark.frame.size.height);
    [self.view addSubview:sumMark];
    TQStarRatingView *sumMarkStar = [[TQStarRatingView alloc] initWithFrame:CGRectMake(sumMark.frame.origin.x+sumMark.frame.size.width+10, sumMark.frame.origin.y-sumMark.frame.size.height/2, 158.5, 30) numberOfStar:5 withState:MarkStateZero withStarImgWith:28.5 touch:YES];
    sumMarkStar.delegate = self;
    sumMarkStar.tag = sumMarkStarViewTag;
    [self.view addSubview:sumMarkStar];
    
    UILabel *technologicMark = [[UILabel alloc] init];
    technologicMark.text = @"技术：";
    [technologicMark sizeToFit];
    technologicMark.frame = CGRectMake(sumMark.frame.origin.x, sumMark.frame.origin.y+sumMark.frame.size.height+30, technologicMark.frame.size.width, technologicMark.frame.size.height);
    [self.view addSubview:technologicMark];
    TQStarRatingView *technologicMarkStar = [[TQStarRatingView alloc] initWithFrame:CGRectMake(technologicMark.frame.origin.x+technologicMark.frame.size.width+10, technologicMark.frame.origin.y-technologicMark.frame.size.height/2, sumMarkStar.frame.size.width, sumMarkStar.frame.size.height) numberOfStar:5 withState:MarkStateZero withStarImgWith:28.5];
    technologicMarkStar.delegate = self;
    technologicMarkStar.tag = technologicMarkStarViewTag;
    [self.view addSubview:technologicMarkStar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"说点什么"]) {
        textView.textColor = [UIColor blackColor];
        textView.text = @"";
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"说点什么";
        textView.textColor = [UIColor lightGrayColor];
    }
}

#pragma mark - StarRatingViewDelegate
-(void)starRatingView:(TQStarRatingView *)view score:(float)score {//每粒星score为0.2
    NSLog(@"TQStarRatingView:%@  score:%f",view, score);
    if (view.tag==sumMarkStarViewTag) {
        self.sumMarkScore = [NSString stringWithFormat:@"%i",(int)score*5];
    }
    else {
        self.techMarkScore = [NSString stringWithFormat:@"%i",(int)score*5];
    }
}

#pragma mark - Button Response
- (void)dismissKeyboard {
    [[self.view viewWithTag:commentContentViewTag] resignFirstResponder];
}

- (void)pressedSend {
    UITextView *inputComment = (UITextView*)[self.view viewWithTag:commentContentViewTag];
    NSLog(@"pressedSend");
    if ([inputComment.text isEqualToString:@""] || [inputComment.text isEqualToString:@"说点什么"]) {
        [ProgressHUD showText:@"你好像还没写评价哦~" Interaction:YES Hide:YES];
    }
    else {
        [HomePageNetwork sendStoreCommentWithUserID:User.userID withPartnerID:self.store.storeID withStarMark:self.sumMarkScore withJiSuMark:self.techMarkScore withContent:inputComment.text withSuccessBlock:^(BOOL finished) {
            if (finished) {
                [ProgressHUD showText:@"评论发送成功" Interaction:YES Hide:YES];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                [ProgressHUD showText:@"评论发送失败，检查下网络后再试试吧" Interaction:YES Hide:YES];
            }
        } withErrorBlock:^(NSError *err) {
            NSLog(@"sendStoreCommentWithUserID err:%@",err);
            [ProgressHUD showText:@"评论发送失败，检查下网络后再试试吧" Interaction:YES Hide:YES];
        }];
    }
}

@end
