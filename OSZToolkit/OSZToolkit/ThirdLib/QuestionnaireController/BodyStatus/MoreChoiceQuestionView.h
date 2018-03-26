//
//  MoreChoiceQuestionView.h
//  TYFitFore
//
//  Created by TanYun on 2018/1/30.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import "BaseQuestionView.h"
#import "QuestionnaireDataModel.h"

@class MoreChoiceQuestionView;
@protocol MoreChoiceQuestionViewDelegate <NSObject>


/**
 选择的结果
 
 @param valueArray 结果集
 @param view 哪个页面
 */
- (void)selectedTypes:(NSMutableArray *)valueArray withView:(MoreChoiceQuestionView *)view;

@end





@interface MoreChoiceQuestionView : BaseQuestionView

@property (nonatomic,weak)id<MoreChoiceQuestionViewDelegate> delegate;
@property (nonatomic,strong) QuestionModel *questionModel;
@property (nonatomic,assign) ControllerType controllerType;     /**< 标记哪个页面 */
@property (nonatomic,assign) BOOL isWeekController;             /**< 是否是选择天数的页面 */
@property (nonatomic,assign) CGFloat buttonY;                    /**< 按钮y */
@property (nonatomic,assign) CGFloat buttonMinWidth;               /**< 按钮最小宽度 */


@end
