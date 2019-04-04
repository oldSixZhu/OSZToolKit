//
//  LaunchOperation.h
//  FitForceCoach
//
//  Created by apple on 2018/3/1.
//

#import <Foundation/Foundation.h>

#import "CoachWorkGymManager.h"                                         //我的健身房

@interface LaunchOperation : NSObject

@property (nonatomic, strong) CoachWorkGymManager *coachWorkGymManager;                     /**< 教练健身房Flutter页面  */

/** 启动设置 */
- (void)launchSettingsWithOptions:(NSDictionary *)launchOptions;

/** 根视图 */
+ (UIViewController *)rootViewController;
/** 推送处理 */
+ (void)pushLaunchingWithOptions:(NSDictionary *)launchOptions;

@end
