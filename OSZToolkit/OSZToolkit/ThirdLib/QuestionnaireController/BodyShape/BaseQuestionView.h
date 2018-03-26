//
//  BaseQuestionView.h
//  TYFitFore
//
//  Created by TanYun on 2018/1/14.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseQuestionView : UIView

@property (nonatomic,strong) UIView *bjView;                            /**< 背景 */
@property (nonatomic,strong) UILabel *numLabel;                         /**< 当前页 */
@property (nonatomic,strong) UILabel *titleNumLabel;                    /**< 总页数 */
@property (nonatomic,strong) UIImageView *titleImageView;              /**< 图片 */
@property (nonatomic,strong) UILabel *titleLabel;                     /**< 问题题目 */



@end
