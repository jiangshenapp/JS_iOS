//
//  DriverConfig.h
//  JS_Driver
//
//  Created by zhanbing han on 2019/8/29.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DriverConfig : NSObject

#pragma mark - H5名称
#define H5_Privacy @"privacyProtocal-driver.html" //隐私协议
#define H5_Register @"registerProtocal-driver.html" //用户注册协议

#pragma mark - APP司机端微信登录
#define URL_BindingWxInfo @"/app/driverWx/bindingWxInfo" //登录后绑定
#define URL_RebindingWxInfo @"/app/driverWx/rebindingWxInfo" //微信号已与其他账号绑定，解除原账号绑定，并绑定当前新账号
#define URL_UnbindingWxInfo @"/app/driverWx/unbindingWxInfo" //登录后解绑
#define URL_WxCodeLogin @"/app/driverWx/wxCodeLogin" //code登录
#define URL_WxLogin @"/app/driverWx/wxLogin" //绑定页面短信登录
#define URL_GetWxBindingInfo @"/app/driverWx/getWxBindingInfo" //获取用户微信授权绑定状态

#pragma mark - 用户信息
#define URL_RechargeDriverDeposit @"/app/account/rechargeDriverDeposit" //运力端缴纳保证金
#define URL_ParkSupplement @"/app/park/supplement" //园区信息补充"

#pragma mark - 我的车辆
#define URL_AddCar @"/app/car/add" //添加车辆"
#define URL_ReAuditCar @"/app/car/reAudit" //重新审核车辆
#define URL_GetCarDetail @"/app/car/get" //车辆详情
#define URL_CarList @"/app/car/list" //我的车辆列表
#define URL_UnbindingCar @"/app/car/unbinding" //解绑

#pragma mark - 我的司机
#define URL_Drivers @"/app/park/drivers" //司机列表
#define URL_BindDriver @"/app/park/binding" //绑定司机
#define URL_UnBindDriver @"/app/park/unbinding" //解绑司机
#define URL_FindDriverByMobile @"/app/driver/findByMobile" //查询司机

#pragma mark - 我的路线
#define URL_MyLines @"/app/line/myLines"//我的路线
#define URL_AddMyLines @"/app/line/add"//添加我的路线
#define URL_EditMyLines @"/app/line/edit"//编辑我的路线
#define URL_GetMyLines @"/app/line/get"//路线详情
#define URL_LineClassic @"/app/line/classic"//申请精品线路
#define URL_LineEnable @"/app/line/enable" //启用停用 1启用0停用
#define URL_LineDelete @"/app/line/remove"//删除线路
#define URL_LineEdit @"/app/line/edit"// 编辑线路
#define URL_DriverFind @"/app/driver/order/find"//找货 所有待分配订单"

#pragma mark - 订单
#define URL_DriverOrdeList @"/app/driver/order/list"//我的运单
#define URL_GetOrderInfo @"/app/driver/order/get"//订单详情
#define URL_RefuseOrder @"/app/driver/order/refuse"//拒绝接单
#define URL_ReceiveOrder @"/app/driver/order/receive"//接单
#define URL_DriverConfirmOrder @"/app/driver/order/confirm"//确认"
#define URL_CancelReceiveOrder @"/app/driver/order/cancelReceive"//取消接货"
#define URL_CancelDistributionOrder @"/app/driver/order/cancelDistribution"//拒绝配送"
#define URL_DistributionOrder @"/app/driver/order/distribution"//开始配送"
#define URL_CompleteDistributionOrder  @"/app/driver/order/completeDistribution"//完成配送"
#define URL_CommentOrder @"/app/driver/order/comment"//回执评价"

@end

NS_ASSUME_NONNULL_END
