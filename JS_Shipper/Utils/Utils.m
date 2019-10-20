//
//  Utils.m
//  Chaozhi
//  Notes：
//
//  Created by Jason on 2018/5/7.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "Utils.h"
#import "Toast.h"
#import "NetworkUtil.h"
#import "BaseNC.h"
#import "TZImageManager.h"
#import <AddressBook/AddressBook.h>
#import "JSPaswdLoginVC.h"
#import "CustomEaseUtils.h"
#import "WXApi.h"

@interface Utils ()
{
    UIColor *_btnNormalColor; //按钮正常颜色
    UIColor *_btnSelectedColor; //按钮选中颜色
    UIColor *_btnBorderNormalColor; //按钮边框正常颜色
    UIColor *_btnBorderSelectedColor; //按钮边框选中颜色
}
@end

static Utils *_utils = nil;

@implementation Utils

/**
 类单例方法

 @return 类实例
 */
+ (instancetype)share {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _utils = [[Utils alloc] init];
    });
    return _utils;
}

/**
 存放服务器环境
 */
+ (void)setServer:(NSInteger)server {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:server forKey:kServerKey];
}

/**
 获取服务器环境
 */
+ (NSInteger)getServer {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults integerForKey:kServerKey];
}

/**
 存放是否在非Wifi情况下播放视频状态
 */
+ (void)setWifi:(BOOL)wifi {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:wifi forKey:kWifiKey];
}

/**
 获取是否在非Wifi情况下播放视频状态
 */
+ (BOOL)getWifi {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:kWifiKey];
}

/**
 判断网络状态

 @return YES 有网
 */
+ (BOOL)getNetStatus {
    if ([NetworkUtil currentNetworkStatus] != NotReachable) { //有网
        return YES;
    } else {
        return NO;
    }
}

/**
 获取当前时间

 @return 1990-09-18 12:23:22
 */
+ (NSString *)getCurrentDate {
    NSDate *date = [NSDate date];
    NSDateFormatter *fom = [[NSDateFormatter alloc]init];
    fom.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [fom stringFromDate:date];
}

/**
 获取当前控制器

 @return 当前控制器
 */
+ (UIViewController *)getCurrentVC {
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
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        if([nextResponder isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = nextResponder;
            BaseNC *nc = tab.selectedViewController;
            result = nc.topViewController;
        } else {
            result = nextResponder;
        }
    }
    else {
        result = window.rootViewController;
    }

    return result;
}

/**
 1、判断是否登录，2、是否跳转到登录页面

 @param isJump YES：跳转
 @return YES：登录
 */
+ (BOOL)isLoginWithJump:(BOOL)isJump{
    
    if (![Utils isBlankString:[UserInfo share].token]) {
        return YES;
    } else {
        if (isJump==YES) {
            BaseNC *nc = JSAppDelegate.tabVC.selectedViewController;
            NSLog(@"%@",JSAppDelegate.tabVC);
            if (![[nc topViewController] isKindOfClass:[JSPaswdLoginVC class]]) {
                //跳转到登录页面
                UIViewController *vc = [Utils getViewController:@"Login" WithVCName:@"JSPaswdLoginVC"];
                vc.hidesBottomBarWhenPushed = YES;
                [[nc topViewController].navigationController pushViewController:vc animated:YES];
            }
        }
        return NO;
    }
}

/**
 1、退出登录，2、是否跳转到登录页面

 @param isJumpLoginVC YES：跳转
 */
+ (void)logout:(BOOL)isJumpLoginVC {
    
    [[UserInfo share] setUserInfo:nil]; //清除用户信息
    [CustomEaseUtils EaseMobLogout];
    if (isJumpLoginVC==YES) {
        BaseNC *nc = JSAppDelegate.tabVC.selectedViewController;
        NSLog(@"%@",JSAppDelegate.tabVC);
        if (![[nc topViewController] isKindOfClass:[JSPaswdLoginVC class]]) {
            //跳转到登录页面
            UIViewController *vc = [Utils getViewController:@"Login" WithVCName:@"JSPaswdLoginVC"];
            vc.hidesBottomBarWhenPushed = YES;
            [[nc topViewController].navigationController pushViewController:vc animated:YES];
        }
    }
}

/**
 判断用户是否认证
 */
+ (BOOL)isVerified {
    
    if (![self isLoginWithJump:YES]) { //先判断登录
        return NO;
    }
    if ([AppChannel isEqualToString:@"1"]) { //货主端
        if ([[UserInfo share].personConsignorVerified integerValue] != 2
            && [[UserInfo share].companyConsignorVerified integerValue] != 2) {
            XLGAlertView *alert = [[XLGAlertView alloc] initWithTitle:@"温馨提示" content:@"您尚未认证通过" leftButtonTitle:@"取消" rightButtonTitle:@"前往认证"];
            alert.doneBlock = ^{
                UIViewController *vc = [Utils getViewController:@"Mine" WithVCName:@"JSAuthenticationVC"];
                [[self getCurrentVC].navigationController pushViewController:vc animated:YES];
            };
            return NO;
        } else {
            return YES;
        }
    } else { //司机端
        if ([[UserInfo share].parkVerified integerValue] != 2
            && [[UserInfo share].driverVerified integerValue] != 2) {
            XLGAlertView *alert = [[XLGAlertView alloc] initWithTitle:@"温馨提示" content:@"您尚未认证通过" leftButtonTitle:@"取消" rightButtonTitle:@"前往认证"];
            alert.doneBlock = ^{
                UIViewController *vc = [Utils getViewController:@"Mine" WithVCName:@"JSAuthencationHomeVC"];
                [[self getCurrentVC].navigationController pushViewController:vc animated:YES];
            };
            return NO;
        } else {
            return YES;
        }
    }
}

/**
 判断字符串是否为空

 @param string 字符串
 @return YES 空
 */
+ (BOOL)isBlankString:(id)string {
    
    string = [NSString stringWithFormat:@"%@",string];
    
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isEqual:[NSNull null]]) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([string isEqualToString:@"null"]) {
        return YES;
    }
    if([string isEqualToString:@"<null>"])
    {
        return YES;
    }
    if ([string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length==0) {
        return YES;
    }
    return NO;
}

/**
 仿安卓消息提示

 @param message 提示内容
 */
+ (void)showToast:(NSString *)message {
    [Toast showBottomWithText:message bottomOffset:HEIGHT/2 duration:1.5];
}

// 验证手机号
+ (BOOL)validateMobile:(NSString *)mobile {
    
    NSString *mobileRegex = @"^1[0123456789]\\d{9}$";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileRegex];
    return [mobileTest evaluateWithObject:mobile];
}

// 加密手机号
+ (NSString *)changeMobile:(NSString *)mobile {
    mobile = [mobile stringByReplacingCharactersInRange:NSMakeRange(3,4) withString:@"****"];
    return mobile;
}

// 加密姓名
+ (NSString *)changeName:(NSString *)name {
    if (name.length>0) {
        name = [NSString stringWithFormat:@"%@xx",[name substringToIndex:1]];
    }
    return name;
}

/**
 设置控件阴影

 @param view 视图View
 */
+ (void)setViewShadowStyle:(UIView *)view {
    view.layer.shadowOffset =  CGSizeMake(0, 2); //阴影偏移量
    view.layer.shadowOpacity = 0.2; //透明度
    view.layer.shadowColor =  kShadowColor.CGColor; //阴影颜色
    view.layer.shadowRadius = 5; //模糊度
    view.layer.shadowPath = [[UIBezierPath bezierPathWithRect:view.bounds] CGPath];
    [view.layer setMasksToBounds:NO];
}

/**
 设置按钮显示、点击效果

 @param btn 按钮
 @param shadow 是否显示阴影
 @param normalBorderColor 正常边框颜色
 @param selectedBorderColor 选中边框颜色
 @param borderWidth 边框宽度
 @param normalColor 正常按钮颜色
 @param selectedColor 选中按钮颜色
 @param radius 圆角
 */
- (void)setButtonClickStyle:(UIButton *)btn Shadow:(BOOL)shadow normalBorderColor: (UIColor *)normalBorderColor selectedBorderColor: (UIColor *)selectedBorderColor BorderWidth:(int)borderWidth normalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor cornerRadius:(CGFloat)radius {
    
    _btnNormalColor = normalColor;
    _btnSelectedColor = selectedColor;
    _btnBorderNormalColor =normalBorderColor;
    _btnBorderSelectedColor =selectedBorderColor;
    btn.layer.borderColor =normalBorderColor.CGColor;
    [btn.layer setBorderWidth:borderWidth];
    btn.backgroundColor = normalColor;
    btn.layer.cornerRadius = radius;
    if (shadow == YES) {
        [Utils setViewShadowStyle:btn];
    }
    [btn addTarget:self action:@selector(downClick:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(doneClick:) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)downClick:(UIButton *)button {
    button.layer.borderColor = _btnBorderSelectedColor.CGColor;
    button.backgroundColor = _btnSelectedColor;
    [button.layer setMasksToBounds:YES];
}

- (void)doneClick:(UIButton *)button {
    button.layer.borderColor = _btnBorderNormalColor.CGColor;
    button.backgroundColor = _btnNormalColor;
    [button.layer setMasksToBounds:NO];
}

/**
 屏幕快照

 @param view 视图View
 @return 屏幕截图
 */
+ (UIImage *)snapshotSingleView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIViewController *)getViewController:(NSString *)stordyName WithVCName:(NSString *)name{
    UIStoryboard *story = [UIStoryboard storyboardWithName:stordyName bundle:nil];
    return [story instantiateViewControllerWithIdentifier:name];
}

#pragma mark - 系统权限判断

+ (BOOL)isCameraPermissionOn {
    //相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            [self permissionSetup:@"“匠神马帮”想访问您的相机"];
            return NO;
        } else {
            return YES;
        }
    } else {
        [Toast showBottomWithText:@"没有相机功能" bottomOffset:100.0 duration:1.2];
        return NO;
    }
}

+ (BOOL)isPhotoPermissionOn {
    if (![[TZImageManager manager] authorizationStatusAuthorized]) {
        [self permissionSetup:@"“匠神马帮”想访问您的相册"];
        return NO;
    } else {
        return YES;
    }
}

+ (void)checkAddressBookAuthorization:(void (^)(bool isAuthorized))block {
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    
    if (authStatus != kABAuthorizationStatusAuthorized) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"Error：%@",(__bridge NSError *)error);
                } else if (!granted) {
                    [self permissionSetup:@"“匠神马帮”想访问您的通讯录"];
                    block(NO);
                } else {
                    block(YES);
                }
            });
        });
    } else {
        block(YES);
    }
}

+ (void)checkMicrophoneAuthorization:(void (^)(bool isAuthorized))block {
    [[AVAudioSession sharedInstance]requestRecordPermission:^(BOOL granted) {
        if (!granted){
            [self permissionSetup:@"“匠神马帮”想访问您的麦克风"];
            block(NO);
        } else {
            block(YES);
        }
    }];
}

//跳转到系统权限设置页面
+ (void)permissionSetup:(NSString *)title {
    //初始化提示框；
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle: UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"不允许" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //跳转到系统设置
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }]];
    //弹出提示框；
    [[Utils getCurrentVC] presentViewController:alert animated:true completion:nil];
}

// 读取本地JSON文件
+ (NSDictionary *)readLocalFileWithName:(NSString *)name {
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if (err) {
//        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

//打电话
+ (void)call:(NSString *)phone {
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

+ (NSString *)getTimeStrToCurrentDateWith:(NSString *)dateStr1 {
    if (dateStr1.length==0) {
        return @"";
    }
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    fmt.timeZone = zone;
    NSDate *timeDate = [fmt dateFromString:dateStr1 ];
    
    NSDate *date = [NSDate date];
    // 设置系统时区为本地时区
    NSTimeZone *zone1 = [NSTimeZone systemTimeZone];
    // 计算本地时区与 GMT 时区的时间差
    NSInteger interval = [zone1 secondsFromGMT];
    // 在 GMT 时间基础上追加时间差值，得到本地时间
    timeDate = [timeDate dateByAddingTimeInterval:interval];
    //    NSTimeInterval tempTime1 = [timeDate timeIntervalSince1970];
    
    date = [date dateByAddingTimeInterval:interval];
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;//只比较天数差异
    //比较的结果是NSDateComponents类对象
    NSDateComponents *delta = [calendar components:unit fromDate:timeDate toDate:date options:0];
    if (delta.day>=1&&delta.day<7) {
        return [NSString stringWithFormat:@"%ld天前",delta.day];
    }
    else {
        if (delta.day<1) {
            if (delta.hour>0) {
                return [NSString stringWithFormat:@"%ld小时前",delta.hour];
            }
            else{
                if (delta.minute>0) {
                    return [NSString stringWithFormat:@"%ld分钟前",delta.minute];
                }
                else {
                    return [NSString stringWithFormat:@"刚刚"];
                }
            }
        }
    }
    return dateStr1;
}

+ (NSString *)distanceBetweenOrderBy:(double) lat1 :(double) lng1 andOther:(double) lat2 :(double) lng2{
    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    double  distance  = [curLocation distanceFromLocation:otherLocation];
    NSString *str = @"";
    if (distance >1000) {
        str = [NSString stringWithFormat:@"%.2fkm",distance/1000];
    }
    else {
        str = [NSString stringWithFormat:@"%.2fm",distance];
    }
    return  str;
}

//计算文字所占大小
+ (CGSize)getSizeByString:(NSString*)string AndFontSize:(CGFloat)font {
    CGSize size = [string boundingRectWithSize:CGSizeMake(999, 25) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Heiti SC" size:font]} context:nil].size;
    size.width += 5;
    return size;
}

/** 时间戳转字符串 */
+ (NSString *)timeStampToString:(NSString *)timeStamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp longLongValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

/** 时间转时间戳 */
+ (NSString *)dateToTimeStamp:(NSDate *)date {
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]*1000];
    return timeSp;
}

/** 字符串转时间 */
+ (NSDate *)stringToDate:(NSString *)dateStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datestr = [dateFormatter dateFromString:dateStr];
    return datestr;
}

+ (BOOL)booWeixin {
    // 判是否安装微
    if ([WXApi isWXAppInstalled] ){
        //判断当前微信的版本是否支持OpenApi
        if ([WXApi isWXAppSupportApi]) {
            return YES;
        }else{
            NSLog(@"请升级微信至最新版本！");
            return NO;
        }
    }else{
        return NO;
    }
}

@end
