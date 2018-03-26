//
//  MoreChoiceQuestionView.m
//  TYFitFore
//
//  Created by TanYun on 2018/1/30.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import "MoreChoiceQuestionView.h"

@interface MoreChoiceQuestionView ()

@property (nonatomic,strong) UIView *buttonView;                        /**< 按钮布局视图 */
@property (nonatomic,strong) NSMutableDictionary *selectedDic;           /**< 选择的按钮 */
@property (nonatomic,assign) BOOL flag;                                  /**< 懒加载创建按钮 */
@property (nonatomic,strong) NSString *lastButtonTitle;                 /**< 最后一个按钮题目 */


@end




@implementation MoreChoiceQuestionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self.bjView addSubview:self.buttonView];
        //初始化
        self.selectedDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //如果有()
    if (([self.questionModel.title containsString:@"("]) || ([self.questionModel.title containsString:@"（"])) {
        //一般文字很长,需要变布局
        self.titleLabel.v_height = 60;
    }

    self.buttonView.frame = CGRectMake(0, self.titleLabel.v_bottom+25, self.v_width, self.v_height-self.titleLabel.v_bottom-25);
    
    if (self.questionModel.options.count == 0) {
        return;
    }
    
    //保存最后一个按钮的文字
    OptionModel *lastModel = self.questionModel.options.lastObject;
    if (lastModel.content.length > 0) {
        self.lastButtonTitle = lastModel.content;
    }else if (lastModel.descriptions.length > 0){
        self.lastButtonTitle = lastModel.descriptions;
    }
    
    //如果没加载过
    if (self.flag == NO) {
        //布局使用
        CGFloat buttonX = 5; //button起始X坐标
        CGFloat buttonY = self.buttonY; //button起始Y坐标
        CGFloat padding = 5.0; //button 间距
        CGFloat buttonHeight = 40; //button高度
        CGFloat allWidth = self.v_width;
        
        //根据选择答案数组创建按钮
        UIFont *titleFont = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        for (int i = 0; i < self.questionModel.options.count; i++) {
            OptionModel *optionModel = self.questionModel.options[i];
            NSString *buttonStr = [NSString string];
            //先这么写,根据选择答案
            if (optionModel.content.length > 0) {
                buttonStr = optionModel.content;
            }else if (optionModel.descriptions.length > 0){
                buttonStr = optionModel.descriptions;
            }
            //根据文字算出size
            CGRect rect = [buttonStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : titleFont} context:nil];
            CGFloat buttonWeight = rect.size.width + 20;
            //如果有最小宽度
            if (self.buttonMinWidth > buttonWeight) {
                buttonWeight = self.buttonMinWidth;
            }
            //换行算法
            if (buttonX + buttonWeight > allWidth) {
                buttonX = 5;//X重新开始
                buttonY += (buttonHeight + padding*2);//换行后Y+
            }
            //创建按钮
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(buttonX, buttonY, buttonWeight, buttonHeight);
            button.layer.cornerRadius = 4;
            button.layer.masksToBounds = YES;
            [button setBackgroundColor: UIColorFromHex(0xF7F8FA) forState:UIControlStateNormal];
            [button setBackgroundColor:UIColorFromHex(0x01C6B8) forState:UIControlStateSelected];
            [button setTitleColor:UIColorFromHex(0x4A4A4A) forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            button.titleLabel.font =  titleFont;
            button.tag = 3000 + optionModel.optionId;//保存选择答案id
            [button setTitle:buttonStr forState:UIControlStateNormal];
            [button addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
            buttonX += (buttonWeight + padding);//每次X都加上button宽和间距5
            [self.buttonView addSubview:button];
        }
        
        //重新布局,居中对齐
        //加入一个虚拟的按钮,为了判断y值不同就布局数组中按钮,布局使用
        UIButton *factitiousButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 1000, 0, 0)];
        [self.buttonView addSubview:factitiousButton];
        
        //设立y值初始为第一个按钮的y值
        UIButton *firstButton = self.buttonView.subviews.firstObject;
        CGFloat tempY = firstButton.v_y;
        //保存相同y值的按钮
        NSMutableArray *tempArray = [NSMutableArray array];
        for (UIButton *subButton in self.buttonView.subviews) {
            //如果y值与保存的y值相同,就存入数组
            if (subButton.v_y == tempY) {
                [tempArray addObject:subButton];
            } else {
                //如果y值不同了,就布局数组中的按钮
                UIButton *firstTempButton = tempArray.firstObject;
                UIButton *lastTempButton = tempArray.lastObject;
                firstTempButton.v_x = (self.v_width - 5 - lastTempButton.v_right) * 0.5;
                
                for (int i = 0; i < tempArray.count - 1; i++) {
                    //后面按钮的x值依次为前面的right+padding
                    UIButton *currentTempButton = tempArray[i];
                    UIButton *nextTempButton = tempArray[i+1];
                    nextTempButton.v_x = currentTempButton.v_right + padding;
                }
                
                //然后更新tempY值,清空tempArray,加入当前按钮
                tempY = subButton.v_y;
                [tempArray removeAllObjects];
                [tempArray addObject:subButton];
            }
        }
        
        
        //创建一次后,标记已经创建过了
        self.flag = YES;
    }
}

#pragma mark - setter
- (void)setQuestionModel:(QuestionModel *)questionModel {
    _questionModel = questionModel;
    self.numLabel.text = [NSString stringWithFormat:@"0%ld",questionModel.questionId];
//    self.titleLabel.text = questionModel.title;
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
    
    //如果是身体状态模块的
    if (self.controllerType == statusType) {
        self.titleNumLabel.text = @"OF 04";
        self.titleImageView.image = [UIImage imageNamed:@"word_injury_status"];
    }
    //如果是目标模块的
    else if(self.controllerType == targetType){
        self.titleNumLabel.text = @"OF 03";
        self.titleImageView.image = [UIImage imageNamed:@"word_body_composition"];
    }
    
    //标记重新创建
    self.flag = NO;
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



//选择按钮
- (void)selectType:(UIButton *)button {
    //按钮状态取反
    button.selected = !button.selected;
    NSNumber *answerID = [NSNumber numberWithInteger:button.tag - 3000];
    //如果按钮选择了,替换或增加
    if (button.selected) {
        [self.selectedDic setObject:answerID forKey:button.titleLabel.text];
    //如果按钮没有选择
    } else {
        //判断看是否保存了,保存过了就删除
        NSNumber *numberID = [self.selectedDic objectForKey:button.titleLabel.text];
        if (numberID) {
            [self.selectedDic removeObjectForKey:button.titleLabel.text];
        }
    }

    //如果点击了最后一个按钮"都不喜欢",就只保存最后一个,清除所有其他的选择
    if ([self.lastButtonTitle isEqualToString:button.titleLabel.text]) {
        //UI清除
        //当前cell为选中状态,其他cell取消选中
        for (UIButton *subButton in self.buttonView.subviews){
            subButton.selected = NO;
            if ([self.lastButtonTitle isEqualToString:subButton.titleLabel.text]) {
                subButton.selected = YES;
            }
        }
        //答案清除
        [self.selectedDic removeAllObjects];
        [self.selectedDic setObject:answerID forKey:button.titleLabel.text];
        
        //-----------如果是选择日期控制器---------------------
        if (self.isWeekController) {
            //最后一个按钮取消点击
            button.selected = NO;
            //答案清除,放1,3,5
            [self.selectedDic removeAllObjects];
            //遍历所有按钮
            for (NSInteger i = 0; i < self.buttonView.subviews.count; i++) {
                //默认选择135
                UIButton *subButton = self.buttonView.subviews[i];
                if ((i == 0) || (i == 2) || (i == 4)) {
                    subButton.selected = YES;
                    NSNumber *answerID = [NSNumber numberWithInteger:subButton.tag - 3000];
                    [self.selectedDic setObject:answerID forKey:subButton.titleLabel.text];
                }
            }
        }
        //-------------------------------------------------
        
    //点击其他的按钮,就要清除最后一个按钮
    } else {
        //UI清除
        for (UIButton *subButton in self.buttonView.subviews){
            if ([self.lastButtonTitle isEqualToString:subButton.titleLabel.text]) {
                subButton.selected = NO;
                //答案清除
                //判断看是否保存了,保存过了就删除
                NSNumber *lastID = [self.selectedDic objectForKey:self.lastButtonTitle];
                if (lastID) {
                    [self.selectedDic removeObjectForKey:self.lastButtonTitle];
                }
            }
        }
    }
    
    
    //把字典中所有答案塞到数组中
    NSMutableArray *valueArray = [NSMutableArray array];
    [self.selectedDic enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, NSString *_Nonnull obj, BOOL * _Nonnull stop) {
        [valueArray addObject:obj];
    }];
    //全塞完之后传出去
    if (self.delegate &&([self.delegate respondsToSelector:@selector(selectedTypes:withView:)])) {
        [self.delegate selectedTypes:valueArray withView:self];
    }
}

#pragma mark - getter
- (UIView *)buttonView {
    if (!_buttonView) {
        _buttonView = [[UIView alloc]init];
        _buttonView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.0f];
    }
    return _buttonView;
}

@end
