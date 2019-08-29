//
//  PayRouteModel.h
//  JS_Shipper
//
//  Created by Jason_zyl on 2019/6/6.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "BaseItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface PayRouteModel : BaseItem

/**
 *
 {
 "defaultAccount" : 2,
 "businessName" : "货主端充值",
 "delFlag" : "0",
 "channelId" : 4,
 "routeId" : 2,
 "channelType" : "2",
 "merchantId" : 1,
 "channelName" : "微信APP支付",
 "createTime" : "2019-06-06 01:25:19",
 "businessId" : 2,
 "status" : "1",
 "updateTime" : "2019-06-06 01:25:19"
 }
 */

/** 默认收款账号id */
@property (nonatomic, copy) NSString              *defaultAccount;
/** 支付业务名称 */
@property (nonatomic, copy) NSString              *businessName;
/** 支付渠道id */
@property (nonatomic, copy) NSString              *channelId;
/** 支付路由id */
@property (nonatomic, copy) NSString              *routeId;
/** 渠道类型 1-支付宝 2-微信 3-银联 */
@property (nonatomic, copy) NSString              *channelType;
/** 商户id */
@property (nonatomic, copy) NSString              *merchantId;
/** 支付渠道名称 */
@property (nonatomic, copy) NSString              *channelName;
/** 支付业务id */
@property (nonatomic, copy) NSString              *businessId;

@end

NS_ASSUME_NONNULL_END
