//
//  FFNotificationConfig.m
//  TYFitFore
//
//  Created by apple on 2019/2/20.
//  Copyright © 2019 tangpeng. All rights reserved.
//

#import "FFNotificationConfig.h"

@implementation FFNotificationConfig

+ (instancetype)defaultConfig {
    FFNotificationConfig *config = [[FFNotificationConfig alloc] init];
    config.showAnimationDuration = 0.3;
    config.hideAnimationDuration = 0.3;
    config.stayDuration = 3.0;
    
    return config;
}

@end
