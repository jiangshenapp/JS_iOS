//
//  Config.h
//  Chaozhi
//  Notes：接口地址【文档：http://47.96.122.74:9999/swagger-ui.html?urls.primaryName=logistic-biz】
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject

#pragma mark - ---------------接口地址---------------

// H5地址
NSString *h5Url(void);
// 接口地址
NSString *ROOT_URL(void);
// 图片地址
NSString *PIC_URL(void);
// 上传地址
NSString *UPLOAD_URL(void);
// 支付地址
NSString *PAY_URL(void);

#pragma mark - ---------------接口名称---------------

#pragma mark - APP账户接口

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
#define URL_CityParkList @"/app/park/list"//找附近网点
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
#define URL_OrderComment @"/app/order/score"//订单评价
#define URL_GetOrderDetail @"/app/order/get"//订单详情
#define URL_OrdeList @"/app/order/list"//我的运单
#define URL_EditOrderDetail @"/app/order/edit" //修改订单

#pragma mark - 圈子相关接口

#define URL_CircleAll @"/app/circle/all"//所有圈子"
#define URL_CircleApply @"/app/circle/apply"//申请加入
#define URL_CircleAuditApply @"/app/circle/auditApply"//入圈审核"
#define URL_CircleDeleteSubscriber @"/app/circle/deleteSubscriber"//删除成员"
#define URL_CircleMyList @"/app/circle/list"//我的圈子
#define URL_CircleMemberList @"/app/circle/memberList"//圈子成员列表"
#define URL_CircleLikeSubject @"/app/circle/likeSubject"//关注话题"
#define URL_ExistCircle @"/app/circle/existCircle"//退出圈子"

#pragma mark - 帖子相关接口

#define URL_PostAdd @"/app/post/addPost"//发帖"
#define URL_PostComment @"/app/post/comment"//评论"
#define URL_PostCommentList @"/app/post/commentList"//评论列表
#define URL_PostLike @"/app/post/like"//点赞"
#define URL_PostList @"/app/post/list"//帖子列表
#define URL_PostDetail @"/app/post/detail"//帖子详情"

#pragma mark - 系统消息、banner相关接口

#define URL_MessageList @"/app/message/page"//消息列表"
#define URL_MessageDetail @"/app/message"//消息详情"
#define URL_GetUnreadMessageCount @"/app/message/getUnreadMessageCount"//获取系统消息未读数"
#define URL_GetUnreadPushLogCount @"/app/message/getUnreadPushLogCount"//获取推送消息未读数
#define URL_GetPushLog @"/app/message/getPushLog"//推送消息列表"
#define URL_ReadAllPushLog @"/app/message/readAllPushLog"//标记全部推送消息为已读"
#define URL_ReadPushLog @"/app/message/readPushLog"//标记推送消息为已读"
#define URL_ReadPushLog @"/app/message/readPushLog"//标记推送消息为已读"


#define URL_GetSysServiceBanner @"/app/sys/getSysServiceBanner"//获取系统服务Banner
#define URL_GetSysServiceList @"/app/sys/getSysServiceList"//获取系统服务
#define URL_GetBannerList @"/app/banner/list"//根据类型获取banner type 1服务页广告、2发货页广告、3启动页广告
#define URL_Feedback @"/app/feedback/save"//新增意见反馈
@end
