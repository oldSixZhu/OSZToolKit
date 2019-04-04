//
//  NetworkTool.h
//  demo
//
//  Created by TanYun on 2018/4/16.
//  Copyright © 2018年 icarbonx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

//请求类型
typedef NS_ENUM(NSInteger, NetRequestType) {
    postRequest = 0,                /**< POST请求 */
    getRequest                      /**< GET请求 */
};


typedef void (^ResponseBlock)(BOOL isSuccess, id object, NSError *error);


@interface NetworkTool : AFHTTPSessionManager

+ (instancetype)sharedInstance;

/** 请求接口方法 */
- (NSURLSessionDataTask *)requestWithPath:(NSString *)path      //接口路径
                              requestType:(NetRequestType)requestType             //请求类型
                          requestParamter:(NSDictionary *)requestParamter         //请求参数
                       responseObjctClass:(Class)responseObjctClass               //请求成功后的返回值类型
                          completionBlock:(ResponseBlock)completionBlcok;         //请求成功后的回调

@end
