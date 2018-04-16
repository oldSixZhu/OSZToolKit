//
//  MeNetworkManager.m
//  demo
//
//  Created by TanYun on 2018/4/16.
//  Copyright © 2018年 icarbonx. All rights reserved.
//

#import "MeNetworkManager.h"

@implementation MeNetworkManager

/// 获取所有朋友列表
+ (RACSignal *)getAllFriends {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //二次封装AFN网络请求类,大概就是这个意思
        [[NetworkTool sharedInstance] requestWithPath:@"url" requestType:@"get" requestParamter:nil responseObjctClass:[FriendModel class] completionBlock:^(BOOL isSuccess, id object, NSError *error) {
            if (isSuccess) {
                [subscriber sendNext:object];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
            }
        }];
        return nil;
    }];
}

/// 添加朋友
+ (RACSignal *)addFriendWithPersonID:(NSInteger)personID {
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    [paramter setObject:@(personID) forKey:@"personID"];
    
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [[NetworkTool sharedInstance] requestWithPath:@"url" requestType:@"post" requestParamter:paramter responseObjctClass:nil completionBlock:^(BOOL isSuccess, id object, NSError *error) {
            if (isSuccess) {
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
            }
        }];
        return nil;
    }];
}


@end
