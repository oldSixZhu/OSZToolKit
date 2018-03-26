//
//  CalenderHeaderView.m
//  YZCCalender
//
//  Created by Jason on 2018/1/18.
//  Copyright © 2018年 jason. All rights reserved.
//

#import "CalenderHeaderView.h"

@implementation CalenderHeaderView

- (UILabel *)yearAndMonthLabel {
    if (!_yearAndMonthLabel) {
        _yearAndMonthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.v_height - 15) * 0.5, self.v_width, 15)];
        _yearAndMonthLabel.textAlignment = NSTextAlignmentCenter;
        _yearAndMonthLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _yearAndMonthLabel.textColor = UIColorFromHex(0x9B9B9B);
        [self addSubview:_yearAndMonthLabel];
    }
    return _yearAndMonthLabel;
}


@end
