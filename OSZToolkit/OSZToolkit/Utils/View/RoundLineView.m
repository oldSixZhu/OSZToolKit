//
//  RoundLineView.m
//  FitForceCoach
//
//  Created by xuyang on 2017/11/30.
//

#import "RoundLineView.h"

@implementation RoundLineView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);      //线的颜色
    
    if (self.lineMode == horizontalMode) {
        CGContextSetLineWidth(context, self.v_height);  //线宽
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, self.v_height/2.0, self.v_height/2.0);  //起点坐标
        CGContextAddLineToPoint(context, self.v_width - self.v_height/2.0, self.v_height/2.0);   //终点坐标
    } else {
        CGContextSetLineWidth(context, self.v_width);  //线宽
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, self.v_width/2.0, self.v_width/2.0);  //起点坐标
        CGContextAddLineToPoint(context, self.v_width/2.0, self.v_height - self.v_width/2.0);   //终点坐标
    }
    
    CGContextStrokePath(context);
}


@end
