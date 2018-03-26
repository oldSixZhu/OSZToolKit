//
//  OSZRulerView.h
//  TYFitFore
//
//  Created by TanYun on 2018/1/17.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSZRulerModel.h"

@class OSZRulerView;

@protocol OSZRulerViewDelegate <NSObject>


/**
 数值变化监听

 @param rulerModel 变化的值
 */
-(void)valueChange:(OSZRulerModel *)rulerModel;

@end



@interface OSZRulerView : UIView

@property (nonatomic,weak)id<OSZRulerViewDelegate> delegate;
@property (nonatomic,strong) UICollectionView *rulerView;                    /**< 滚轮 */
@property (nonatomic,strong) NSMutableArray *dataArray;                    /**< 数据源 */


@end
