//
//  OSZNetWorkTool.h
//  网易新闻 1.0
//
//  Created by oldSix_Zhu on 16/8/14.
//  Copyright © 2016年 oldSix_Zhu. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface OSZNetWorkTool : AFHTTPSessionManager

+(instancetype)sharedOSZNetWorkTool;

@end
