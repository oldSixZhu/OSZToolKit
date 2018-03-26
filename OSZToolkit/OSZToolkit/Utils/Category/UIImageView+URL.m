//
//  UIImageView+URL.m
//  FitForceCoach
//
//  Created by apple on 2018/1/23.
//

#import "UIImageView+URL.h"

@implementation UIImageView (URL)

- (void)sd_setImageWithKey:(NSString *)key placeholderImage:(UIImage *)placeholder {
    //设置默认图片
    self.image = placeholder;
    
    if (key.length > 0) {
        //如果是正常链接，则直接使用SDWebImage
        if ([key hasPrefix:@"http"]) {
            [self sd_setImageWithURL:[NSURL URLWithString:key]];
        } else {
            //如果是mediaId类型的图片key，则使用自定义下载
            SDImageCache *imageCache = [SDImageCache sharedImageCache];
            
            //查询图片是否有缓存，如果有，则使用；如果没有，则下载图片
            @weakify(self)
            [imageCache queryCacheOperationForKey:key done:^(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType) {
                @strongify(self)
                if (image) {
                    self.image = image;
                } else {
                    [self downLoadImageWithKey:key];
                }
            }];
        }
        
    }
}

- (void)downLoadImageWithKey:(NSString *)key {
    //获取头像
    NSString *imageID = [NSString stringWithFormat:@"%@%@", CombinePath(TY_DEBUG_HOST, DOWNLOAD_OTHER_MEDIA_IMAGE), key];
    //从图片服务器获取
    @weakify(self)
    [[[NetworkImageTool alloc]init] downloadImageWithRedirect:imageID callBackBlock:^(UIImage *image, BOOL isSuccess) {
        @strongify(self)
        if (isSuccess) {
            //下载成功后，替换图片，并且缓存图片
            self.image = image;
            //缓存图片
            SDImageCache *imageCache = [SDImageCache sharedImageCache];
            [imageCache storeImage:image forKey:key completion:nil];
        }
    }];
}

//根据图片id下载图片
+ (void)sd_setImageWithKey:(NSString *)key callBackBlock:(void(^)(UIImage *image, BOOL isSuccess))callback {
    if (key.length > 0) {
        //如果是正常链接，则直接使用SDWebImage
        if ([key hasPrefix:@"http"]) {
            [[UIImageView new] sd_setImageWithURL:[NSURL URLWithString:key] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                callback(image, error == nil);
            }];
        } else {
            //如果是mediaId类型的图片key，则使用自定义下载
            
            SDImageCache *imageCache = [SDImageCache sharedImageCache];
            
            NSString *imageID = [NSString stringWithFormat:@"%@%@", CombinePath(TY_DEBUG_HOST, DOWNLOAD_OTHER_MEDIA_IMAGE), key];
            
            //查询图片是否有缓存，如果有，则使用；如果没有，则下载图片
            [imageCache queryCacheOperationForKey:key done:^(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType) {
                if (image) {
                    callback(image, YES);
                } else {
                    [[[NetworkImageTool alloc] init] downloadImageWithRedirect:imageID callBackBlock:^(UIImage *image, BOOL isSuccess) {
                        if (isSuccess) {
                            //缓存图片
                            SDImageCache *imageCache = [SDImageCache sharedImageCache];
                            [imageCache storeImage:image forKey:key completion:nil];
                            
                            callback(image, YES);
                        } else {
                            callback(nil, NO);
                        }
                    }];
                }
            }];
        }
        
    }
}

@end
