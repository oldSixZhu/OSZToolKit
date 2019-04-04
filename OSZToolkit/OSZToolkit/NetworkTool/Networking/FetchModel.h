//
//  FetchModel.h
//  TYFitFore
//
//  Created by apple on 2018/2/2.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FetchModel : NSObject

+ (void)fetchModelWithJson:(NSDictionary *)responseObjectWithJson objctClass:(Class)responseObjctClass withCompletion:(void (^)(BOOL isSuccess, id object, NSError *error))completion;

@end

//====================================================

@interface FetchMappingModel : NSObject

@property (nonatomic, copy) NSArray *data;

@end
