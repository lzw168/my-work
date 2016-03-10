//
//  PersonalViewController.m
//  BeautyWhere
//
//  Created by Michael on 15-7-21.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "AddMyAddressViewController.h"
#import "UserBean.h"
#import "UIImageView+AFNetworking.h"
#import "ChangeUserInfoViewController.h"
#import "CouponDetailViewController.h"
#import "CollectionDetailViewController.h"
#import "PersonalPageNetwork.h"
#import "IntegralTableViewController.h"
#import "InformationViewController.h"
#import "TSLocateView.h"
#import "AddressPageNetwork.h"

@interface AddMyAddressViewController ()

@property (nonatomic, weak) UserBean *user;
@property (nonatomic, strong) NSArray *detailArr;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *mobileArr;
@property (nonatomic, strong) UITextField *input1;
@property (nonatomic, strong) UITextField *input2;
@property (nonatomic, strong) UITextView *input3;
@property (nonatomic, strong) UILabel * address;
@property (nonatomic, strong) UIButton * choosebtn;
@property (nonatomic, strong) UILabel * desc;
@property (nonatomic) int ischoose;
@property (nonatomic, strong) TSLocateView *locateView;
@end

@implementation AddMyAddressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleArr = @[@"收货人姓名", @"手机号码",@"省,市", @"详细地址",@""];
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *save = [[UIButton  alloc] initWithFrame:CGRectMake(0, 0, 45, 45/2)];
    [save setTitle:@"保存" forState:UIControlStateNormal];
    save.layer.cornerRadius = 5;
    save.backgroundColor = [UIColor clearColor];
    //[UIColor colorWithRed:255.0/255.0 green:79.0/255.0 blue:3.0/255.0 alpha:1.0];
    save.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [save addTarget:self action:@selector(pressedSave) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:save];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"User:%@",User);
    NSLog(@"User.userID---1:%@",User.userID);
    if (!User || !User.userID)
    {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.edgesForExtendedLayout = UIRectEdgeNone;
        login.backItemType = BackItemTypeNone;
        login.enterType = EnterTypePush;
        [self.navigationController pushViewController:login animated:NO];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentify"];
    CGSize cellSize = [tableView rectForRowAtIndexPath:indexPath].size;
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reuseIdentify"];
        
        if (indexPath.row == 4)
        {
            
        }
        else
        {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, cellSize.height-0.5, ScreenWidth, 0.5)];
            line.backgroundColor =[UIColor lightGrayColor];
            [cell.contentView addSubview:line];
        }
        
        if(indexPath.row == 0)
        {
            self.input1 = [[UITextField alloc] initWithFrame:CGRectMake(90, 12.5, 150, 25)];
            self.input1.delegate = self;
            self.input1.text = self.reciver;
            self.input1.textColor = [UIColor lightGrayColor];
            self.input1.layer.borderWidth = 0.0;
            self.input1.layer.borderColor = [UIColor grayColor].CGColor;
            self.input1.layer.cornerRadius = 3;
            self.input1.font = [UIFont systemFontOfSize:16];
            self.input1.textAlignment = NSTextAlignmentLeft;
            self.input1.returnKeyType = UIReturnKeyDone;
            self.input1.keyboardType = UIKeyboardTypeDefault;
            self.input1.tag = 111;
            [cell addSubview:self.input1];
        }
        
        if(indexPath.row == 1)
        {
            self.input2 = [[UITextField alloc] initWithFrame:CGRectMake(90, 12.5, 150, 25)];
            self.input2.delegate = self;
            self.input2.text = self.mobile;
            self.input2.textColor = [UIColor lightGrayColor];
            self.input2.layer.borderWidth = 0.0;
            self.input2.layer.borderColor = [UIColor grayColor].CGColor;
            self.input2.layer.cornerRadius = 3;
            self.input2.font = [UIFont systemFontOfSize:16];
            self.input2.textAlignment = NSTextAlignmentLeft;
            self.input2.returnKeyType = UIReturnKeyDone;
            self.input2.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            self.input2.tag = 222;
            [cell addSubview:self.input2];
        }
        
        if (indexPath.row == 2)
        {
            self.address = [[UILabel alloc]initWithFrame:CGRectMake(90, 12.5, 150, 25)];
            self.address.font = [UIFont systemFontOfSize:16];
            self.address.textColor = [UIColor lightGrayColor];
            self.address.text = self.MyAddress;
            //self.address.enabled = NO;
            [cell addSubview:self.address];
        }
        
        if(indexPath.row == 3)
        {
            self.input3 = [[UITextView alloc] initWithFrame:CGRectMake(90, 5, 180, 90)];
            self.input3.delegate = self;
            self.input3.text = self.location;
            self.input3.textColor = [UIColor lightGrayColor];
            self.input3.layer.borderWidth = 0.0;
            self.input3.layer.borderColor = [UIColor grayColor].CGColor;
            self.input3.layer.cornerRadius = 3;
            self.input3.font = [UIFont systemFontOfSize:16];
            self.input3.textAlignment = NSTextAlignmentLeft;
            self.input3.returnKeyType = UIReturnKeyDone;
            self.input3.keyboardType = UIKeyboardTypeDefault;
            self.input3.tag = 333;
            [cell addSubview:self.input3];
        }
        
        if (indexPath.row == 4)
        {
            if ([self.is_default isEqualToString:@"1"])
            {
                self.ischoose = 1;
                self.choosebtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10,88*RatioWidth,88*RatioHeight)];
                UIImage * chooseimage = [UIImage imageNamed:@"icon_choosed.png"];
                [self.choosebtn setImage:chooseimage forState:UIControlStateNormal];
                [self.choosebtn addTarget:self action:@selector(pressedChoose) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:self.choosebtn];
            }
            else
            {
                self.ischoose = 0;
                self.choosebtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10,88*RatioWidth,88*RatioWidth)];
                UIImage * chooseimage = [UIImage imageNamed:@"icon_choose.png"];
                [self.choosebtn setImage:chooseimage forState:UIControlStateNormal];
                [self.choosebtn addTarget:self action:@selector(pressedChoose) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:self.choosebtn];
            }
            
            self.desc = [[UILabel alloc]initWithFrame:CGRectMake(30+40*RatioWidth, 18, 80, 10)];
            self.desc.text = @"默认收货地址";
            [self.desc setFont:[UIFont systemFontOfSize:13.0]];
            [self.desc setTextColor:[UIColor colorWithRed:133.0/255.0 green:131.0/255.0 blue:132.0/255.0 alpha:1.0]];
            [cell addSubview:self.desc];
        }
    }
    
    NSString * NameAndMob = [NSString stringWithFormat:@"%@",[self.titleArr objectAtIndex:indexPath.row]];
    cell.textLabel.text = NameAndMob;
    cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 1)
    {
        [self.locateView removeFromSuperview];
    }
    
    if (indexPath.row == 2)
    {
        [self.input2 resignFirstResponder];
        self.locateView = [[TSLocateView alloc] initWithTitle:@"选择城市" delegate:self];
        [self.locateView showInView:self.view];
    }
    else
    {
        return;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3)
    {
        return 100;
    }
    else
    {
         return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    /*if ([textView.text isEqualToString:self.price])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }*/
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    /*if (textView.text.length < 1)
    {
        textView.text = self.price;
        textView.textColor = [UIColor lightGrayColor];
    }*/
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //输入完成隐藏键盘
    //self.address.enabled = YES;
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    NSLog(@"======================000");
    
    if (textField == self.input1)
    {
        if (textField.text.length > 11)
        {
            textField.text = [textField.text substringToIndex:11];
        }
    }
    
    if (textField == self.input2)
    {
        if (textField.text.length > 10)
        {
            textField.text = [textField.text substringToIndex:10];
        }
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"======================000");
    
    if (textView == self.input3)
    {
        if (textView.text.length > 50)
        {
            textView.text = [textView.text substringToIndex:50];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(self.locateView)
    {
        [self.locateView removeFromSuperview];
    }
    NSLog(@"======================111");
    if (textField == self.input1)
    {
        if (textField.text.length > 12)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    /*if (textField == self.input2)
    {
        if (textField.text.length > 10)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }*/
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    if (textView == self.input3)
    {
        if (textView.text.length > 51)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return YES;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    TSLocateView *locateView = (TSLocateView *)actionSheet;
    TSLocation *location = locateView.locate;
    NSString * Name = [NSString stringWithFormat:@"%@%@市",location.state,location.city];
    self.address.text = Name;
}

-(void) pressedSave
{
    if (self.address.text.length == 0 || self.input3.text.length == 0 ||
        self.input1.text.length == 0 || self.input2.text.length == 0)
    {
        [ProgressHUD showText:@"请完整输入再保存" Interaction:YES Hide:YES];
        return;
    }
    
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:self.input2.text];
    
    if (!isMatch)
    {
        [ProgressHUD showText:@"您输入正确的手机号码" Interaction:YES Hide:YES];
        return;
    }
    
    if ([self.editstatus isEqualToString:@"0"])
    {
        [self startNet];
    }
    else
    {
        [self updateaddress:self.addressid];
    }
    //[ProgressHUD showText:@"新增收货地址成功" Interaction:YES Hide:YES];
    return;
}

-(void) pressedChoose
{
    if(self.ischoose == 0)
    {
        self.ischoose = 1;
        [self.choosebtn setImage:[UIImage imageNamed:@"icon_choosed.png"] forState:UIControlStateNormal];
    }
    else
    {
        self.ischoose = 0;
        UIImage * chooseimage = [UIImage imageNamed:@"icon_choose.png"];
        [self.choosebtn setImage:chooseimage forState:UIControlStateNormal];
    }
}

#pragma mark - Net
- (void)startNet
{
    NSString * detailaddress = [NSString stringWithFormat:@"%@%@",self.address.text,self.input3.text];
    NSLog(@"detailaddress=========%@",detailaddress);
    [AddressPageNetwork AddAddressWithReceiver:self.input1.text withMobile:self.input2.text withLocation:self.input3.text withIsDefault:self.ischoose withRegion:self.address.text withSuccessBlock:^(BOOL finished)
     {
         if (finished)
         {
             [ProgressHUD showText:@"增加收货地址成功" Interaction:YES Hide:YES];
             [self.navigationController popViewControllerAnimated:YES];
         }
         else
         {
             [ProgressHUD showText:@"增加收货地址失败" Interaction:YES Hide:YES];
         }
     } withErrorBlock:^(NSError *err)
     {
         [ProgressHUD showText:@"获取失败，请检查网络后稍后再试" Interaction:YES Hide:YES];
     }];
}

#pragma mark - Net
- (void)updateaddress:(NSString *)AddressId
{
    NSString * detailaddress = [NSString stringWithFormat:@"%@%@",self.address.text,self.input3.text];
    NSLog(@"detailaddress=========%@",detailaddress);
    [AddressPageNetwork EditAddressWithId:self.input1.text withMobile:self.input2.text withLocation:self.input3.text withIsDefault:self.ischoose withid:[AddressId intValue] withRegion:self.address.text withSuccessBlock:^(BOOL finished)
     {
         if (finished)
         {
             [ProgressHUD showText:@"修改收货地址成功" Interaction:YES Hide:YES];
             [self.navigationController popViewControllerAnimated:YES];
         }
         else
         {
             [ProgressHUD showText:@"修改收货地址失败" Interaction:YES Hide:YES];
         }
     } withErrorBlock:^(NSError *err)
     {
         [ProgressHUD showText:@"获取失败，请检查网络后稍后再试" Interaction:YES Hide:YES];
     }];
}

@end
