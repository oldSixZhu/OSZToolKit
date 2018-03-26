//
//  BodyFatQuestionView.h
//  TYFitFore
//
//  Created by TanYun on 2018/1/14.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import "BaseQuestionView.h"
#import "QuestionnaireDataModel.h"

@class BodyFatQuestionView;
@protocol BodyFatQuestionViewDelegate <NSObject>

/**
 体脂率变化

 @param valueArray 值
 */
-(void)bodyFatValueChange:(NSArray *)valueArray;

@end



@interface BodyFatQuestionView : BaseQuestionView

@property (nonatomic,weak)id<BodyFatQuestionViewDelegate> delegate;
@property (nonatomic,strong) QuestionModel *questionModel;

@end
