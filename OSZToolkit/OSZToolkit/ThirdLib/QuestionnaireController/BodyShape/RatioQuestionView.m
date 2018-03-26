//
//  RatioQuestionView.m
//  TYFitFore
//
//  Created by TanYun on 2018/1/23.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import "RatioQuestionView.h"
#import "OSZRulerView.h"
#import "OSZRulerModel.h"

@interface RatioQuestionView ()<OSZRulerViewDelegate>

@property (nonatomic,strong) UILabel *littleDetailLabel;                   /**< 注释 */

@property (nonatomic,strong) UILabel *yaoLabel;                         /**< 腰围 */
@property (nonatomic,strong) UILabel *cmLabel1;                         /**< CM */
@property (nonatomic,strong) OSZRulerView *yaoRulerView;                /**< 腰围刻度尺 */

@property (nonatomic,strong) UILabel *tunLabel;                       /**< 臀围 */
@property (nonatomic,strong) UILabel *cmLabel2;                        /**< CM */
@property (nonatomic,strong) OSZRulerView *tunRulerView;                /**< 臀围刻度尺 */

@property (nonatomic,strong) UILabel *ratioLabel;                    /**< 腰臀比 */
@property (nonatomic,strong) UILabel *ratioValueLabel;                 /**< 比例 */
@property (nonatomic,strong) UILabel *detailLabel;                   /**< 腰臀比注释 */

@property (nonatomic,strong) NSString *yaoValue;
@property (nonatomic,strong) NSString *tunValue;
@property (nonatomic,strong) NSString *ratioValue;


@end




@implementation RatioQuestionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self.bjView addSubview:self.littleDetailLabel];
        [self.bjView addSubview:self.yaoLabel];
        [self.bjView addSubview:self.cmLabel1];
        [self.bjView addSubview:self.yaoRulerView];
        [self.bjView addSubview:self.tunLabel];
        [self.bjView addSubview:self.cmLabel2];
        [self.bjView addSubview:self.tunRulerView];
        [self.bjView addSubview:self.ratioLabel];
        [self.bjView addSubview:self.ratioValueLabel];
        [self.bjView addSubview:self.detailLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.littleDetailLabel.frame = CGRectMake(20, self.titleLabel.v_bottom+10, self.v_width-40, 16);
    
    self.yaoLabel.frame = CGRectMake(138, self.titleLabel.v_bottom+48, 28, 14);
    self.cmLabel1.frame = CGRectMake(self.yaoLabel.v_right+5, self.yaoLabel.v_y+4, 17, 10);
    self.yaoRulerView.v_y = self.yaoLabel.v_bottom + 5;

    self.tunLabel.frame = CGRectMake(138, self.yaoRulerView.v_bottom+25, 28, 14);
    self.cmLabel2.frame = CGRectMake(self.tunLabel.v_right+5, self.tunLabel.v_y+4, 17, 10);
    self.tunRulerView.v_y = self.tunLabel.v_bottom + 5;

    self.ratioLabel.frame = CGRectMake(175, self.tunRulerView.v_bottom+61, 45, 14);
    self.ratioValueLabel.frame = CGRectMake(self.ratioLabel.v_right+10, self.ratioLabel.v_y-10, self.width-self.ratioLabel.v_right-10, 24);
    self.detailLabel.frame = CGRectMake(175, self.ratioLabel.v_bottom+9, 120, 12);
}


#pragma mark - getter
-(UILabel *)littleDetailLabel{
    if (!_littleDetailLabel) {
        _littleDetailLabel = [[UILabel alloc]init];
        _littleDetailLabel.textColor = UIColorFromHex(0x9B9B9B);
        _littleDetailLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    }
    return _littleDetailLabel;
}


-(UILabel *)yaoLabel{
    if (!_yaoLabel) {
        _yaoLabel = [[UILabel alloc]init];
        _yaoLabel.textColor = UIColorFromHex(0x9B9B9B);
        _yaoLabel.textAlignment = NSTextAlignmentCenter;
        _yaoLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    }
    return _yaoLabel;
}

-(UILabel *)cmLabel1{
    if (!_cmLabel1) {
        _cmLabel1 = [[UILabel alloc]init];
        _cmLabel1.textColor = UIColorFromHex(0x9B9B9B);
        _cmLabel1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    }
    return _cmLabel1;
}

-(OSZRulerView *)yaoRulerView{
    if (!_yaoRulerView) {
        _yaoRulerView = [[OSZRulerView alloc]initWithFrame:CGRectMake(32.5, 0, 260, 55)];
        _yaoRulerView.delegate = self;
    }
    return _yaoRulerView;
}

-(UILabel *)tunLabel{
    if (!_tunLabel) {
        _tunLabel = [[UILabel alloc]init];
        _tunLabel.textColor = UIColorFromHex(0x9B9B9B);
        _tunLabel.textAlignment = NSTextAlignmentCenter;
        _tunLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    }
    return _tunLabel;
}

-(UILabel *)cmLabel2{
    if (!_cmLabel2) {
        _cmLabel2 = [[UILabel alloc]init];
        _cmLabel2.textColor = UIColorFromHex(0x9B9B9B);
        _cmLabel2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    }
    return _cmLabel2;
}

-(OSZRulerView *)tunRulerView{
    if (!_tunRulerView) {
        _tunRulerView = [[OSZRulerView alloc]initWithFrame:CGRectMake(32.5, 0, 260, 55)];
        _tunRulerView.delegate = self;
    }
    return _tunRulerView;
}

-(UILabel *)ratioLabel{
    if (!_ratioLabel) {
        _ratioLabel = [[UILabel alloc]init];
        _ratioLabel.textColor = UIColorFromHex(0x9B9B9B);
        _ratioLabel.textAlignment = NSTextAlignmentCenter;
        _ratioLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    }
    return _ratioLabel;
}

-(UILabel *)ratioValueLabel{
    if (!_ratioValueLabel) {
        _ratioValueLabel = [[UILabel alloc]init];
        _ratioValueLabel.textColor = UIColorFromHex(0x4A4A4A);
        //_ratioValueLabel.textAlignment = NSTextAlignmentCenter;
        _ratioValueLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:32];
        _ratioValueLabel.text = @"0.0";
    }
    return _ratioValueLabel;
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
    self.numLabel.text = @"03";
    self.titleNumLabel.text = @"OF 03";
    self.titleImageView.image = [UIImage imageNamed:@"word_body_shape"];
//    self.titleLabel.text = questionModel.title;
    self.littleDetailLabel.text = questionModel.tips;
    self.ratioLabel.text = questionModel.rateName;
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
    
    //腰臀数据
    NSMutableArray *dataArrayY = [NSMutableArray array];
    NSMutableArray *dataArrayT = [NSMutableArray array];
    //判断长度
    if (questionModel.options.count != 2) {
        return;
    }
    //更新UI
    OptionModel *yOption = questionModel.options[0];
    self.yaoLabel.text = yOption.descriptions;
    self.cmLabel1.text = yOption.unit;
    //身高范围
    NSString *startYao = yOption.range[0];
    NSString *endYao = yOption.range[1];
    //准备身高数据
    for (NSInteger i = startYao.integerValue ; i <= endYao.integerValue; i++) {
        OSZRulerModel *rulerModel = [[OSZRulerModel alloc]init];
        rulerModel.isCenter = NO;
        rulerModel.unit = @"yao";
        rulerModel.value = [NSString stringWithFormat:@"%ld",(long)i];
        [dataArrayY addObject:rulerModel];
    }
    
    //更新UI
    OptionModel *tOption = questionModel.options[1];
    self.tunLabel.text = tOption.descriptions;
    self.cmLabel2.text = tOption.unit;
    //体重范围
    NSString *startTun = tOption.range[0];
    NSString *endTun = tOption.range[1];
    //准备体重数据
    for (NSInteger i = startTun.integerValue ; i<= endTun.integerValue; i++) {
        OSZRulerModel *rulerModel = [[OSZRulerModel alloc]init];
        rulerModel.isCenter = NO;
        rulerModel.unit = @"tun";
        rulerModel.value = [NSString stringWithFormat:@"%ld",(long)i];
        [dataArrayT addObject:rulerModel];
    }
    
    
    self.yaoRulerView.dataArray = dataArrayY;
    self.tunRulerView.dataArray = dataArrayT;
    
    NSString *defaultYaoStr = @"";
    NSString *defaultTunStr = @"";
    //默认值:男-女
    AccountModel *accountModel = [AccountModel sharedInstance];
    //腰
    if ([yOption.defaultValue containsString:@"-"]) {
        NSRange range = [yOption.defaultValue rangeOfString:@"-"];
        //如果是男
        if (accountModel.personSex == 0) {
            defaultYaoStr = [yOption.defaultValue substringToIndex:range.location];
        } else if (accountModel.personSex == 1){
            defaultYaoStr = [yOption.defaultValue substringFromIndex:range.location + 1];
        }
    }
    //臀
    if ([tOption.defaultValue containsString:@"-"]) {
        NSRange range = [tOption.defaultValue rangeOfString:@"-"];
        //如果是男
        if (accountModel.personSex == 0) {
            defaultTunStr = [tOption.defaultValue substringToIndex:range.location];
        } else if (accountModel.personSex == 1){
            defaultTunStr = [tOption.defaultValue substringFromIndex:range.location + 1];
        }
    }
    //默认滚动
    NSInteger defaultYao = defaultYaoStr.integerValue - startYao.integerValue;
    self.yaoRulerView.rulerView.contentOffset = CGPointMake(defaultYao * 40 , 0);
    //默认滚动
    NSInteger defaultTun = defaultTunStr.integerValue - startTun.integerValue;
    self.tunRulerView.rulerView.contentOffset = CGPointMake(defaultTun * 40 , 0);
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
    //    NSLog(@"%@---%@",rulerModel.unit,rulerModel.value);
    //根据单位分开
    if ([rulerModel.unit isEqualToString:@"yao"]) {
        self.yaoValue = rulerModel.value;
        [self calculateRatio];
    }else if ([rulerModel.unit isEqualToString:@"tun"]){
        self.tunValue = rulerModel.value;
        [self calculateRatio];
    }
    
}

//计算比例
- (void)calculateRatio{
    CGFloat yao = [self.yaoValue floatValue];
    CGFloat tun = [self.tunValue floatValue];
    if ((yao > 0) && (tun > 0)) {
        CGFloat ratio = yao/tun;
        self.ratioValue = [NSString stringWithFormat:@"%.2f",ratio];
        self.ratioValueLabel.text = self.ratioValue;
        
        //传出去
        if (self.delegate &&([self.delegate respondsToSelector:@selector(yaoTunValueChange:)])) {
            NSNumber *yao = @(self.yaoValue.floatValue);
            NSNumber *tun = @(self.tunValue.floatValue);
            NSNumber *ratio = @(self.ratioValue.floatValue);
            
            NSArray *valueArray = @[yao,tun,ratio];
            [self.delegate yaoTunValueChange:valueArray];
        }
        
    }
}

@end












