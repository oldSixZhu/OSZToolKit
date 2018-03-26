//
//  NSObject+ModelDescription.h
//  MTime
//
//  Created by imac on 2017/8/26.
//  Copyright © 2017年 imac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ModelDescription)

- (NSString *)modelDescription;

/** 获取类的所有属性 */
+ (void)showProperties;

/** 获取类的所有方法 */
+ (void)showStudentClassMethods;

/** 获取对象的所有属性 以及属性值 */
- (NSDictionary *)properties_aps;

@end
