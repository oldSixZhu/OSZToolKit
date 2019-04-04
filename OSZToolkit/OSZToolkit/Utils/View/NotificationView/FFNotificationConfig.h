//
//  FFNotificationConfig.h
//  TYFitFore
//
//  Created by apple on 2019/2/20.
//  Copyright © 2019 tangpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FFNotificationConfig : NSObject

@property(nonatomic, strong) NSString *message;                                 /**< 弹窗提示内容  */
@property(nonatomic, assign) NSTimeInterval showAnimationDuration;              //default is 0.3
@property(nonatomic, assign) NSTimeInterval hideAnimationDuration;              //default is 0.5
@property(nonatomic, assign) NSTimeInterval stayDuration;                       //default is 3.0

+ (instancetype)defaultConfig;

@end

NS_ASSUME_NONNULL_END
