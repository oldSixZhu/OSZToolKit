//
//  LoadAnimationView.h
//  TYFitFore
//
//  Created by TanYun on 2018/3/15.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoadAnimationView : UIView

@property (nonatomic, strong) NSString *title;     /**< 文字 */


/// 展示动画
- (void)startAnimation;

//直接更改图片为红色问号
- (void)setupStatusNO;

@end
