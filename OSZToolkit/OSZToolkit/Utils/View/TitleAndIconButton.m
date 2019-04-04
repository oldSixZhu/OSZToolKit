//
//  TitleAndIconButton.m
//  TYFitFore
//
//  Created by apple on 2018/5/26.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import "TitleAndIconButton.h"

@interface TitleAndIconButton ()

@property (nonatomic, strong) UIImageView *buttonIcon;
@property (nonatomic, strong) UILabel *buttonText;
@property (nonatomic, assign) TitleIconDirectionType directionType;

@end

@implementation TitleAndIconButton

- (instancetype)initWithType:(TitleIconDirectionType)type title:(NSString *)title titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor iconName:(NSString *)iconName iconSize:(CGSize)iconSize space:(CGFloat)space {
    return [[TitleAndIconButton alloc] initWithType:type title:title titleFont:titleFont titleColor:titleColor iconName:iconName iconSize:iconSize space:space textMaxWidth:SCREEN_WIDTH];
}

/** 根据类型初始化视图，并初始化视图SIZE 设置文字最大宽度 */
- (instancetype)initWithType:(TitleIconDirectionType)type
                       title:(NSString *)title
                   titleFont:(UIFont *)titleFont
                  titleColor:(UIColor *)titleColor
                    iconName:(NSString *)iconName
                    iconSize:(CGSize)iconSize
                       space:(CGFloat)space
                textMaxWidth:(CGFloat)textMaxWidth {
    if (self = [super init]) {
        
        [self addSubview:self.buttonIcon];
        [self addSubview:self.buttonText];
        self.directionType = type;
        //text
        self.buttonText.text = title;
        self.buttonText.font = titleFont;
        self.buttonText.textColor = titleColor;
        //icon
        self.buttonIcon.image = [UIImage imageNamed:iconName];
        
        //文字size
        CGSize size = [self.buttonText.text boundingRectWithSize:CGSizeMake(textMaxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: titleFont} context:nil].size;
        size.height = self.buttonText.font.lineHeight;          //文字高度不能超过一行
        //最大高度
        CGFloat maxHeight = (size.height > iconSize.height) ? size.height : iconSize.height;
        //最大宽度
        CGFloat maxWidth = (size.width > iconSize.width) ? size.width : iconSize.width;
        
        switch (type) {
            case iconLeftType:          //icon左，title右
            {
                self.buttonIcon.frame = CGRectMake(0, (maxHeight - iconSize.height)/2.0, iconSize.width, iconSize.height);
                self.buttonText.frame = CGRectMake(CGRectGetWidth(self.buttonIcon.frame) + space, (maxHeight - size.height)/2.0, size.width, size.height);
                //view宽度 = icon宽度 + space + 文字宽度
                self.frame = CGRectMake(0, 0, CGRectGetWidth(self.buttonIcon.frame) + space + CGRectGetWidth(self.buttonText.frame), maxHeight);
            }
                break;
            case iconRightType:         //title左，icon右
            {
                self.buttonText.frame = CGRectMake(0, (maxHeight - size.height)/2.0, size.width, size.height);
                self.buttonIcon.frame = CGRectMake(CGRectGetWidth(self.buttonText.frame) + space, (maxHeight - iconSize.height)/2.0, iconSize.width, iconSize.height);
                //view宽度 = 文字宽度 + space + icon宽度
                self.frame = CGRectMake(0, 0, CGRectGetWidth(self.buttonText.frame) + space + CGRectGetWidth(self.buttonIcon.frame), maxHeight);
            }
                break;
            case iconTopType:           //icon上，title下
            {
                self.buttonIcon.frame = CGRectMake((maxWidth - iconSize.width)/2.0, 0, iconSize.width, iconSize.height);
                self.buttonText.frame = CGRectMake((maxWidth - size.width)/2.0, iconSize.height + space, size.width, size.height);
                //view高度 = icon高度 + space + 文字高度
                self.frame = CGRectMake(0, 0, maxWidth, iconSize.height + space + size.height);
            }
                break;
            case iconBottomType:        //title上，icon下
            {
                self.buttonText.frame = CGRectMake((maxWidth - size.width)/2.0, 0, size.width, size.height);
                self.buttonIcon.frame = CGRectMake((maxWidth - iconSize.width)/2.0, size.height + space, iconSize.width, iconSize.height);
                //view高度 = 文字高度 + space +icon高度
                self.frame = CGRectMake(0, 0, maxWidth, size.height + space + iconSize.height);
            }
                break;
        }
    }
    return self;
}

#pragma mark - setter
- (void)setExpandSize:(CGSize)expandSize {
    _expandSize = expandSize;
    
    //最大高度
    CGFloat maxHeight = ((CGRectGetHeight(self.buttonText.frame) > CGRectGetHeight(self.buttonIcon.frame)) ? CGRectGetHeight(self.buttonText.frame) : CGRectGetHeight(self.buttonIcon.frame)) + expandSize.height * 2;
    
    //图片size
    CGSize iconSize = self.buttonIcon.v_size;
    //文字size
    CGSize size = [self.buttonText.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.buttonText.font} context:nil].size;
    CGFloat space = 0;
    
    switch (self.directionType) {
        case iconLeftType:          //icon左，title右
        {
            space = self.buttonText.v_left - self.buttonIcon.v_right;
            self.buttonIcon.frame = CGRectMake(expandSize.width, (maxHeight - iconSize.height)/2.0, iconSize.width, iconSize.height);
            self.buttonText.frame = CGRectMake(CGRectGetWidth(self.buttonIcon.frame) + space + expandSize.width, (maxHeight - size.height)/2.0, size.width, size.height);
            //view宽度 = icon宽度 + space + 文字宽度
            self.frame = CGRectMake(0, 0, CGRectGetWidth(self.buttonIcon.frame) + space + CGRectGetWidth(self.buttonText.frame) + expandSize.width * 2, maxHeight);
        }
            break;
        case iconRightType:         //title左，icon右
        {
            space = self.buttonIcon.v_left - self.buttonText.v_right;
            self.buttonText.frame = CGRectMake(expandSize.width, (maxHeight - size.height)/2.0, size.width, size.height);
            self.buttonIcon.frame = CGRectMake(CGRectGetWidth(self.buttonText.frame) + space + expandSize.width, (maxHeight - iconSize.height)/2.0, iconSize.width, iconSize.height);
            //view宽度 = 文字宽度 + space + icon宽度
            self.frame = CGRectMake(0, 0, CGRectGetWidth(self.buttonText.frame) + space + CGRectGetWidth(self.buttonIcon.frame) + expandSize.width * 2, maxHeight);
        }
            break;
        case iconTopType:           //icon上，title下
        {
            //            self.buttonIcon.frame = CGRectMake((maxWidth - iconSize.width)/2.0, 0, iconSize.width, iconSize.height);
            //            self.buttonText.frame = CGRectMake((maxWidth - size.width)/2.0, iconSize.height + space, size.width, size.height);
            //            //view高度 = icon高度 + space + 文字高度
            //            self.frame = CGRectMake(0, 0, maxWidth, iconSize.height + space + size.height);
        }
            break;
        case iconBottomType:        //title上，icon下
        {
            //            self.buttonText.frame = CGRectMake((maxWidth - size.width)/2.0, 0, size.width, size.height);
            //            self.buttonIcon.frame = CGRectMake((maxWidth - iconSize.width)/2.0, size.height + space, iconSize.width, iconSize.height);
            //            //view高度 = 文字高度 + space +icon高度
            //            self.frame = CGRectMake(0, 0, maxWidth, size.height + space + iconSize.height);
        }
            break;
    }
}

#pragma mark - getter
- (UIImageView *)buttonIcon {
    if (!_buttonIcon) {
        _buttonIcon = [[UIImageView alloc] init];
    }
    return _buttonIcon;
}

- (UILabel *)buttonText {
    if (!_buttonText) {
        _buttonText = [[UILabel alloc] init];
    }
    return _buttonText;
}

@end
