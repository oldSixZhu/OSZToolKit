//
//  NetworkTool.m
//  demo
//
//  Created by TanYun on 2018/4/16.
//  Copyright © 2018年 icarbonx. All rights reserved.
//

#import "NetworkTool.h"

@implementation NetworkTool

+ (instancetype)sharedInstance{
    static NetworkTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[self alloc] init];
    });
    return tool;
}


#pragma mark - 请求接口方法
- (NSURLSessionDataTask *)requestWithPath:(NSString *)path
                              requestType:(NetRequestType)requestType
                          requestParamter:(NSDictionary *)requestParamter
                       responseObjctClass:(Class)responseObjctClass
                          completionBlock:(ResponseBlock)completionBlcok {
    //发起请求
    return [self requestType:requestType path:path requestParamter:requestParamter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject == nil) {
            NSError *error;
            completionBlcok(NO, nil, error);
        } else {
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}



#pragma mark 根据请求方式请求数据
- (NSURLSessionDataTask *)requestType:(NetRequestType)requestType
                                 path:(NSString *)path
                      requestParamter:(NSDictionary *)requestParamter
                              success:(void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                              failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure {
    
    //拦截请求，判断app运行期间是否有获取过用户信息，如果没有则获取用户信息并更新
    //(登录和获取用户信息接口不能拦截)
    //    BOOL isUpdated = [[[NSUserDefaults standardUserDefaults] objectForKey:kIsUpdateUserInfoKey] boolValue];
    
    
    if (requestType == postRequest) {               //post请求
        return [self POST:path parameters:requestParamter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(task, responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(task, error);
        }];
    } else if (requestType == getRequest) {         //get请求
        return [self GET:path parameters:requestParamter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(task, responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(task, error);
        }];
    }
    return nil;
}


@end
