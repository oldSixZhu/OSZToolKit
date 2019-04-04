//
//  FFNotificationView.m
//  TYFitFore
//
//  Created by apple on 2019/2/20.
//  Copyright © 2019 tangpeng. All rights reserved.
//

#import "FFNotificationView.h"
#import "FFNotificationWindow.h"

#define kAnimationDamping 0.8

@interface FFNotificationView ()

@property (nonatomic, strong) UILabel *messageLabel;                        /**< 消息文字  */

@property (nonatomic, strong) NSTimer *hideTimer;                           /**< 关闭弹窗的定时器  */
@property (nonatomic, strong) FFNotificationConfig *config;                 /**< 弹窗配置  */
@property (nonatomic, assign) BOOL isHiding;                                /**< 是否正在执行隐藏动画  */

@end

@implementation FFNotificationView

static NSMutableArray <FFNotificationView *> *sharedNotificationViews;
static FFNotificationWindow *sharedWindow;

#pragma mark - 初始化弹窗
+ (instancetype)showWithConfig:(void(^)(FFNotificationConfig *config))block {
    //获取弹窗window
    sharedWindow = [FFNotificationWindow sharedWindow];
    //初始化弹窗视图
    FFNotificationConfig *config = [FFNotificationConfig defaultConfig];
    block(config);
    
    FFNotificationView *notificationView = [[FFNotificationView alloc] init];
    notificationView.backgroundColor = UIColorFromHex(0x20C6BA);
    notificationView.config = config;
    [notificationView addGestureRecognizer];
    return notificationView;
}

#pragma mark - 获取当前弹窗
+ (instancetype)current {
    FFNotificationView *notificationView = sharedWindow.rootViewController.view.subviews.lastObject;
    if ([notificationView isKindOfClass:[FFNotificationView class]] && notificationView.superview) {
        return notificationView;
    }
    return nil;
}

#pragma mark - 视图处理
- (void)show {
    //定时器处理
    if (self.hideTimer) {
        [self.hideTimer invalidate];
        self.hideTimer = nil;
    }
    
    //布局视图
    self.messageLabel.text = self.config.message;
    self.frame = CGRectMake(0, -NAV_HEIGHT, SCREEN_WIDTH, NAV_HEIGHT);
    CGSize size = [Tools calculateTextSize:self.messageLabel.text maxSize:CGSizeMake(SCREEN_WIDTH - kFloat(40), CGFLOAT_MAX) font:self.messageLabel.font];
    CGFloat labelHeight = 0;
    if (size.height > self.messageLabel.font.lineHeight) {
        labelHeight = self.messageLabel.font.lineHeight * 2;
    } else {
        labelHeight = size.height;
    }
    CGFloat startY = isIPhoneXSeries() ? ((CGRectGetHeight(self.frame) - labelHeight - STATUSBAR_HEIGHT)/2.0 + STATUSBAR_HEIGHT) : ((CGRectGetHeight(self.frame) - labelHeight)/2.0);
    self.messageLabel.frame = CGRectMake((SCREEN_WIDTH - size.width)/2.0, startY, size.width, labelHeight);
    [self addSubview:self.messageLabel];
    [sharedWindow.rootViewController.view addSubview:self];
    
    //添加到数组中
    if (!sharedNotificationViews) {
        sharedNotificationViews = [NSMutableArray array];
    }
    [sharedNotificationViews addObject:self];
    
    //视图出现动画
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:self.config.showAnimationDuration delay:0 usingSpringWithDamping:kAnimationDamping initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.frame = CGRectMake(0, 0, SCREEN_WIDTH, NAV_HEIGHT);
    } completion:^(BOOL finished) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.hideTimer = [NSTimer scheduledTimerWithTimeInterval:strongSelf.config.stayDuration target:weakSelf selector:@selector(hide) userInfo:nil repeats:NO];
    }];
}

- (void)hide {
    if (!self.isHiding) {
        //标记为正在执行隐藏动画，不再重复执行
        self.isHiding = YES;
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:self.config.showAnimationDuration delay:0 usingSpringWithDamping:kAnimationDamping initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.frame = CGRectMake(0, -NAV_HEIGHT, SCREEN_WIDTH, NAV_HEIGHT);
        } completion:^(BOOL finished) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf removeFromSuperview];
            if (strongSelf && [sharedNotificationViews containsObject:strongSelf]) {
                [sharedNotificationViews removeObject:strongSelf];
            }
        }];
    }
}

/** 移除所有弹窗 */
+ (void)hideAll {
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:sharedNotificationViews];
    for (FFNotificationView *view in tempArray) {
        if ([sharedNotificationViews containsObject:view]) {
            [view hide];
        }
    }
}

/** 添加手势 */
- (void)addGestureRecognizer {
    //点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:tapGesture];
    
    //平移手势隐藏弹窗
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [self addGestureRecognizer:panGesture];
}

/** 点击手势 */
- (void)tapGesture:(UITapGestureRecognizer*)tapGesture {
    [self hide];
    if (self.didTouchView) {
        self.didTouchView();
    }
}

- (void)panGestureAction:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [pan translationInView:self];
        CGFloat absX = fabs(translation.x);
        CGFloat absY = fabs(translation.y);
        // 设置滑动有效距离
        if (MAX(absX, absY) < 5)
            return;
        if (absY > absX) {
            //向上滑动
            if (translation.y < 0) {
                [self hide];
            }
        }
    }
}

#pragma mark - getter
- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = [UIFont systemFontOfSize:kFloat(15)];
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.numberOfLines = 2;
        _messageLabel.userInteractionEnabled = NO;
    }
    return _messageLabel;
}

@end
