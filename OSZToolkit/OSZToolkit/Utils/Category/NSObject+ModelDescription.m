//
//  NSObject+ModelDescription.m
//  MTime
//
//  Created by imac on 2017/8/26.
//  Copyright © 2017年 imac. All rights reserved.
//

#import "NSObject+ModelDescription.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSObject (ModelDescription)

- (NSString *)modelDescription {
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    //得到当前class的所有属性
    uint count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    //循环并用KVC得到每个属性的值
    for (int i = 0; i<count; i++) {
        objc_property_t property = properties[i];
        NSString *name = @(property_getName(property));
        id value = [self valueForKey:name]?:@"nil";//默认值为nil字符串
        [dictionary setObject:value forKey:name];//装载到字典里
    }
    free(properties);
    return [NSString stringWithFormat:@"<%@: %p> -- %@",[self class],self,dictionary];
}

#pragma mark - 获取类的所有属性
+ (void)showProperties {
    Class cls = [self class];
    unsigned int count;
    while (cls != [NSObject class]) {
        objc_property_t *properties = class_copyPropertyList(cls, &count);
        for (int i = 0; i<count; i++) {
            objc_property_t property = properties[i];
            NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            NSLog(@"属性名==%@",propertyName);
        }
        if (properties){
            //要释放
            free(properties);
        }
        //得到父类的信息
        cls = class_getSuperclass(cls);
    }
}

#pragma mark - 获取类的所有方法
+ (void)showStudentClassMethods {
    unsigned int count;
    Class cls = [self class];
    while (cls != [NSObject class]) {
        Method *methods = class_copyMethodList(cls, &count);
        for (int i=0; i < count; i++) {
            NSString *methodName = [NSString stringWithCString:sel_getName(method_getName(methods[i])) encoding:NSUTF8StringEncoding];
            NSLog(@"方法名：%@ ", methodName);
        }
        if (methods) {
            free(methods);
        }
        cls = class_getSuperclass(cls);
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    /* 1. 拿到对象的成员变量列表 */
    /* 1.1 定义一个unsigned int 类型的变量, 将变量的指针传给下面的函数 */
    unsigned int outCount = 0;
    /* 1.2 拿到对象的成员变量列表  */
    Ivar *ivarList = class_copyIvarList([self class], &outCount);
    /* 2. 遍历成员变量列表, 对属性进行归档操作 */
    for (int i = 0; i < outCount; i++) {
        /* 2.1 拿到对象的名字'C'字符串  */
        const char *ivar = ivar_getName(ivarList[i]);
        /* 2.2 转化成OC字符串 */
        NSString *key = [NSString stringWithUTF8String:ivar];
        /* 2.3 通过成员变量的名称拿到成员变量的值*/
        id value = [self valueForKey:key];
        /* 2.4 将key和value进行归档 */
        [aCoder encodeObject:value forKey:key];
    }
    /* 3. 释放ivarList */
    free(ivarList);
}

#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    /* 1. 拿到成员变量列表 */
    /* 1.1 定义一个unsigned int类型的变量, 将指针传给下面的函数 */
    unsigned int outCount = 0;
    /* 1.2 拿到成员变量列表 */
    Ivar *ivarList = class_copyIvarList([self class], &outCount);
    /* 2. 遍历成员变量列表, 将里面的每个键值对读出来赋值给对象 */
    for (int i = 0; i < outCount; i++) {
        /* 2.1 拿到成员变量名'C'字符串 */
        const char *ivar = ivar_getName(ivarList[i]);
        /* 2.2 转换成OC字符串 */
        NSString *key = [NSString stringWithUTF8String:ivar];
        /* 2.3 根据key解档拿到value */
        id value = [aDecoder decodeObjectForKey:key];
        /* 2.4 利用KVC给对象赋值 */
        if (value) {
            [self setValue:value forKey:key];
        }
        
    }
    /* 3. 释放ivarList */
    free(ivarList);
    /* 4. 将对象返回出去 */
    return self;
}

- (NSDictionary *)properties_aps {
    
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i<outCount; i++) {
        objc_property_t property = properties[i];
        
        const char* char_f =property_getName(property);
        
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    
    free(properties);
    return props;
}

@end
