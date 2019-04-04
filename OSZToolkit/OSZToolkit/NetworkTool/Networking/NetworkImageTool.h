//
//  NetworkImageTool.h
//  FitForceCoach
//
//  Created by TanYun on 2017/12/28.
//

#import <Foundation/Foundation.h>
//图片下载block
typedef void (^imageDownloadBlock)(UIImage *image,BOOL isSuccess);

@interface NetworkImageTool : NSObject



/**
 *  调整图片尺寸和大小
 *
 *  @param sourceImage  原始图片
 *  @param maxImageSize 新图片最大尺寸
 *  @param maxSize      新图片最大存储大小
 *
 *  @return 新图片imageData
 */
+ (NSData *)reSizeImageData:(UIImage *)sourceImage
               maxImageSize:(CGFloat)maxImageSize
              maxSizeWithKB:(CGFloat) maxSize;


/** 上传图片 */
- (void)uploadImageWithPath:(NSString *)path
            requestParamter:(NSDictionary *)requestParamter
                  imageData:(NSData *)imageData
         responseObjctClass:(Class)responseObjctClass
            completionBlock:(ResponseBlock)completionBlcok;


//下载图片
- (void)downloadImageWithRedirect:(NSString *)urlstring
                    callBackBlock:(imageDownloadBlock)block;


@end
