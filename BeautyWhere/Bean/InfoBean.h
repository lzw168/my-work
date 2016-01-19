//
//  InfoBean.h
//  BeautyWhere
//
//  Created by Michael on 15/8/6.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoBean : NSObject

@property (nonatomic, strong) NSString *infoID;
@property (nonatomic, strong) NSString *infoTitle;
@property (nonatomic, strong) NSString *infoIntro;
@property (nonatomic, strong) NSString *infoAuthor;
@property (nonatomic, strong) NSString *infoDetail;
@property (nonatomic, strong) NSString *infoCreateTime;
@property (nonatomic, strong) NSString *infoType;
@property (nonatomic, strong) NSString *infoImage;
@property (nonatomic, assign) BOOL infoIsCollect;
@property (nonatomic, strong) NSString *videoURL;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
