//
//  BaseLoadingView.h
//  TYFitFore
//
//  Created by 徐杨 on 2017/12/12.
//  Copyright © 2017年 tangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingAnimationView.h"

@interface BaseLoadingView : UIView

@property (nonatomic, strong) LoadingAnimationView *loadingView;
//@property (nonatomic, strong) UIImageView *loadingView;                             /**< 加载的gif图 */
//@property (nonatomic, strong) UILabel *loadingTextLabel;                            /**< 加载中... */

//+ (NSArray *)gifImagesWithImage;

@end
