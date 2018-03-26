//
//  UIImageView+URL.h
//  FitForceCoach
//
//  Created by apple on 2018/1/23.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>

@interface UIImageView (URL)

- (void)sd_setImageWithKey:(NSString *)key placeholderImage:(UIImage *)placeholder; 

//根据图片id下载图片
+ (void)sd_setImageWithKey:(NSString *)key callBackBlock:(void(^)(UIImage *image, BOOL isSuccess))callback;

@end
