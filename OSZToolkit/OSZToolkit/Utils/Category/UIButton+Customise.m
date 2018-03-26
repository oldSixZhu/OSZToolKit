//
//  UIButton+Customise.m
//  LaiCai
//
//  Created by SmartMin on 15-8-10.
//  Copyright (c) 2015年 LaiCai. All rights reserved.
//

#import "UIButton+Customise.h"
#import <objc/runtime.h>

static char *buttonCallBackBlockKey;
static char *touchKey;

@implementation UIButton (Customise)

#pragma mark - 给UIButton添加点击事件
- (void) buttonWithBlock:(void(^)(UIButton *button))buttonClickBlock{
    [self addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    if (buttonClickBlock){
        objc_setAssociatedObject(self, &buttonCallBackBlockKey, buttonClickBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

-(void)buttonClick:(UIButton *)sender{
    void(^buttonClickBlock)(UIButton *button) = objc_getAssociatedObject(sender, &buttonCallBackBlockKey);
    if (buttonClickBlock){
        buttonClickBlock(sender);
    }
}

#pragma mark - 给UIButton增加额外的点击区域
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    UIEdgeInsets touchAreaInsets = self.touchAreaInsets;
    CGRect bounds = self.bounds;
    bounds = CGRectMake(bounds.origin.x - touchAreaInsets.left,
                        bounds.origin.y - touchAreaInsets.top,
                        bounds.size.width + touchAreaInsets.left + touchAreaInsets.right,
                        bounds.size.height + touchAreaInsets.top + touchAreaInsets.bottom);
    return CGRectContainsPoint(bounds, point);
}

- (void)setTouchAreaInsets:(UIEdgeInsets)touchAreaInsets {
    objc_setAssociatedObject(self, &touchKey, [NSValue valueWithUIEdgeInsets:touchAreaInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (UIEdgeInsets)touchAreaInsets {
    NSValue *value = objc_getAssociatedObject(self, &touchKey);
    return [value UIEdgeInsetsValue];
}

#pragma mark - 给button设置背景颜色的图片
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:[UIButton imageWithColor:backgroundColor] forState:state];
}


+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - 倒计时
- (void)startWithTime:(NSInteger)time btnNormalTitle:(NSString *)norTitle selectedTitle:(NSString *)selTitle normalColor:(UIColor *)norColor selectedColor:(UIColor *)selColor completeBlock:(void(^)(void))blcok {
    __block NSInteger timeOut = time;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.enabled = YES;
                [self setBackgroundColor:norColor forState:UIControlStateNormal];
                [self setTitle:norTitle forState:UIControlStateNormal];
                if (blcok) { //倒计时完成
                    blcok();
                }
            });
        } else {
            int allTime = (int)time + 1;
            int seconds = timeOut % allTime;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.enabled = NO;
                NSString *title = [NSString stringWithFormat:@"%dS后%@",seconds,selTitle];
                [self setBackgroundColor:selColor forState:UIControlStateDisabled];
                [self setTitle:title forState:UIControlStateDisabled];
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

@end
