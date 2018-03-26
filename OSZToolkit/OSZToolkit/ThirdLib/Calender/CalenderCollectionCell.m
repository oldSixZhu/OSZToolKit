//
//  CalenderCollectionCell.m
//  YZCCalender
//
//  Created by Jason on 2018/1/17.
//  Copyright © 2018年 jason. All rights reserved.
//

#import "CalenderCollectionCell.h"


@interface CalenderCollectionCell()

@property (nonatomic, strong) UILabel *numberLabel;  /**< 数字 */
@property (nonatomic, strong) UILabel *detailLabel;  /**< 今天明天后天 */


@end

@implementation CalenderCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 2;
        self.layer.masksToBounds = YES;
        [self.contentView addSubview:self.detailLabel];
    }
    return self;
}

#pragma mark - setter
-(void)setModel:(CalenderModel *)model {
    _model = model;
    
    [self.contentView addSubview:self.numberLabel];
    self.numberLabel.text = model.day;
    //今天明天后天
    if (model.dayType == Today) {
        self.detailLabel.hidden = NO;
        self.detailLabel.text = ZYSString(@"me_coach_dayLabel1");
    } else if (model.dayType == Tomorrow) {
        self.detailLabel.hidden = NO;
        self.detailLabel.text = ZYSString(@"me_coach_dayLabel2");
    } else if (model.dayType == AfterTomorrow) {
        self.detailLabel.hidden = NO;
        self.detailLabel.text = ZYSString(@"me_coach_dayLabel3");
    } else {
        self.detailLabel.hidden = YES;
        self.detailLabel.text = @"";
    }
    
    //如果被选择
    if (model.isSelected) {
        self.backgroundColor =  UIColorFromHex(0x18C9CB);
        self.numberLabel.textColor = [UIColor whiteColor];
        self.detailLabel.textColor = [UIColor whiteColor];
        //展示动画
        [self addAnimaiton];
    } else {
        self.backgroundColor = [UIColor whiteColor];
        self.numberLabel.textColor = UIColorFromHex(0x4A4A4A);
        self.detailLabel.textColor = UIColorFromHex(0x9B9B9B);
        //如果是今天
        if (model.dayType == Today) {
            self.detailLabel.textColor = UIColorFromHex(0x18C9C9);
        }
    }
}

//展示动画
-(void)addAnimaiton{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.values = @[@0.6,@1.2,@1.0];
    anim.keyPath = @"transform.scale";  // transform.scale 表示长和宽都缩放
    anim.calculationMode = kCAAnimationPaced;
    anim.duration = 0.25;
    [self.numberLabel.layer addAnimation:anim forKey:nil];
    [self.detailLabel.layer addAnimation:anim forKey:nil];
}


#pragma mark - getter
- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.v_width - 24) * 0.5, 10, 24, 20)];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
    }
    return _numberLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.numberLabel.v_bottom + 5, self.v_width, 12)];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        _detailLabel.hidden = YES;
    }
    return _detailLabel;
}

@end

