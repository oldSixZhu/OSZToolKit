//
//  NetworkImageTool.m
//  FitForceCoach
//
//  Created by TanYun on 2017/12/28.
//

#import "NetworkImageTool.h"


@interface NetworkImageTool ()<NSURLSessionDelegate>

@end


@implementation NetworkImageTool


/**
 *  调整图片尺寸和大小
 *
 *  @param sourceImage  原始图片
 *  @param maxImageSize 新图片最大尺寸
 *  @param maxSize      新图片最大存储大小
 *
 *  @return 新图片imageData
 */
+ (NSData *)reSizeImageData:(UIImage *)sourceImage maxImageSize:(CGFloat)maxImageSize maxSizeWithKB:(CGFloat) maxSize
{
    
    if (maxSize <= 0.0) maxSize = 1024.0;
    if (maxImageSize <= 0.0) maxImageSize = 1024.0;
    
    //先调整分辨率
    CGSize newSize = CGSizeMake(sourceImage.size.width, sourceImage.size.height);
    
    CGFloat tempHeight = newSize.height / maxImageSize;
    CGFloat tempWidth = newSize.width / maxImageSize;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempWidth, sourceImage.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(sourceImage.size.width / tempHeight, sourceImage.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [sourceImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage,1.0);
    CGFloat sizeOriginKB = imageData.length / 1024.0;
    
    CGFloat resizeRate = 0.9;
    while (sizeOriginKB > maxSize && resizeRate > 0.1) {
        imageData = UIImageJPEGRepresentation(newImage,resizeRate);
        sizeOriginKB = imageData.length / 1024.0;
        resizeRate -= 0.1;
    }
    
    return imageData;
}



/** 上传图片 */
- (void)uploadImageWithPath:(NSString *)path
            requestParamter:(NSDictionary *)requestParamter
                  imageData:(NSData *)imageData
         responseObjctClass:(Class)responseObjctClass
            completionBlock:(ResponseBlock)completionBlcok{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//参数类型
    manager.requestSerializer.timeoutInterval = 30;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/javascript", @"text/json", @"image/png", @"image/jpeg", @"application/json", @"text/plain", nil];
    //设置请求授权参数
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[CoachInfoModel sharedInstance].access_token] forHTTPHeaderField:@"Authorization"];
    
    //获取当前时间戳为文件名,目前由服务器设置
    //    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970]*1000;
    //    long long theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
    //    NSString *curTime = [NSString stringWithFormat:@"%llu",theTime];
    //    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",curTime];
    
    [manager POST:path parameters:requestParamter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"image" fileName:@"imageName.jpg" mimeType:@"multipart/form-data"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //如果AFN没有结果返回，则直接返回错误信息
        if (responseObject == nil) {
            completionBlcok(NO, nil, kMakeErrorAndCode(XYLString(@"network_service_noResponse"), -1));
            return;
        } else {
            id responseObjectWithJson;
            NSString *result;
            //如果返回类型是NSData类型，则转为字典类型；如果返回类型是字典类型，则直接使用
            if ([responseObject isKindOfClass:[NSData class]]) {
                responseObjectWithJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                result = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                responseObjectWithJson = responseObject;
                result = responseObject;
            }
#ifdef DEBUG
            //debug模式下，打印调试输出
            NSLog(@"url = %@", path);
            if (requestParamter) {
                NSLog(@"params : %@", requestParamter);
            }
            if (responseObjectWithJson != nil){
                NSLog(@"RESPONSE JSON:%@", responseObjectWithJson );
            } else {
                NSLog(@"RESPONSE JSON:%@", result );
            }
#endif
            if ([[responseObjectWithJson objectForKey:@"errorCode"] integerValue] == 0) {
                
                if (responseObjctClass == nil) {
                    //如果不需要返回model，操作成功后，携带json数据直接返回
                    completionBlcok(YES, responseObjectWithJson, nil);
                    return;
                } else {
                    //请求成功，使用YYModel解析json，返回解析成功后的数据；如果解析失败，则返回空数据
                    id responseClass = [responseObjctClass yy_modelWithJSON: responseObjectWithJson];
                    if (responseClass) {
                        completionBlcok(YES, responseClass, nil);
                    } else {
                        completionBlcok(YES, nil, nil);
                    }
                    return;
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#ifdef DEBUG
        NSString *requestURL = [task.currentRequest.URL absoluteString];
        NSString *params = [[NSString alloc]initWithData:task.currentRequest.HTTPBody encoding:NSUTF8StringEncoding];
        NSLog(@"网络层错误 URL -- %@ \nPARAMS:%@ \nAND RESPONSE:%@ \nerror = %@", requestURL, params, task.response, error);
#endif
    }];
    
    
}




#pragma mark - 重定向下载资源文件
- (void)downloadImageWithRedirect:(NSString *)urlstring callBackBlock:(imageDownloadBlock)block
{
    NSURL *url = [NSURL URLWithString:urlstring];
    NSMutableURLRequest *quest = [NSMutableURLRequest requestWithURL:url];
    quest.HTTPMethod = @"GET";//设置get请求
    //设置请求授权参数
    [quest setValue:[NSString stringWithFormat:@"Bearer %@",[CoachInfoModel sharedInstance].access_token] forHTTPHeaderField:@"Authorization"];
    
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    sessionConfig.timeoutIntervalForRequest = 30;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:[NSOperationQueue currentQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:quest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            block(nil,NO);
            TYLog(@"下载资源失败1");
        }
        
        
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        if (res.statusCode == 302) {
            //去真正的文件下载地址请求资源
            NSURL* imageDownloadUrl = [NSURL URLWithString:res.allHeaderFields[@"Location"]];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:imageDownloadUrl];
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                       if ( !error ){
                                           UIImage *image = [UIImage imageWithData: data];
                                           block(image,YES);
                                           
                                           TYLog(@"下载资源成功");
                                       }else{
                                           block(nil,NO);
                                           TYLog(@"下载资源失败3");
                                       }
                                   }];
        }else{
            block(nil,NO);
            TYLog(@"下载资源失败2");
        }
    }];
    [task resume];
}


//重定向的代理方法
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler{
    
    NSDictionary *dic = response.allHeaderFields;
    NSLog(@"重定向URL = %@",dic[@"Location"]);
    completionHandler(nil);//这个如果为nil则表示拦截跳转。
}



@end
