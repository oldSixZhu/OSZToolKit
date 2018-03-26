//
//  BMIQuestionView.h
//  TYFitFore
//
//  Created by TanYun on 2018/1/14.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import "BaseQuestionView.h"
#import "QuestionnaireDataModel.h"

@class BMIQuestionView;
@protocol BMIQuestionViewDelegate <NSObject>

/**
 BMI变化
 
 @param valueArray 值
 */
-(void)BMIValueChange:(NSArray *)valueArray;

@end




@interface BMIQuestionView : BaseQuestionView

@property (nonatomic,weak)id<BMIQuestionViewDelegate> delegate;
@property (nonatomic,strong) QuestionModel *questionModel;

@end












