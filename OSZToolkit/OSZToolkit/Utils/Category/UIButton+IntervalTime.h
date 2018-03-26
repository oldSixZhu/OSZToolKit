//
//  UIButton+IntervalTime.h
//  FitForceCoach
//
//  Created by apple on 2018/3/8.
//

#import <UIKit/UIKit.h>

@interface UIButton (IntervalTime)

/* 防止button重复点击，设置间隔 */
@property (nonatomic, assign) NSTimeInterval mm_acceptEventInterval;;

@end
