//
//  CommentBean.m
//  BeautyWhere
//
//  Created by Michael on 15/8/18.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "CommentBean.h"

@implementation CommentBean

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        self.commentID = [dic valueNull2NilForKey:@"id"];
        self.commentPartnerID = [dic valueNull2NilForKey:@"partner_id"];
        self.commentUserID = [dic valueNull2NilForKey:@"user_id"];
        self.commentGoodsID = [dic valueNull2NilForKey:@"goods_id"];
        self.commentContent = [dic valueNull2NilForKey:@"content"];
        self.commentStar = [dic valueNull2NilForKey:@"star"];
        self.commentService = [dic valueNull2NilForKey:@"service"];
        self.commentEnviroment = [dic valueNull2NilForKey:@"environment"];
        self.commentCreateTime = [dic valueNull2NilForKey:@"createtime"];
        self.commentScore = [dic valueNull2NilForKey:@"score"];
        self.commentAvatar = [dic valueNull2NilForKey:@"avatar"];
        self.commentUserName = [dic valueNull2NilForKey:@"username"];
    }
    return self;
}

@end
