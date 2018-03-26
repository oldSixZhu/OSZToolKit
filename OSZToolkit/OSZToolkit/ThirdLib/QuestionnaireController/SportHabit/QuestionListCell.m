//
//  QuestionListCell.m
//  TYFitFore
//
//  Created by TanYun on 2018/1/18.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import "QuestionListCell.h"

@interface QuestionListCell ()

@property (nonatomic,strong) UIView *bjView;                   /**< 背景 */
@property (nonatomic,strong) UIView *dian;                    /**< 点 */
@property (nonatomic,strong) UILabel *titleLabel;             /**< 问题 */
@property (nonatomic,strong) UILabel *detailLabel;            /**< 注释 */


@end



@implementation QuestionListCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor =  [[UIColor whiteColor]colorWithAlphaComponent:0.0f];
        self.backgroundColor =  [[UIColor whiteColor]colorWithAlphaComponent:0.0f];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //添加子视图
        [self.contentView addSubview:self.bjView];
        [self.bjView addSubview:self.dian];
        [self.bjView addSubview:self.titleLabel];
        [self.bjView addSubview:self.detailLabel];

    }
    return self;
}

#pragma mark - setter
-(void)setListModel:(QuestionListModel *)listModel{
    _listModel = listModel;
    self.titleLabel.text = listModel.questionTitle;
    //是否选中
    if (listModel.isSelected) {
        self.bjView.backgroundColor = UIColorFromHex(0x01C6B8);
        self.dian.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.detailLabel.textColor = [UIColor whiteColor];
    }else{
        self.bjView.backgroundColor = UIColorFromHex(0xF7F8FA);
        self.dian.backgroundColor = UIColorFromHex(0xE4E6EB);
        self.titleLabel.textColor = UIColorFromHex(0x4A4A4A);
        self.detailLabel.textColor = UIColorFromHex(0x4A4A4A);
    }
    
    //根据是否有注释布局
    if (listModel.questionDetail.length > 0) {
        self.titleLabel.frame = CGRectMake(self.dian.v_right+15,10, 200, 17);
        self.detailLabel.frame = CGRectMake(self.dian.v_right+10, self.titleLabel.v_bottom+5,  200, 10);
        
        self.detailLabel.text = listModel.questionDetail;
    }else{
        self.titleLabel.frame = CGRectMake(self.dian.v_right+10,5, 200, 50);
        self.titleLabel.v_centerY = self.dian.v_centerY;
        self.detailLabel.frame = CGRectMake(0, 0, 0, 0);
    }
}


#pragma mark - getter
-(UIView *)bjView{
    if (!_bjView) {
        _bjView = [[UIView alloc]initWithFrame:CGRectMake(37.5, 10, 250, 50)];
        _bjView.backgroundColor = UIColorFromHex(0xF7F8FA);
        _bjView.layer.cornerRadius = 5;
        _bjView.layer.masksToBounds = YES;
    }
    return _bjView;
}


-(UIView *)dian{
    if (!_dian) {
        _dian = [[UIView alloc]initWithFrame:CGRectMake(25, 20, 10, 10)];
        _dian.backgroundColor = UIColorFromHex(0xE4E6EB);
        _dian.layer.cornerRadius = 5;
        _dian.layer.masksToBounds = YES;
    }
    return _dian;
}


-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = UIColorFromHex(0x4A4A4A);
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

-(UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.textColor = UIColorFromHex(0x4A4A4A);
        _detailLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:10];
    }
    return _detailLabel;
}


@end
