//
//  OSZRulerViewCell.m
//  TYFitFore
//
//  Created by TanYun on 2018/1/17.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import "OSZRulerViewCell.h"

@interface OSZRulerViewCell ()

@property (nonatomic,strong) UILabel *numberLabel;                    /**< 数字 */
@property (nonatomic,strong) UIView *line;                            /**< 线 */


@end




@implementation OSZRulerViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

    }
    return self;
}

#pragma mark - setter
-(void)setRulerModel:(OSZRulerModel *)rulerModel{
    _rulerModel = rulerModel;
    
    //如果居中,文字变大线消失
    if (rulerModel.isCenter) {
        self.numberLabel.frame = CGRectMake(0, 13, self.v_width, 14);
        self.numberLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        self.numberLabel.textColor = UIColorFromHex(0x00C6B8);
        self.line.frame = CGRectMake(19, 45, 2, 0);
        rulerModel.isCenter = NO;
    //还原
    }else{
        self.numberLabel.frame = CGRectMake(0, 24, self.v_width, 11);
        self.numberLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        self.numberLabel.textColor = UIColorFromHex(0x4A4A4A);
        self.line.frame = CGRectMake(19, 45, 2, 10);
    }
    self.numberLabel.text = rulerModel.value;
    [self.contentView addSubview:self.numberLabel];
    [self.contentView addSubview:self.line];
}

#pragma mark - getter
-(UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]init];
        _numberLabel.textColor = UIColorFromHex(0x4A4A4A);
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    }
    return _numberLabel;
}

-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = UIColorFromHex(0x9B9B9B);
    }
    return _line;
}



@end
