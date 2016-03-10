//
//  PersonalViewController.h
//  BeautyWhere
//
//  Created by Michael on 15-7-21.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddMyAddressViewController : UITableViewController<UITextFieldDelegate,UIActionSheetDelegate,UITextViewDelegate>

@property (nonatomic, strong)UIImage *cacheHeaderImg;
@property (nonatomic, strong) NSString *editstatus;//0表示增加、1表示修改
@property (nonatomic, strong) NSString *addressid;
@property (nonatomic, strong) NSString *reciver;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *MyAddress;
@property (nonatomic, strong) NSString *is_default;
@end
