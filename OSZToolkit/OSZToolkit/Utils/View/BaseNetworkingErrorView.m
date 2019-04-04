//
//  BaseNetworkingErrorView.m
//  FitForceCoach
//
//  Created by xuyang on 2017/12/4.
//

#import "BaseNetworkingErrorView.h"

@interface BaseNetworkingErrorView ()

@property (nonatomic, strong) UIImageView *errorImageView;                      /**< 网络异常图片 */
@property (nonatomic, strong) UILabel *errorTextLabel;                          /**< 网络异常 */
@property (nonatomic, strong) UIButton *reloadButton;                           /**< 重新加载按钮 */

@end

@implementation BaseNetworkingErrorView

#pragma mark - 初始化
- (instancetype)init {
    if (self = [super init]) {
        [self initSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    [self addSubview:self.errorImageView];
    [self addSubview:self.errorTextLabel];
    [self addSubview:self.reloadButton];
    self.backgroundColor = UIColorFromHex(0xEAECEF);
}

#pragma mark - 布局
- (void)layoutSubviews {
    [super layoutSubviews];
    
    //以文字居中布局
    [self.errorTextLabel layoutForFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MAX)];
    [self.errorTextLabel centerEqualToView:self];
    
    self.errorImageView.frame = CGRectMake((self.v_width - kFloat(140))/2.0, 0, kFloat(140), kFloat(140));
    self.errorImageView.v_bottom = self.errorTextLabel.v_top - kFloat(15);
    
    self.reloadButton.frame = CGRectMake((self.v_width - kFloat(110))/2.0, 0, kFloat(110), kFloat(40));
    self.reloadButton.v_top = self.errorTextLabel.v_bottom + kFloat(40);
}

#pragma mark - 重新加载
- (void)reloadButtonAction:(UIButton *)sender {
    if (self.reloadClosure) {
        self.reloadClosure();
    }
}

#pragma mark - getter
- (UIImageView *)errorImageView {
    if (!_errorImageView) {
        _errorImageView = [[UIImageView alloc] init];
        _errorImageView.image = kUIImageMake(@"icon_nowif");
    }
    return _errorImageView;
}

- (UILabel *)errorTextLabel {
    if (!_errorTextLabel) {
        _errorTextLabel = [[UILabel alloc] init];
        _errorTextLabel.textColor = UIColorFromHex(0x8597A1);
        _errorTextLabel.font = kFont(15);
        _errorTextLabel.text = XYLString(@"network_view_disconnected");
        _errorTextLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _errorTextLabel;
}

- (UIButton *)reloadButton {
    if (!_reloadButton) {
        _reloadButton = [[UIButton alloc] init];
        [_reloadButton setTitle:XYLString(@"network_view_reload") forState:(UIControlStateNormal)];
        [_reloadButton setTitleColor:UIColorFromHex(0x00C6B8) forState:(UIControlStateNormal)];
        _reloadButton.titleLabel.font = kFont(15);
        [_reloadButton addTarget:self action:@selector(reloadButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        _reloadButton.layer.cornerRadius = kFloat(20);
        _reloadButton.layer.borderWidth = 0.5;
        _reloadButton.layer.borderColor = UIColorFromHex(0x00C6B8).CGColor;
    }
    return _reloadButton;
}

@end
