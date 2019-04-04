//
//  RulerCollectionViewCell.h
//  TYFitFore
//
//  Created by apple on 2018/7/5.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RulerNumberDirection) {
    numberTop = 0,
    numberBottom,
    numberLeft,
    numberRight
};

@interface RulerCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) CGFloat shortScaleLength;                         /**< 短刻度长度  */
@property (nonatomic, assign) CGFloat longScaleLength;                          /**< 长刻度长度  */
@property (nonatomic, assign) CGFloat scaleWidth;                               /**< 刻度尺宽度  */
@property (nonatomic, assign) CGFloat shortScaleStart;                          /**< 短刻度起始位置  */
@property (nonatomic, assign) CGFloat longScaleStart;                           /**< 长刻度起始位置  */
@property (nonatomic, strong) UIColor *scaleColor;                              /**< 刻度颜色  */
@property (nonatomic, strong) UIFont *numberFont;                               /**< 数字字体  */
@property (nonatomic, strong) UIColor *numberColor;                             /**< 数字颜色  */
@property (nonatomic, assign) CGFloat distanceFromScaleToNumber;                /**< 刻度和数字之间的距离  */
@property (nonatomic, assign) RulerNumberDirection numberDirection;             /**< 数字方向  */
@property (nonatomic, assign) NSInteger min;                                    /**< 最小值  */

@property (nonatomic, assign) NSInteger index;                                  /**< cell下标  */
@property (nonatomic, assign) BOOL isDecimal;                                   /**< 保留一位小数类型  */

/** 选中当前cell */
- (void)makeCellSelect;
/** 隐藏当前cell的文字 */
- (void)makeCellHiddenText;

@end
