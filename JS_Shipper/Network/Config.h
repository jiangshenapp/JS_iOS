//
//  Config.h
//  Chaozhi
//  Notes：接口地址【文档：http://47.96.122.74:9999/swagger-ui.html】
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject

#pragma mark - ---------------接口地址---------------

// 接口地址
NSString *ROOT_URL(void);
// 图片地址
NSString *PIC_URL(void);

#pragma mark - ---------------接口名称---------------

#pragma mark - 上传文件

#define URL_FileUpload @"http://gateway.jiangshen56.com/admin/file/upload" //上传文件

#pragma mark - APP账户接口

#define URL_GetPayRoute @"http://gateway.jiangshen56.com/pigx-pay-biz/pay/getRoute"//获取支付方式
#define URL_Recharge @"/app/account/recharge"//账户充值
#define URL_BalanceWithdraw @"/app/account/balanceWithdraw"//提现申请
#define URL_GetBySubscriber @"/app/account/getBySubscriber"//账户详情
#define URL_GetTradeRecord @"/app/account/getTradeRecord"//账单明细
#define URL_RechargeOrderFee @"/app/account/rechargeOrderFee"//支付运费(余额)

#pragma mark - 根据类型获取字典

#define URL_GetDictByType @"/app/dict/getDictByType"//根据类型获取字典
#define URL_GetDictList @"/app/dict/getDictList" //获取字典列表
#define URL_GetCityList @"/app/area/getCityTree"// 获取所有城市

#pragma mark - APP会员注册登录接口

#define URL_Login @"/app/subscriber/login2" //密码登录
#define URL_SmsLogin @"/app/subscriber/smsLogin2" //短信验证码登录
#define URL_Logout @"/app/subscriber/logout" //退出登录
#define URL_Profile @"/app/subscriber/profile" //获取当前登录人信息
#define URL_Registry @"/app/subscriber/registry" //会员注册
#define URL_ResetPwdStep1 @"/app/subscriber/resetPwdStep1" //重置密码步骤1
#define URL_ResetPwdStep2 @"/app/subscriber/resetPwdStep2" //重置密码步骤2
#define URL_SendSmsCode @"/app/subscriber/sendSmsCode" //发送短信验证码
#define URL_SetPwd @"/app/subscriber/setPwd" //设置密码
#define URL_BindMobile @"/app/subscriber/bindMobile" //绑定手机号
#define URL_ChangeAvatar @"/app/subscriber/changeAvatar" //修改头像
#define URL_ChangeNickname @"/app/subscriber/changeNickname" //修改昵称

#pragma mark - APP会员认证接口

#define URL_CompanyConsignorVerified @"/app/subscriber/verify/companyConsignorVerified" //企业货主认证
#define URL_DriverVerified @"/app/subscriber/verify/driverVerified" //个人司机认证
#define URL_GetCompanyConsignorVerifiedInfo @"/app/subscriber/verify/getCompanyConsignorVerifiedInfo" //获取企业货主认证信息
#define URL_GetDriverVerifiedInfo @"/app/subscriber/verify/getDriverVerifiedInfo" //获取司机认证信息
#define URL_GetParkVerifiedInfo @"/app/subscriber/verify/getParkVerifiedInfo" //获取园区认证信息
#define URL_GetPersonConsignorVerifiedInfo @"/app/subscriber/verify/getPersonConsignorVerifiedInfo" //获取个人货主认证信息
#define URL_ParkVerified @"/app/subscriber/verify/parkVerified" //园区认证
#define URL_PersonConsignorVerified @"/app/subscriber/verify/personConsignorVerified" //个人货主认证

#pragma mark - APP线路相关接口

#define URL_Classic @"/app/line/classic" //精品线路
#define URL_Find @"/app/line/find" //车源
#define URL_CityParkList @"/app/park/list"//找城市配送
#define URL_GetParkDetail @"/app/park/get"//园区详情"
#define URL_GetLineDetail @"/app/line/get"//线路详情"

#pragma mark - APP收藏相关接口

#define URL_LineAdd @"/app/collect/line/add" //线路收藏
#define URL_LineRemove @"/app/collect/line/remove" //取消线路收藏
#define URL_LineList @"/app/collect/line/list" //我的线路收藏
#define URL_LineClassicList @"/app/collect/line/classicList" //我的精品线路收藏
#define URL_ParkAdd @"/app/collect/park/add" //添加园区收藏
#define URL_ParkRemove @"/app/collect/park/remove" //取消园区收藏
#define URL_ParkList @"/app/collect/park/list" //我的园区收藏

#pragma mark - APP订单相关接口

#define URL_AddOrder @"/app/order/addOrder"//发货 --综合下单
#define URL_AddStepOne @"/app/order/addStepOne"//发货 --创建订单
#define URL_AddStepTwo @"/app/order/addStepTwo"//发货 --确认订单
#define URL_AgainOrder @"/app/order/again"//重新发货
#define URL_CancelOrderDetail @"/app/order/cancel"//取消订单
#define URL_ConfirmOrder @"/app/order/confirm"//确认收货
#define URL_ConfirmOrderReceipt @"/app/order/receipt"//确认收到回执
#define URL_GetOrderDetail @"/app/order/get"//订单详情
#define URL_OrdeList @"/app/order/list"//我的运单
#define URL_EditOrderDetail @"/app/order/edit" //修改订单

#pragma mark - ---------------H5地址---------------

NSString *h5Url(void);

#pragma mark - ---------------H5名称---------------

#define H5_Privacy @"yszc.html" //隐私协议
#define H5_Register @"yhzcxy.html" //用户注册协议

@end
