//
//  UINavigationController+MCObjc.h
//  MCExtensionTools
//
//  Created by mtime_lee on 2017/8/2.
//  Copyright © 2017年 mctools. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PANOFFSETX 40

@interface UINavigationController (MCObjc)

@property (nonatomic, strong, readonly) UIPanGestureRecognizer *mc_popGestureRecognizer;

@property (nonatomic, assign) BOOL enableMCPopGesture;                           /**< 是否允许左侧滑动返回 */

@end
