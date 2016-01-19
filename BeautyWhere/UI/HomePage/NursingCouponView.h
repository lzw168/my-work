//
//  NursingCouponView.h
//  BeautyWhere
//
//  Created by lizhiwei on 16/1/7.
//  Copyright © 2016年 Michael. All rights reserved.
//

#ifndef NursingCouponView_h
#define NursingCouponView_h

@interface NursingCouponView : UIViewController{
}

@property (nonatomic) int width;//当前view的宽
@property (nonatomic) int height;//当前view的高
-(void)setWidth:(int)width andsetHeight:(int)height andsetImage:(NSString*)image;//设置当前VIEW高和宽
@end

#endif /* NursingCouponView_h */
