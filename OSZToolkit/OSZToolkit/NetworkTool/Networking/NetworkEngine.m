//
//  NetworkEngine.m
//  NetworkAdapter
//
//  Created by bluedaquiri on 16/7/5.
//  Copyright © 2016年 blue. All rights reserved.
//

#import "NetworkEngine.h"
#import "TYGlobalManager.h"
#import "FetchModel.h"

#import "AppDelegate.h"
#import "BaseTabBarViewController.h"

typedef void(^RequestPathBlock)(void);

@interface NetworkEngine ()

@property (nonatomic, assign) NSInteger re_requestTimes;     /**< 重新请求次数：登录失效时，会刷新token，最多刷新不能超过1次  */
@property (nonatomic, strong) NSURLSessionDataTask *updateUserInfoTask;
@property (nonatomic, assign) BOOL isUpdating;                          /**< 是否正在更新用户信息  */
@property (nonatomic, strong) NSURLSessionDataTask *loginTask;          /**< 登录请求  */
@property (nonatomic, strong) NSMutableArray *waitingTaskArray;         /**< 等待中的请求  */

@end

@implementation NetworkEngine

+ (instancetype)shareEngine {
    static NetworkEngine *_engine = nil;
    static dispatch_once_t onceToken;
    //每次开始请求时，都重置请求次数
//    _engine.re_requestTimes = 0;
    dispatch_once(&onceToken, ^{
        _engine = [[NetworkEngine alloc] init];
        _engine.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//        _engine.requestSerializer = [RequestSerializer serializer];
//        _engine.requestSerializer = [AFJSONRequestSerializer serializer];
//        _engine.responseSerializer = [AFJSONResponseSerializer serializer];
        _engine.requestSerializer.timeoutInterval = 30;

        _engine.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/javascript", @"text/json", @"image/png", @"image/jpeg", @"application/json", @"text/plain", nil]; // 设置content-Type为text/html
    });
    
    return _engine;
}

#pragma mark - 请求接口方法
- (NSURLSessionDataTask *)requestWithPath:(NSString *)path
            requestType:(RequestType)requestType
        requestParamter:(NSDictionary *)requestParamter
     responseObjctClass:(Class)responseObjctClass
        completionBlock:(ResponseBlock)completionBlcok {
    
    //请求之前，至少更新一次用户信息
    if (!self.isUpdating) {
        NSFileManager *manager = [NSFileManager defaultManager];
        BOOL existPerson = [manager fileExistsAtPath:kAccountInfoFilePath];
        //用户已经退出登录的情况下，不会再获取用户信息
        if (existPerson) {
            [self updateUserInfoAction];
        }
    }
    
    //设置请求授权参数
    [self.requestSerializer setValue:kAccess_token forHTTPHeaderField:@"Authorization"];
    //支持put,delete
    self.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"GET",@"POST",@"PUT",@"DELETE"]];
    //发起请求
    return [self requestType:requestType path:path requestParamter:requestParamter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

            //debug模式下，打印调试输出
            FFLogInfo(@"URL = %@", path);
            if (requestParamter) {
                FFLogInfo(@"params : %@", requestParamter);
            }
            if (responseObjectWithJson != nil) {
                //debug下直接打印，release下输出json格式
#ifdef DEBUG
                FFLogInfo(@"RESPONSE JSON:%@", responseObjectWithJson);
#else
                FFLogInfo(@"RESPONSE JSON:%@", [responseObjectWithJson yy_modelToJSONString]);
#endif
            } else {
                FFLogInfo(@"RESPONSE JSON:%@", result);
            }

            //同步服务器当前时间
            if ([responseObjectWithJson objectForKey:@"timestamp"]) {
                NSInteger serverTimeStamp = [[responseObjectWithJson objectForKey:@"timestamp"] integerValue];
                if (serverTimeStamp > 0) {
                    [[NSUserDefaults standardUserDefaults] setObject:@(serverTimeStamp) forKey:kServerTimeKey];
                }
            }
            
            if ([[responseObjectWithJson objectForKey:@"errorCode"] integerValue] == 0) {
                
                if (responseObjctClass == nil || [responseObject isKindOfClass:[NSNull class]]) {
                    //如果不需要返回model，操作成功后，携带json数据直接返回
                    completionBlcok(YES, responseObjectWithJson, nil);
                    return;
                } else {
                    //请求成功，使用YYModel解析json，返回解析成功后的数据；如果解析失败，则返回空数据
                    [FetchModel fetchModelWithJson:responseObjectWithJson objctClass:responseObjctClass withCompletion:^(BOOL isSuccess, id object, NSError *error) {
                        completionBlcok(YES, object, nil);
                    }];
                    return;
                }
                
            } else if ([[responseObjectWithJson objectForKey:@"errorCode"] integerValue] == kNotLoginCode) {
                //如果未登录时，仅刷新一次token(每次发起请求时，重置self.re_requestTimes次数)，如果刷新之后，仍返回未登录，则直接返回错误信息
                if (self.re_requestTimes == 0) {
                    //如果请求为空或者请求非进行中，则重新请求刷新token
                    if (!self.loginTask || self.loginTask.state !=  NSURLSessionTaskStateRunning) {
                        //将当前的请求保存
                        __weak typeof(self) weakSelf = self;
                        RequestPathBlock recallBlock = ^ {
                            __strong typeof(self) strongSelf = weakSelf;
                            [strongSelf requestWithPath:path requestType:requestType requestParamter:requestParamter responseObjctClass:responseObjctClass completionBlock:completionBlcok];
                        };
                        [self.waitingTaskArray addObject:recallBlock];
                        //进行刷新token的请求
                        self.loginTask = [self refreshTokenRequestWithPath:path requestType:requestType requestParamter:requestParamter responseObjctClass:responseObjctClass completionBlock:completionBlcok];
                    } else {
                        if (path.length > 0) {
                            __weak typeof(self) weakSelf = self;
                            RequestPathBlock recallBlock = ^ {
                                __strong typeof(self) strongSelf = weakSelf;
                                [strongSelf requestWithPath:path requestType:requestType requestParamter:requestParamter responseObjctClass:responseObjctClass completionBlock:completionBlcok];
                            };
                            [self.waitingTaskArray addObject:recallBlock];
                        }
                    }
                    return;
                } else {
                    //刷新token一次之后，将错误信息转为NSError，返回错误信息
                    NSDictionary *responseDic = (NSDictionary *)responseObjectWithJson;
                    NSString *errorMsg;
                    if ([responseDic.allKeys containsObject:@"errMsg"]) {
                        errorMsg = [responseObjectWithJson objectForKey:@"errMsg"];
                    } else {
                        errorMsg = XYLString(@"network_service_unknowError");
                    }
                    completionBlcok(NO, nil, kMakeErrorAndCode(errorMsg, kNotLoginCode));
                    return;
                }
            } else {
                //操作错误时，将错误信息转为NSError，返回错误信息
                NSDictionary *responseDic = (NSDictionary *)responseObjectWithJson;
                NSString *errorMsg;
                if ([responseDic.allKeys containsObject:@"errMsg"]) {
                    errorMsg = [responseObjectWithJson objectForKey:@"errMsg"];
                } else {
                    errorMsg = XYLString(@"network_service_unknowError");
                }
                //转为model
                id responseClass = [responseObjctClass yy_modelWithJSON: responseObjectWithJson];
                //如果需要返回model，则将信息转为model，并返回错误信息；如果不需要返回model，则直接返回json和错误信息
                if (responseObjctClass == nil) {
                    completionBlcok(NO, responseObjectWithJson, kMakeErrorAndCode(errorMsg, [[responseObjectWithJson objectForKey:@"errorCode"] integerValue]));
                    return;
                } else {
                    completionBlcok(NO, responseClass, kMakeErrorAndCode(errorMsg, [[responseObjectWithJson objectForKey:@"errorCode"] integerValue]));
                    return;
                }
                
                
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *requestURL = [task.currentRequest.URL absoluteString];
        FFLogInfo(@"网络层错误 URL -- %@ \nPARAMS:%@ \nAND RESPONSE:%@ \nerror = %@", requestURL, requestParamter, task.response, error);
        //获取服务器错误信息
        NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if (data != nil) {
            NSError *error = [self dealErrorWithData:data];
            if (error) {
                completionBlcok(NO, nil, error);
                return;
            }
        }
        
        @weakify(self)
        [self showResponseCode:task.response WithBlock:^(NSInteger statusCode) {
            @strongify(self)
            NSError *handleError = [self getTYHttpErrorByServerError:error serverCode:statusCode serverTip:nil];
            completionBlcok(NO, nil, handleError);
        }];
    }];
}

#pragma mark 根据请求方式请求数据
- (NSURLSessionDataTask *)requestType:(RequestType)requestType
               path:(NSString *)path
    requestParamter:(NSDictionary *)requestParamter
            success:(void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
            failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure {
    
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
    } else if (requestType == putRequest) {         //put请求
        return [self PUT:path parameters:requestParamter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(task, responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(task, error);
        }];
    }
    
    return nil;
}

#pragma mark 处理错误信息
- (void)showResponseCode:(NSURLResponse *)response WithBlock:(void (^)(NSInteger statusCode))block{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    return block(responseStatusCode);
}

#pragma mark - 刷新token的方法
- (NSURLSessionDataTask *)refreshTokenRequestWithPath:(NSString *)path
                        requestType:(RequestType)requestType
                    requestParamter:(NSDictionary *)requestParamter
                 responseObjctClass:(Class)responseObjctClass
                    completionBlock:(ResponseBlock)completionBlcok {
    //接口请求路径
    NSString *post_path = CombinePath(TY_USER_HOST, TY_LOGINORREFRESH_TOKEN);
    //参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"refresh_token" forKey:@"grant_type"];
    id token = [CoachInfoModel sharedInstance].refresh_token;
    [parameters setObject:token?token:@"" forKey:@"refresh_token"];
    //设置授权参数
//    NSString *refreshToken = @"Basic Y29tLmljYXJib254LmlwaG9uZTp4SXI3YmQxOXVoTTVrNmxY";
    [self.requestSerializer setValue:Basic_Authrization forHTTPHeaderField:@"Authorization"];
    
    @weakify(self)
    return [self POST:post_path parameters:parameters progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self)
        //如果有返回值
        if (responseObject) {
            id response;
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                response = responseObject;
            } else if ([responseObject isKindOfClass:[NSData class]]) {
                response = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            }
            FFLogInfo(@"刷新token成功 = %@", response);
            //刷新token之后，更新token信息
            if ([response isKindOfClass:[NSDictionary class]]) {
                CoachInfoModel *coachModel = [CoachInfoModel sharedInstance];
                if (response[@"access_token"]) {
                    coachModel.access_token = response[@"access_token"];
                }
                //更新refresh_token
                if (response[@"refresh_token"]) {
                    coachModel.refresh_token = response[@"refresh_token"];
                }
                //登录请求成功后，登录刷新的标识
                self.re_requestTimes = 0;
                @weakify(self)
                [CoachInfoModel saveAccountInfo:coachModel completed:^{
                    @strongify(self)
                    //执行其他等待中的请求
                    [self executeWaitingRequest];
                }];
            }
        } else {            //没有返回值，直接回调失败
            self.re_requestTimes = 1;
            //执行其他等待中的请求
            [self executeWaitingRequest];
            completionBlcok(NO, nil, kMakeErrorAndCode(@"未登录", kNotLoginCode));
            FFLogInfo(@"调用刷新token失效");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        @strongify(self)
        self.re_requestTimes = 1;
        //移除等待中的请求
        [self.waitingTaskArray removeAllObjects];
        completionBlcok(NO, nil, kMakeErrorAndCode(@"未登录", kNotLoginCode));
        FFLogInfo(@"刷新token请求失败");
    }];
}

/** 执行等待中的请求 */
- (void)executeWaitingRequest {
    //执行等待中的请求
    for (NSInteger i=0; i<self.waitingTaskArray.count; i++) {
        id object = self.waitingTaskArray[i];
        RequestPathBlock block = (RequestPathBlock)object;
        block();
    }
    
    //执行完成之后，移除所有请求
    [self.waitingTaskArray removeAllObjects];
}

#pragma mark - json参数类型接口方法
- (NSURLSessionDataTask *)requestJsonWithPath:(NSString *)path
                                  requestType:(RequestType)requestType
                              requestParamter:(NSDictionary *)requestParamter
                           responseObjctClass:(Class)responseObjctClass
                              completionBlock:(ResponseBlock)completionBlcok {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//参数类型
    manager.requestSerializer.timeoutInterval = 30;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/javascript", @"text/json", @"image/png", @"image/jpeg", @"application/json", @"text/plain", nil];
    //设置请求授权参数
    [manager.requestSerializer setValue:kAccess_token forHTTPHeaderField:@"Authorization"];
    
    //发起请求
    return [self requestJsonType:requestType path:path requestParamter:requestParamter manager:manager success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

            //打印调试输出
            FFLogInfo(@"URL = %@", path);
            if (requestParamter) {
                FFLogInfo(@"params : %@", requestParamter);
            }
            if (responseObjectWithJson != nil) {
                //debug下直接打印，release下输出json格式
#ifdef DEBUG
                FFLogInfo(@"RESPONSE JSON:%@", responseObjectWithJson);
#else
                FFLogInfo(@"RESPONSE JSON:%@", [responseObjectWithJson yy_modelToJSONString]);
#endif
            } else {
                FFLogInfo(@"RESPONSE JSON:%@", result);
            }

            //同步服务器当前时间
            if ([responseObjectWithJson objectForKey:@"timestamp"]) {
                NSInteger serverTimeStamp = [[responseObjectWithJson objectForKey:@"timestamp"] integerValue];
                if (serverTimeStamp > 0) {
                    [[NSUserDefaults standardUserDefaults] setObject:@(serverTimeStamp) forKey:kServerTimeKey];
                }
            }
            
            if ([[responseObjectWithJson objectForKey:@"errorCode"] integerValue] == 0) {
                
                if (responseObjctClass == nil) {
                    //如果不需要返回model，操作成功后，携带json数据直接返回
                    completionBlcok(YES, responseObjectWithJson, nil);
                    return;
                } else {
                    //请求成功，使用YYModel解析json，返回解析成功后的数据；如果解析失败，则返回空数据
                    [FetchModel fetchModelWithJson:responseObjectWithJson objctClass:responseObjctClass withCompletion:^(BOOL isSuccess, id object, NSError *error) {
                        completionBlcok(YES, object, nil);
                    }];
                    return;
                }
                
            } else if ([[responseObjectWithJson objectForKey:@"errorCode"] integerValue] == kNotLoginCode) {
                //如果未登录时，仅刷新一次token(每次发起请求时，重置self.re_requestTimes次数)，如果刷新之后，仍返回未登录，则直接返回错误信息
                if (self.re_requestTimes == 0) {
                    //如果请求为空或者请求非进行中，则重新请求刷新token
                    if (!self.loginTask || self.loginTask.state !=  NSURLSessionTaskStateRunning) {
                        //将当前的请求保存
                        __weak typeof(self) weakSelf = self;
                        RequestPathBlock recallBlock = ^ {
                            __strong typeof(self) strongSelf = weakSelf;
                            [strongSelf requestJsonWithPath:path requestType:requestType requestParamter:requestParamter responseObjctClass:responseObjctClass completionBlock:completionBlcok];
                        };
                        [self.waitingTaskArray addObject:recallBlock];
                        //进行刷新token的请求
                        self.loginTask = [self refreshTokenRequestWithPath:path requestType:requestType requestParamter:requestParamter responseObjctClass:responseObjctClass completionBlock:completionBlcok];
                    } else {
                        if (path.length > 0) {
                            __weak typeof(self) weakSelf = self;
                            RequestPathBlock recallBlock = ^ {
                                __strong typeof(self) strongSelf = weakSelf;
                                [strongSelf requestJsonWithPath:path requestType:requestType requestParamter:requestParamter responseObjctClass:responseObjctClass completionBlock:completionBlcok];
                            };
                            [self.waitingTaskArray addObject:recallBlock];
                        }
                    }
                    return;
                } else {
                    //刷新token一次之后，将错误信息转为NSError，返回错误信息
                    NSDictionary *responseDic = (NSDictionary *)responseObjectWithJson;
                    NSString *errorMsg;
                    if ([responseDic.allKeys containsObject:@"errMsg"]) {
                        errorMsg = [responseObjectWithJson objectForKey:@"errMsg"];
                    } else {
                        errorMsg = XYLString(@"network_service_unknowError");
                    }
                    completionBlcok(NO, nil, kMakeErrorAndCode(errorMsg, kNotLoginCode));
                    return;
                }
            } else {
                //操作错误时，将错误信息转为NSError，返回错误信息
                NSDictionary *responseDic = (NSDictionary *)responseObjectWithJson;
                NSString *errorMsg;
                if ([responseDic.allKeys containsObject:@"errMsg"]) {
                    errorMsg = [responseObjectWithJson objectForKey:@"errMsg"];
                } else {
                    errorMsg = XYLString(@"network_service_unknowError");
                }
                //转为model
                id responseClass = [responseObjctClass yy_modelWithJSON: responseObjectWithJson];
                //如果需要返回model，则将信息转为model，并返回错误信息；如果不需要返回model，则直接返回json和错误信息
                if (responseObjctClass == nil) {
                    completionBlcok(NO, responseObjectWithJson, kMakeErrorAndCode(errorMsg, [[responseObjectWithJson objectForKey:@"errorCode"] integerValue]));
                    return;
                } else {
                    completionBlcok(NO, responseClass, kMakeErrorAndCode(errorMsg, [[responseObjectWithJson objectForKey:@"errorCode"] integerValue]));
                    return;
                }
                
                
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *requestURL = [task.currentRequest.URL absoluteString];
        FFLogInfo(@"网络层错误 URL -- %@ \nPARAMS:%@ \nAND RESPONSE:%@ \nerror = %@", requestURL, requestParamter, task.response, error);
        @weakify(self)
        [self showResponseCode:task.response WithBlock:^(NSInteger statusCode) {
            @strongify(self)
            NSError *handleError = [self getTYHttpErrorByServerError:error serverCode:statusCode serverTip:nil];
            completionBlcok(NO, nil, handleError);
        }];
    }];
}

- (NSURLSessionDataTask *)requestJsonType:(RequestType)requestType
               path:(NSString *)path
        requestParamter:(NSDictionary *)requestParamter
                manager:(AFHTTPSessionManager *)manager
            success:(void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
            failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure {
    if (requestType == postRequest) {               //post请求
        return [manager POST:path parameters:requestParamter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(task, responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(task, error);
        }];
    } else if (requestType == getRequest) {         //get请求
        return [manager GET:path parameters:requestParamter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(task, responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(task, error);
        }];
    } else if (requestType == putRequest) {         //put请求
        return [manager PUT:path parameters:requestParamter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(task, responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(task, error);
        }];
    }
    return nil;
}

#pragma mark - 用户接口 
- (void)userInterfaceWithPath:(NSString *)path authrization:(NSString *)authrization requestType:(RequestType)type requestParamter:(NSDictionary *)requestParamter  completionBlock:(ResponseBlock)completionBlcok {
    //设置授权参数和请求头
//    self.requestSerializer = [AFHTTPRequestSerializer serializer];//登录需要
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];//登录需要
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];//登录
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions: NSJSONReadingMutableContainers];
    manager.requestSerializer.timeoutInterval = 30;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain",nil];
    if (authrization.length > 0) {
        [manager.requestSerializer setValue:authrization forHTTPHeaderField:@"Authorization"];
    }
    
    if (type == postRequest) {
        [manager POST:path parameters:requestParamter progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            FFLogInfo(@"task = %@", task.response);
            
            if (responseObject == nil) {
                completionBlcok(NO, nil, kMakeErrorAndCode(XYLString(@"network_service_noResponse"), -1));
            } else {
                completionBlcok(YES, responseObject, nil);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSString *requestURL = [task.currentRequest.URL absoluteString];
            FFLogInfo(@"网络层错误 URL -- %@  \nAND RESPONSE:%@", requestURL, task.response);
            if (requestParamter) {
                FFLogInfo(@"失败参数 : %@", requestParamter);
            }
            //获取服务器错误信息
            NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            if (data != nil) {
                NSError *error = [self dealErrorWithData:data];
                if (error) {
                    completionBlcok(NO, nil, error);
                    return;
                }
            }
            
            __weak typeof(self) weakSelf = self;
            [self showResponseCode:task.response WithBlock:^(NSInteger statusCode) {
                NSError *handleError = [weakSelf getTYHttpErrorByServerError:error serverCode:statusCode serverTip:nil];
                completionBlcok(NO, nil, handleError);
            }];
        }];
    } else {
        [manager GET:path parameters:requestParamter progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            FFLogInfo(@"获取用户信息返回 = %@", responseObject);
            
            if (responseObject == nil) {
                completionBlcok(NO, nil, kMakeErrorAndCode(XYLString(@"network_service_noResponse"), -1));
            } else {
                completionBlcok(YES, responseObject, nil);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSString *requestURL = [task.currentRequest.URL absoluteString];
            FFLogInfo(@"网络层错误 URL -- %@ \nAND RESPONSE:%@", requestURL, task.response);
            if (requestParamter) {
                FFLogInfo(@"失败参数 : %@", requestParamter);
            }
            //获取服务器错误信息
            NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            if (data != nil) {
                NSError *error = [self dealErrorWithData:data];
                if (error) {
                    completionBlcok(NO, nil, error);
                    return;
                }
            }
            
            __weak typeof(self) weakSelf = self;
            [self showResponseCode:task.response WithBlock:^(NSInteger statusCode) {
                NSError *handleError = [weakSelf getTYHttpErrorByServerError:error serverCode:statusCode serverTip:nil];
                completionBlcok(NO, nil, handleError);
            }];
        }];
    }
}

/** 提取网络层的错误信息 */
- (NSError *)dealErrorWithData:(NSData *)data {
    
    NSString *errorMsg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (errorMsg.length > 0) {
        NSData *jsonData = [errorMsg dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        NSString *errorKey = dic[@"error"];
        NSString *desc = dic[@"error_description"];
        NSString *wechatToken = dic[@"token"];
        NSString *message = nil;
        NSInteger errorCode = -1;
        if ([errorKey isEqualToString:@"username.or.password.incorrect"]) {
            //密码与账户不匹配
            message = XYLString(@"login_error_passwordIncorrect");
        } else if ([errorKey isEqualToString:@"username.validator.fail"]) {
            //账号格式不正确
            message = XYLString(@"login_error_incorrectAccount");
        } else if ([errorKey isEqualToString:@"invalid_grant"] || [errorKey isEqualToString:@"verify.code.failed"]) {
            //验证码有误
            message = XYLString(@"login_error_errorVerifyCode");
        } else if ([errorKey isEqualToString:@"username.not.exist"]) {
            //用户不存在时，发送验证码，并跳转到注册页面
            message = errorKey;
            errorCode = kRegisterErrorCode;
        } else if ([errorKey isEqualToString:@"forgetKey.validator.fail"]) {
            //修改超时，请重试
            message = XYLString(@"login_password_checkCodeError");
            errorCode = kForgetKeyInvalid; 
        } else if ([errorKey isEqualToString:@"password.not.comply.specification"]) {
            //修改失败，原因：密码不符合规范
            message = XYLString(@"login_password_non-compliant");
        } else if ([errorKey isEqualToString:@"inconsistent.password.twice"]) {
            //修改失败，原因：两次输入的密码不一致
            message = XYLString(@"login_password_reason-different");
        } else if ([errorKey isEqualToString:@"wechat.not.exist"]) {
            //参数错误
            message = XYLString(@"login_bind_error");
        } else if ([errorKey isEqualToString:@"wechatToken.time.out"] || [errorKey isEqualToString:@"wechat.code.expire"]) {
            //微信授权已超时
            message = XYLString(@"login_bind_timeout");
        } else if ([errorKey isEqualToString:@"mobile.bind"]) {
            //该手机号已绑定微信
            message = XYLString(@"login_bind_already");
        } else if ([errorKey isEqualToString:@"account.not.exist"]) {
            //微信未与手机绑定
            errorCode = kWechatBindErrorCode;
        } else if ([errorKey isEqualToString:@"no.need.modify.same.account"]) {
            //相同的账户不需要修改
            message = XYLString(@"me_update_sameAccount");
        } else if ([errorKey isEqualToString:@"user.already.exists"]) {
            //账户已经存在
            message = XYLString(@"me_update_accountExist");
        } else if ([errorKey isEqualToString:@"code.validator.fail"]) {
            //验证码有误
            message = XYLString(@"me_update_errorCode");
        } else if ([errorKey isEqualToString:@"user.already.exists"]) {
            //账号已存在
            message = XYLString(@"login_bind_exist");
        } else if ([errorKey isEqualToString:@"password.validator.fail"]) {
            //密码不符合规范
            message = XYLString(@"login_error_passwordFormat");
        } else if ([errorKey isEqualToString:@"userName.not.exist"]) {
            //账号不存在
            message = XYLString(@"login_reset_accountNotExist");
        }
        
        if (message.length > 0) {
            return kMakeErrorAndCode(message, errorCode);
        } else if (wechatToken.length > 0) {
            return kMakeErrorAndCode(wechatToken, errorCode);
        } else if (desc.length > 0) {
            return kMakeErrorAndCode(desc, errorCode);
        }
    }
    return nil;
}

//更新用户信息接口
- (void)updateUserInfoAction {
    //是否更新过用户信息
    BOOL isUpdated = [[[NSUserDefaults standardUserDefaults] objectForKey:kIsUpdateUserInfoKey] boolValue];
    //如果已经登录，并且需要更新用户信息时，调用接口更新用户信息
    if ([CoachInfoModel sharedInstance].access_token.length > 0 && !isUpdated) {
        //如果更新请求，或者请求状态不是进行中，则可以进行更新用户信息请求
        if (!self.updateUserInfoTask || self.updateUserInfoTask.state != NSURLSessionTaskStateRunning) {
            self.isUpdating = YES;
            self.updateUserInfoTask = [Networking requestWithPath:CombinePath(TY_DEBUG_HOST, GET_COACH_SELF_INFO) requestType:postRequest requestParamter:nil responseObjctClass:[CoachInfoDataModel class] completionBlock:^(BOOL isSuccess, id object, NSError *error) {
                //已更新用户信息
                self.isUpdating = NO;
                [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:kIsUpdateUserInfoKey];
                
                if (isSuccess) {
                    //获取到用户信息，并更新
                    CoachInfoDataModel *dataObject = (CoachInfoDataModel *)object;
                    CoachInfoModel *coachModel = dataObject.data;
                    if (coachModel) {
                        //设置token
                        coachModel.access_token = [CoachInfoModel sharedInstance].access_token;
                        coachModel.refresh_token = [CoachInfoModel sharedInstance].refresh_token;
                        [CoachInfoModel saveAccountInfo:coachModel completed:nil];
                    }
                } else {
                    //如果请求失败了,不处理
                }
            }];
        }
    } else {
        //如果请求失败了,不处理
    }
}

#pragma mark - 获取授权
- (void)obtainAuthorizationWithPath:(NSString *)path completionBlock:(ResponseBlock)completionBlcok {
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[CoachInfoModel sharedInstance].access_token] forHTTPHeaderField:@"Authorization"];
    
    [self POST:path parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        completionBlcok(YES, responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *requestURL = [task.currentRequest.URL absoluteString];
        FFLogInfo(@"网络层错误 URL -- %@ \nAND RESPONSE:%@", requestURL, task.response);
        @weakify(self)
        [self showResponseCode:task.response WithBlock:^(NSInteger statusCode) {
            @strongify(self)
            NSError *handleError = [self getTYHttpErrorByServerError:error serverCode:statusCode serverTip:nil];
            completionBlcok(NO, nil, handleError);
        }];
    }];
}

- (NSError *)getTYHttpErrorByServerError:(NSError *)error serverCode:(NSInteger)serverCode serverTip:(NSString *)serverTip {
    NSString *errorMsg = @"";
    NSInteger errorCode = -2015000;
    NSDictionary *userInfo = nil;
    
    if (error) { //网络底层请求出错 -> (网络请求,错误回调返回的错)
//        errorMsg = [error.domain isEqualToString:@"NSURLErrorDomain"] ? @"服务器内部繁忙,请稍后重试" : error.domain;
        if (error && error.userInfo && error.userInfo[NSLocalizedDescriptionKey]) {
            errorMsg = error.userInfo[NSLocalizedDescriptionKey];
        } else {
            errorMsg = @"服务器内部繁忙,请稍后重试";
        }
        errorCode = error.code;
        userInfo = error.userInfo;
        
    } else { // 服务器请求失败 -> (网络请求,非0,200的返回码)
        errorCode = serverCode;
        errorMsg = serverTip;
    }
    
    //规避两个错误码一样而不能退出登录的问题
    if (errorCode == Code_ShopUExist) {
        if ([errorMsg rangeOfString:HasSameShopNameError].location != NSNotFound ||
            [errorMsg rangeOfString:@"登录账户已经存在"].location != NSNotFound)
        {
            errorCode = -errorCode;
        }
    }
    
    //在这里自定义错误码的提示信息
    switch (errorCode) {
        case -1011:
        {
            errorMsg = ServerConnectFail;
        }
            break;
            
        case -1001:
        case -1004:
        {
            errorMsg = RequestTimeOut;
        }
            break;
            
        case Code_AgainLoginThree:      //请求错误需要重新登录
        case Code_AgainLoginFour:       //请求错误需要重新登录
        case Code_AgainLoginsFifth:     //请求错误需要重新登录
            //        case Code_ShopUExist:           //请求错误需要重新登录 <警告:正式打包要干掉50001错误码的判断>
        {
            NSLog(@"处理服务端特殊Code");
            //退出登录
            [TYGlobalManager logoutDealWithFMDB];
        }
            break;
            
        case GJNoInterneErrorCode: //网络连接失败
        {
            errorMsg = NetworkConnectFail;
        }
            break;
            
        default:
            break;
    }
    
    if (errorMsg == nil) {
        errorMsg = @"";//Domain不能为空
    }
    
    NSError *httpError = [[NSError alloc] initWithDomain:errorMsg code:errorCode userInfo:@{NSLocalizedDescriptionKey: errorMsg}];
    
    return httpError;
}

#pragma mark - getter
- (NSMutableArray *)waitingTaskArray {
    if (!_waitingTaskArray) {
        _waitingTaskArray = [NSMutableArray array];
    }
    return _waitingTaskArray;
}

/** 登录时的默认token */
+ (NSString *)getBasicAuthorizationWithAppID:(NSString *)appID appSecret:(NSString *)appSecret {
    //先将string转换成data
    NSString *needEncodeStr = [NSString stringWithFormat:@"%@:%@",appID,appSecret];
    NSData *data = [needEncodeStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *base64Data = [data base64EncodedDataWithOptions:0];
    
    NSString *baseString = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
    
    return [NSString stringWithFormat:@"Basic %@",baseString];
}

@end
