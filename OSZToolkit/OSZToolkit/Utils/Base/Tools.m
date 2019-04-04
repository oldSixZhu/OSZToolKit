//
//  Tools.m
//  MS3.0
//
//  Created by 徐杨 on 2017/6/15.
//  Copyright © 2017年 麦时. All rights reserved.
//

#import "Tools.h"
#import <CommonCrypto/CommonDigest.h>
#define TIME_ZONE @"Asia/Beijing"

#import "sys/utsname.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#include <ifaddrs.h>
#include <arpa/inet.h>
#include <netdb.h>
#import <dlfcn.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <SystemConfiguration/SystemConfiguration.h>
//引入IOS自带密码库
#import <CommonCrypto/CommonCryptor.h>

#import "BaseViewController.h"

@implementation Tools  

#pragma mark - 时间分割
+ (NSString *)timeStrSegmentation:(NSString *)timeStr {
    // 根据空格截取
    NSArray *arr = [timeStr componentsSeparatedByString:@" "];
    if (arr.count >= 2) {
        return arr[0];
    } else {
        return nil;
    }
}

#pragma mark - 清理缓存
+ (void)cleanCache:(cleanCacheBlock)block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *folderPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
        
        if (!folderPath) {
            return;
        }
        //Caches路径
        NSString *cachePath = [NSString stringWithFormat:@"%@/Caches", folderPath];
        //判断caches路径是否存在
        NSFileManager *manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:cachePath]) {
            return;
        }
        
        //删除cache文件夹下的所有文件
        NSArray *dirArray = [manager contentsOfDirectoryAtPath:cachePath error:nil];
        
        for (NSString *subDir in dirArray) {
            //忽略user_db_name文件夹
            if (![subDir isEqualToString:@"user_db_name"]) {
                NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:[NSString stringWithFormat:@"%@/%@", cachePath, subDir]] objectEnumerator];
                //文件名
                NSString *fileName;
                while ((fileName = [childFilesEnumerator nextObject]) != nil) {
                    NSString *fileAbsolutePath = [[cachePath stringByAppendingPathComponent:subDir] stringByAppendingPathComponent:fileName];
                    [self deleteFileAtPath:fileAbsolutePath];
                }
            }
        }
        
        //删除Application Support文件夹下的所有文件
        NSString *supportPath = [NSString stringWithFormat:@"%@/Application Support", folderPath];
        //判断supportPath路径是否存在
        if (![manager fileExistsAtPath:supportPath]) {
            return;
        }
        
        //Application Support文件夹下的所有文件 user_db_name
        NSArray *supportDirArray = [manager contentsOfDirectoryAtPath:supportPath error:nil];
        
        for (NSString *supportDir in supportDirArray) {
            NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:[NSString stringWithFormat:@"%@/%@", supportPath, supportDir]] objectEnumerator];
            //文件名
            NSString *fileName;
            while ((fileName = [childFilesEnumerator nextObject]) != nil) {
                NSString *fileAbsolutePath = [[supportPath stringByAppendingPathComponent:supportDir] stringByAppendingPathComponent:fileName];
                [self deleteFileAtPath:fileAbsolutePath];
            }
        }
        
        //返回主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    });
}

#pragma mark - 删除某个文件
+ (void)deleteFileAtPath:(NSString *)filePath {
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath :filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}

#pragma mark - 获取缓存文件大小
+ (CGFloat)cacheSize {
    NSString *folderPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    
    if (!folderPath) {
        return 0;
    }
    //Caches路径
    NSString *cachePath = [NSString stringWithFormat:@"%@/Caches", folderPath];
    //判断caches路径是否存在
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:cachePath]) {
        return 0;
    }
    
    //文件总大小
    long long folderSize = 0;
    
    //cache文件夹下的所有文件 user_db_name
    NSArray *cacheDirArray = [manager contentsOfDirectoryAtPath:cachePath error:nil];
    
    for (NSString *subDir in cacheDirArray) {
        //忽略用户文件夹
        if (![subDir isEqualToString:@"user_db_name"]) {
            NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:[NSString stringWithFormat:@"%@/%@", cachePath, subDir]] objectEnumerator];
            //文件名
            NSString *fileName;
            while ((fileName = [childFilesEnumerator nextObject]) != nil) {
                NSString *fileAbsolutePath = [[cachePath stringByAppendingPathComponent:subDir] stringByAppendingPathComponent:fileName];
                folderSize += [self fileSizeAtPath:fileAbsolutePath];
            }
        }
    }
    
    //Application Support文件夹下的所有文件
    NSString *supportPath = [NSString stringWithFormat:@"%@/Application Support", folderPath];
    //判断supportPath路径是否存在
    if (![manager fileExistsAtPath:supportPath]) {
        return folderSize;
    }
    
    //Application Support文件夹下的所有文件 user_db_name
    NSArray *supportDirArray = [manager contentsOfDirectoryAtPath:supportPath error:nil];
    
    for (NSString *supportDir in supportDirArray) {
        NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:[NSString stringWithFormat:@"%@/%@", supportPath, supportDir]] objectEnumerator];
        //文件名
        NSString *fileName;
        while ((fileName = [childFilesEnumerator nextObject]) != nil) {
            NSString *fileAbsolutePath = [[supportPath stringByAppendingPathComponent:supportDir] stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:fileAbsolutePath];
        }
    }
    
    return folderSize/(1024.0 * 1024.0);
}

#pragma mark - 获取单个文件大小
+ (long long)fileSizeAtPath:(NSString *)filePath {
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath :filePath]) {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    
    return 0;
}

#pragma mark - 判断一个字符串是否是整形
+ (BOOL)isPureInt:(NSString *)string {
    if (!string) {
        return false;
    }
    //string不是浮点型
    if (![string containsString:@"."]) {
        NSScanner *scan = [NSScanner scannerWithString:string];
        int val;
        return[scan scanInt:&val] && [scan isAtEnd];
    }
    //string是浮点型
    else {
        NSArray *numberArray = [string componentsSeparatedByString:@"."];
        if (numberArray.count != 2) {
            return false;
        }
        else {
            NSString *behindNumber = numberArray[1];
            //如果小数点后的数字等于0，则是整数
            return ([behindNumber integerValue] == 0);
        }
    }
}
#pragma mark - 字符串插入逗号格式 是否加.00
+ (NSString *)priceFormatInsertComma:(NSString *)priceText isDecimals:(BOOL)isDecimals{
    if (!priceText) {
        
        return nil;
    }
    NSString *replaceStr = priceText;
    NSString *decimalPointStr = nil;
    if ([priceText containsString:@"."]) {
            // 价格包含点. 则截取点后面的小数临时保存, 转换完成后拼接返回
            replaceStr = [priceText substringToIndex:[priceText length] - 3];
            decimalPointStr = [priceText substringFromIndex:[priceText length] - 3];
    }
    NSString *str = [replaceStr substringWithRange:NSMakeRange(replaceStr.length % 3, replaceStr.length - replaceStr.length % 3)];
    NSString *strs = [replaceStr substringWithRange:NSMakeRange(0, replaceStr.length % 3)];
    for (NSInteger i = 0; i < str.length; i = i + 3) {
        NSString *sss = [str substringWithRange:NSMakeRange(i, 3)];
        strs = [strs stringByAppendingString:[NSString stringWithFormat:@",%@",sss]];
    }
    if ([[strs substringWithRange:NSMakeRange(0, 1)] isEqualToString:@","]) {
        strs = [strs substringWithRange:NSMakeRange(1, strs.length - 1)];
    }

    return [[NSString stringWithFormat:@"¥%@",strs] stringByAppendingString:decimalPointStr];
    
}


#pragma mark - 模型转字典
+ (NSMutableDictionary *)returnToDictionaryWithModel:(NSObject *)model {
    NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([model class], &count);
    for (int i = 0; i < count; i++) {
        const char *name = property_getName(properties[i]);
        
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id propertyValue = [model valueForKey:propertyName];
        if (propertyValue) {
            [userDic setObject:propertyValue forKey:propertyName];
        }
        
    }
    free(properties);
    return userDic;
}

#pragma mark - 根据image 获得image的type jpg/png
+ (NSString *)contentTypeWithImage:(UIImage *)image {
    
    NSData *imageData = UIImagePNGRepresentation(image);
    uint8_t c;
    [imageData getBytes:&c length:1];
    switch (c) {
        case 0xFF: return @"jpeg";
            
        case 0x89: return @"png";
            
        case 0x47: return @"gif";
            
        case 0x49:
        case 0x4D: return @"tiff";
            
        case 0x52:
            
            if ([imageData length] < 12) {
                return nil;
            }
            
            NSString *testString = [[NSString alloc] initWithData:[imageData subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                
                return @"webp";
            }
            return nil;
    }
    return nil;
    
    
}


#pragma mark - 相机权限
+ (BOOL)devicePermissionForCamera {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"相机不能用");
        return NO;
    }
    
    //判断是否已授权
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == ALAuthorizationStatusDenied||authStatus == ALAuthorizationStatusRestricted) {
//        [ToastTools showDialogWithTitle:@"相机没有权限" content:@"请到设置-隐私-相机中开启" submitAction:^{
//            NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
//
//            if (kApplicationCanOpenURL(identifier)) {
//                kApplicationOpenURL(identifier);
//            }
//        }];
        
        return NO;
    }
    
    return YES;
}
#pragma mark - 相册权限
+ (BOOL)devicePermissionForPhotoAlbum {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return NO;
    }
    return YES;
}

#pragma mark - 判断是否含有非法字符
+ (BOOL)judgeTheillegalCharacter:(NSString *)content {
    //提示 标签不能输入特殊字符
    NSString *str = @"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    if (![emailTest evaluateWithObject:content]) {
        return YES;
    }
    return NO;
}

#pragma mark - 只能输入中文,英文,数字 正则
+ (BOOL)judgeRegexOnlyChineseEnglishNumber:(NSString *)content {
    NSString *regex = @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![pred evaluateWithObject:content]) {
        return YES;
    }
    return NO;
}

#pragma mark - 是否包含emoji表情
+ (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar high = [substring characterAtIndex: 0];
                                
                                // Surrogate pair (U+1D000-1F9FF)
                                if (0xD800 <= high && high <= 0xDBFF) {
                                    const unichar low = [substring characterAtIndex: 1];
                                    const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                    
                                    if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                        returnValue = YES;
                                    }
                                    
                                    // Not surrogate pair (U+2100-27BF)
                                } else {
                                    if (0x2100 <= high && high <= 0x27BF){
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

#pragma mark - 获取缓存内存大小
+ (CGFloat)getCachSize {
    
    NSUInteger imageCacheSize = [[SDImageCache sharedImageCache] getSize];
    //获取自定义缓存大小
    //用枚举器遍历 一个文件夹的内容
    //1.获取 文件夹枚举器
    NSString *myCachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:myCachePath];
    __block NSUInteger count = 0;
    //2.遍历
    for (NSString *fileName in enumerator) {
        NSString *path = [myCachePath stringByAppendingPathComponent:fileName];
        NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
        count += fileDict.fileSize;//自定义所有缓存大小
    }
    // 得到是字节  转化为M
    CGFloat totalSize = ((CGFloat)imageCacheSize+count)/1024/1024;
    return totalSize;
}

#pragma mark - 清除缓存
+ (void)clearMemeory {
    //删除两部分
    //1.删除 sd 图片缓存
    //先清除内存中的图片缓存
    [[SDImageCache sharedImageCache] clearMemory];
    //清除磁盘的缓存
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        
    }];
    //2.删除自己缓存
    NSString *myCachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    [[NSFileManager defaultManager] removeItemAtPath:myCachePath error:nil];
}

#pragma mark - 获取视频任意帧图片
+ (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode =AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage:thumbnailImageRef] : nil;
    return thumbnailImage;
}

#pragma mark - 计算文字大小
+ (CGSize)sizeForText:(NSString *)text fontSize:(UIFont *)fontSize size:(CGSize)size {
    if (text && text.length > 0) {
        NSMutableParagraphStyle *paraghStyle = [[NSMutableParagraphStyle alloc] init];
        paraghStyle.lineBreakMode = NSLineBreakByCharWrapping;
        
        return [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: fontSize, NSParagraphStyleAttributeName:paraghStyle} context:nil].size;
    }else {
        return CGSizeZero;
    }
}

+ (CGSize)boundingAllRectWithSize:(NSString*)txt font:(UIFont*)font size:(CGSize)size {
    //    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:txt];
    //    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    //    [style setLineSpacing:2.0f];
    //    [attributedString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [txt length])];
    //
    //    CGSize realSize = CGSizeZero;
    //
    //#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    //    CGRect textRect = [txt boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:style} context:nil];
    //    realSize = textRect.size;
    //#else
    //    realSize = [txt sizeWithFont:font constrainedToSize:size];
    //#endif
    //
    //    realSize.width = ceilf(realSize.width);
    //    realSize.height = ceilf(realSize.height);
    return [txt boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
}



//MD5加密
+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (int)str.length, digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}

#pragma mark - 将字符串转化成试图控制器
+ (UIViewController *)StringIntoViewController:(NSString *)classString
{
    UIViewController *vc = [NSClassFromString(classString) new];
    return vc;
}

#pragma mark - 验证银行卡号是否规范
+ (BOOL)validateBankCardWithNumber:(NSString *)cardNum
{
    NSString * CT = @"^([0-9]{16}|[0-9]{19})$";
    NSPredicate *regextestCard = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if ([regextestCard evaluateWithObject:cardNum] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - 验证正整数
+ (BOOL)validatePositiveInteger:(NSString *)integer {
    NSString *regex = @"^[0-9]*$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [emailTest evaluateWithObject:integer];
}

#pragma mark - 判断身份证号码是否规范
+ (BOOL)checkIdentityCardNo:(NSString*)cardNo
{
    if (cardNo.length != 18) {
        return  NO;
    }
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    
    NSScanner* scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i =0; i<17; i++) {
        sumValue+=[[cardNo substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    
    if ([strlast isEqualToString: [[cardNo substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;
}

#pragma mark - 验证手机号码
+ (BOOL)validatePhone:(NSString *)mobileNum
{
    if (mobileNum.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    /**
     25     * 大陆地区固话及小灵通
     26     * 区号：010,020,021,022,023,024,025,027,028,029
     27     * 号码：七位或八位
     28     */
    //  NSString * PHS = @"^(0[0-9]{2})\\d{8}$|^(0[0-9]{3}(\\d{7,8}))$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }else {
        return NO;
    }
}

#pragma mark - 拨打电话
+ (void)makePhoneCallWithTelNumber:(NSString *)tel
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",tel]]];
}

#pragma mark - 直接打开网页
+ (void)openURLWithUrlString:(NSString *)url
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",url]]];
}

#pragma mark - 获取当前时间
+ (NSString *)currentTime
{
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    NSDate *curDate = [NSDate date];//获取当前日期
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//这里去掉 具体时间 保留日期
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:TIME_ZONE];
    [formater setTimeZone:timeZone];
    NSString * curTime = [formater stringFromDate:curDate];
    
    return curTime;
}

#pragma mark - 将时间转换成时间戳
/**
 *  时间戳：指格林威治时间1970年01月01日00时00分00秒(北京时间1970年01月01日08时00分00秒)起至现在的总秒数。
 */
+ (NSString *)timeStringIntoTimeStamp:(NSString *)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:TIME_ZONE];
    [dateFormatter setTimeZone:timeZone];
    
    NSDate *date = [dateFormatter dateFromString:time];
    
    NSString *timeSP = [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];
    
    return timeSP;
}

#pragma mark - 将时间戳转换成时间
+ (NSString *)timeStampIntoTimeString:(NSString *)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    /* 设置时区 */
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:TIME_ZONE];
    [dateFormatter setTimeZone:timeZone];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time intValue]];
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    //dateString = [dateString substringToIndex:20];
    return  dateString;
}

#pragma mark - 通过时间字符串获取年、月、日
+ (NSArray *)getYearAndMonthAndDayFromTimeString:(NSString *)time
{
    NSString *year = [time substringToIndex:4];
    NSString *month = [[time substringFromIndex:5] substringToIndex:2];
    NSString *day = [[time substringFromIndex:8] substringToIndex:2];
    
    return @[year,month,day];
}
#pragma mark - 获取今天、明天、后天的日期
+ (NSArray *)timeForTheRecentDate
{
    NSMutableArray *dateArr = [[NSMutableArray alloc]init];
    
    //今天
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    NSDate *curDate = [NSDate date];//获取当前日期
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//这里去掉 具体时间 保留日期
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:TIME_ZONE];
    [formater setTimeZone:timeZone];
    NSString * curTime = [formater stringFromDate:curDate];
    
    NSArray *today = [self getYearAndMonthAndDayFromTimeString:curTime];
    [dateArr addObject:today];
    
    
    //明天
    NSString *timeStamp = [self timeStringIntoTimeStamp:curTime];
    NSInteger seconds = 24*60*60 + [timeStamp integerValue];
    timeStamp = [NSString stringWithFormat:@"%ld",(long)seconds];
    curTime = [self timeStampIntoTimeString:timeStamp];
    
    NSArray *tomorrow = [self getYearAndMonthAndDayFromTimeString:curTime];
    [dateArr addObject:tomorrow];
    
    return [NSArray arrayWithArray:dateArr];
}

#pragma mark - 获取当前时间的时间戳
+ (NSString *)getCurrentTimestamp {
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
}

#pragma mark - 当前界面截图
+ (UIImage *)imageFromCurrentView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, [UIScreen mainScreen].scale);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - 获取Documents中文件的路径
+ (NSString *)accessToTheDocumentsInTheFilePath:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    
    return filePath;
}

#pragma mark - 判断网址是否有效
+ (BOOL)validateHttp:(NSString *)textString
{
    NSString* number=@"^([w-]+.)+[w-]+(/[w-./?%&=]*)?$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:textString];
}

#pragma mark - 给view设置边框
+ (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, view.frame.size.height - width, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(view.frame.size.width - width, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
}

#pragma mark - 给view设置圆角
/**
 *  给view设置圆角(指定圆角)
 *
 */
+ (void)setCornerRadiuswithView:(UIView *)view targetAngles:(UIRectCorner) targetAngles cornerRadii:(CGSize) size {
    
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:targetAngles cornerRadii:size];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    maskLayer.strokeColor = [UIColor whiteColor].CGColor;
    view.layer.mask = maskLayer;
}

#pragma mark - 将数组中重复的对象去除，只保留一个
+ (NSMutableArray *)arrayWithMemberIsOnly:(NSMutableArray *)array
{
    NSMutableArray *categoryArray =  [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [array count]; i++) {
        @autoreleasepool {
            if ([categoryArray containsObject:[array objectAtIndex:i]] == NO) {
                [categoryArray addObject:[array objectAtIndex:i]];
            }
        }
    }
    return categoryArray;
}

#pragma mark - 图片大小设置
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 44 * w, colorSpace,kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, size.width/3, size.height/3);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), scaledImage.CGImage);
    //CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    //返回新的改变大小后的图片
    return scaledImage;
}

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

#pragma mark - 获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

#pragma mark - 获取当前处于activity状态的view controller
+ (UIViewController *)activityViewController
{
    UIViewController* activityViewController = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows)
        {
            if(tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0)
    {
        UIView *frontView = [viewsArray objectAtIndex:0];
        
        id nextResponder = [frontView nextResponder];
        
        if([nextResponder isKindOfClass:[UIViewController class]])
        {
            activityViewController = nextResponder;
        }
        else
        {
            activityViewController = window.rootViewController;
        }
    }
    
    return activityViewController;
}

#pragma mark - 处理字符串
+ (NSString *)avoidNull:(NSString *)text {
    return (text.length>0)?text:@"";
}

#pragma mark - 计算文字大小
+ (CGSize)calculateTextSize:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont *)font {
    if (text && text.length > 0) {
        return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
    } else {
        return CGSizeZero;
    }
}

#pragma mark - 毫秒时间戳格式化 有规则
+ (NSString *)convertStrToTime:(NSString *)timeStr {
    if (!timeStr || timeStr.length == 0) {
        return @"";
    }
    long long time = [timeStr longLongValue];
    NSDate *d = [[NSDate alloc] initWithTimeIntervalSince1970:time/1000.0];
    //判断日期是否是今年
    if ([d isYear]) {               //今年的日期，不显示"年"
        if ([d isToday]) {          //今天的日期，则不显示日期，只显示时间
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm"];
            NSString *timeString = [formatter stringFromDate:d];
            return [NSString stringWithFormat:@"%@ %@", XYLString(@"schedule_plan_today"), timeString];
        } else {                    //今年，非今天，则显示月份 + 具体时间
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MM/dd HH:mm"];
            NSString *timeString = [formatter stringFromDate:d];
            return timeString;
        }
    } else {                        //今年以前的日期，则显示 年/月/日 时:分
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yy/MM/dd HH:mm"];
        NSString *timeString = [formatter stringFromDate:d];
        return timeString;
    }
}

#pragma mark - 毫秒时间戳格式化 无规则
+ (NSString *)convertStrToStringTime:(NSString *)timeStr {
    if (!timeStr || timeStr.length == 0) {
        return @"";
    }
    long long time = [timeStr longLongValue];
    NSDate *d = [[NSDate alloc] initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:[NSString stringWithFormat:@"yyyy%@MM%@dd%@ HH:mm", XYLString(@"schedule_plan_year"), XYLString(@"schedule_plan_month"), XYLString(@"schedule_plan_day")]];
    NSString *timeString = [formatter stringFromDate:d];
    return timeString;
}


#pragma mark -  long型时间戳转化为生日
+ (NSString *)birthdayFromNumber:(NSNumber *)number{
    NSTimeInterval interval=[number doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd"];
    NSString *time = [objDateformat stringFromDate: date];
    return time;
}

#pragma mark - 根据颜色生成纯色图片
+ (UIImage *)creatImageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


//根据颜色创建图片
+ (UIImage *)creatImageWithColor:(UIColor *)color andFrame:(CGRect)rect{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//把两张图片合成一张图片
+ (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 {
    CGFloat image1X = (image2.size.width-image1.size.width)*0.5;
    CGFloat image1Y = (image2.size.height-image1.size.height)*0.5;
    //    NSLog(@"%f,%f",image1.size.width,image1.size.height);
    
    //以image2的图大小为画布创建上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(image2.size.width, image2.size.height), NO,[UIScreen mainScreen].scale);
    [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];//先把大图画到上下文中
    [image1 drawInRect:CGRectMake(image1X, image1Y, image1.size.width, image1.size.height)];//再把小图放在上下文中
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();//从当前上下文中获得最终图片
    UIGraphicsEndImageContext();//关闭上下文
    
    return resultImg;
}

#pragma mark - 将指定的控制器标记为待刷新状态
+ (void)remarkRefresh:(NSString *)aClassName nav:(UINavigationController *)nav {
    Class class = NSClassFromString(aClassName);
    if (class) {
        for (UIViewController *subVC in nav.viewControllers) {
            if ([subVC isKindOfClass:class]) {
                BaseViewController *toBeRefreshVC = (BaseViewController *)subVC;
                toBeRefreshVC.isRefresh = YES;
                break;
            }
        }
    }
}

#pragma mark - 加密、解密
/** DES加密 */
+ (NSString *)desStringFromText:(NSString *)text key:(NSString *)key {
    if (text.length && key.length) {
        return [self encryptUseDES:text Andkey:key];
    }
    return nil;
}

/** DES解密 */
+ (NSString *)encryptDESStringFromText:(NSString *)text key:(NSString *)key {
    if (text.length && key.length) {
        return [self decryptUseDES:text Andkey:key];
    }
    return nil;
}

/** DES加密 */
+ (NSString *)encryptUseDES:(NSString *)clearText Andkey:(NSString *)key {
    NSString *ciphertext = nil;
    NSData *textData = [clearText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [textData length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void * buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String], kCCBlockSizeDES,
                                          NULL,
                                          [textData bytes]  , dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [self stringWithHexBytes2:data];
    }
    
    free(buffer);
    return ciphertext;
}

/** DES解密 */
+ (NSString *)decryptUseDES:(NSString *)plainText Andkey:(NSString *)key {
    NSString *cleartext = nil;
    NSData *textData = [self parseHexToByteArray:plainText];
    NSUInteger dataLength = [textData length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String], kCCKeySizeDES,
                                          NULL,
                                          [textData bytes]  , dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        cleartext = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    free(buffer);
    return cleartext;
}

//nsdata转成16进制字符串
+ (NSString*)stringWithHexBytes2:(NSData *)sender {
    static const char hexdigits[] = "0123456789ABCDEF";
    const size_t numBytes = [sender length];
    const unsigned char* bytes = [sender bytes];
    char *strbuf = (char *)malloc(numBytes * 2 + 1);
    char *hex = strbuf;
    NSString *hexBytes = nil;
    
    for (int i = 0; i<numBytes; ++i) {
        const unsigned char c = *bytes++;
        *hex++ = hexdigits[(c >> 4) & 0xF];
        *hex++ = hexdigits[(c ) & 0xF];
    }
    
    *hex = 0;
    hexBytes = [NSString stringWithUTF8String:strbuf];
    
    free(strbuf);
    return hexBytes;
}


/*
 将16进制数据转化成NSData 数组
 */
+ (NSData*)parseHexToByteArray:(NSString *)hexString {
    int j=0;
    Byte bytes[hexString.length];
    for(int i=0;i<[hexString length];i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
    }
    
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:hexString.length/2];
    return newData;
}

#pragma mark - 设备型号
+ (DeviceType)deviceType {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine
                                            encoding:NSUTF8StringEncoding];
    //simulator
    if ([platform isEqualToString:@"i386"])          return simulator;
    if ([platform isEqualToString:@"x86_64"])        return simulator;
    
    //iPhone
    if ([platform isEqualToString:@"iPhone1,1"])     return iPhone_1G;
    if ([platform isEqualToString:@"iPhone1,2"])     return iPhone_3G;
    if ([platform isEqualToString:@"iPhone2,1"])     return iPhone_3GS;
    if ([platform isEqualToString:@"iPhone3,1"])     return iPhone_4;
    if ([platform isEqualToString:@"iPhone3,2"])     return iPhone_4;
    if ([platform isEqualToString:@"iPhone4,1"])     return iPhone_4S;
    if ([platform isEqualToString:@"iPhone5,1"])     return iPhone_5;
    if ([platform isEqualToString:@"iPhone5,2"])     return iPhone_5;
    if ([platform isEqualToString:@"iPhone5,3"])     return iPhone_5C;
    if ([platform isEqualToString:@"iPhone5,4"])     return iPhone_5C;
    if ([platform isEqualToString:@"iPhone6,1"])     return iPhone_5S;
    if ([platform isEqualToString:@"iPhone6,2"])     return iPhone_5S;
    if ([platform isEqualToString:@"iPhone7,1"])     return iPhone_6_P;
    if ([platform isEqualToString:@"iPhone7,2"])     return iPhone_6;
    if ([platform isEqualToString:@"iPhone8,1"])     return iPhone_6S;
    if ([platform isEqualToString:@"iPhone8,2"])     return iPhone_6S_P;
    if ([platform isEqualToString:@"iPhone8,4"])     return iPhone_SE;
    if ([platform isEqualToString:@"iPhone9,1"])     return iPhone_7;
    if ([platform isEqualToString:@"iPhone9,3"])     return iPhone_7;
    if ([platform isEqualToString:@"iPhone9,2"])     return iPhone_7_P;
    if ([platform isEqualToString:@"iPhone9,4"])     return iPhone_7_P;
    if ([platform isEqualToString:@"iPhone10,1"])    return iPhone_8;
    if ([platform isEqualToString:@"iPhone10,4"])    return iPhone_8;
    if ([platform isEqualToString:@"iPhone10,2"])    return iPhone_8_P;
    if ([platform isEqualToString:@"iPhone10,5"])    return iPhone_8_P;
    if ([platform isEqualToString:@"iPhone10,3"])    return iPhone_X;
    if ([platform isEqualToString:@"iPhone10,6"])    return iPhone_X;
    
    return unknown;
}

#pragma mark - 新手引导图
+ (UIImage *)imageForPage:(BeginnerGuidePage)page {
    
    NSInteger width = (long)([UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].scale);
    NSInteger height = (long)([UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].scale);
    
    if (isIPhoneXSeries()) {
        width = 1242;
        height = 2688;
    }
    
    switch (page) {
        case courseListGuidePage: {                             //课程首页 - 待办课程
            if (isIPhoneXSeries()) {
                return [UIImage imageNamed:[NSString stringWithFormat:@"%liX%li_1", (long)width, (long)height]];
            } else if (DEVICE_IPAD) {
                return [UIImage imageNamed:@"guide_1_1536X2048"];
            } else {
                return [UIImage imageNamed:@"guide_1"];
            }
        }
        case studentListGuidePage: {                            //学员列表 - 邀约
            if (isIPhoneXSeries()) {
                return [UIImage imageNamed:[NSString stringWithFormat:@"%liX%li_2", (long)width, (long)height]];
            } else if (DEVICE_IPAD) {
                return [UIImage imageNamed:@"guide_2_1536X2048"];
            } else {
                return [UIImage imageNamed:@"guide_2"];
            }
        }
            break;
        case courseActionOneGuidePage: {                        //课程上课 - 结束课程
            if (isIPhoneXSeries()) {
                return [UIImage imageNamed:[NSString stringWithFormat:@"%liX%li_3_0", (long)width, (long)height]];
            } else if (DEVICE_IPAD) {
                return [UIImage imageNamed:@"guide_3_1536X2048"];
            } else {
                return [UIImage imageNamed:@"guide_3_0"];
            }
        }
        case courseActionTwoGuidePage: {                        //课程上课 - 切换动作
            if (isIPhoneXSeries()) {
                return [UIImage imageNamed:[NSString stringWithFormat:@"%liX%li_3_1", (long)width, (long)height]];
            } else if (DEVICE_IPAD) {
                return [UIImage imageNamed:@"guide_3_1536X2048"];
            } else {
                return [UIImage imageNamed:@"guide_3_1"];
            }
        }
        case courseActionThreeGuidePage: {                      //课程上课 - 间歇计时器
            if (isIPhoneXSeries()) {
                return [UIImage imageNamed:[NSString stringWithFormat:@"%liX%li_3_2", (long)width, (long)height]];
            } else if (DEVICE_IPAD) {
                return [UIImage imageNamed:@"guide_3_1536X2048"];
            } else {
                return [UIImage imageNamed:@"guide_3_2"];
            }
        }
        default:
            break;
    }
    
    return nil;
}

#pragma mark - 保存日志文件
+ (void)redirectNSLogToDocumentFolder {
    //如果已经连接Xcode调试则不输出到文件
    if(isatty(STDOUT_FILENO)) {
        return;
    }
    
    UIDevice *device = [UIDevice currentDevice];
    if([[device model] hasSuffix:@"Simulator"]){ //在模拟器不保存到文件中
        return;
    }
    
    //获取Document目录下的Log文件夹，若没有则新建
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *logDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Log"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:logDirectory];
    if (!fileExists) {
        [fileManager createDirectoryAtPath:logDirectory  withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //每次启动后都保存一个新的日志文件中
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    NSString *logFilePath = [logDirectory stringByAppendingFormat:@"/%@.txt",dateStr];
    
    // freopen 重定向输出输出流，将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}

/** 产生随机字符串 */
+ (NSString *)generateString:(NSInteger)length {
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRST";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(NULL));
    for (int i = 0; i < length; i++) {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

@end
