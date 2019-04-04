//
//  FetchModel.m
//  TYFitFore
//
//  Created by apple on 2018/2/2.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import "FetchModel.h"

#import <YYModel/YYModel.h>
#import <objc/runtime.h>

static Class classKey;

@implementation FetchMappingModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    if (classKey) {
        return @{@"data": classKey};
    } else {
        return [NSDictionary dictionary];
    }
}

@end

//====================================================

@implementation FetchModel

+ (void)fetchModelWithJson:(NSDictionary *)responseObjectWithJson objctClass:(Class)responseObjctClass withCompletion:(void (^)(BOOL, id, NSError *))completion {
    
    //如果返回json有data数据，并且指定responseObjctClass不包含data层，则开始解析data层
    id dataValue = [responseObjectWithJson objectForKey:@"data"];
    if (dataValue && ![dataValue isKindOfClass:[NSNull class]]) {
        //如果data层是一个数组
        if ([dataValue isKindOfClass:[NSArray class]]) {
            
            if (![self isConstainsDataProperty:responseObjctClass]) {
                //设置解析类名
                classKey = responseObjctClass;
                FetchMappingModel *modelArray = [FetchMappingModel yy_modelWithJSON:responseObjectWithJson];
                if (modelArray) {
                    //将解析成功后的数组返回
                    completion(YES, modelArray.data, nil);
                } else {
                    completion(YES, nil, nil);
                }
            } else {
                //如果responseObjctClass包含data属性，则直接解析
                id responseClass = [responseObjctClass yy_modelWithJSON: responseObjectWithJson];
                if (responseClass) {
                    //解析成功，返回model
                    completion(YES, responseClass, nil);
                } else {
                    //解析失败，返回nil
                    completion(YES, nil, nil);
                }
            }
            
        } else { //如果data层是一个对象
            //解析后的model对象
            id responseClass = nil;
            if (![self isConstainsDataProperty:responseObjctClass]) {
                //如果responseObjctClass不包含data，则解析data内层
                responseClass = [responseObjctClass yy_modelWithDictionary:dataValue];
                
            } else {
                //如果responseObjctClass包含data，则解析data层
                responseClass = [responseObjctClass yy_modelWithJSON: responseObjectWithJson];
            }
            
            if (responseClass) {
                //解析成功，返回model
                completion(YES, responseClass, nil);
            } else {
                //解析失败，返回nil
                completion(YES, nil, nil);
            }
        }
        
        
    } else {
        //刷新token接口没有data层，或者指定responseObjctClass包含data属性，则直接开始解析json
        id responseClass = [responseObjctClass yy_modelWithJSON: responseObjectWithJson];
        if (responseClass) {
            //解析成功，返回model
            completion(YES, responseClass, nil);
        } else {
            //解析失败，返回nil
            completion(YES, nil, nil);
        }
    }
}

//判断指定的Class是否包含data属性
+ (BOOL)isConstainsDataProperty:(Class)responseObjctClass {
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(responseObjctClass, &count);
    for(int i = 0; i < count; i++) {
        objc_property_t property = *properties;
        
        //判断当前传入model，是否有一个NSArray类型的data属性
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        if (propertyName && [propertyName isEqualToString:@"data"]) {
            /*
            NSString *propertyType = [NSString stringWithUTF8String:property_getAttributes(property)];
            if (propertyType && [propertyType containsString:@"NSArray"]) {
                //释放properties
                free(properties);
                return YES;
            }
             */
            //释放properties
            free(properties);
            return YES;
        }
    }
    free(properties);

    return NO;
}

@end


