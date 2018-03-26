//
//  SingleChoiceQuestionView.h
//  TYFitFore
//
//  Created by TanYun on 2018/1/29.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import "BaseQuestionView.h"
#import "QuestionnaireDataModel.h"



@class SingleChoiceQuestionView;
@protocol SingleChoiceQuestionViewDelegate <NSObject>

/**
 选择变化
 
 @param valueArray 值
 */
-(void)singleButtonValueChange:(NSArray *)valueArray withView:(SingleChoiceQuestionView *)view;


@end




@interface SingleChoiceQuestionView : BaseQuestionView

@property (nonatomic,weak)id<SingleChoiceQuestionViewDelegate> delegate;
@property (nonatomic,strong) QuestionModel *questionModel;
@property (nonatomic,assign) ControllerType controllerType;                    /**< 标记哪个页面 */


@end
