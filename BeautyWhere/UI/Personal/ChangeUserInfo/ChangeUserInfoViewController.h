//
//  ChangeUserInfoViewController.h
//  BeautyWhere
//
//  Created by Michael on 15/7/31.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalViewController.h"

@interface ChangeUserInfoViewController : UITableViewController

<
    UIActionSheetDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
>

@property (nonatomic, assign)PersonalViewController *personalPage;

@end
