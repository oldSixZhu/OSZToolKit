//
//  BirthdateQuestionView.h
//  TYFitFore
//
//  Created by TanYun on 2018/1/14.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import "BaseQuestionView.h"
#import "QuestionnaireDataModel.h"


@class BirthdateQuestionView;
@protocol BirthdateQuestionViewDelegate <NSObject>

/**
 生日变化
 
 @param valueArray 值
 */
- (void)birthdateValueChange:(NSArray *)valueArray;

//禁止提交按钮
- (void)enableSubmitButton;

@end



@interface BirthdateQuestionView : BaseQuestionView

@property (nonatomic,weak)id<BirthdateQuestionViewDelegate> delegate;
@property (nonatomic,strong) QuestionModel *questionModel;

@end
