//
//  NetworkEngine.h
//  NetworkAdapter
//
//  Created by bluedaquiri on 16/7/5.
//  Copyright © 2016年 blue. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef void (^ResponseBlock)(BOOL isSuccess, id object, NSError *error);
//接口路径
#define CombinePath(host, url) [NSString stringWithFormat:@"%@%@", host, url]
//请求类型
typedef NS_ENUM(NSInteger, RequestType) {
    postRequest = 0,                /**< POST请求 */
    getRequest,                     /**< GET请求 */
    putRequest                      /**< PUT请求 */
};

@interface NetworkEngine : AFHTTPSessionManager

+ (instancetype)shareEngine;    // 单例

/** 请求接口方法*/
- (NSURLSessionDataTask *)requestWithPath:(NSString *)path      //接口路径
            requestType:(RequestType)requestType                //请求类型
        requestParamter:(NSDictionary *)requestParamter         //请求参数
      responseObjctClass:(Class)responseObjctClass              //请求成功后的返回值类型
        completionBlock:(ResponseBlock)completionBlcok;         //请求成功后的回调
        
/** 用户接口  登录、获取用户信息 */
- (void)userInterfaceWithPath:(NSString *)path                          //接口路径
                 authrization:(NSString *)authrization                  //授权参数
                  requestType:(RequestType)type                         //请求类型
              requestParamter:(NSDictionary *)requestParamter           //请求参数
              completionBlock:(ResponseBlock)completionBlcok;           //请求成功后的回调

/** json参数类型接口方法 */
- (NSURLSessionDataTask *)requestJsonWithPath:(NSString *)path
                                  requestType:(RequestType)requestType
                              requestParamter:(NSDictionary *)requestParamter
                           responseObjctClass:(Class)responseObjctClass
                              completionBlock:(ResponseBlock)completionBlcok;

/** 获取授权 */
- (void)obtainAuthorizationWithPath:(NSString *)path
                    completionBlock:(ResponseBlock)completionBlcok;

/** 更新用户信息 */
- (void)updateUserInfoAction;

/** 登录默认token授权码 */
+ (NSString *)getBasicAuthorizationWithAppID:(NSString *)appID appSecret:(NSString *)appSecret;

@end 
