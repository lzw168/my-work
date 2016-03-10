//
//  InfoDetailTableViewController.m
//  BeautyWhere
//
//  Created by Michael on 15/8/5.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "InfoDetailTableViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UserProtocolDetailViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface InfoDetailTableViewController ()

@property (nonatomic, strong) InfoBean *infoBean;

@end

@implementation InfoDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    
    // Configure the cell...
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
        switch (indexPath.row) {
            case 0:
            {
                UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, CellHeight)];
                title.text = self.infoBean.infoTitle;
                title.textAlignment = NSTextAlignmentCenter;
                title.font = [UIFont boldSystemFontOfSize:19];
                [cell.contentView addSubview:title];
                
                UILabel *date = [[UILabel alloc] init];
                date.text = [NSString stringWithFormat:@"时间：%@",self.infoBean.infoCreateTime];
                date.font = [UIFont systemFontOfSize:13];
                [date sizeToFit];
                date.frame = CGRectMake(0, CellHeight-date.frame.size.height, date.frame.size.width, date.frame.size.height);
                date.center = CGPointMake(ScreenWidth/2, date.center.y);
                [cell.contentView addSubview:date];
            }
                break;
            case 1:
            {
                UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(30, CellHeight-(ScreenWidth-60)*0.75, ScreenWidth-60, (ScreenWidth-60)*0.75)];
                [pic setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",GetAppDelegate.img_path, self.infoBean.infoImage]] placeholderImage:[UIImage imageNamed:@"pic_2loading.png"]];
                pic.userInteractionEnabled = YES;
                [cell.contentView addSubview:pic];
                
                if (self.infoBean.videoURL && ![self.infoBean.videoURL isEqualToString:@""]) {
                    UIImage *playImg = [UIImage imageNamed:@"icpn-bofang@2x.png"];
                    UIButton *play = [[UIButton alloc] initWithFrame:CGRectMake(pic.frame.size.width-playImg.size.width-5, pic.frame.size.height-playImg.size.height-5, playImg.size.width, playImg.size.height)];
                    [play setImage:playImg forState:UIControlStateNormal];
                    [play addTarget:self action:@selector(playURLContent) forControlEvents:UIControlEventTouchUpInside];
                    [pic addSubview:play];
                }
            }
                break;
            case 2:
            {
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.lineSpacing = 9;
                NSAttributedString *contentStr = [[NSAttributedString alloc] initWithString:self.infoBean.infoDetail attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
                UILabel *content = [[UILabel alloc] init];
                content.lineBreakMode = NSLineBreakByCharWrapping;
                content.numberOfLines = 0;
                content.attributedText = contentStr;
                [content sizeToFit];
                content.font = [UIFont systemFontOfSize:13.0];
                content.frame = CGRectMake(10, 10, ScreenWidth-20, CellHeight-10);
                [cell.contentView addSubview:content];
            }
                break;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return 70;
            break;
        case 1:
            return 210;
            break;
        case 2:
        {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 9;
            return [self.infoBean.infoDetail boundingRectWithSize:CGSizeMake(ScreenWidth-20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height+10;
        }
            break;
        default:
            return 0;
            break;
    }
}

#pragma mark - Button Response
- (void)playURLContent {
    NSLog(@"playURLContent self.infoBean.videoURL:%@",self.infoBean.videoURL);
 /*   MPMoviePlayerViewController *playViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:self.infoBean.videoURL]];
    MPMoviePlayerController *player = [playViewController moviePlayer];
    player.scalingMode = MPMovieScalingModeFill;
    player.controlStyle = MPMovieControlStyleFullscreen;
    [player play];
    [self.navigationController presentViewController:playViewController animated:YES completion:nil];*/
    UserProtocolDetailViewController *web = [[UserProtocolDetailViewController alloc] init];
    web.urlStr = self.infoBean.videoURL;
    web.title = self.infoBean.infoTitle;
    [self.navigationController pushViewController:web animated:YES];
}

#pragma mark - Setter & Getter
- (void)passInfoBean:(InfoBean *)infoBean {
    self.infoBean = infoBean;
}

@end
