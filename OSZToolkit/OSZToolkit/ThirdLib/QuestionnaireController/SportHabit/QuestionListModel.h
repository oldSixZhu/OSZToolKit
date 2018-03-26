//
//  QuestionListModel.h
//  TYFitFore
//
//  Created by TanYun on 2018/1/18.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

////cell的类型
//typedef NS_ENUM(NSUInteger, ListCellType) {
//    singleLineType,                    /**< 单行 */
//    doubleLineType                     /**< 双行 */
//};


@interface QuestionListModel : NSObject

@property (nonatomic,strong) NSNumber *questionID;                       /**< 题目的ID,提交使用 */
@property (nonatomic,strong) NSString *questionTitle;                    /**< 题目 */
@property (nonatomic,strong) NSString *questionDetail;                    /**< 注释 */
@property (nonatomic,assign) BOOL isSelected;                            /**< 是否选中 */
//@property (nonatomic,assign) ListCellType cellType;                    /**< 题目类型 */


@end
