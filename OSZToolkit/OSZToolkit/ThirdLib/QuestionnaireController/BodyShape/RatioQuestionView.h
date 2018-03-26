//
//  RatioQuestionView.h
//  TYFitFore
//
//  Created by TanYun on 2018/1/23.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import "BaseQuestionView.h"
#import "QuestionnaireDataModel.h"

@class RatioQuestionView;
@protocol RatioQuestionViewDelegate <NSObject>

/**
 腰臀比变化
 
 @param valueArray 值
 */
-(void)yaoTunValueChange:(NSArray *)valueArray;

@end




@interface RatioQuestionView : BaseQuestionView

@property (nonatomic,weak)id<RatioQuestionViewDelegate> delegate;
@property (nonatomic,strong) QuestionModel *questionModel;


@end
