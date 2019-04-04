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
            @weakify(self)
            [UIImageView getImageWithQCloudPath:key callBackBlock:^(UIImage *image) {
                @strongify(self)
                if (image) {
                    self.image = image;
                }
            }];
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
    NSString *imageID = [NSString stringWithFormat:@"%@%@", CombinePath(TY_DEBUG_HOST, DOWNLOAD_MEDIA_IMAGE), key];
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
            //通过地址下载链接
            [UIImageView getImageWithQCloudPath:key callBackBlock:^(UIImage *image) {
                callback(image, image == nil);
            }];
        } else {
            //如果是mediaId类型的图片key，则使用自定义下载
            
            SDImageCache *imageCache = [SDImageCache sharedImageCache];
            
            NSString *imageID = [NSString stringWithFormat:@"%@%@", CombinePath(TY_DEBUG_HOST, DOWNLOAD_MEDIA_IMAGE), key];
            
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

/** 通过腾讯云的图片链接下载图片 */
+ (void)getImageWithQCloudPath:(NSString *)path callBackBlock:(void(^)(UIImage *image))imageCallback  {
    
    //判断图片是否是腾讯云的一次性下载路径
    NSString *imageMediaId = [UIImageView getMediaIdFromImagePath:path];
    
    UIImageView *tempImageView = [[UIImageView alloc] init];
    
    if (imageMediaId.length > 0) {
        //如果是mediaId格式的图片，则用mediaId读取图片路径
        [[SDImageCache sharedImageCache] queryCacheOperationForKey:imageMediaId done:^(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType) {
            if (image) {
                //如果查询到了缓存，则使用缓存
                imageCallback(image);
            } else {
                //如果没有查询到缓存，则下载该图片
                [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:path] options:SDWebImageCacheMemoryOnly progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                    if (image) {
                        //缓存图片，并且使用mediaId当做图片的缓存key
                        SDImageCache *imageCache = [SDImageCache sharedImageCache];
                        [imageCache storeImage:image forKey:imageMediaId completion:nil];
                        //回调图片
                        imageCallback(image);
                    } else {
                        //如果下载不成功，则再使用mediaId下载图片
                        [[[NetworkImageTool alloc] init] downloadImageWithRedirect:imageMediaId callBackBlock:^(UIImage *image, BOOL isSuccess) {
                            if (isSuccess) {
                                //缓存图片
                                SDImageCache *imageCache = [SDImageCache sharedImageCache];
                                [imageCache storeImage:image forKey:imageMediaId completion:nil];
                                //回调图片
                                imageCallback(image);
                            } else {
                                imageCallback(nil);
                            }
                        }];
                    }
                }];
            }
        }];
    } else {
        [tempImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            imageCallback(image);
        }];
    }
    
}

/** 获取链接中的图片mediaId */
+ (NSString *)getMediaIdFromImagePath:(NSString *)imagePath {
    //判断是否是从腾讯云服务器地址存储的链接
    if (imagePath.length && [imagePath containsString:@"myqcloud"]) {
        //将路径转为小写
        //https://sportdev-1251962406.file.myqcloud.com/media/1658/images/3c4f5ee1-70f3-4c98-ba0c-59e2520c409d.jpg?sign=xxx
        NSString *imageCloudPath = [imagePath lowercaseString];
        //截取图片名称
        //https://sportdev-1251962406.file.myqcloud.com/media/1658/images/3c4f5ee1-70f3-4c98-ba0c-59e2520c409d.jpg
        NSArray<NSString *> *tempUrlArray = [imageCloudPath componentsSeparatedByString:@"?"];
        if (tempUrlArray.count > 0 && [tempUrlArray.firstObject containsString:@"jpg"]) {
            //3c4f5ee1-70f3-4c98-ba0c-59e2520c409d.jpg
            tempUrlArray = [tempUrlArray.firstObject componentsSeparatedByString:@"/"];
            //3c4f5ee1-70f3-4c98-ba0c-59e2520c409d
            if (tempUrlArray.count > 0 && [tempUrlArray.lastObject containsString:@"jpg"]) {
                return [tempUrlArray.lastObject stringByDeletingPathExtension];
            }
        }
    }
    
    return @"";
}

- (void)sd_setSelfImageWithKey:(NSString *)key placeholderImage:(UIImage *)placeholder {
    //设置默认图片
    self.image = placeholder;
    
    if (key.length > 0) {
        //如果是正常链接，则直接使用SDWebImage
        if ([key hasPrefix:@"http"]) {
            @weakify(self)
            [UIImageView getImageWithQCloudPath:key callBackBlock:^(UIImage *image) {
                @strongify(self)
                if (image) {
                    self.image = image;
                }
            }];
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
                    [self downLoadSelfImageWithKey:key];
                }
            }];
        }
        
    }
}

- (void)downLoadSelfImageWithKey:(NSString *)key {
    //获取头像
    NSString *imageID = [NSString stringWithFormat:@"%@%@", CombinePath(TY_DEBUG_HOST, DOWNLOAD_SELF_IMAGE), key];
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

+ (void)sd_setSelfImageWithKey:(NSString *)key callBackBlock:(void(^)(UIImage *image, BOOL isSuccess))callback {
    if (key.length > 0) {
        //如果是正常链接，则直接使用SDWebImage
        if ([key hasPrefix:@"http"]) {
            //通过地址下载链接
            [UIImageView getImageWithQCloudPath:key callBackBlock:^(UIImage *image) {
                callback(image, image == nil);
            }];
        } else {
            //如果是mediaId类型的图片key，则使用自定义下载
            
            SDImageCache *imageCache = [SDImageCache sharedImageCache];
            
            NSString *imageID = [NSString stringWithFormat:@"%@%@", CombinePath(TY_DEBUG_HOST, DOWNLOAD_SELF_IMAGE), key];
            
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
