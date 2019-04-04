//
//  AddressModel.m
//  FitForceCoach
//
//  Created by fun on 2019/1/2.
//

#import "AddressModel.h"



@implementation AddressModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"districts": [AddressModel class]};
}


@end
