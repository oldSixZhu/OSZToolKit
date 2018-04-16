//
//  MeNetworkManager.h
//  demo
//
//  Created by TanYun on 2018/4/16.
//  Copyright © 2018年 icarbonx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "NetworkTool.h"
#import "FriendModel.h"

@interface MeNetworkManager : NSObject


/// 获取所有朋友列表
+ (RACSignal *)getAllFriends;

/// 添加朋友
+ (RACSignal *)addFriendWithPersonID:(NSInteger)personID;


@end
