//
//  CookieManager.h
//  Meum
//
//  Created by 吕佳珍 on 2017/5/16.
//  Copyright © 2017年 huangwei. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <WebKit/WebKit.h>

@interface CookieManager : NSObject

@property (nonatomic, strong) WKProcessPool *processPool;

+ (instancetype)sharedInstance;
+ (void)clearCookie;

@end
