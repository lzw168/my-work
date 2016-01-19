//
//  AboutViewController.m
//  BeautyWhere
//
//  Created by Michael Chan on 15/7/24.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIImage *logoImg = [UIImage imageNamed:@"guanyu-guanggao.png"];
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-logoImg.size.width)/2, 10, logoImg.size.width, logoImg.size.height)];
    logo.image = logoImg;
    [self.view addSubview:logo];
    
//    NSString *content = @"上哪美专注“促销活动、教育培训、广告支持、客户服务、公共关系、电子商务、产品研发更新、电话行销、忠诚度行销”为主的360度品牌行销服务，想店家所想，做店家所做，与每一个创业者共同创富。";
    NSString *content = @"上哪美，一家专门为女性消费者做美容特惠的APP。";
    NSMutableAttributedString *attributeContent = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 16;
    paragraphStyle.firstLineHeadIndent = 38;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *contentAttributeDic = @{NSFontAttributeName:[UIFont systemFontOfSize:19], NSParagraphStyleAttributeName:paragraphStyle};
    [attributeContent addAttributes:contentAttributeDic range:NSMakeRange(0, content.length)];
    CGSize contentSize = [content boundingRectWithSize:CGSizeMake(ScreenWidth-20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:contentAttributeDic context:nil].size;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, logo.frame.size.height+30, contentSize.width, contentSize.height)];
    label.numberOfLines = 0;
    label.attributedText = attributeContent;
    [self.view addSubview:label];
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

@end
