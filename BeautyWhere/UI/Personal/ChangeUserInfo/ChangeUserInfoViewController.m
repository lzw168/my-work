//
//  ChangeUserInfoViewController.m
//  BeautyWhere
//
//  Created by Michael on 15/7/31.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "ChangeUserInfoViewController.h"
#import "UIImageView+AFNetworking.h"
#import "PersonalPageNetwork.h"
#import "ChangeNameViewController.h"
#import "MorePageNetwork.h"

@interface ChangeUserInfoViewController ()

@property (nonatomic, strong) NSArray *titleArr;

@end

@implementation ChangeUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleArr = @[@"头像", @"昵称"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize cellSize = [tableView rectForRowAtIndexPath:indexPath].size;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentify"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentify"];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, cellSize.height-0.5, ScreenWidth, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:line];
        if (indexPath.row == 0)
        {
            UIImageView *headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(cellSize.width-100, 10, 60, 60)];
            headImgView.tag = changeUserInfoHeadImgViewTag;
            [headImgView setImageWithURL:[NSURL URLWithString:User.avatar] placeholderImage:[UIImage imageNamed:@"touxiang.png"]];
            headImgView.layer.cornerRadius = headImgView.frame.size.width/2;
            headImgView.clipsToBounds = YES;
            [cell.contentView addSubview:headImgView];
        }
        else
        {
            UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2-30, cellSize.height)];
            content.tag = changeUserInfoContentLabelTag;
            content.text = User.nickName;
            [content setTextAlignment:NSTextAlignmentRight];
            [cell.contentView addSubview:content];
        }
    }
    UIImageView *headImgView = (UIImageView*)[cell.contentView viewWithTag:changeUserInfoHeadImgViewTag];
    UILabel *content = (UILabel*)[cell.contentView viewWithTag:changeUserInfoContentLabelTag];
    if (indexPath.row == 0) {
        headImgView.hidden = NO;
        content.hidden = YES;
    }
    else {
        headImgView.hidden = YES;
        content.hidden = NO;
    }
    cell.textLabel.text = [self.titleArr objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row==0?80:62;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从照片选取", @"从相机获取", nil];
            [sheet showInView:self.view];
        }
            break;
        case 1:
        {
            ChangeNameViewController *changeName = [[ChangeNameViewController alloc] init];
            [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
            changeName.edgesForExtendedLayout = UIRectEdgeNone;
            [self.navigationController pushViewController:changeName animated:YES];
        }
            break;
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self imagePickerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    else if (buttonIndex == 1) {
        [self imagePickerWithType:UIImagePickerControllerSourceTypeCamera];
    }
}

#pragma mark - Camera & Photo
- (void)imagePickerWithType:(UIImagePickerControllerSourceType)type {
    UIImagePickerController *p = [[UIImagePickerController alloc] init];
    p.delegate = self;
    p.sourceType = type;
    p.allowsEditing = YES;
    [self presentViewController:p animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    __weak typeof(self) wself = self;
    [PersonalPageNetwork changeUserName:nil headerImg:img withUserID:User.userID withMobileNumber:User.mobile withSuccessBlock:^(NSString *userName, NSString *imgURL)
     {
        [MorePageNetwork refleshUserInfoWithUserID:User.userID withSuccessBlock:^(BOOL finished)
        {
            if (!finished)
            {
                NSLog(@"获取不了新用户信息的json 数据");
            }
            else
            {
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                UIImageView *headImgView = (UIImageView*)[cell.contentView viewWithTag:changeUserInfoHeadImgViewTag];
                headImgView.image = img;
                GetAppDelegate.cacheHeaderImg = img;
                [ProgressHUD showText:@"头像更改成功" Interaction:YES Hide:YES];
            }
        } withErrorBlock:^(NSError *err)
        {
            NSLog(@"更新用户信息有误：%@",err);
            NSError *error = nil;
            BOOL removeFinished;
            removeFinished = [[NSFileManager defaultManager] removeItemAtPath:UserInfoFilePath error:&error];
            if (error)
            {
                NSLog(@"删除用户信息文件有误：%@",error);
            }
            else if (removeFinished)
            {
                User = nil;
            }
            [wself.navigationController popViewControllerAnimated:YES];
            [ProgressHUD showText:@"获取不了新的用户数据，请重新登录" Interaction:YES Hide:YES];
        }];
    } withErrorBlock:^(NSError *err)
     {
        NSLog(@"change img err:%@",err);
        if (err.code == -1009)
        {
            [ProgressHUD showText:@"无网络连接，请检查网络后重试" Interaction:YES Hide:YES];
        }
        else
        {
            [ProgressHUD showText:@"上传失败，请检查网络后重试" Interaction:YES Hide:YES];
        }
    }];
    [ProgressHUD show:@"上传中..." Interaction:NO Hide:NO];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
