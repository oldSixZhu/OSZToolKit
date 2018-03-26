//
//  DataTimeLineView.m
//  FitForceCoach
//
//  Created by xuyang on 2017/12/5.
//

#import "DataTimeLineView.h"

@implementation DataTimeLineView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat centerX = self.v_width/2.0;
    
    //绘制线条
    CGPoint aPoints[2];//坐标点
    aPoints[0] = CGPointMake(centerX, 0);//坐标1
    aPoints[1] = CGPointMake(centerX, self.v_height);//坐标2
    //points[]坐标数组，和count大小
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColorFromHex(0x20C6BA) colorWithAlphaComponent:0.5].CGColor);
    
    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
    
    //绘制外圆
    //    CGContextSetRGBFillColor(context, 24.0/255.0, 40.0/255.0, 69.0/255.0, 1.0);
    CGContextSetFillColorWithColor(context, UIColorFromHex(0x182845).CGColor);
    CGContextAddArc(context, centerX, self.v_height - 27, 4, 0, 2*M_PI, 0);
    CGContextDrawPath(context, kCGPathFill); //绘制路径
    
    //绘制内圆
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextAddArc(context, centerX, self.v_height - 27, 2.5, 0, 2*M_PI, 0);
    CGContextDrawPath(context, kCGPathFill); //绘制路径
    
}

@end
