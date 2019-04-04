//
//  UINavigationController+pop.h
//  FitForceCoach
//
//  Created by apple on 2019/3/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (pop)

@property (nonatomic, copy, nullable) void (^popCompletion)(void);                        /**< pop完成之后  */

@end 

NS_ASSUME_NONNULL_END
