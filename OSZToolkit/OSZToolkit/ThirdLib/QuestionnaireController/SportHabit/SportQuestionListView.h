//
//  SportQuestionListView.h
//  TYFitFore
//
//  Created by TanYun on 2018/1/25.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import "BaseQuestionView.h"
#import "QuestionnaireDataModel.h"

//列表页面是否多选
typedef NS_ENUM(NSUInteger, ListControllerType) {
    singleType,                      /**< 单选 */
    multipleType                     /**< 多选 */
};

@class SportQuestionListView;
@protocol SportQuestionListViewDelegate <NSObject>

/**
 选择答案
 
 @param valueArray 答案
 */
-(void)selectedAnswer:(NSArray *)valueArray withView:(SportQuestionListView *)listView;

@end


@interface SportQuestionListView : BaseQuestionView

@property (nonatomic,weak) id<SportQuestionListViewDelegate> delegate;
@property (nonatomic,strong) QuestionModel *questionModel;
@property (nonatomic,assign) ListControllerType controllerType;


@end
