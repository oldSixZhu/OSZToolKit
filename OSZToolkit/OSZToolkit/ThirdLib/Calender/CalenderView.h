//
//  CalenderView.h
//  YZCCalender
//
//  Created by Jason on 2018/1/17.
//  Copyright © 2018年 jason. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CalenderView;

@protocol CalenderViewDelegate <NSObject>


- (void)selectedDate:(NSString *)selectedDate;

@end





@interface CalenderView : UIView

@property (nonatomic, copy) NSString *selectedDate;                  /**< 选择的日期 格式：2018-01-17 */
@property (nonatomic, weak) id<CalenderViewDelegate> delegate;

/// 更新数据源
- (void)refreshCalenderWithSelectedDay:(NSString *)date;

@end
