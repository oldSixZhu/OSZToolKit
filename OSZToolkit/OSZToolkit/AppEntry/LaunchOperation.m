//
//  LaunchOperation.m
//  FitForceCoach
//
//  Created by apple on 2018/3/1.
//

#import "LaunchOperation.h"

#import "LoginViewModel.h"
#import "RemotePushModel.h"
#import "SportVersionModel.h"
#import "UpgradeAlertController.h"                                      //升级弹窗

#import "AppDelegate.h"
#import "BaseTabBarViewController.h"
#import "BaseNavigationController.h"
#import "LoginVC.h"                                                     //登录
#import "CourseViewController.h"                                        //课程首页
#import "GuideViewController.h"                                         //引导页
#import "CourseHistoryViewController.h"                                 //课程历史
#import "HistoryInviteViewController.h"                                 //邀约历史

//第三方库
#import <IQKeyboardManager.h>
#import <AvoidCrash.h>
#import <Bugly/Bugly.h>
#import <JPUSHService.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"
#import "Growing.h"
#import <QCloudCore/QCloudCore.h>
#import <QCloudCOSXML/QCloudCOSXMLTransfer.h>
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

//极光推送appkey
#define JPush_AppKey @"d55619995db8919e27589055"
#define JPush_AppKey_Test @"7b0d510f8dd1e5ff2599a171"
//微信分享的AppId和AppSecret
#define WX_AppId @"wxa1097dd80cc55ad0"
#define WX_AppSecret @"a5ef1ce787f5787dc71801e58768e981"
//GrowingIO 测试环境 URL scheme：growing.d8ab7a526923d5fe
#define GrowingIO_AppId @"bdd6ede9cc7cb1da"
//GrowingIO 正式环境 URL scheme：growing.1ca73d9147b39e87
#define GrowingIO_AppId_Release @"8e034881f690dd73"

@interface LaunchOperation () <JPUSHRegisterDelegate, QCloudSignatureProvider, QCloudCredentailFenceQueueDelegate>

@property (nonatomic, strong) NSURLSessionDataTask *updateUserInfoTask;                     /**< 更新用户信息请求  */
@property (nonatomic, strong) UpgradeAlertController *upgradeAlertVC;                       /**< 升级提示弹窗  */
@property (nonatomic, strong) QCloudCredentailFenceQueue *credentialFenceQueue;             /**< 腾讯云存储签名  */

@end

@implementation LaunchOperation

#pragma mark - 启动设置
- (void)launchSettingsWithOptions:(NSDictionary *)launchOptions {
    
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = XYLString(@"base_keyboard_done");
    
#ifdef DEBUG       //调试环境
    /*   切换环境配置：
         1、修改bundle id
         2、TYFirfore.pch文件中的 isIDC 宏定义修改
         3、GrowingIO的URL scheme修改
         4、bugly shell脚本文件中修改bundle id
     */
#else              //发布环境
    //防止程序崩溃
    [AvoidCrash becomeEffective];
    //bug上报
    BuglyConfig *config = [[BuglyConfig alloc] init];
    config.debugMode = YES;
    config.blockMonitorEnable = YES;
    config.unexpectedTerminatingDetectionEnable = YES;
    [Bugly startWithAppId:@"9ba170b186" config:config];
    
    // 启动GrowingIO 发布版本时使用
    [Growing startWithAccountId:isIDC?GrowingIO_AppId_Release:GrowingIO_AppId];
#endif
    
#if TARGET_IPHONE_SIMULATOR
#else
    //推送初始化
    [self configJPushWithOptions:launchOptions];
#endif
    
    //应用启动期时，设置需要更新用户信息
    [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:kIsUpdateUserInfoKey];
    
    // 监听网络状况
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:                    // 未知
                break;
            case AFNetworkReachabilityStatusNotReachable:               // 无连接
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:           // WIFI
            case AFNetworkReachabilityStatusReachableViaWWAN:           // 2G 3G 4G
            {
                NSLog(@"----------WiFi OR WWAN----------");
                //更新用户信息
                [Networking updateUserInfoAction];
                //检测版本
                [self serverLevel];
            }
                break;
            default:
                break;
        }
    }];
    [mgr startMonitoring];
    //分享
    [self shareSettings];
    //注册微信
    [WXApi registerApp:WX_AppId];
    //重置当前记录的服务器时间
    [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:kServerTimeKey];
    //开启日志记录
    //日志语句写入到一个文件中
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24;
    fileLogger.logFileManager.maximumNumberOfLogFiles = 1;
    [DDLog addLogger:fileLogger];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];         //发送日志语句到Xcode控制台，如果可用
    
    //腾讯云存储
    [self setupCOSXMLShareService];
}

#pragma mark - 腾讯云存储
- (void)setupCOSXMLShareService {
    //配置
    QCloudServiceConfiguration *configuration = [QCloudServiceConfiguration new];
    configuration.appID = kQCloudAppID;
    configuration.signatureProvider = self;
    QCloudCOSXMLEndPoint *endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = kQCloudRegion;
    configuration.endpoint = endpoint;
    [QCloudCOSXMLService registerDefaultCOSXMLWithConfiguration:configuration];
    [QCloudCOSTransferMangerService registerDefaultCOSTransferMangerWithConfiguration:configuration];
    //签名
    self.credentialFenceQueue = [QCloudCredentailFenceQueue new];
    self.credentialFenceQueue.delegate = self;
}

- (void)signatureWithFields:(QCloudSignatureFields *)fileds request:(QCloudBizHTTPRequest *)request urlRequest:(NSMutableURLRequest *)urlRequst compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock {
    QCloudCredential *credential = [QCloudCredential new];
    credential.secretID  = kQCloudSecretID;
    credential.secretKey = kQCloudSecretKey;
    //设置签名有效期为一个月
    credential.experationDate = [NSDate afterDateFrom:[NSDate serverDate] between:31];
    QCloudAuthentationV5Creator *creator = [[QCloudAuthentationV5Creator alloc] initWithCredential:credential];
    QCloudSignature *signature = [creator signatureForData:urlRequst];
    continueBlock(signature, nil);
}

- (void)fenceQueue:(QCloudCredentailFenceQueue *)queue requestCreatorWithContinue:(QCloudCredentailFenceQueueContinue)continueBlock {
    QCloudCredential *credential = [QCloudCredential new];
    credential.secretID = kQCloudSecretID;
    credential.secretKey = kQCloudSecretKey;
    //设置签名有效期为一个月
    credential.experationDate = [NSDate afterDateFrom:[NSDate serverDate] between:31];
    QCloudAuthentationV5Creator *creator = [[QCloudAuthentationV5Creator alloc] initWithCredential:credential];
    continueBlock(creator, nil);
}

#pragma mark - 版本升级提示
- (void)serverLevel {
    //本地检测到的服务器最新版本
    NSString *newestVersion = [Tools avoidNull:[[NSUserDefaults standardUserDefaults] objectForKey:kUpdateVersionKey]];
    //上次提示更新的日期
    NSDate *remindDate = [[NSUserDefaults standardUserDefaults] objectForKey:kUpdateDateKey];
    //app当前版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurrentVersion = [Tools avoidNull:[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    //版本更新检查路径
    NSString *checkUrlPath = [NSString stringWithFormat:@"%@/Coach/IOS/%@", CombinePath(TY_DEBUG_HOST, SPORT_FITFORCE_VERSION), appCurrentVersion];
    @weakify(self)
    [Networking requestWithPath:checkUrlPath requestType:postRequest requestParamter:nil responseObjctClass:[SportVersionModel class] completionBlock:^(BOOL isSuccess, id object, NSError *error) {
        @strongify(self)
        if (isSuccess) {
            SportVersionModel *versionModel = (SportVersionModel *)object;
            //检查更新
            if (versionModel && versionModel.downloadURL.length && versionModel.notes.length && versionModel.upgradeType.length && versionModel.targetVersion.length) {
                //升级类型：Force是强制升级，Choice是选择升级
                if ([versionModel.upgradeType isEqualToString:@"Force"]) {
                    //强制更新每次启动都提示
                    [self upgradeWithVersion:versionModel.targetVersion detail:versionModel.notes url:versionModel.downloadURL isForce:YES];
                    //提示升级后，记录最新版本号
                    [[NSUserDefaults standardUserDefaults] setObject:versionModel.targetVersion forKey:kUpdateVersionKey];
                } else {
                    //非强制更新的情况，根据条件提示：
                    //1、当前记录的最新版本号跟获取到的最新版本号不一致时，提示更新
                    //2、上次更新的时间已经过期
                    if (![newestVersion isEqualToString:versionModel.targetVersion] || [NSDate isExpiredDate:remindDate]) {
                        //升级类型：Force是强制升级，Choice是选择升级 (选择升级时，如果是首页，才显示)
                        [self upgradeWithVersion:versionModel.targetVersion detail:versionModel.notes url:versionModel.downloadURL isForce:NO];
                        //提示升级后，记录最新版本号
                        [[NSUserDefaults standardUserDefaults] setObject:versionModel.targetVersion forKey:kUpdateVersionKey];
                    }
                }
            }
        }
    }];
}

/** 升级提示 */
- (void)upgradeWithVersion:(NSString *)version detail:(NSString *)detail url:(NSString *)url isForce:(BOOL)isForce {
    //设置升级弹窗参数
    if (!self.upgradeAlertVC) {
        self.upgradeAlertVC = [[UpgradeAlertController alloc] init];
    }
    
    self.upgradeAlertVC.isForce = isForce;
    [self.upgradeAlertVC popUpWithVersion:version detail:detail];
    self.upgradeAlertVC.upgradeCallback = ^{
        //跳转到App Store
        UIApplication *application = [UIApplication sharedApplication];
        if ([application canOpenURL:[NSURL URLWithString:url]]) {
            [application openURL:[NSURL URLWithString:url]];
        }
    };
    
    //在根视图上弹出升级提示
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (keyWindow) {
        [keyWindow addSubview:self.upgradeAlertVC.view];
    }
     
    //记录更新提醒时间
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate serverDate] forKey:kUpdateDateKey];
}

#pragma mark - 根视图
+ (UIViewController *)rootViewController {
    
    //引导页出现过的版本
    NSString *versionNumber = [Tools avoidNull:[[NSUserDefaults standardUserDefaults] objectForKey:kGuideVersionKey]];
    //app当前版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurrentVersion = [Tools avoidNull:[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    //如果没有记录过版本；或者记录的版本和当前版本不一致，则显示引导图
    if (versionNumber.length == 0 || ![versionNumber isEqualToString:appCurrentVersion]) {
        return [[GuideViewController alloc] init];
    } else {
        CoachInfoModel *infoModel = [CoachInfoModel sharedInstance];
        //如果登录了，则直接出现根视图；如果没有登录，则直接出现登录界面
        if (!infoModel.access_token) {
            LoginVC *loginVC = [[LoginVC alloc] init];
            BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
            return nav;
        } else {    //创建跟视图控制器
            NSLog(@"token = %@", infoModel.access_token);
            NSLog(@"personId = %ld", (long)infoModel.personId);
            //如果登录了但没有填写过健身房资料,跳转到登录页面
            if ((infoModel.personName.length == 0)
                || (infoModel.brandName.length == 0)
                || (infoModel.branchOfficeProvince.length == 0)
//                || (infoModel.branchOfficeCity.length == 0)
//                || (infoModel.branchOfficeDistrict.length == 0)
                || (infoModel.branchOfficeDetailAddress.length == 0)) {
                LoginVC *loginVC = [[LoginVC alloc] init];
                BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
                return nav;
            }
            BaseTabBarViewController *tabBarController = [[BaseTabBarViewController alloc] init];
            [tabBarController createViewController];
            return tabBarController;
        }
    }
}

//返回顶层控制器的导航栏视图
+ (BaseNavigationController *)topNavigationController {
    //获取顶层控制器
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *rootViewController = appdelegate.window.rootViewController;
    //获取tabbar
    if ([rootViewController isKindOfClass:[BaseTabBarViewController class]]) {
        BaseTabBarViewController *tabbar = (BaseTabBarViewController *)rootViewController;
        //获取导航栏
        UIViewController *childViewController = tabbar.viewControllers[tabbar.selectedIndex];
        if ([childViewController isKindOfClass:[BaseNavigationController class]]) {
            return (BaseNavigationController *)childViewController;
        }
    }
    return nil;
}

//根据tabbar的下标获取控制器
+ (BaseNavigationController *)findViewControllerByIndex:(NSInteger)index {
    //获取顶层控制器
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *rootViewController = appdelegate.window.rootViewController;
    //获取tabbar
    if ([rootViewController isKindOfClass:[BaseTabBarViewController class]]) {
        BaseTabBarViewController *tabbar = (BaseTabBarViewController *)rootViewController;
        //当前已选中的控制器回到顶层
        UIViewController *currentViewController = tabbar.viewControllers[tabbar.selectedIndex];
        if ([currentViewController isKindOfClass:[BaseNavigationController class]]) {
            [((BaseNavigationController *)currentViewController) popToRootViewControllerAnimated:NO];
        }
        
        tabbar.changeSelectedIndex = 0;
        //获取导航栏
        UIViewController *childViewController = tabbar.viewControllers[index];
        if ([childViewController isKindOfClass:[BaseNavigationController class]]) {
            return (BaseNavigationController *)childViewController;
        }
        
    }
    return nil;
}

#pragma mark - 分享
- (void)shareSettings {
    //shareSDK  目前只分享到微信
    [ShareSDK registerActivePlatforms:@[@(SSDKPlatformTypeWechat)] onImport:^(SSDKPlatformType platformType) {
        switch (platformType) {
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
            default:break;
        }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType) {
            case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:WX_AppId appSecret:WX_AppSecret];
                break;
            default:
                break;
        }
    }];
}


#pragma mark - 极光推送设置
/*
     //有学员预约课程
     meum://fitforcecoach:80/main/course?status=appointment&position=1
     //有学员拒绝邀约
     meum://fitforcecoach:80/main/course?status=invitation&position=1
     //教练未给学员排课，教练端提前一天的通知
     meum://fitforcecoach:80/main/course?status=arrangement&position=0
     //15分钟之前要上课的通知
     meum://fitforcecoach:80/main/course?status=classBegin&position=0
     //学员评价之后，教练端收到推送
     meum://fitforcecoach:80/main/course/history
     //升级通知
     meum://fitforcecoach:80/app/update
 */

//根据推送内容，跳转到对应的视图
+ (void)pushLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //收到推送时，点击通知栏通知，根据推送的内容，标记视图
    RemotePushModel *pushModel = [RemotePushModel yy_modelWithDictionary:launchOptions];
    
    if (pushModel.target.length > 0) {
        NSString *target = pushModel.target;
        
        [RemotePushModel analyzeScheme:target processCallback:^(SportPushModule module, NSString *pageAddress, NSDictionary *paramter) {
            if (module == sportCourseModule) {
                //课程相关
                if (pageAddress.length) {
                    if ([pageAddress isEqualToString:@"/main/course"]) {
                        //课程状态更新
                        if (paramter.allKeys.count > 0 && [paramter.allKeys containsObject:@"status"]) {
                            NSString *status = [Tools avoidNull:paramter[@"status"]];
                            if ([status isEqualToString:@"invitation"]) {
                                //学员拒绝邀约，跳转到学员 --> 邀约历史页面
                                BaseNavigationController *baseNav = [self topNavigationController];
                                UIViewController *viewController = baseNav.topViewController;
                                if ([viewController isKindOfClass:[HistoryInviteViewController class]]) {
                                    HistoryInviteViewController *inviteVC = (HistoryInviteViewController *)viewController;
                                    [inviteVC reloadAction];
                                } else {
                                    HistoryInviteViewController *inviteVC = [[HistoryInviteViewController alloc] init];
                                    inviteVC.hidesBottomBarWhenPushed = YES;
                                    [baseNav pushViewController:inviteVC animated:YES];
                                }
                            } else if ([status isEqualToString:@"classBegin"] || [status isEqualToString:@"appointment"]) {
                                //15分钟要上课的通知 和 有学员预约课程，跳转到课程首页对应的日期选中
                                BaseNavigationController *baseNav = [self findViewControllerByIndex:0];
                                UIViewController *viewController = baseNav.topViewController;
                                if ([viewController isKindOfClass:[CourseViewController class]]) {
                                    CourseViewController *courseVC = (CourseViewController *)viewController;
                                    [courseVC defaultSelectTimestamp:pushModel.reserveTime];
                                }
                            }
                        }
                    } else if ([pageAddress isEqualToString:@"/main/course/history"]) {
                        //学员评价之后，教练端收到推送
                        BaseNavigationController *baseNav = [self findViewControllerByIndex:0];
                        UIViewController *viewController = baseNav.topViewController;
                        if ([viewController isKindOfClass:[CourseHistoryViewController class]]) {
                            CourseHistoryViewController *historyVC = (CourseHistoryViewController *)viewController;
                            [historyVC reloadAction];
                        } else {
                            CourseHistoryViewController *historyVC = [[CourseHistoryViewController alloc] init];
                            historyVC.hidesBottomBarWhenPushed = YES;
                            [baseNav pushViewController:historyVC animated:YES];
                        }
                    }
                }
            } else if (module == sportUpgradeModule) {
                //应用版本升级
                //应用版本升级暂不需要做任何操作
            } else if (module == sportCertificationModule) {
                //教练审核结果推送
                BaseTabBarViewController *rootViewController = [BaseTabBarViewController rootViewController];
                UIViewController *presentedVC = rootViewController.presentedViewController;
                if ([presentedVC isKindOfClass:[UINavigationController class]]) {       //present方式
                    UINavigationController *topNav = (UINavigationController *)presentedVC;
                    if (topNav.viewControllers.count > 0) {
                        UIViewController *topVC = topNav.viewControllers.firstObject;
                        if ([topVC isKindOfClass:NSClassFromString(@"FlutterViewController")]) {
                            [CoachWorkGymManager reloadData];
                        }
                    }
                } else {                            //push方式
                    BaseNavigationController *baseNav = [self topNavigationController];
                    BaseViewController *viewController = baseNav.viewControllers.lastObject;
                    //如果顶层控制器不是目标控制器，则push控制器
                    if (![viewController isKindOfClass:NSClassFromString(@"FlutterViewController")]) {
                        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        CoachWorkGymManager *workGymManager = nil;
                        if (!appDelegate.launchOperation.coachWorkGymManager) {
                            workGymManager = [[CoachWorkGymManager alloc] init];
                            appDelegate.launchOperation.coachWorkGymManager = workGymManager;
                        }
                        workGymManager.topViewController = baseNav.viewControllers.lastObject;
                        [workGymManager pushFlutterViewControllerBy:baseNav];
                    } else {
                        //如果是目标控制器，则刷新控制器
                        [CoachWorkGymManager reloadData];
                    }
                }
                
                //收到教练审核推送时，通知个人中心首页更新教练状态信息
                UIViewController *viewController = [BaseTabBarViewController rootViewControllerAtIndex:2];
                if ([viewController isKindOfClass:[BaseViewController class]]) {
                    BaseViewController *baseVC = (BaseViewController *)viewController;
                    [baseVC reloadAction];
                }
            }
        }];
    }
}

//推送设置
- (void)configJPushWithOptions:(NSDictionary *)launchOptions {
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //启动极光推送SDK
    //    [JPUSHService setupWithOption:launchOptions appKey:JPush_AppKey
    //                          channel:nil
    //                 apsForProduction:NO
    //            advertisingIdentifier:nil];
    [JPUSHService setupWithOption:launchOptions appKey:isIDC?JPush_AppKey:JPush_AppKey_Test channel:@"AppStore" apsForProduction:YES];
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler NS_AVAILABLE_IOS(10_0) {
    
    // Required
    NSDictionary *userInfo = notification.request.content.userInfo;
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    
    //收到推送时，根据推送的内容，标记视图
    [BadgeManager badgeMarkByUserInfo:userInfo];
    //收到推送时，根据推送的内容，标记视图
    RemotePushModel *pushModel = [RemotePushModel yy_modelWithDictionary:userInfo];
    //根据推送内容，显示弹窗通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kRemotePushKey object:nil userInfo:userInfo];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:kRemotePushKey object:nil userInfo:@{@"target": @"meum://fitforcecoach:80/main/course/history", @"aps":@{@"alert":@"有学员评价"}}];
    
    if (pushModel.target.length > 0) {
        NSString *target = pushModel.target;
        [RemotePushModel analyzeScheme:target processCallback:^(SportPushModule module, NSString *pageAddress, NSDictionary *paramter) {
            if (module == sportUpgradeModule || module == sportNoneModule) {
                //应用版本升级暂不需要做任何操作
                completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
                return;
            }
        }];
    }
    
    //清除通知栏消息和应用桌面角标
    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    if (@available(iOS 10.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
    } else {
        // Fallback on earlier versions
    }
    [JPUSHService resetBadge];
    
    //应用在前台时，在通知栏不显示消息
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound);     // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler NS_AVAILABLE_IOS(10_0) {
    if (@available(iOS 10.0, *)) {
        // Required
        NSDictionary *userInfo = response.notification.request.content.userInfo;
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
            //处理推送内容
            [LaunchOperation pushLaunchingWithOptions:userInfo];
        }
    } else {
        // Fallback on earlier versions
    }
    
    completionHandler();  // 系统要求执行这个方法
}

@end
