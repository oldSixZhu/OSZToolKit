//
//  FFNotificationView.h
//  TYFitFore
//
//  Created by apple on 2019/2/20.
//  Copyright © 2019 tangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FFNotificationConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface FFNotificationView : UIView

@property (nonatomic, copy) void (^didTouchView)(void);                             /**< 点击视图响应  */

+ (instancetype)showWithConfig:(void(^)(FFNotificationConfig *config))block;

- (void)show;

- (void)hide;
+ (void)hideAll;

//can be nil
+ (instancetype)current;

@end

NS_ASSUME_NONNULL_END
