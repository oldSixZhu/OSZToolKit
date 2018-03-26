//
//  DataColorView.m
//  FitForceCoach
//
//  Created by xuyang on 2017/12/4.
//

#import "DataColorView.h"

@implementation DataColorView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextSetRGBStrokeColor(context, 32/255.0, 198/255.0, 186/255.0, 1.0);
    CGContextSetStrokeColorWithColor(context, self.viewColor.CGColor);
    CGContextSetLineWidth(context, self.frame.size.width);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    //画轴
    CGPoint aPoints[2];//X轴
    aPoints[0] = CGPointMake(self.frame.size.width / 2.0, self.frame.size.width / 2.0);//起始点
    aPoints[1] = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height - self.frame.size.width / 2.0);//终点
    
    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
}

@end
