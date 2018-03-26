//
//  BaseQuestionView.m
//  TYFitFore
//
//  Created by TanYun on 2018/1/14.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import "BaseQuestionView.h"


@interface BaseQuestionView ()

@property (nonatomic,strong) UIView *line;                       /**< 线条 */


@end


@implementation BaseQuestionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        //设置阴影
        self.layer.shadowColor = UIColorFromHex(0x294473).CGColor;//shadowColor阴影颜色
        //shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        self.layer.shadowOffset = CGSizeMake(0,8);
        self.layer.shadowRadius = 8;//阴影半径，默认3
        self.layer.shadowOpacity = 0.7;//阴影透明度，默认0
        self.layer.cornerRadius = 8;
        self.clipsToBounds = NO;//视图上的子视图,如果超出父视图的部分就截取掉
        
        [self addSubview:self.bjView];
        [self.bjView addSubview:self.numLabel];
        [self.bjView addSubview:self.line];
        [self.bjView addSubview:self.titleNumLabel];
        [self.bjView addSubview:self.titleImageView];
        [self.bjView addSubview:self.titleLabel];
        
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bjView.frame = self.bounds;
    self.numLabel.frame = CGRectMake(20, 45, 40, 32);
    self.line.frame = CGRectMake(26, self.numLabel.v_bottom+7, 28, 4.5);
    self.titleNumLabel.frame = CGRectMake(self.numLabel.v_right+10, 57, 53, 18);
    self.titleImageView.frame = CGRectMake(self.v_width-207, 0, 207, 172);
    self.titleLabel.frame = CGRectMake(20, 120, self.v_width-20, 22);
}


#pragma mark - getter
//圆角背景
-(UIView *)bjView{
    if (!_bjView) {
        _bjView = [[UIView alloc]init];
        _bjView.backgroundColor = [UIColor whiteColor];
        _bjView.layer.cornerRadius = 8;
        _bjView.layer.masksToBounds = YES;
    }
    return _bjView;
}

//当前页
-(UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc]init];
        _numLabel.textColor = UIColorFromHex(0x4A4A4A);
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.text = @"01";
        _numLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:32];
    }
    return _numLabel;
}

//线
-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = UIColorFromHex(0x00C6B8);
        _line.layer.cornerRadius = 2;
        _line.layer.masksToBounds= YES;
    }
    return _line;
}
//总页数
-(UILabel *)titleNumLabel{
    if (!_titleNumLabel) {
        _titleNumLabel = [[UILabel alloc]init];
        _titleNumLabel.textColor = UIColorFromRGB_A(0x4A4A4A, 0.6);
        _titleNumLabel.text = @"OF 04";
        _titleNumLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
    }
    return _titleNumLabel;
}
//图片
-(UIImageView *)titleImageView{
    if (!_titleImageView) {
        _titleImageView = [[UIImageView alloc]init];
    }
    return _titleImageView;
}
///题目
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = UIColorFromHex(0x4A4A4A);
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:20];
    }
    return _titleLabel;
}

@end


