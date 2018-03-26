//
//  BodyFatQuestionView.m
//  TYFitFore
//
//  Created by TanYun on 2018/1/14.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import "BodyFatQuestionView.h"
#import "OSZRulerView.h"
#import "OSZRulerModel.h"

@interface BodyFatQuestionView ()<OSZRulerViewDelegate>

@property (nonatomic,strong) UILabel *detailLabel;                    /**< 注释 */
@property (nonatomic,strong) UILabel *unitLabel;                     /**< 单位 */
@property (nonatomic,strong) UILabel *unitLabel2;                    /**< % */
@property (nonatomic,strong) OSZRulerView *rulerView;                /**< 刻度尺 */


@end



@implementation BodyFatQuestionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    
        [self.bjView addSubview:self.detailLabel];
        [self.bjView addSubview:self.unitLabel];
        [self.bjView addSubview:self.unitLabel2];
        [self.bjView addSubview:self.rulerView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.detailLabel.frame = CGRectMake(20, self.titleLabel.v_bottom+10, self.v_width-40, 16);
    self.unitLabel.frame = CGRectMake((self.v_width-45)*0.5, self.detailLabel.v_bottom+101, 45, 16);
    self.unitLabel2.frame = CGRectMake(self.unitLabel.v_right+5, self.unitLabel.v_y+6, 10, 10);
    self.rulerView.v_y = self.unitLabel.v_bottom+5;
}

#pragma mark - getter
-(UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.textColor = UIColorFromHex(0x9B9B9B);
        _detailLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    }
    return _detailLabel;
}

-(UILabel *)unitLabel{
    if (!_unitLabel) {
        _unitLabel = [[UILabel alloc]init];
        _unitLabel.textColor = UIColorFromHex(0x9B9B9B);
        _unitLabel.textAlignment = NSTextAlignmentCenter;
        _unitLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    }
    return _unitLabel;
}

-(UILabel *)unitLabel2{
    if (!_unitLabel2) {
        _unitLabel2 = [[UILabel alloc]init];
        _unitLabel2.textColor = UIColorFromHex(0x9B9B9B);
        _unitLabel2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    }
    return _unitLabel2;
}

- (OSZRulerView *)rulerView {
    if (!_rulerView) {
        _rulerView = [[OSZRulerView alloc]initWithFrame:CGRectMake(32.5, 0, 260, 55)];
        _rulerView.delegate = self;
    }
    return _rulerView;
}


#pragma mark - setter
-(void)setQuestionModel:(QuestionModel *)questionModel{
    _questionModel = questionModel;
    //配置数据
    self.numLabel.text = @"02";
    self.titleNumLabel.text = @"OF 03";
    self.titleImageView.image = [UIImage imageNamed:@"word_body_shape"];
//    self.titleLabel.text = questionModel.title;
    self.detailLabel.text = questionModel.tips;
    //如果有(可多选) 要判断中英文,防止崩溃
    if ([questionModel.title containsString:@"（"] && [questionModel.title containsString:@"）"]) {
        //设置()内文字大小
        NSRange range = [self indexOfFirstString:questionModel.title withFirst:@"（" andEnd:@"）"];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:questionModel.title];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Semibold" size:16] range:range];
        self.titleLabel.attributedText= str;
    }else if([questionModel.title containsString:@"("] && [questionModel.title containsString:@")"]) {
        //设置()内文字大小
        NSRange range = [self indexOfFirstString:questionModel.title withFirst:@"(" andEnd:@")"];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:questionModel.title];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Semibold" size:16] range:range];
        self.titleLabel.attributedText= str;
    }
    
    //准备体脂率数据
    NSMutableArray *dataArray = [NSMutableArray array];
    //判断长度
    if (questionModel.options.count == 0) {
        return;
    }
    //更新UI
    OptionModel *fatOption = questionModel.options[0];
    self.unitLabel.text = fatOption.descriptions;
    self.unitLabel2.text = fatOption.unit;
    //身高范围
    NSString *startFat = fatOption.range[0];
    NSString *endFat = fatOption.range[1];
    //准备数据
    CGFloat unit = startFat.floatValue;
    for (NSInteger i = startFat.integerValue ; i <= ((endFat.integerValue - 9) * 10); i++) {
        OSZRulerModel *rulerModel = [[OSZRulerModel alloc]init];
        rulerModel.isCenter = NO;
        rulerModel.value = [NSString stringWithFormat:@"%.1f",unit];
        [dataArray addObject:rulerModel];
        unit += 0.1;
    }
    
    self.rulerView.dataArray = dataArray;
    
    NSString *defaultFatStr = @"";
    //默认值:男-女
    AccountModel *accountModel = [AccountModel sharedInstance];
    if ([fatOption.defaultValue containsString:@"-"]) {
        NSRange range = [fatOption.defaultValue rangeOfString:@"-"];
        //如果是男
        if (accountModel.personSex == 0) {
            defaultFatStr = [fatOption.defaultValue substringToIndex:range.location];
        } else if (accountModel.personSex == 1){
            defaultFatStr = [fatOption.defaultValue substringFromIndex:range.location + 1];
        }
    }
    
    //默认滚动
    NSInteger defaultHeight = defaultFatStr.integerValue - startFat.integerValue;
    self.rulerView.rulerView.contentOffset = CGPointMake(defaultHeight * 40 * 10, 0);
}

//截取()中的字符
- (NSRange)indexOfFirstString:(NSString *)string withFirst:(NSString *)first andEnd:(NSString *)end {
    NSInteger loc = 0;
    NSInteger len = 0;
    //你的体脂率是？(选填)
    NSArray<NSString *> *leftStringArray = [string componentsSeparatedByString:first];
    loc = leftStringArray.firstObject.length;
    
    NSArray<NSString *> *rightStringArray = [string componentsSeparatedByString:end];
    len = rightStringArray.firstObject.length - leftStringArray.firstObject.length + 1;
    
    return NSMakeRange(loc, len);
}


#pragma mark - OSZRulerViewDelegate
-(void)valueChange:(OSZRulerModel *)rulerModel{
    //NSLog(@"%@",value);
    if (self.delegate &&([self.delegate respondsToSelector:@selector(bodyFatValueChange:)])) {
        NSNumber *fat = @(rulerModel.value.floatValue);
        NSArray *valueArray = @[fat];
        [self.delegate bodyFatValueChange:valueArray];
    }
}


@end



















