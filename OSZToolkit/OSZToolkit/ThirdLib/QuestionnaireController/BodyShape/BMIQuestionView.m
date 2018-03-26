//
//  BMIQuestionView.m
//  TYFitFore
//
//  Created by TanYun on 2018/1/14.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import "BMIQuestionView.h"
#import "OSZRulerView.h"
#import "OSZRulerModel.h"


@interface BMIQuestionView ()<OSZRulerViewDelegate>

@property (nonatomic,strong) UILabel *heightLabel;                    /**< 身高 */
@property (nonatomic,strong) UILabel *cmLabel;                         /**< CM */
@property (nonatomic,strong) OSZRulerView *hRulerView;                /**< 身高刻度尺 */

@property (nonatomic,strong) UILabel *weightLabel;                     /**< 体重 */
@property (nonatomic,strong) UILabel *kgLabel;                        /**< KG */
@property (nonatomic,strong) OSZRulerView *wRulerView;                /**< 体重刻度尺 */

@property (nonatomic,strong) UILabel *BMILabel;                       /**< BMI */
@property (nonatomic,strong) UILabel *BMIValueLabel;                  /**< BMI值 */
@property (nonatomic,strong) UILabel *detailLabel;                    /**< BMI注释 */

@property (nonatomic,strong) NSString *heightValue;                    /**< 身高 */
@property (nonatomic,strong) NSString *weightValue;                    /**< 体重 */
@property (nonatomic,strong) NSString *BMIValue;                      /**< BMI */

@end




@implementation BMIQuestionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self.bjView addSubview:self.heightLabel];
        [self.bjView addSubview:self.cmLabel];
        [self.bjView addSubview:self.hRulerView];
        [self.bjView addSubview:self.weightLabel];
        [self.bjView addSubview:self.kgLabel];
        [self.bjView addSubview:self.wRulerView];
        [self.bjView addSubview:self.BMILabel];
        [self.bjView addSubview:self.BMIValueLabel];
        [self.bjView addSubview:self.detailLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.heightLabel.frame = CGRectMake(138, self.titleLabel.v_bottom+48, 28, 14);
    self.cmLabel.frame = CGRectMake(self.heightLabel.v_right+5, self.heightLabel.v_y+4, 17, 10);
    self.hRulerView.v_y = self.heightLabel.v_bottom + 5;
    
    self.weightLabel.frame = CGRectMake(138, self.hRulerView.v_bottom+25, 28, 14);
    self.kgLabel.frame = CGRectMake(self.weightLabel.v_right+5, self.weightLabel.v_y+4, 17, 10);
    self.wRulerView.v_y = self.weightLabel.v_bottom + 5;
    
    self.BMILabel.frame = CGRectMake(194, self.wRulerView.v_bottom+61, 26, 14);
    self.BMIValueLabel.frame = CGRectMake(self.BMILabel.v_right+10, self.BMILabel.v_y-10, self.width-self.BMILabel.v_right-10, 24);
    self.detailLabel.frame = CGRectMake(self.width-120-10, self.BMILabel.v_bottom+9, 120, 12);
}


#pragma mark - getter
-(UILabel *)heightLabel{
    if (!_heightLabel) {
        _heightLabel = [[UILabel alloc]init];
        _heightLabel.textColor = UIColorFromHex(0x9B9B9B);
        _heightLabel.textAlignment = NSTextAlignmentCenter;
        _heightLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    }
    return _heightLabel;
}

-(UILabel *)cmLabel{
    if (!_cmLabel) {
        _cmLabel = [[UILabel alloc]init];
        _cmLabel.textColor = UIColorFromHex(0x9B9B9B);
        _cmLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    }
    return _cmLabel;
}

-(OSZRulerView *)hRulerView{
    if (!_hRulerView) {
        _hRulerView = [[OSZRulerView alloc]initWithFrame:CGRectMake(32.5, 0, 260, 55)];
        _hRulerView.delegate = self;
    }
    return _hRulerView;
}

-(UILabel *)weightLabel{
    if (!_weightLabel) {
        _weightLabel = [[UILabel alloc]init];
        _weightLabel.textColor = UIColorFromHex(0x9B9B9B);
        _weightLabel.textAlignment = NSTextAlignmentCenter;
        _weightLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    }
    return _weightLabel;
}

-(UILabel *)kgLabel{
    if (!_kgLabel) {
        _kgLabel = [[UILabel alloc]init];
        _kgLabel.textColor = UIColorFromHex(0x9B9B9B);
        _kgLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    }
    return _kgLabel;
}

-(OSZRulerView *)wRulerView{
    if (!_wRulerView) {
        _wRulerView = [[OSZRulerView alloc]initWithFrame:CGRectMake(32.5, 0, 260, 55)];
        _wRulerView.delegate = self;
    }
    return _wRulerView;
}

-(UILabel *)BMILabel{
    if (!_BMILabel) {
        _BMILabel = [[UILabel alloc]init];
        _BMILabel.textColor = UIColorFromHex(0x9B9B9B);
        _BMILabel.textAlignment = NSTextAlignmentCenter;
        _BMILabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    }
    return _BMILabel;
}

-(UILabel *)BMIValueLabel{
    if (!_BMIValueLabel) {
        _BMIValueLabel = [[UILabel alloc]init];
        _BMIValueLabel.textColor = UIColorFromHex(0x4A4A4A);
        //_BMIValueLabel.textAlignment = NSTextAlignmentCenter;
        _BMIValueLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:32];
        _BMIValueLabel.text = @"0.0";
    }
    return _BMIValueLabel;
}

-(UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.textColor = UIColorFromHex(0x9B9B9B);
        _detailLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        _detailLabel.text = ZYSString(@"sport_questionnaire_BMI_detail");
    }
    return _detailLabel;
}

#pragma mark - setter
-(void)setQuestionModel:(QuestionModel *)questionModel{
    _questionModel = questionModel;
    //配置数据
    self.numLabel.text = @"01";
    self.titleNumLabel.text = @"OF 03";
    self.titleImageView.image = [UIImage imageNamed:@"word_body_shape"];
    self.titleLabel.text = questionModel.title;
    self.BMILabel.text = questionModel.rateName;
    //身高体重
    NSMutableArray *dataArrayH = [NSMutableArray array];
    NSMutableArray *dataArrayW = [NSMutableArray array];
    //判断长度
    if (questionModel.options.count != 2) {
        return;
    }
    //更新UI
    OptionModel *hOption = questionModel.options[0];
    self.heightLabel.text = hOption.descriptions;
    self.cmLabel.text = hOption.unit;
    //身高范围
    NSString *startHeight = hOption.range[0];
    NSString *endHeight = hOption.range[1];
    //准备身高数据
    for (NSInteger i = startHeight.integerValue ; i <= endHeight.integerValue; i++) {
        OSZRulerModel *rulerModel = [[OSZRulerModel alloc]init];
        rulerModel.isCenter = NO;
        rulerModel.unit = @"cm";
        rulerModel.value = [NSString stringWithFormat:@"%ld",(long)i];
        [dataArrayH addObject:rulerModel];
    }
    
    //更新UI
    OptionModel *wOption = questionModel.options[1];
    self.weightLabel.text = wOption.descriptions;
    self.kgLabel.text = wOption.unit;
    //体重范围
    NSString *startWeight = wOption.range[0];
    NSString *endWeight = wOption.range[1];
    //准备体重数据
    for (NSInteger i = startWeight.integerValue ; i<= endWeight.integerValue; i++) {
        OSZRulerModel *rulerModel = [[OSZRulerModel alloc]init];
        rulerModel.isCenter = NO;
        rulerModel.unit = @"kg";
        rulerModel.value = [NSString stringWithFormat:@"%ld",(long)i];
        [dataArrayW addObject:rulerModel];
    }
    
    self.hRulerView.dataArray = dataArrayH;
    self.wRulerView.dataArray = dataArrayW;
    
    NSString *defaultHeightStr = @"";
    NSString *defaultWeightStr = @"";
    //默认值:男-女
    AccountModel *accountModel = [AccountModel sharedInstance];
    //身高
    if ([hOption.defaultValue containsString:@"-"]) {
        NSRange range = [hOption.defaultValue rangeOfString:@"-"];
        //如果是男
        if (accountModel.personSex == 0) {
            defaultHeightStr = [hOption.defaultValue substringToIndex:range.location];
        } else if (accountModel.personSex == 1){
            defaultHeightStr = [hOption.defaultValue substringFromIndex:range.location + 1];
        }
    }
    //体重
    if ([wOption.defaultValue containsString:@"-"]) {
        NSRange range = [wOption.defaultValue rangeOfString:@"-"];
        //如果是男
        if (accountModel.personSex == 0) {
            defaultWeightStr = [wOption.defaultValue substringToIndex:range.location];
        } else if (accountModel.personSex == 1){
            defaultWeightStr = [wOption.defaultValue substringFromIndex:range.location + 1];
        }
    }
    
    //默认滚动
    NSInteger defaultHeight = defaultHeightStr.integerValue - startHeight.integerValue;
    self.hRulerView.rulerView.contentOffset = CGPointMake(defaultHeight * 40 , 0);
    //默认滚动
    NSInteger defaultWeight = defaultWeightStr.integerValue - startWeight.integerValue;
    self.wRulerView.rulerView.contentOffset = CGPointMake(defaultWeight * 40 , 0);
}


#pragma mark - OSZRulerViewDelegate
-(void)valueChange:(OSZRulerModel *)rulerModel{
//    NSLog(@"%@---%@",rulerModel.unit,rulerModel.value);
    //根据单位分开
    if ([rulerModel.unit isEqualToString:@"cm"]) {
        //计算BMI
        self.heightValue = rulerModel.value;
        [self calculateBMI];
    }else if ([rulerModel.unit isEqualToString:@"kg"]){
        self.weightValue = rulerModel.value;
        [self calculateBMI];
    }
    
}

//计算BMI
- (void)calculateBMI{
    CGFloat height = [self.heightValue floatValue] * 0.01;
    CGFloat weight = [self.weightValue floatValue];
    if ((height > 0) && (weight > 0)) {
        CGFloat BMI = weight/(height*height);
        self.BMIValue = [NSString stringWithFormat:@"%.2f",BMI];
        self.BMIValueLabel.text = self.BMIValue;
        
        //传出去
        if (self.delegate &&([self.delegate respondsToSelector:@selector(BMIValueChange:)])) {
            NSNumber *height = @(self.heightValue.floatValue);
            NSNumber *weight = @(self.weightValue.floatValue);
            NSNumber *BMI = @(self.BMIValue.floatValue);
            
            NSArray *valueArray = @[height,weight,BMI];
            [self.delegate BMIValueChange:valueArray];
        }
    }
}

@end

















