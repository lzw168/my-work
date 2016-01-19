//
//  TQStarRatingView.m
//  TQStarRatingView
//
//  Created by fuqiang on 13-8-28.
//  Copyright (c) 2013年 TinyQ. All rights reserved.
//

#import "TQStarRatingView.h"

@interface TQStarRatingView ()

@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;

@end

@implementation TQStarRatingView

@synthesize starImgWidth = _starImgWidth;

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame numberOfStar:5 withState:MarkStateZero withStarImgWith:kDEFAULTIMAGEWIDTH_STAR];
}

/**
 *  初始化TQStarRatingView
 *
 *  @param frame  Rectangles
 *  @param number 星星个数
 *
 *  @return TQStarRatingViewObject
 */
- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number withState:(MarkState)state withStarImgWith:(CGFloat)imgWidth
{
    self = [super initWithFrame:frame];
    if (self) {
        self.starImgWidth = imgWidth;
        _numberOfStar = number;
        self.starBackgroundView = [self buidlStarViewWithImageName:kBACKGROUND_STAR];
        self.starForegroundView = [self buidlStarViewWithImageName:kFOREGROUND_STAR];
        [self addSubview:self.starBackgroundView];
        [self addSubview:self.starForegroundView];
        if (state == MarkStateZero) {
            [self changeStarForegroundViewWithPoint:CGPointZero];
        }
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tap];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number withState:(MarkState)state withStarImgWith:(CGFloat)imgWidth touch:(BOOL)touch
{
    self = [super initWithFrame:frame];
    if (self) {
        self.starImgWidth = imgWidth;
        _numberOfStar = number;
        self.starBackgroundView = [self buidlStarViewWithImageName:kBACKGROUND_STAR];
        self.starForegroundView = [self buidlStarViewWithImageName:kFOREGROUND_STAR];
        [self addSubview:self.starBackgroundView];
        [self addSubview:self.starForegroundView];
        if (state == MarkStateZero) {
            [self changeStarForegroundViewWithPoint:CGPointZero];
        }
        
        if (touch) {
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [self addGestureRecognizer:tap];
            [self addGestureRecognizer:pan];
        }
    }
    return self;
}

#pragma mark -
#pragma mark - Set Score

/**
 *  设置控件分数
 *
 *  @param score     分数，必须在 0 － 1 之间
 *  @param isAnimate 是否启用动画
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate
{
    [self setScore:score withAnimation:isAnimate completion:^(BOOL finished){}];
}

/**
 *  设置控件分数
 *
 *  @param score      分数，必须在 0 － 1 之间
 *  @param isAnimate  是否启用动画
 *  @param completion 动画完成block
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate completion:(void (^)(BOOL finished))completion
{
//    NSAssert((score >= 0.0)&&(score <= 1.0), @"score must be between 0 and 1");
    
    if (score < 0.0)
    {
        score = 0.0;
    }
    
    if (score > 1.0)
    {
        score = 1.0;
    }
    
    CGPoint point = CGPointMake(score * self.frame.size.width, 0);
    
    if(isAnimate)
    {
        __weak TQStarRatingView * weekSelf = self;
        
        [UIView animateWithDuration:0.2 animations:^
         {
             [weekSelf changeStarForegroundViewWithPoint:point];
             
         } completion:^(BOOL finished)
         {
             if (completion)
             {
                 completion(finished);
             }
         }];
    }
    else
    {
        [self changeStarForegroundViewWithScore:score];
    }
}

#pragma mark -
#pragma mark - Touche Event
- (void)handlePan:(UIPanGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [g locationInView:self];
        CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        if(CGRectContainsPoint(rect,point))
        {
            [self changeStarForegroundViewWithPoint:point showWholeStar:YES];
        }
    }
    else if (g.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [g locationInView:self];
        __weak TQStarRatingView * weekSelf = self;
        
        [UIView animateWithDuration:0.2 animations:^
         {
             [weekSelf changeStarForegroundViewWithPoint:point showWholeStar:YES];
         }];
    }
}
- (void)handleTap:(UITapGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [g locationInView:self];
        __weak TQStarRatingView * weekSelf = self;
        
        [UIView animateWithDuration:0.2 animations:^
         {
             [weekSelf changeStarForegroundViewWithPoint:point showWholeStar:YES];
         }];
    }
}
/*
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if(CGRectContainsPoint(rect,point))
    {
        [self changeStarForegroundViewWithPoint:point];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    __weak TQStarRatingView * weekSelf = self;
    
    [UIView animateWithDuration:0.2 animations:^
     {
         [weekSelf changeStarForegroundViewWithPoint:point];
     }];
}
*/
#pragma mark -
#pragma mark - Buidl Star View

/**
 *  通过图片构建星星视图
 *
 *  @param imageName 图片名称
 *
 *  @return 星星视图
 */
- (UIView *)buidlStarViewWithImageName:(NSString *)imageName
{
    CGRect frame = self.bounds;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.clipsToBounds = YES;
    for (int i = 0; i < self.numberOfStar; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(i * frame.size.width / self.numberOfStar, 0, self.starImgWidth, frame.size.height);
        [view addSubview:imageView];
    }
    return view;
}

#pragma mark -
#pragma mark - Change Star Foreground With Point

/**
 *  通过坐标改变前景视图
 *
 *  @param point 坐标
 */
- (void)changeStarForegroundViewWithPoint:(CGPoint)point
{
    CGFloat halfImgWidth = self.starImgWidth / 2.0 - 4.0;
    
    CGPoint p = point;
    
    if (p.x < 0.0)
    {
        p.x = 0.0;
    }
    
    if (p.x > self.frame.size.width)
    {
        p.x = self.frame.size.width;
    }

    int halfStarCount = (int)(p.x / halfImgWidth + .5);
    if ((p.x > halfImgWidth * (halfStarCount - 1)) && halfStarCount > 0) {
        p.x = halfImgWidth * (halfStarCount + 1);
    }
    
    NSString * str = [NSString stringWithFormat:@"%0.1f",p.x / self.frame.size.width];
    float score = [str floatValue];
    ///////////////
//    int bigScore = score*10;
//    if (bigScore%2 != 0) {
//        score += .1;
//    }
    ///////////////
    p.x = score * self.frame.size.width - 4.0;
    if (p.x < 0.0) {
        p.x = 0.0;
    }
    if (p.x > self.frame.size.width)
    {
        p.x = self.frame.size.width;
    }

    self.starForegroundView.frame = CGRectMake(0, 0, p.x, self.frame.size.height);
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(starRatingView: score:)])
    {
        [self.delegate starRatingView:self score:score];
    }
}

- (void)changeStarForegroundViewWithScore:(CGFloat)score
{
    CGFloat halfImgWidth = self.starImgWidth / 2.0;
    
    CGPoint p = CGPointZero;
    score = score*10.0;
    
    int s = (int)score;
    if ((score - s) > 0.0) {
        s += 1.0;
    }
    
    int index = (s-1)/2;
    
    p.x = index*4.0 + s * halfImgWidth;

    self.starForegroundView.frame = CGRectMake(0, 0, p.x, self.frame.size.height);
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(starRatingView: score:)])
    {
        [self.delegate starRatingView:self score:score];
    }
}

- (void)changeStarForegroundViewWithPoint:(CGPoint)point showWholeStar:(BOOL)showWhole
{
    CGFloat halfImgWidth = self.starImgWidth / 2.0 - 4.0;
    
    CGPoint p = point;
    
    if (p.x < 0.0)
    {
        p.x = 0.0;
    }
    
    if (p.x > self.frame.size.width)
    {
        p.x = self.frame.size.width;
    }
    
    int halfStarCount = (int)(p.x / halfImgWidth + .5);
    if ((p.x > halfImgWidth * (halfStarCount - 1)) && halfStarCount > 0) {
        p.x = halfImgWidth * (halfStarCount + 1);
    }
    
    NSString * str = [NSString stringWithFormat:@"%0.1f",p.x / self.frame.size.width];
    float score = [str floatValue];
    if (showWhole) {
        int bigScore = score*10;
        if (bigScore%2 != 0) {
            score += .1;
        }
    }
    p.x = score * self.frame.size.width - 4.0;
    if (p.x < 0.0) {
        p.x = 0.0;
    }
    if (p.x > self.frame.size.width)
    {
        p.x = self.frame.size.width;
    }
    
    self.starForegroundView.frame = CGRectMake(0, 0, p.x, self.frame.size.height);
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(starRatingView: score:)])
    {
        [self.delegate starRatingView:self score:score];
    }
}

@end
