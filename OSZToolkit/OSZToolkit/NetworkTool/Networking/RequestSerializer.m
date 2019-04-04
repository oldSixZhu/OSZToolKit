//
//  RequestSerializer.m
//  NetworkAdapter
//
//  Created by bluedaquiri on 16/7/5.
//  Copyright © 2016年 blue. All rights reserved.
//  请求头

#import "RequestSerializer.h"

@implementation RequestSerializer

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(id)parameters error:(NSError *__autoreleasing  _Nullable *)error {
    NSMutableURLRequest *request = [super requestWithMethod:method URLString:URLString parameters:parameters error:error];
    
    return request;
}
@end
