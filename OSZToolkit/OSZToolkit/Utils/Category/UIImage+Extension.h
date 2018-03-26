//
//  UIImage+Extension.h
//  MTime
//
//  Created by mtime_lee on 2017/10/16.
//  Copyright © 2017年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/** 根据Rect 截取当前UIImage对象获取图片*/
- (UIImage *)cutImageWithImageFrame:(CGRect)frame;

/** 更改图片的颜色 */
- (void)qmui_imageWithBlendColor:(UIColor *)blendColor completeBlock:(void (^)(UIImage *image))completed;

/**
 *  创建一个纯色的UIImage
 *
 *  @param  color           图片的颜色
 *  @param  size            图片的大小
 *  @param  cornerRadius    图片的圆角
 *
 * @return 纯色的UIImage
 */
//+ (UIImage *)qmui_imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius;

/**
 *  创建一个纯色的UIImage，支持为四个角设置不同的圆角
 *  @param  color               图片的颜色
 *  @param  size                图片的大小
 *  @param  cornerRadius   四个角的圆角值的数组，长度必须为4，顺序分别为[左上角、左下角、右下角、右上角]
 */
//+ (UIImage *)qmui_imageWithColor:(UIColor *)color size:(CGSize)size cornerRadiusArray:(NSArray<NSNumber *> *)cornerRadius;

@end
