//
//  SingleChoiceQuestionView.m
//  TYFitFore
//
//  Created by TanYun on 2018/1/29.
//  Copyright © 2018年 tangpeng. All rights reserved.
// 你最大的运动目标？/ 您训练结束后身体一般是

#import "SingleChoiceQuestionView.h"

@interface SingleChoiceQuestionView ()

@property (nonatomic,strong) UIButton *leftButton;                      /**< 左边按钮 */
@property (nonatomic,strong) UIButton *rightButton;                    /**< 右边按钮 */
@property (nonatomic,strong) UIButton *bottomButton;                    /**< 中间按钮 */
@property (nonatomic,strong) UILabel *leftLabel;                    /**< 左边文字 */
@property (nonatomic,strong) UILabel *rightLabel;                    /**< 右边文字 */
@property (nonatomic,weak) UIButton *currentButton;                    /**< 当前感觉按钮 */


@end



@implementation SingleChoiceQuestionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self.bjView addSubview:self.leftButton];
        [self.bjView addSubview:self.leftLabel];
        [self.bjView addSubview:self.rightButton];
        [self.bjView addSubview:self.rightLabel];
        [self.bjView addSubview:self.bottomButton];
        
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.leftButton.frame = CGRectMake(47.5, self.titleLabel.v_bottom+72, 100, 100);
    self.leftLabel.frame = CGRectMake(0, self.leftButton.v_bottom+20, 65, 17);
    self.leftLabel.v_centerX = self.leftButton.v_centerX;
    
    self.rightButton.frame = CGRectMake(self.leftButton.v_right+30, self.leftButton.v_y, 100, 100);
    self.rightLabel.frame = CGRectMake(0, self.rightButton.v_bottom+20, 65, 17);
    self.rightLabel.v_centerX = self.rightButton.v_centerX;
    
    self.bottomButton.frame = CGRectMake(100, self.leftButton.v_bottom+90, 125, 50);
}

#pragma mark - getter
- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIButton alloc]init];
        [_leftButton addTarget:self action:@selector(didClickFeelButton:) forControlEvents:UIControlEventTouchUpInside];
        _leftButton.tag = 3001;
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc]init];
        [_rightButton addTarget:self action:@selector(didClickFeelButton:) forControlEvents:UIControlEventTouchUpInside];
        _rightButton.tag = 3002;
    }
    return _rightButton;
}


- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc]init];
        _leftLabel.textColor = UIColorFromHex(0x4A4A4A);
        _leftLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    }
    return _leftLabel;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc]init];
        _rightLabel.textColor = UIColorFromHex(0x4A4A4A);
        _rightLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    }
    return _rightLabel;
}

- (UIButton *)bottomButton {
    if (!_bottomButton) {
        _bottomButton = [[UIButton alloc]init];
        _bottomButton.layer.cornerRadius = 4;
        _bottomButton.layer.masksToBounds = YES;
        [_bottomButton setBackgroundColor: UIColorFromHex(0xF7F8FA) forState:UIControlStateNormal];
        [_bottomButton setBackgroundColor:UIColorFromHex(0x01C6B8) forState:UIControlStateSelected];
        [_bottomButton setTitleColor:UIColorFromHex(0x4A4A4A) forState:UIControlStateNormal];
        [_bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _bottomButton.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        [_bottomButton addTarget:self action:@selector(didClickFeelButton:) forControlEvents:UIControlEventTouchUpInside];
        _bottomButton.tag = 3003;
    }
    return _bottomButton;
}


#pragma mark - setter
-(void)setQuestionModel:(QuestionModel *)questionModel{
    _questionModel = questionModel;
    //题目
    self.numLabel.text = @"01";
    self.titleLabel.text = questionModel.title;
    //判断长度
    if (questionModel.options.count != 3) {
        return;
    }
    //label文字
    OptionModel *leftOption = questionModel.options[0];
    //暂时先这么写
    if (leftOption.descriptions.length > 0) {
        self.leftLabel.text = leftOption.descriptions;
    }else{
        self.leftLabel.text = @"大汗淋漓";
    }
    
    OptionModel *rightOption = questionModel.options[1];
    if (rightOption.descriptions.length > 0) {
        self.rightLabel.text = rightOption.descriptions;
    }else{
        self.rightLabel.text = @"微微出汗";
    }
    
    OptionModel *bottomOption = questionModel.options[2];
    if (bottomOption.descriptions.length > 0) {
        [self.bottomButton setTitle:bottomOption.descriptions forState:UIControlStateNormal];
    }else{
        [self.bottomButton setTitle:@"没什么感觉" forState:UIControlStateNormal];
    }
    
    //如果是 您训练结束后身体一般是？
    if (self.controllerType == statusType) {
        self.titleNumLabel.text = @"OF 04";
        self.titleImageView.image = [UIImage imageNamed:@"word_injury_status"];
        //根据性别换图片
        AccountModel *accountModel = [AccountModel sharedInstance];
        //如果是男
        if (accountModel.personSex == 0) {
            [self.leftButton setImage:[UIImage imageNamed:@"btn_boy_tired"] forState:UIControlStateNormal];
            [self.leftButton setImage:[UIImage imageNamed:@"btn_boy_tired_press"] forState:UIControlStateSelected];
            
            [self.rightButton setImage:[UIImage imageNamed:@"btn_boy_easy"] forState:UIControlStateNormal];
            [self.rightButton setImage:[UIImage imageNamed:@"btn_boy_easy_press"] forState:UIControlStateSelected];
        }
        //如果是女
        else if(accountModel.personSex == 1){
            [self.leftButton setImage:[UIImage imageNamed:@"btn_girl_tired"] forState:UIControlStateNormal];
            [self.leftButton setImage:[UIImage imageNamed:@"btn_girl_tired_press"] forState:UIControlStateSelected];
            
            [self.rightButton setImage:[UIImage imageNamed:@"btn_girl_easy"] forState:UIControlStateNormal];
            [self.rightButton setImage:[UIImage imageNamed:@"btn_girl_easy_press"] forState:UIControlStateSelected];
        }
        
    }
    //如果是 你最大的运动目标？
    else if (self.controllerType == targetType){
        self.titleNumLabel.text = @"OF 03";
        self.titleImageView.image = [UIImage imageNamed:@"word_body_composition"];
        
        [self.leftButton setImage:[UIImage imageNamed:@"btn_aerobic"] forState:UIControlStateNormal];
        [self.leftButton setImage:[UIImage imageNamed:@"btn_aerobic_press"] forState:UIControlStateSelected];
        
        [self.rightButton setImage:[UIImage imageNamed:@"btn_fitness"] forState:UIControlStateNormal];
        [self.rightButton setImage:[UIImage imageNamed:@"btn_fitness_press"] forState:UIControlStateSelected];
    }
    
}


#pragma mark - other
//点击按钮
- (void)didClickFeelButton:(UIButton *)button {
    if (button != self.currentButton) {
        self.currentButton.selected = NO;
        button.selected = YES;
        self.currentButton = button;
    }else{
        self.currentButton.selected = YES;
    }
    
    NSArray *valueArray = [NSArray array];
    //传出去
    if (self.currentButton.tag == 3001) {
        valueArray = @[@1];
    }else if (self.currentButton.tag == 3002){
        valueArray = @[@2];
    }else if (self.currentButton.tag == 3003){
        valueArray = @[@3];
    }
    //传出去
    if (self.delegate &&([self.delegate respondsToSelector:@selector(singleButtonValueChange:withView:)])) {
        [self.delegate singleButtonValueChange:valueArray withView:self];
    }
}



@end









