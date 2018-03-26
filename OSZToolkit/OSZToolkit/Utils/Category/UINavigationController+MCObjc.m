//
//  UINavigationController+MCObjc.m
//  MCExtensionTools
//
//  Created by mtime_lee on 2017/8/2.
//  Copyright © 2017年 mctools. All rights reserved.
//

#import "UINavigationController+MCObjc.h"
#import <objc/runtime.h>

static char *navigationPanOffsetKey = "navigationPanOffsetKey";

@interface MCFullScreenPopGestureRecognizerDelegate : NSObject<UIGestureRecognizerDelegate>

@property(nonatomic, weak) UINavigationController *navigationController;

@end

@implementation MCFullScreenPopGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    
    //当手势在屏幕边缘时，才响应手势
    CGPoint point = [gestureRecognizer locationOfTouch:0 inView:gestureRecognizer.view];
    //=============================
    //不允许手势滑动返回
    if (!self.navigationController.enableMCPopGesture) {
        return NO;
    }
    //当手势偏移量小于最大值时，才允许操作
    else if (point.x > PANOFFSETX) {
        return NO;
    }
    
    return YES;
}

@end

@implementation UINavigationController (MCObjc)

+ (void)load {
    
    Method originalMethod = class_getInstanceMethod([self class], @selector(pushViewController:animated:));
    Method exchangeMethod = class_getInstanceMethod([self class], @selector(mc_pushViewController:animated:));
    method_exchangeImplementations(originalMethod, exchangeMethod);
}

- (void)mc_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.mc_popGestureRecognizer]) {
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.mc_popGestureRecognizer];
        
        NSArray *targets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
        id internalTarget = [targets.firstObject valueForKey:@"target"];
        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
        
        self.mc_popGestureRecognizer.delegate = [self mc_fullScreenPopGestureRecognizerDelegate];
        [self.mc_popGestureRecognizer addTarget:internalTarget action:internalAction];
        
        // 禁用系统的交互手势
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    if (![self.viewControllers containsObject:viewController]) {
        [self mc_pushViewController:viewController animated:animated];
    }
}

- (MCFullScreenPopGestureRecognizerDelegate *)mc_fullScreenPopGestureRecognizerDelegate {
    MCFullScreenPopGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    if (!delegate) {
        delegate = [[MCFullScreenPopGestureRecognizerDelegate alloc] init];
        delegate.navigationController = self;
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}

- (UIPanGestureRecognizer *)mc_popGestureRecognizer {
    UIPanGestureRecognizer *pan = objc_getAssociatedObject(self, _cmd);
    if (!pan) {
        pan = [[UIPanGestureRecognizer alloc] init];
        pan.maximumNumberOfTouches = 1;
        objc_setAssociatedObject(self, _cmd, pan, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return pan;
}

//自定义是否允许左滑返回
- (void)setEnableMCPopGesture:(BOOL)enableMCPopGesture {
    objc_setAssociatedObject(self, navigationPanOffsetKey, @(enableMCPopGesture), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)enableMCPopGesture {
    NSNumber *enable = objc_getAssociatedObject(self, navigationPanOffsetKey);
    if (enable) {
        return [enable intValue];
    }
    return YES;
}

@end
