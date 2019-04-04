//
//  HorizontalPageableLayout.h
//  HorizontalPageableLayout
//
//  Created by Jay on 2017/8/8.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HorizontalPageableLayout : UICollectionViewFlowLayout

// 一行中 cell的个数
@property (nonatomic) NSUInteger itemCountPerRow;
// 一页显示多少行
@property (nonatomic) NSUInteger rowCount;

@end
