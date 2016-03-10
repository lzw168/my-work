//
//  NursingCouponView.m
//  BeautyWhere
//
//  Created by lizhiwei on 16/1/7.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NursingCouponView.h"
#import "UIImageView+AFNetworking.h"

@interface NursingCouponView ()

@end

@implementation NursingCouponView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Custom initialization
    NSLog(@"viewdidload[%d]",self.height);
}

-(void)setWidth:(int)width andsetHeight:(int)height andsetImage:(NSString*)image
{
    self.width = width;
    self.height = height;
    
    /*UIView *shuoview = [[UIView alloc] init];
    shuoview.frame = CGRectMake(0, 0, self.width, self.height);*/
    UIButton *btnCard = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    NSLog(@"=======IMAGE=======%@%@",GetAppDelegate.img_path,image);
    [pic setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",GetAppDelegate.img_path,image]] placeholderImage:[UIImage imageNamed:@"pic_2loading.png"]];
    [btnCard setBackgroundImage:[pic image] forState:UIControlStateNormal];
    [btnCard setFrame:CGRectMake(2, 0, self.width, self.height)];
    //[shuoview addSubview:btnCard];
    [self.view addSubview:pic];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    self.width = 0;
    self.height = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

@end
