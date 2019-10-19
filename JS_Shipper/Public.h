//
//  Public.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/8/29.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#ifndef Public_h
#define Public_h
/****************************头文件*****************************/
#ifdef __OBJC__

#import "AppDelegate.h"
#import "BaseVC.h"
#import "BaseWebVC.h"
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
#import "Utils.h"
#import "CacheUtil.h"
#import "ReactiveObjC.h"
#import "Masonry.h"
#import <XLGCategory.h>
#import "UserInfo.h"
#import "Config.h"
#import "NetworkManager.h"
#import "JHHJView.h"
#import "XLGLottie.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "XLGAlertView.h"
#import <FXToast.h>

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//3.6.0
#import <HyphenateLite/HyphenateLite.h>
#import "EMDefines.h"

#endif

// AppDelegate
#define JSAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define kCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

#define EaseMobKey @"1114190326030612#android-driver"
#define OnlineCustomerEaseMobKey @"kefuchannelimid_484880"

// cache key
#define kServerKey @"ServerKey"
#define kWifiKey   @"WifiKey"
#define kSelectCourseIDKey   @"SelectCourseIDKey"
#define PageSize   @"10"
#define kSendAddressArchiver [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"sendAddress.archiver"]
#define kReceiveAddressArchiver [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"receiveAddress.archiver"]

#define kCompanyTypeStrDic @{@"全部":@"",@"服务中心":@"1",@"车代点":@"2",@"网点":@"3",@"1":@"服务中心",@"2":@"车代点",@"3":@"网点"}
#define DefaultImage [UIImage imageNamed:@"personalcenter_shipper_icon_head_landing"]
#define kAuthStateStrDic @{@(0):@"未提交",@(1):@"认证中",@(2):@"已认证",@(3):@"认证失败"}
#define kAuthStateColorDic @{@(0):kVerifiedUnCommitColor,@(1):kVerifiedOnColor,@(2):AppThemeColor,@(3):kVerifiedFailColor}

/******************************通知****************************/

#define kLoginStateChangeNotification  @"kLoginStateChangeNotification"

#define kUserInfoChangeNotification  @"kUserInfoChangeNotification"

#define kPaySuccNotification  @"kPaySuccNotification"
#define kPayFailNotification  @"kPayFailNotification"
#define kPayCancelNotification  @"kPayCancelNotification"

#define kChangeMoneyNotification  @"kChangeMoneyNotification"

/********************屏幕宽高、系统版本、手机型号******************/

#define SCREEN_BOUNDS [[UIScreen mainScreen] bounds]
#define WIDTH  [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

#define YYISiPhoneX [[UIScreen mainScreen] bounds].size.width >=375.0f && [[UIScreen mainScreen] bounds].size.height >=812.0f&& YYIS_IPHONE
#define YYIS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kStatusBarH (CGFloat)(YYISiPhoneX?(44):(20))
#define kNavBarH (CGFloat)(YYISiPhoneX?(88.0):(64.0))
#define kTabBarH (CGFloat)(YYISiPhoneX?(49+34):(49))
#define kTabBarSafeH (CGFloat)(YYISiPhoneX?(34):(0))

#define kNavBtnW autoScaleH(44)

// 控件宽高、字体适配
#define autoScaleW(width) (float)width / 375 * WIDTH
#define autoScaleH(height) (float)height / 667 * HEIGHT

/*****************************系统版本***************************/

// 判断是否是IOS7
#define IS_IOS_7  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
// 判断是否是IOS8
#define IS_IOS_8  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)
// 判断是否是IOS9
#define IS_IOS_9  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? YES : NO)
// 判断是否是IOS10
#define IS_IOS_10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0 ? YES : NO)
// 判断是否是IOS10
#define IS_IOS_11 ([[[UIDevice currentDevice] systemVersion] floatValue]>=11.0)

/*****************************APP信息***************************/

// app版本
#define AppVersion      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
// app build版本
#define AppBuildVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
// app名称
#define AppName         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
//1货主 2司机
#define AppChannel         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"channel"]
// 当前系统语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

#define JSAppDelegate ((AppDelegate*)[UIApplication sharedApplication].delegate)


#if TARGET_IPHONE_SIMULATOR //模拟器
#define IS_SIMULATOR YES
#elif TARGET_OS_IPHONE      //真机
#define IS_SIMULATOR NO
#endif

/*****************************颜色*****************************/

#define RGB(r,g,b) [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1.0f]
#define RGBA(r,g,b,a) [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
#define RGBValue(value) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:1.0]
#define RGBAValue(value,a) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:a] //a:透明度

#define AppThemeColor RGBValue(0xECA73F)
#define PageColor RGBValue(0xF5F5F5)
#define kTitleColor RGBValue(0x030303)
#define kShadowColor RGBValue(0x24709C)
#define kBlueColor RGBValue(0x00A8FF)
#define kGreenColor RGBValue(0x7AD300)
#define kLightBlackColor [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8]
#define kLineColor RGBValue(0xEEEEEE)
#define kWhiteColor RGBValue(0xFFFFFF)
#define kBlackColor RGBValue(0x000000)
#define kBorderGrayColor RGBValue(0xCCCCCC)
#define TableViewDefaultBGColor RGBValue(0xfafafa) // 默认背景颜色
#define kSeparatorColor RGB(235,235,235) // 分割线颜色
#define ButtonColor RGBValue(0xECA73F)
#define kBlack55Color RGBValue(0x555555)
#define kVerifiedUnCommitColor RGBValue(0xB4B4B4)
#define kVerifiedOnColor RGBValue(0x0091FF)
#define kVerifiedFailColor RGBValue(0xE02020)

//环信颜色
#define kColor_LightGray [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1.0]

#define kColor_Gray [UIColor colorWithRed:229 / 255.0 green:229 / 255.0 blue:229 / 255.0 alpha:1.0]

#define kColor_Blue [UIColor colorWithRed:45 / 255.0 green:116 / 255.0 blue:215 / 255.0 alpha:1.0]


#define JSFontMin(size) [UIFont systemFontOfSize:MAX(size, autoScaleW(size))]


#ifdef DEBUG
#define KOnline NO

#else
#define KOnline YES
#endif

/**
 *  完美解决Xcode NSLog打印不全的宏
 */
#ifdef DEBUG
#define NSLog(...) printf("%f %s\n",[[NSDate date]timeIntervalSince1970],[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);
#else
#define NSLog(format, ...)
#endif

#endif /* Public_h */
