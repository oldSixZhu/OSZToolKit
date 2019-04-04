//
//  RulerLayout.h
//  TYFitFore
//
//  Created by apple on 2018/7/5.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RulerLayout : UICollectionViewLayout

//cell间距
@property (nonatomic, assign) CGFloat spacing;
//cell的尺寸
@property (nonatomic, assign) CGSize itemSize;
//滚动方向
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

@end
