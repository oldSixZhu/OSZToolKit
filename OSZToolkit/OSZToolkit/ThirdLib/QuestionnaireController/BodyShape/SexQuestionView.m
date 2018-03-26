//
//  SexQuestionView.m
//  TYFitFore
//
//  Created by TanYun on 2018/1/14.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import "SexQuestionView.h"

@interface SexQuestionView ()

@property (nonatomic,strong) UILabel *detailLabel;                     /**< 注: */
@property (nonatomic,strong) UILabel *manLabel;                     /**< 男生 */
@property (nonatomic,strong) UILabel *womanLabel;                     /**< 女生 */
@property (nonatomic,strong) UILabel *warnLabel;                    /**< 如实填写 */



@end



@implementation SexQuestionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self.bjView addSubview:self.detailLabel];
        [self.bjView addSubview:self.manButton];
        [self.bjView addSubview:self.womanButton];
        [self.bjView addSubview:self.manLabel];
        [self.bjView addSubview:self.womanLabel];
        [self.bjView addSubview:self.warnLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.detailLabel.frame = CGRectMake(20, self.titleLabel.v_bottom+10, self.v_width-40, 16);
    self.manButton.frame = CGRectMake(47, 226, 100, 100);
    self.womanButton.frame = CGRectMake(self.manButton.v_right+30, 226, 100, 100);
    self.manLabel.frame = CGRectMake(0, self.manButton.v_bottom+20, 32, 17);
    self.manLabel.v_centerX = self.manButton.v_centerX;
    self.womanLabel.frame = CGRectMake(0, self.womanButton.v_bottom+20, 32, 17);
    self.womanLabel.v_centerX = self.womanButton.v_centerX;
    self.warnLabel.frame = CGRectMake(0, self.v_height-14-15, self.v_width, 14);
}


#pragma mark - getter
//注:
-(UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.textColor = UIColorFromHex(0x9B9B9B);
        _detailLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _detailLabel.text = ZYSString(@"sport_questionnaire_sexDetail");
    }
    return _detailLabel;
}


-(UIButton *)manButton{
    if (!_manButton) {
        _manButton = [[UIButton alloc]init];
        [_manButton setImage:[UIImage imageNamed:@"btn_boy"] forState:UIControlStateNormal];
        [_manButton setImage:[UIImage imageNamed:@"btn_boy_press"] forState:UIControlStateSelected];
    }
    return _manButton;
}

-(UIButton *)womanButton{
    if (!_womanButton) {
        _womanButton = [[UIButton alloc]init];
        [_womanButton setImage:[UIImage imageNamed:@"btn_girl"] forState:UIControlStateNormal];
        [_womanButton setImage:[UIImage imageNamed:@"btn_girl_press"] forState:UIControlStateSelected];
    }
    return _womanButton;
}

-(UILabel *)manLabel{
    if (!_manLabel) {
        _manLabel = [[UILabel alloc]init];
        _manLabel.textColor = UIColorFromHex(0x4A4A4A);
        _manLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    }
    return _manLabel;
}


-(UILabel *)womanLabel{
    if (!_womanLabel) {
        _womanLabel = [[UILabel alloc]init];
        _womanLabel.textColor = UIColorFromHex(0x4A4A4A);
        _womanLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    }
    return _womanLabel;
}

-(UILabel *)warnLabel{
    if (!_warnLabel) {
        _warnLabel = [[UILabel alloc]init];
        _warnLabel.textAlignment = NSTextAlignmentCenter;
        _warnLabel.text = ZYSString(@"sport_questionnaire_warn");
        _warnLabel.textColor = [UIColorFromHex(0x868D9A) colorWithAlphaComponent:0.8];
        _warnLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    }
    return _warnLabel;
}


#pragma mark - setter
-(void)setQuestionModel:(QuestionModel *)questionModel{
    _questionModel = questionModel;
    //配置数据
    self.numLabel.text = @"01";
    self.titleNumLabel.text = @"OF 02";
    self.titleImageView.image = [UIImage imageNamed:@"word_body_shape"];
    self.titleLabel.text = questionModel.title;
    if (questionModel.options.count != 2) {
        return;
    }
    //男
    OptionModel *manOption = questionModel.options[0];
    self.manLabel.text = manOption.descriptions;
    //女
    OptionModel *womanOption = questionModel.options[1];
    self.womanLabel.text = womanOption.descriptions;
    

}



@end










