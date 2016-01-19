//
//  TQStarRatingView.h
//  TQStarRatingView
//
//  Created by fuqiang on 13-8-28.
//  Copyright (c) 2013年 TinyQ. All rights reserved.
//


#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, MarkState) {
    MarkStateZero,
    MarkStateFullScore
};

@class TQStarRatingView;

@protocol StarRatingViewDelegate <NSObject>

@optional
-(void)starRatingView:(TQStarRatingView *)view score:(float)score;

@end

@interface TQStarRatingView : UIView

@property (nonatomic, readonly) int numberOfStar;

@property (nonatomic, weak) id <StarRatingViewDelegate> delegate;

@property (nonatomic, assign) CGFloat starImgWidth;

/**
 *  初始化TQStarRatingView
 *
 *  @param frame  Rectangles
 *  @param number 星星个数
 *
 *  @return TQStarRatingViewObject
 */
- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number withState:(MarkState)state withStarImgWith:(CGFloat)imgWidth;

- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number withState:(MarkState)state withStarImgWith:(CGFloat)imgWidth touch:(BOOL)touch;

/**
 *  设置控件分数
 *
 *  @param score     分数，必须在 0 － 1 之间
 *  @param isAnimate 是否启用动画
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate;

/**
 *  设置控件分数
 *
 *  @param score      分数，必须在 0 － 1 之间
 *  @param isAnimate  是否启用动画
 *  @param completion 动画完成block
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate completion:(void (^)(BOOL finished))completion;

@end

#define kBACKGROUND_STAR @"backgroundStar.png"
#define kFOREGROUND_STAR @"foregroundStar.png"
#define kDEFAULTIMAGEWIDTH_STAR 35.0