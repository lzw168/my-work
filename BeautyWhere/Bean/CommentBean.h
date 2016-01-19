//
//  CommentBean.h
//  BeautyWhere
//
//  Created by Michael on 15/8/18.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentBean : NSObject

@property (nonatomic, strong) NSString *commentID;
@property (nonatomic, strong) NSString *commentPartnerID;
@property (nonatomic, strong) NSString *commentUserID;
@property (nonatomic, strong) NSString *commentGoodsID;
@property (nonatomic, strong) NSString *commentContent;
@property (nonatomic, strong) NSString *commentStar;
@property (nonatomic, strong) NSString *commentService;
@property (nonatomic, strong) NSString *commentEnviroment;
@property (nonatomic, strong) NSString *commentCreateTime;
@property (nonatomic, strong) NSString *commentScore;
@property (nonatomic, strong) NSString *commentAvatar;//头像
@property (nonatomic, strong) NSString *commentUserName;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
