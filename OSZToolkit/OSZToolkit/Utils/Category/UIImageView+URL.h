//
//  UIImageView+URL.h
//  FitForceCoach
//
//  Created by apple on 2018/1/23.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>

@interface UIImageView (URL)

//根据图片id下载图片
- (void)sd_setImageWithKey:(NSString *)key placeholderImage:(UIImage *)placeholder;

+ (void)sd_setImageWithKey:(NSString *)key callBackBlock:(void(^)(UIImage *image, BOOL isSuccess))callback;

//下载自己的图片
- (void)sd_setSelfImageWithKey:(NSString *)key placeholderImage:(UIImage *)placeholder;

+ (void)sd_setSelfImageWithKey:(NSString *)key callBackBlock:(void(^)(UIImage *image, BOOL isSuccess))callback;

@end
