//
//  AppDelegate.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/25.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "AppDelegate.h"
#import "JSLauncherVC.h"
#import "BaseTabBarVC.h"
#import <IQKeyboardManager.h>
#import "NetworkUtil.h"
#import <BaiduMapAPI_Base/BMKMapManager.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import <UserNotifications/UserNotifications.h>
#import "CustomEaseUtils.h"
#import "EMNotificationHelper.h"
#import "WXApiManager.h"
#import <Bugly/Bugly.h>

@interface AppDelegate ()< WXApiDelegate,BuglyDelegate,UNUserNotificationCenterDelegate>
@property (nonatomic, strong) BMKMapManager *mapManager; //主引擎类
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSDictionary *locDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"loc"];
    if (locDic.allKeys.count == 0) {
        NSDictionary *locDic = @{@"lat":@(0),@"lng":@(0)};
        [[NSUserDefaults standardUserDefaults] setObject:locDic forKey:@"loc"];
    }
    
    //Bugly
    [self initBugly];
    
    //监测网络
    [[NetworkUtil sharedInstance] listening];
    
    //键盘事件
    [self processKeyBoard];
    
    [self initMapKey];
    
    [self initEmData];

    [WXApi startLogByLevel:WXLogLevelNormal logBlock:^(NSString *log) {
        NSLog(@"log : %@", log);
    }];
    NSString *WechatDescription = kWechatKey;
    [WXApi registerApp:WechatDescription universalLink:@"https://help.wechat.com/sdksample/"];
    //解决tabbar上移
    [[UITabBar appearance] setTranslucent:NO];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    JSLauncherVC *launcherVC = [[JSLauncherVC alloc] init];
    launcherVC.doneBlock = ^{
        self.tabVC = [[BaseTabBarVC alloc] init];
        self.tabVC.delegate = self;
        self.window.rootViewController = self.tabVC;
    };
    self.window.rootViewController = launcherVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)initBugly {
    BuglyConfig *config = [[BuglyConfig alloc] init];
    config.channel = @"App Store";
    config.blockMonitorEnable = YES; // 卡顿监控开关，默认关闭
    config.blockMonitorTimeout = 5;
    config.unexpectedTerminatingDetectionEnable = YES; // 非正常退出事件记录开关，默认关闭
    config.delegate = self;
    
#ifdef DEBUG
    config.debugMode = YES; // debug 模式下，开启调试模式
    config.reportLogLevel = BuglyLogLevelVerbose; // 设置自定义日志上报的级别，默认不上报自定义日志
#else
    config.debugMode = NO; // release 模式下，关闭调试模式
    config.reportLogLevel = BuglyLogLevelWarn;
#endif
    
    [Bugly startWithAppId:KBuglyAppId config:config];
}

#pragma mark - BuglyDelegate

- (NSString * BLY_NULLABLE)attachmentForException:(NSException * BLY_NULLABLE)exception {
    NSDictionary *dictionary = @{@"Name":exception.name,
                                 @"Reason":exception.reason};
    return [NSString stringWithFormat:@"Exception:%@",dictionary];
}

- (void)processKeyBoard {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
}

#pragma mark - 支付宝、微信支付回调

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self applicationOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [self applicationOpenURL:url];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options {
    return [self applicationOpenURL:url];
}

- (BOOL)applicationOpenURL:(NSURL *)url {
    
    //支付宝回调
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            NSInteger status = [resultDic[@"resultStatus"] integerValue];
            
            switch (status) {
                case 9000:
                    [[NSNotificationCenter defaultCenter] postNotificationName:kPaySuccNotification object:nil];
                    break;
                    
                case 8000:
                    [Utils showToast:@"订单正在处理中"];
                    break;
                    
                case 4000:
                    [[NSNotificationCenter defaultCenter] postNotificationName:kPayFailNotification object:nil];
                    break;
                    
                case 6001:
                    [[NSNotificationCenter defaultCenter] postNotificationName:kPayCancelNotification object:nil];
                    break;
                    
                case 6002:
                    [Utils showToast:@"网络连接出错"];
                    break;
                    
                default:
                    break;
            }
        }];
        return YES;
    }
    
    //微信支付回调
    if([[url absoluteString] rangeOfString:[NSString stringWithFormat:@"%@://pay",kWechatKey]].location == 0) {
        return [WXApi handleOpenURL:url delegate:self];
    }
//    if([[url absoluteString] rangeOfString:[NSString stringWithFormat:@"%@://platformId=wechat",kWechatKey]].location == 0) {
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
//    }
    
    
    return YES;
}

#pragma mark - WXApiDelegate

-(void)onResp:(BaseResp *)resp {
    //微信支付信息
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *payResp = (PayResp *)resp;
        
        NSLog(@"微信支付成功回调：%d",payResp.errCode);
        
        switch (payResp.errCode) {
            case 0:
                [[NSNotificationCenter defaultCenter] postNotificationName:kPaySuccNotification object:nil];
                break;
            case -1:
                [[NSNotificationCenter defaultCenter] postNotificationName:kPayFailNotification object:nil];
                break;
            case -2:
                [[NSNotificationCenter defaultCenter] postNotificationName:kPayCancelNotification object:nil];
                break;
                
            default:
                break;
        }
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    //这里我判断的是当前点击的tabBarItem的标题
    NSString *tabBarTitle = viewController.tabBarItem.title;
    if ([tabBarTitle isEqualToString:@"我的"]) {
        if ([Utils isLoginWithJump:YES]) {
            return YES;
        } else {
            return NO;
        }
    }
    if ([tabBarTitle isEqualToString:@"社区"]) {
        if ([Utils isVerified]) { //已认证
            return YES;
        } else {
            return NO;
        }
    }
    else {
        return YES;
    }
}

- (void)initMapKey {
    NSLog(@"%@",kMapKey);
    // 初始化定位SDK
//    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:kMapKey authDelegate:self];
    //要使用百度地图，请先启动BMKMapManager
    _mapManager = [[BMKMapManager alloc] init];
    
    /**
     百度地图SDK所有API均支持百度坐标（BD09）和国测局坐标（GCJ02），用此方法设置您使用的坐标类型.
     默认是BD09（BMK_COORDTYPE_BD09LL）坐标.
     如果需要使用GCJ02坐标，需要设置CoordinateType为：BMK_COORDTYPE_COMMON.
     */
    if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL]) {
        NSLog(@"经纬度类型设置成功");
    } else {
        NSLog(@"经纬度类型设置失败");
    }
    
    //启动引擎并设置AK并设置delegate
    BOOL result = [_mapManager start:kMapKey generalDelegate:self];
    if (!result) {
        NSLog(@"启动引擎失败");
    }
}

- (void)initEmData {
    
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStateChange:) name:ACCOUNT_LOGIN_CHANGED object:nil];
    //注册推送
    [self _registerRemoteNotification];
    
    EMOptions *options = [EMOptions optionsWithAppkey:EaseMobKey];
    options.isAutoLogin = YES;
    if ([AppChannel isEqualToString:@"1"]) { //货主端
    #ifdef DEBUG
        options.apnsCertName = @"shipperDev";
    #else
        options.apnsCertName = @"shipperDis";
    #endif
    }
    else if ([AppChannel isEqualToString:@"2"]) { //司机端
        #ifdef DEBUG
            options.apnsCertName = @"driverDev";
        #else
            options.apnsCertName = @"driverDis";
        #endif
    }
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    [CustomEaseUtils shareHelper];
    [EMNotificationHelper shared];
    
}

//注册远程通知
- (void)_registerRemoteNotification
{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError *error) {
            if (granted) {
#if !TARGET_IPHONE_SIMULATOR
                dispatch_async(dispatch_get_main_queue(), ^{
                    [application registerForRemoteNotifications];
                });
#endif
            }
        }];
        return;
    }
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    } else {
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
}

- (void)loginStateChange:(NSNotification *)aNotif
{
    UINavigationController *navigationController = nil;
    
    BOOL loginSuccess = [aNotif.object boolValue];
    if (loginSuccess) {//登录成功加载主窗口控制器
        navigationController = (UINavigationController *)self.window.rootViewController;
    } else {//登录失败加载登录页面控制器
        [Utils logout:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStateChangeNotification object:@NO];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationDidEnterBackground:application];
    [UIApplication sharedApplication].applicationIconBadgeNumber
    = [CustomEaseUtils getUnreadCount];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}

// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] bindDeviceToken:deviceToken];
    });
}

// 注册deviceToken失败，此处失败，与环信SDK无关，一般是您的环境配置或者证书配置有误
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册device token失败" message:error.description delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
//    if (gMainController) {
//        [gMainController jumpToChatList];
//    }
    
    [[EMClient sharedClient] application:application didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
//    if (gMainController) {
//        [gMainController didReceiveLocalNotification:notification];
//    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    NSDictionary *userInfo = notification.request.content.userInfo;
    [[EMClient sharedClient] application:[UIApplication sharedApplication] didReceiveRemoteNotification:userInfo];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
//    if (gMainController) {
//        [gMainController didReceiveUserNotification:response.notification];
//    }
    completionHandler();
}

#pragma mark - EMPushManagerDelegateDevice

// 打印收到的apns信息
-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"推送内容" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
}

@end
