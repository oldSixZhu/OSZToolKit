//
//  SportQuestionListView.m
//  TYFitFore
//
//  Created by TanYun on 2018/1/25.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import "SportQuestionListView.h"
#import "QuestionListCell.h"
#import "QuestionListModel.h"


@interface SportQuestionListView ()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;                    /**< 题目数组 */
@property (nonatomic,strong) NSMutableDictionary *selectedDic;           /**< 选择的按钮 */
@property (nonatomic,strong) NSString *lastButtonTitle;                 /**< 最后一个按钮题目 */



@end




@implementation SportQuestionListView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
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
    
    self.tableView.frame = CGRectMake(0, self.titleLabel.v_bottom+15, self.v_width, self.v_height-self.titleLabel.v_bottom-15);
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//组
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

//cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuestionListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionListCell"];
    if (!cell) {
        cell = [[QuestionListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QuestionListCell"];
    }
    cell.listModel = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

//点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    QuestionListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
     QuestionListModel *listModel = self.dataArray[indexPath.row];
    //如果是单选
    if (self.controllerType == singleType) {
        //替换当前的答案
        [self.selectedDic setObject:listModel.questionID forKey:@"singleAnswer"];
        //当前cell为选中状态,其他cell取消选中
        [self.dataArray enumerateObjectsUsingBlock:^(QuestionListModel *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //所有的都变成no
            obj.isSelected = NO;
            //如果是当前选中的cell,就变成yes
            if (idx == indexPath.row) {
                obj.isSelected = YES;
            }
        }];
    //如果是多选
    }else if (self.controllerType == multipleType){
        //选中状态取反
        listModel.isSelected = !listModel.isSelected;
        
        //如果按钮选择了,更新或增加
        if (listModel.isSelected) {
            //更新字典中答案
            [self.selectedDic setObject:listModel.questionID forKey:listModel.questionTitle];
        //如果按钮没有选择
        } else {
            //判断看是否保存了,保存过了就删除
            NSNumber *numberID = [self.selectedDic objectForKey:listModel.questionTitle];
            if (numberID) {
                [self.selectedDic removeObjectForKey:listModel.questionTitle];
            }
        }
        
        //如果点击了最后一个按钮"都不喜欢",就只保存最后一个,清除所有其他的选择
        if ([self.lastButtonTitle isEqualToString:listModel.questionTitle]) {
            //UI清除
            //当前cell为选中状态,其他cell取消选中
            [self.dataArray enumerateObjectsUsingBlock:^(QuestionListModel *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                //所有的都变成no
                obj.isSelected = NO;
                //如果是当前选中的cell,就变成yes
                if (idx == indexPath.row) {
                    obj.isSelected = YES;
                }
            }];
            //答案清除
            [self.selectedDic removeAllObjects];
            [self.selectedDic setObject:listModel.questionID forKey:listModel.questionTitle];
        //点击其他的按钮,就要清除最后一个按钮
        }else{
            //UI清除
            QuestionListModel *lastModel = self.dataArray.lastObject;
            lastModel.isSelected = NO;
            //答案清除
            //判断看是否保存了,保存过了就删除
            NSNumber *lastID = [self.selectedDic objectForKey:self.lastButtonTitle];
            if (lastID) {
                [self.selectedDic removeObjectForKey:self.lastButtonTitle];
            }
        }
        
    }
    //根据数据刷新tableView
    [self.tableView reloadData];

    //把字典中所有答案塞到数组中
    NSMutableArray *valueArray = [NSMutableArray array];
    [self.selectedDic enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, NSString *_Nonnull obj, BOOL * _Nonnull stop) {
        [valueArray addObject:obj];
    }];
    //全塞完之后传出去
    if (self.delegate && ([self.delegate respondsToSelector:@selector(selectedAnswer:withView:)])) {
        [self.delegate selectedAnswer:valueArray withView:self];
    }
}

//数据源
#pragma mark - setter
-(void)setQuestionModel:(QuestionModel *)questionModel{
    _questionModel = questionModel;
    //配置数据
    self.numLabel.text = [NSString stringWithFormat:@"0%ld",questionModel.questionId];
    self.titleNumLabel.text = @"OF 05";
    self.titleImageView.image = [UIImage imageNamed:@"word_physical_fitness"];
    self.titleLabel.text = questionModel.title;

    //如果有(可多选) 要判断中英文,防止崩溃
    if ([questionModel.title containsString:@"（"] && [questionModel.title containsString:@"）"]) {
        //设置()内文字大小
        NSRange range = [self indexOfFirstString:questionModel.title withFirst:@"（" andEnd:@"）"];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:questionModel.title];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Semibold" size:16] range:range];
        self.titleLabel.attributedText= str;
    }else if ([questionModel.title containsString:@"("] && [questionModel.title containsString:@")"]) {
        //设置()内文字大小
        NSRange range = [self indexOfFirstString:questionModel.title withFirst:@"(" andEnd:@")"];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:questionModel.title];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Semibold" size:16] range:range];
        self.titleLabel.attributedText= str;
    }
    
    
    //列表数据源
    self.dataArray = [NSMutableArray array];
    [questionModel.options enumerateObjectsUsingBlock:^(OptionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        QuestionListModel *model = [[QuestionListModel alloc]init];
        model.questionTitle = obj.content;
        model.isSelected = NO;
        model.questionID = [NSNumber numberWithInteger:obj.optionId];
        //如果有(,截取(后内容为注释,截取(前的为题目
        if ([obj.content containsString:@"（"]) {
            NSRange range = [obj.content rangeOfString:@"（"];
            model.questionTitle = [obj.content substringToIndex:range.location];
            model.questionDetail = [obj.content substringFromIndex:range.location];
        }else if([obj.content containsString:@"("]) {
            NSRange range = [obj.content rangeOfString:@"("];
            model.questionTitle = [obj.content substringToIndex:range.location];
            model.questionDetail = [obj.content substringFromIndex:range.location];
        }
        [self.dataArray addObject:model];
    }];
    //加入列表
    [self.bjView addSubview:self.tableView];
    
    //保存最后一个按钮的文字
    QuestionListModel *lastModel = self.dataArray.lastObject;
    self.lastButtonTitle = lastModel.questionTitle;
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

#pragma mark - getter
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.titleLabel.v_bottom+15, self.v_width, self.v_height-self.titleLabel.v_bottom-15)style:UITableViewStylePlain];
        _tableView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.0f];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = NO;
        //布局
        UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.v_width, 10)];
        _tableView.tableFooterView = footer;
    }
    return _tableView;
}


@end
