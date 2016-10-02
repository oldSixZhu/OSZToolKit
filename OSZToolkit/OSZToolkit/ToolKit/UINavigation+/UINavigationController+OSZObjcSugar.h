//
//  UINavigationController+OSZObjcSugar.h
//
//  Created by OSZ on 16/3/26.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (OSZObjcSugar)

/// 自定义全屏拖拽返回手势
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *osz_popGestureRecognizer;

@end
