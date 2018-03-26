//
//  UIImage+FixOrientation.h
//  LuxuryTrade
//
//  Created by 麦时 on 2017/5/30.
//  Copyright © 2017年 insun21. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FixOrientation)

+ (NSData *)zipNSDataWithImage:(UIImage *)sourceImage;

- (UIImage *)croppedImage:(CGRect)bounds;

- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality;

- (CGAffineTransform)transformForOrientation:(CGSize)newSize;

- (UIImage *)fixOrientation;

- (UIImage *)rotatedByDegrees:(CGFloat)degrees;

@end
