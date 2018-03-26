//
//  SexQuestionView.h
//  TYFitFore
//
//  Created by TanYun on 2018/1/14.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import "BaseQuestionView.h"
#import "QuestionnaireDataModel.h"

@interface SexQuestionView : BaseQuestionView


@property (nonatomic,strong) UIButton *manButton;                    /**< 男生按钮 */
@property (nonatomic,strong) UIButton *womanButton;                    /**< 女生按钮 */

@property (nonatomic,strong) QuestionModel *questionModel;


@end
