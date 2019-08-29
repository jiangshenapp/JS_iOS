//
//  AppDelegate.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/25.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>
{
//    EMConnectionState _connectionState;
}
/**  */
@property (nonatomic,retain) UITabBarController *tabVC;
@property (strong, nonatomic) UIWindow *window;

@end

