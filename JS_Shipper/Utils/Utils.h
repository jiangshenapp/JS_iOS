//
//  Utils.h
//  Chaozhi
//  Notes：工具类
//
//  Created by Jason on 2018/5/7.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

#pragma mark - 类单例方法
+ (Utils *)share;

#pragma mark - 存取服务器环境【0：测试地址test-aci-api.chaozhiedu.com，1：正式地址：aci-api.chaozhiedu.com】
+ (void)setServer:(NSInteger)server;

+ (NSInteger)getServer;

#pragma mark - 存取是否在非Wifi情况下播放视频【NO：不可以，YES：可以】
+ (void)setWifi:(BOOL)wifi;

+ (BOOL)getWifi;

#pragma mark - 判断网络状态
+ (BOOL)getNetStatus;

#pragma mark - 获取当前时间
+(NSString *)getCurrentDate;

#pragma mark - 获取当前控制器
+ (UIViewController *)getCurrentVC;

#pragma mark - 1、判断是否登录，2、是否跳转到登录页面
+ (BOOL)isLoginWithJump:(BOOL)isJump;

#pragma mark - 1、退出登录，2、是否跳转到登录页面
+ (void)logout:(BOOL)isJumpLoginVC;

#pragma mark - 判断用户是否认证
+ (BOOL)isVerified;

#pragma mark - 判断字符串是否为空
+ (BOOL)isBlankString:(id)string;

#pragma mark - 仿安卓消息提示
+ (void)showToast:(NSString *)message;

#pragma mark - 验证手机号
+ (BOOL)validateMobile:(NSString *)mobile;

#pragma mark - 设置控件阴影
+ (void)setViewShadowStyle:(UIView *)view;

#pragma mark - 加密手机号
+ (NSString *)changeMobile:(NSString *)mobile;

#pragma mark - 加密姓名
+ (NSString *)changeName:(NSString *)name;


#pragma mark - 设置按钮显示、点击效果
- (void)setButtonClickStyle:(UIButton *)btn
                     Shadow:(BOOL)shadow
          normalBorderColor:(UIColor *)normalBorderColor
        selectedBorderColor: (UIColor *)selectedBorderColor
                BorderWidth:(int)borderWidth
                normalColor:(UIColor *)normalColor
              selectedColor:(UIColor *)selectedColor
               cornerRadius:(CGFloat)radius;

#pragma mark - 屏幕快照
+ (UIImage *)snapshotSingleView:(UIView *)view;

+ (UIViewController *)getViewController:(NSString *)stordyName WithVCName:(NSString *)name;

/*!
 *  @brief 判断系统相机权限
 */
+ (BOOL)isCameraPermissionOn;

/*!
 *  @brief 判断系统照片权限
 */
+ (BOOL)isPhotoPermissionOn;

/*!
 *  @brief 判断系统通讯录权限
 */
+ (void)checkAddressBookAuthorization:(void (^)(bool isAuthorized))block;

/*!
 *  @brief 判断系统麦克风权限
 */
+ (void)checkMicrophoneAuthorization:(void (^)(bool isAuthorized))block;

/*!
 *  @brief 读取本地JSON文件
 */
+ (id )readLocalFileWithName:(NSString *)name;

/*!
 *  @brief JSON字符串转字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/*!
 *  @brief 打电话
 */
+ (void)call:(NSString *)phone;

/*!
 *  @brief 根据文字计算文字所占的位置
 */
+ (CGSize)getSizeByString:(NSString*)string AndFontSize:(CGFloat)font;

/** 计算时间差 返回几分钟/小时前   */
+ (NSString *)getTimeStrToCurrentDateWith:(NSString *)dateStr1;

/** 计算经纬度 */
+ (NSString *)distanceBetweenOrderBy:(double) lat1 :(double) lng1 andOther:(double) lat2 :(double) lng2;

/** 时间戳转字符串 */
+ (NSString *)timeStampToString:(NSString *)timeStamp;

/** 时间转时间戳 */
+ (NSString *)dateToTimeStamp:(NSDate *)date;

/** 字符串转时间 */
+ (NSDate *)stringToDate:(NSString *)dateStr;

/** 判断是否安装微信 */
+ (BOOL)booWeixin;

@end
