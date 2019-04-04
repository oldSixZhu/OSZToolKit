//
//  Tools.h
//  MS3.0
//
//  Created by 徐杨 on 2017/6/15.
//  Copyright © 2017年 麦时. All rights reserved.
//

/*
    1、你可以在任何地方加上这句话，可以用来统一收起键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
 
 
*/

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DeviceType) {
    unknown = 0,
    simulator,
    iPhone_1G,
    iPhone_3G,
    iPhone_3GS,
    iPhone_4,
    iPhone_4S,
    iPhone_5,
    iPhone_5C,
    iPhone_5S,
    iPhone_SE,
    iPhone_6,
    iPhone_6_P,
    iPhone_6S,
    iPhone_6S_P,
    iPhone_7,
    iPhone_7_P,
    iPhone_8,
    iPhone_8_P,
    iPhone_X,
};

typedef NS_ENUM(NSInteger, BeginnerGuidePage) {
    courseListGuidePage = 0,                                    //课程首页 - 待办课程
    studentListGuidePage,                                       //学员列表 - 邀约
    courseActionOneGuidePage,                                   //课程上课 - 结束课程
    courseActionTwoGuidePage,                                   //课程上课 - 切换动作
    courseActionThreeGuidePage,                                 //课程上课 - 间歇计时器
};

typedef void(^cleanCacheBlock)(void);

@interface Tools : NSObject

#pragma mark - 正则 中文,英文,数字
/** 正则 中文,英文,数字*/
+ (BOOL)judgeRegexOnlyChineseEnglishNumber:(NSString *)content;

#pragma mark - 时间分割
/** 时间分割*/
+ (NSString *)timeStrSegmentation:(NSString *)timeStr;

#pragma mark - 清理缓存
/** 清理缓存 */
+ (void)cleanCache:(cleanCacheBlock)block;

#pragma mark - 删除某个文件
/** 删除某个文件 */
+ (void)deleteFileAtPath:(NSString *)filePath;

#pragma mark - 获取缓存文件大小
/** 获取缓存文件大小 */
+ (CGFloat)cacheSize;

#pragma mark - 获取单个文件大小
/** 获取单个文件大小 */
+ (long long)fileSizeAtPath:(NSString *)filePath;

#pragma mark - 判断一个字符串是否是整形
/** 判断一个字符串是否是整形 */
+ (BOOL)isPureInt:(NSString*)string;

#pragma mark - 模型转字典
/** 模型转字典 */
+ (NSMutableDictionary *)returnToDictionaryWithModel:(NSObject *)model;

#pragma mark - 根据image 获得image的type jpg/png
/**
 根据image 获得image的type jpg/png
 */
+ (NSString *)contentTypeWithImage:(UIImage *)image;

#pragma mark - 相机权限
+ (BOOL)devicePermissionForCamera;

#pragma mark - 相册权限
+ (BOOL)devicePermissionForPhotoAlbum;

#pragma mark - 判断是否含有非法字符
/** 判断是否含有非法字符 */
+ (BOOL)judgeTheillegalCharacter:(NSString *)content;

#pragma mark - 是否包含emoji表情
/** 是否包含emoji表情 */
+ (BOOL)stringContainsEmoji:(NSString *)string;

#pragma mark - 获取缓存内存大小
/** 获取缓存内存大小 */
+ (CGFloat)getCachSize;

#pragma mark - 清除缓存
/** 清除缓存 */
+ (void)clearMemeory;

#pragma mark - 获取视频任意帧
/** 获取视频任意帧 */
+ (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;

#pragma mark - 计算文字大小
/** 计算文字大小 */
+ (CGSize)sizeForText:(NSString *)text fontSize:(UIFont *)fontSize size:(CGSize)size;

+ (CGSize)boundingAllRectWithSize:(NSString*)txt font:(UIFont*)font size:(CGSize)size;

//MD5加密
+ (NSString *) md5:(NSString *)str;

#pragma mark - 将字符串转化成试图控制器
/**
 *  将字符串转化成视图 控制器
 */
+ (UIViewController *)StringIntoViewController:(NSString *)classString;


#pragma mark - 验证银行卡号是否规范
/**
 *  验证银行卡号是否规范
 */
+ (BOOL)validateBankCardWithNumber:(NSString *)cardNum;


#pragma mark - 判断身份证号码是否规范
/**
 *  判断身份证号码是否规范
 */
+ (BOOL)checkIdentityCardNo:(NSString*)cardNo;

#pragma mark - 验证手机号码

/** 验证手机号码 */
+ (BOOL)validatePhone:(NSString *)phoneNumber;

#pragma mark - 验证正整数
/** 验证正整数 */
+ (BOOL)validatePositiveInteger:(NSString *)integer;

#pragma mark - 拨打电话
/**
 *  拨打电话
 */
+ (void)makePhoneCallWithTelNumber:(NSString *)tel;



#pragma mark - 直接打开网页
/**
 *  直接打开网页
 */
+ (void)openURLWithUrlString:(NSString *)url;


#pragma mark - 获取当前时间
/**
 *  获取当前时间
 */
+ (NSString *)currentTime;


#pragma mark - 将时间转换成时间戳
/**
 *  将时间转换成时间戳
 *
 *   时间戳：指格林威治时间1970年01月01日00时00分00秒(北京时间1970年01月01日08时00分00秒)起至现在的总秒数。
 */
+ (NSString *)timeStringIntoTimeStamp:(NSString *)time;


#pragma mark - 将时间戳转换成时间
/**
 *  将时间戳转换成时间
 */
+ (NSString *)timeStampIntoTimeString:(NSString *)time;


#pragma mark - 通过时间字符串获取年、月、日
/**
 *  通过时间字符串获取年、月、日
 */
+ (NSArray *)getYearAndMonthAndDayFromTimeString:(NSString *)time;


#pragma mark - 获取今天、明天、后天的日期
/**
 *  获取今天、明天、后天的日期
 */
+ (NSArray *)timeForTheRecentDate;

#pragma mark - 获取当前时间的时间戳
/**
 *  获取当前时间的时间戳
 */
+ (NSString *)getCurrentTimestamp;

#pragma mark - 当前界面截图
/**
 *  当前界面截图
 */
+ (UIImage *)imageFromCurrentView:(UIView *)view;

#pragma mark - 获取Documents中文件的路径
/**
 *  获取Documents中文件的路径
 */
+ (NSString *)accessToTheDocumentsInTheFilePath:(NSString *)fileName;


#pragma mark - 判断网址是否有效
/**
 *  判断网址是否有效
 */
+ (BOOL)validateHttp:(NSString *)textString;


#pragma mark - 给view设置边框
/**
 *  给view设置边框(指定边框)
 *
 */
+ (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width;

#pragma mark - 给view设置圆角

/**
 给view设置圆角(指定圆角)
 
 @param view 目标 View
 @param targetAngles  想要改变的角 可多选 用 | 字符分开
 @param size 圆角半径(CGSize 格式 所以是给出的 椭圆半径)
 如果你们有更变态需求每个角的半径都不一样那就让美工 MM 切图吧
 */
+ (void)setCornerRadiuswithView:(UIView *)view targetAngles:(UIRectCorner) targetAngles cornerRadii:(CGSize) size;

#pragma mark - 将数组中重复的对象去除，只保留一个
/**
 *  将数组中重复的对象去除，只保留一个
 */
+ (NSMutableArray *)arrayWithMemberIsOnly:(NSMutableArray *)array;


#pragma mark - 图片大小设置
/**
 *  图片大小设置
 */
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;


#pragma mark - 获取当前屏幕显示的viewcontroller
/**
 *  获取当前屏幕显示的viewcontroller
 */
+ (UIViewController *)getCurrentVC;


#pragma mark - 获取当前处于activity状态的view controller
/**
 *  获取当前处于activity状态的view controller
 */
+ (UIViewController *)activityViewController;

#pragma mark - 处理字符串
/** 处理字符串 */
+ (NSString *)avoidNull:(NSString *)text;

#pragma mark - 计算文字大小
/** 计算文字大小 */
+ (CGSize)calculateTextSize:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont *)font;

/** 毫秒时间戳格式化 有规则 */
+ (NSString *)convertStrToTime:(NSString *)timeStr;

/** 毫秒时间戳格式化 无规则 */
+ (NSString *)convertStrToStringTime:(NSString *)timeStr;

#pragma mark -  long型时间戳转化为生日
+ (NSString *)birthdayFromNumber:(NSNumber *)number;

#pragma mark - 根据颜色生成纯色图片
+ (UIImage *)creatImageWithColor:(UIColor *)color;

//根据颜色创建图片
+ (UIImage *)creatImageWithColor:(UIColor *)color andFrame:(CGRect)rect;

//把两张图片合成一张图片
+ (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2;

#pragma mark - 将指定的控制器标记为待刷新状态
/** 将指定的控制器标记为待刷新状态 */
+ (void)remarkRefresh:(NSString *)aClassName nav:(UINavigationController *)nav;

#pragma mark - 加密、解密
/** DES加密 */
+ (NSString *)desStringFromText:(NSString *)text key:(NSString *)key;
/** DES解密 */
+ (NSString *)encryptDESStringFromText:(NSString *)text key:(NSString *)key;

#pragma mark - 设备型号
/** 设备型号 */
+ (DeviceType)deviceType;

#pragma mark - 新手引导图
/** 新手引导图 */
+ (UIImage *)imageForPage:(BeginnerGuidePage)page;

#pragma mark - 保存日志文件
/** 保存日志文件 */
+ (void)redirectNSLogToDocumentFolder;

#pragma mark - 产生随机字符串
/** 产生随机字符串 */
+ (NSString *)generateString:(NSInteger)length;

@end
