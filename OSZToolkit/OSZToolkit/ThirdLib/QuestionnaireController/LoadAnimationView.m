//
//  LoadAnimationView.m
//  TYFitFore
//
//  Created by TanYun on 2018/3/15.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import "LoadAnimationView.h"

@interface LoadAnimationView ()

@property (nonatomic, strong) UIImageView *imageView;  /**< 图片 */
@property (nonatomic, strong) UILabel *titleLabel;     /**< 文字 */
@property (nonatomic, strong) UILabel *centerLabel;    /**< 解析中 */

@end




@implementation LoadAnimationView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.0];
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.centerLabel];
        //初始化位置
        [self setupStatus1];
    }
    return self;
}

//展示动画
- (void)startAnimation {
    //图片变大,文字挪到图片中间--0.5s
    [UIView animateWithDuration:0.5 animations:^{
        [self setupStatus2];
    } completion:^(BOOL finished) {
        //"解决中"立刻出现,然后开始画圆圈,文字挪到图片上边--1s
        [self setupStatus3];
    }];
}

//普通视图  白色图片,文字右边
- (void)setupStatus1 {
    self.imageView.frame = CGRectMake(20, 20, 34, 34);
    self.imageView.image = UIImageMake(@"icon_noselect");
    self.titleLabel.alpha = 1.0;
    self.titleLabel.frame = CGRectMake(64, 29, 55, 16);
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    self.titleLabel.textColor = [[UIColor whiteColor]colorWithAlphaComponent:0.6];
}

//图片变大,文字挪到图片上边--0.5s
- (void)setupStatus2 {
    self.imageView.frame = CGRectMake(0, 0, self.v_height, self.v_height);
    self.imageView.image = [Tools creatImageWithColor:UIColorFromHex(0x182845)];
    self.titleLabel.frame = CGRectMake(14, 22, 46, 12);
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    self.titleLabel.textColor = UIColorFromHex(0xD8E0E4);
}

//"解决中"立刻出现,然后开始画圆圈--1s
- (void)setupStatus3 {
    self.centerLabel.alpha = 1.0;
//    self.titleLabel.v_centerX = self.centerLabel.v_centerX;
    [self cicleAnimationIn:self.imageView withTime:1.0];
    [self performSelector:@selector(setupStatus4) withObject:nil afterDelay:1.1];
}

//3s圆画完后,两个label立刻消失,更换图片,在图片上画个对勾--0.5s
- (void)setupStatus4 {
    self.titleLabel.alpha = 0.0;
    self.centerLabel.alpha = 0.0;
    self.imageView.image = UIImageMake(@"bg_complete_ani");
    [self drawSuccessLineIn:self.imageView withTime:0.5];
    //画完对勾后开始下一个动画
    [self performSelector:@selector(startAnimation2) withObject:nil afterDelay:0.6];
}

//画完对勾,图片变小,右边label出现,归位--1s
- (void)startAnimation2 {
    [UIView animateWithDuration:1.0 animations:^{
        [self setupStatus5];
    }];
}

//画完对勾,图片变小,右边label出现,归位--1s
- (void)setupStatus5 {
    //清空图片的layer
    [self.imageView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self setupStatus1];
    //如果有基因报告,是绿的,没有是红色问号
    self.imageView.image = UIImageMake(@"icon_complete_big");
}

//直接更改图片为红色问号
- (void)setupStatusNO {
    self.imageView.image = UIImageMake(@"icon_no");
}


//画个圆
- (void)cicleAnimationIn:(UIImageView *)view withTime:(CGFloat)duration{
    //线宽
    CGFloat lineWidth = 5.0;
    //根据值动画画一个圆环
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path addArcWithCenter:CGPointMake(view.v_width/2.0, view.v_height/2.0) radius:view.v_height/2.0 - lineWidth startAngle:-M_PI_2 endAngle: M_PI * 2 - M_PI_2 clockwise:YES];
    shapeLayer.path = path.CGPath;
    shapeLayer.lineWidth = lineWidth;
    //指定线的边缘是圆的
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor blueColor].CGColor;
    [view.layer addSublayer:shapeLayer];
    //设置渐变颜色
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[UIColorFromHex(0x20C6BA ) CGColor], (id)[UIColorFromHex(0x00D3FF) CGColor], nil]];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    [view.layer addSublayer:gradientLayer];
    [gradientLayer setMask:shapeLayer];
    
    //动画
    CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnima.duration = duration;
    pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnima.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnima.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnima.fillMode = kCAFillModeForwards;
    pathAnima.removedOnCompletion = NO;
    [shapeLayer addAnimation:pathAnima forKey:@"strokeEndAnimation"];
}


//画对勾 (以74为宽高处理的point)
- (void)drawSuccessLineIn:(UIImageView *)view withTime:(CGFloat)duration{
    //清空之前的layer
    [view.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    //曲线建立开始点和结束点
    UIBezierPath *path = [UIBezierPath bezierPath];
    //对拐角和中点处理
    path.lineCapStyle  = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    //对勾的三个点
    [path moveToPoint:CGPointMake(24.5,35.5)];
    [path addLineToPoint:CGPointMake(32.5,44)];
    [path addLineToPoint:CGPointMake(48,28)];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    //内部填充颜色
    layer.fillColor = [UIColor clearColor].CGColor;
    //线条颜色
    layer.strokeColor = [UIColor whiteColor].CGColor;
    //线条宽度
    layer.lineWidth = 5;
    layer.path = path.CGPath;
    //头是圆的
    layer.lineCap = kCALineCapRound;
    layer.lineJoin = kCALineCapRound;
    //动画设置
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = duration;
    [layer addAnimation:animation forKey:NSStringFromSelector(@selector(strokeEnd))];
    
    [view.layer addSublayer:layer];
}

#pragma mark - setter
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}


#pragma mark - getter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
    }
    return _imageView;
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)centerLabel {
    if (!_centerLabel) {
        _centerLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 35, 50, 18)];
        _centerLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _centerLabel.textAlignment = NSTextAlignmentCenter;
        _centerLabel.textColor = [UIColor whiteColor];
        _centerLabel.text = ZYSString(@"sport_load_loading");
        _centerLabel.alpha = 0.0;
    }
    return _centerLabel;
}


@end











