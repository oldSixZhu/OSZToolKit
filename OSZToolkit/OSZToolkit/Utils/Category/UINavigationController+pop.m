//
//  UINavigationController+pop.m
//  FitForceCoach
//
//  Created by apple on 2019/3/12.
//

#import "UINavigationController+pop.h"
#import <objc/runtime.h>

static char *navigationPopKey;

@implementation UINavigationController (pop)

+ (void)load {
    // 通过class_getInstanceMethod()函数从当前对象中的method list获取method结构体，如果是类方法就使用class_getClassMethod()函数获取。
    Method fromMethod = class_getInstanceMethod([self class], @selector(popViewControllerAnimated:));
    Method toMethod = class_getInstanceMethod([self class], @selector(xy_popViewControllerAnimated:));
    /**
     *  我们在这里使用class_addMethod()函数对Method Swizzling做了一层验证，如果self没有实现被交换的方法，会导致失败。
     *  而且self没有交换的方法实现，但是父类有这个方法，这样就会调用父类的方法，结果就不是我们想要的结果了。
     *  所以我们在这里通过class_addMethod()的验证，如果self实现了这个方法，class_addMethod()函数将会返回NO，我们就可以对其进行交换了。
     */
    if (!class_addMethod([self class], @selector(xy_popViewControllerAnimated:), method_getImplementation(toMethod), method_getTypeEncoding(toMethod))) {
        method_exchangeImplementations(fromMethod, toMethod);
    }
}

- (void)setPopCompletion:(void (^)(void))popCompletion {
    objc_setAssociatedObject(self, &navigationPopKey, popCompletion, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(void))popCompletion {
    return objc_getAssociatedObject(self, &navigationPopKey);
}

- (UIViewController *)xy_popViewControllerAnimated:(BOOL)animated {
    if (self.popCompletion) {
        UIViewController *poppedViewController;
        [CATransaction setCompletionBlock:self.popCompletion];
        [CATransaction begin];
        poppedViewController = [self xy_popViewControllerAnimated:animated];
        [CATransaction commit];
        return poppedViewController;
    } else {
        return [self xy_popViewControllerAnimated:animated];
    }
}

@end
