//
//  UIView+Extension.m
//  FitForceCoach
//
//  Created by xuyang on 2017/11/29.
//

#import "UIView+Extension.h"

#import <objc/runtime.h>

static char *cornerImageViewKey;

@implementation UIView (Extension)

- (CGFloat)v_height {
    return self.frame.size.height;
}

- (CGFloat)v_width {
    return self.frame.size.width;
}

- (CGFloat)v_x {
    return self.frame.origin.x;
}

- (CGFloat)v_y {
    return self.frame.origin.y;
}

- (CGSize)v_size {
    return self.frame.size;
}

- (CGPoint)v_origin {
    return self.frame.origin;
}

- (CGFloat)v_centerX {
    return self.center.x;
}

- (CGFloat)v_centerY {
    return self.center.y;
}

- (CGFloat)v_left {
    return CGRectGetMinX(self.frame);
}

- (CGFloat)v_top {
    return CGRectGetMinY(self.frame);
}

- (CGFloat)v_bottom {
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)v_right {
    return CGRectGetMaxX(self.frame);
}

- (void)setV_x:(CGFloat)x {
    self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)setV_left:(CGFloat)left {
    self.v_x = left;
}

- (void)setV_y:(CGFloat)y {
    self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height);
}

- (void)setV_top:(CGFloat)top {
    self.v_y = top;
}

- (void)setV_bottom:(CGFloat)bottom {
    self.frame = CGRectMake(self.frame.origin.x, bottom - self.frame.size.height, self.frame.size.width, self.frame.size.height);
}
- (void)setV_right:(CGFloat)right {
    self.frame = CGRectMake(right - self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

// height
- (void)setV_height:(CGFloat)height {
    CGRect newFrame = CGRectMake(self.v_x, self.v_y, self.v_width, height);
    self.frame = newFrame;
}

- (void)heightEqualToView:(UIView *)view {
    self.v_height = view.v_height;
}

// width
- (void)setV_width:(CGFloat)width {
    CGRect newFrame = CGRectMake(self.v_x, self.v_y, width, self.v_height);
    self.frame = newFrame;
}

- (void)widthEqualToView:(UIView *)view {
    self.v_width = view.v_width;
}

// size
- (void)setV_size:(CGSize)size {
    self.frame = CGRectMake(self.v_x, self.v_y, size.width, size.height);
}

- (void)sizeEqualToView:(UIView *)view {
    self.frame = CGRectMake(self.v_x, self.v_y, view.v_width, view.v_height);
}

// center
- (void)setV_centerX:(CGFloat)centerX {
    CGPoint center = CGPointMake(self.v_centerX, self.v_centerY);
    center.x = centerX;
    self.center = center;
}

- (void)setV_centerY:(CGFloat)centerY {
    CGPoint center = CGPointMake(self.v_centerX, self.v_centerY);
    center.y = centerY;
    self.center = center;
}

- (void)centerXEqualToView:(UIView *)view {
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewCenterPoint = [superView convertPoint:view.center toView:self.topSuperView];
    CGPoint centerPoint = [self.topSuperView convertPoint:viewCenterPoint toView:self.superview];
    self.v_centerX = centerPoint.x;
}

- (void)centerYEqualToView:(UIView *)view {
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewCenterPoint = [superView convertPoint:view.center toView:self.topSuperView];
    CGPoint centerPoint = [self.topSuperView convertPoint:viewCenterPoint toView:self.superview];
    self.v_centerY = centerPoint.y;
}

- (void)centerEqualToView:(UIView *)view {
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewCenterPoint = [superView convertPoint:view.center toView:self.topSuperView];
    CGPoint centerPoint = [self.topSuperView convertPoint:viewCenterPoint toView:self.superview];
    self.v_centerX = centerPoint.x;
    self.v_centerY = centerPoint.y;
}

- (UIView *)topSuperView
{
    UIView *topSuperView = self.superview;
    
    if (topSuperView == nil) {
        topSuperView = self;
    } else {
        while (topSuperView.superview) {
            topSuperView = topSuperView.superview;
        }
    }
    
    return topSuperView;
}

#pragma mark - 视图布局，适用于UILabel
- (void)layoutForFrame:(CGRect)frame text:(NSString *)text {
    if ([self isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)self;
        CGSize size = [Tools sizeForText:text fontSize:label.font size:CGSizeMake(frame.size.width, frame.size.height)];
        label.frame = CGRectMake(frame.origin.x, frame.origin.y, size.width, size.height);
        label.text = text;
    }
}

- (void)layoutForFrame:(CGRect)frame {
    if ([self isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)self;
        CGSize size = [Tools sizeForText:label.text fontSize:label.font size:CGSizeMake(frame.size.width, frame.size.height)];
        label.frame = CGRectMake(frame.origin.x, frame.origin.y, size.width, size.height);
    }
}

#pragma mark - 为UIView设置圆角
- (void)setCornerImageView:(UIImageView *)cornerImageView {
    objc_setAssociatedObject(self, &cornerImageViewKey, cornerImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)cornerImageView {
    UIImageView *cornerImageView = objc_getAssociatedObject(self, &cornerImageViewKey);
    return cornerImageView;
}

- (void)addRounderCornerWithRadius:(CGFloat)radius color:(UIColor *)color {
    CGSize size = self.v_size;
    if (!self.cornerImageView) {
        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
        CGContextRef cxt = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(cxt, color.CGColor);
        
        CGContextMoveToPoint(cxt, size.width, size.height-radius);
        CGContextAddArcToPoint(cxt, size.width, size.height, size.width-radius, size.height, radius);//右下角
        CGContextAddArcToPoint(cxt, 0, size.height, 0, size.height-radius, radius);//左下角
        CGContextAddArcToPoint(cxt, 0, 0, radius, 0, radius);//左上角
        CGContextAddArcToPoint(cxt, size.width, 0, size.width, radius, radius);//右上角
        CGContextClosePath(cxt);
        CGContextDrawPath(cxt, kCGPathFill);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.cornerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        [self.cornerImageView setImage:image];
    } else {
        self.cornerImageView.frame = CGRectMake(0, 0, size.width, size.height);
    }
    
    [self insertSubview:self.cornerImageView atIndex:0];
}


@end
