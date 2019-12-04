//
//  ShipperConfig.h
//  JS_Shipper
//
//  Created by Jason_zyl on 2019/9/30.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShipperConfig : NSObject

#pragma mark - APP货主端微信登录

#define URL_BindingWxInfo @"/app/wx/bindingWxInfo" //登录后绑定
#define URL_RebindingWxInfo @"/app/wx/rebindingWxInfo" //微信号已与其他账号绑定，解除原账号绑定，并绑定当前新账号
#define URL_UnbindingWxInfo @"/app/wx/unbindingWxInfo" //登录后解绑
#define URL_WxCodeLogin @"/app/wx/wxCodeLogin" //code登录
#define URL_WxLogin @"/app/wx/wxLogin" //绑定页面短信登录
#define URL_GetWxBindingInfo @"/app/wx/getWxBindingInfo" //获取用户微信授权绑定状态

#pragma mark - H5名称

#define H5_Privacy @"privacyProtocal-shipper.html" //隐私协议
#define H5_Register @"registerProtocal-shipper.html" //用户注册协议

@end

NS_ASSUME_NONNULL_END
