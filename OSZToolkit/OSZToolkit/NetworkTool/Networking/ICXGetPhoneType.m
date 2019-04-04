//
//  ICXGetPhoneType.m
//  ICXCommercialPR
//
//  Created by tangpeng on 2018/4/19.
//Copyright © 2018年 ICX. All rights reserved.
//

#import "ICXGetPhoneType.h"
#import <sys/utsname.h>
#import <UIKit/UIKit.h>
@implementation ICXGetPhoneType

+ (NSString *)iphoneInfoWithAppName:(NSString *)appName {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *phone_model = [[UIDevice currentDevice] model];
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    NSString *userAgent = [NSString stringWithFormat:@"%@/%@ iOS/%.1lf %@/%@",appName,app_Version,version,phone_model,[self iphoneType]];
    return userAgent;
}

+ (NSString *)iphoneType {
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([platform isEqualToString:@"iPhone1,1"])  return@"iPhone2G";
    
    if([platform isEqualToString:@"iPhone1,2"])  return@"iPhone3G";
    
    if([platform isEqualToString:@"iPhone2,1"])  return@"iPhone3GS";
    
    if([platform isEqualToString:@"iPhone3,1"])  return@"iPhone4";
    
    if([platform isEqualToString:@"iPhone3,2"])  return@"iPhone4";
    
    if([platform isEqualToString:@"iPhone3,3"])  return@"iPhone4";
    
    if([platform isEqualToString:@"iPhone4,1"])  return@"iPhone4S";
    
    if([platform isEqualToString:@"iPhone5,1"])  return@"iPhone5";
    
    if([platform isEqualToString:@"iPhone5,2"])  return@"iPhone5";
    
    if([platform isEqualToString:@"iPhone5,3"])  return@"iPhone5c";
    
    if([platform isEqualToString:@"iPhone5,4"])  return@"iPhone5c";
    
    if([platform isEqualToString:@"iPhone6,1"])  return@"iPhone5s";
    
    if([platform isEqualToString:@"iPhone6,2"])  return@"iPhone5s";
    
    if([platform isEqualToString:@"iPhone7,1"])  return@"iPhone6Plus";
    
    if([platform isEqualToString:@"iPhone7,2"])  return@"iPhone6";
    
    if([platform isEqualToString:@"iPhone8,1"])  return@"iPhone6s";
    
    if([platform isEqualToString:@"iPhone8,2"])  return@"iPhone6sPlus";
    
    if([platform isEqualToString:@"iPhone8,4"])  return@"iPhone SE";
    
    if([platform isEqualToString:@"iPhone9,1"])  return@"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,3"])  return@"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,2"])  return@"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone9,4"])  return@"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone10,1"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,4"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,2"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,5"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,3"]) return@"iPhone X";
    
    if([platform isEqualToString:@"iPhone10,6"]) return@"iPhone X";
    
    if([platform isEqualToString:@"iPhone11,2"]) return@"iPhone XS";
    
    if([platform isEqualToString:@"iPhone11,4"] || [platform isEqualToString:@"iPhone11,6"]) return@"iPhone XS Max";
    
    if([platform isEqualToString:@"iPhone11,8"]) return@"iPhone XR";
    
    if([platform isEqualToString:@"iPod1,1"])  return@"iPod Touch 1G";
    
    if([platform isEqualToString:@"iPod2,1"])  return@"iPod Touch 2G";
    
    if([platform isEqualToString:@"iPod3,1"])  return@"iPod Touch 3G";
    
    if([platform isEqualToString:@"iPod4,1"])  return@"iPod Touch 4G";
    
    if([platform isEqualToString:@"iPod5,1"])  return@"iPod Touch 5G";
    
    if([platform isEqualToString:@"iPod7,1"])  return@"iPod Touch 6G";
    
    if([platform isEqualToString:@"iPad1,1"])  return@"iPad 1G";
    
    if([platform isEqualToString:@"iPad2,1"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,2"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,3"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,4"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,5"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,6"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,7"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad3,1"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,2"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,3"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,4"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,5"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,6"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad4,1"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,2"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,3"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,4"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,5"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,6"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,7"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,8"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,9"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad5,1"])  return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,2"])  return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,3"])  return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad5,4"])  return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad6,3"])  return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,4"])  return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,7"])  return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"iPad6,8"])  return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"iPad6,11"] || [platform isEqualToString:@"iPad6,12"]) return@"iPad 5";
    
    if([platform isEqualToString:@"iPad7,1"] || [platform isEqualToString:@"iPad7,2"]) return@"iPad Pro 12.9-inch 2";
    
    if([platform isEqualToString:@"iPad7,3"] || [platform isEqualToString:@"iPad7,4"]) return@"iPad Pro 10.5";
    
    if([platform isEqualToString:@"i386"])  return@"iPhone Simulator";
    
    if([platform isEqualToString:@"x86_64"])  return@"iPhone Simulator";
    
    return platform;
    
}
@end
