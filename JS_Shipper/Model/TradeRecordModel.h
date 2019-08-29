//
//  TradeRecordModel.h
//  JS_Shipper
//
//  Created by Jason_zyl on 2019/6/6.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "BaseItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface TradeRecordModel : BaseItem

/**
 * {
 "remark" : "保证金提现",
 "accountId" : 2,
 "finishTime" : "",
 "id" : 23,
 "tradeType" : 3,
 "orderNo" : "",
 "createTime" : "2019-06-06 22:21:14",
 "tradeMoney" : -0.01,
 "tradeNo" : "YETX-1559830873543",
 "state" : 0,
 "operateBy" : ""
 }
 */

/** 交易描述 */
@property (nonatomic, copy) NSString              *remark;
/** 交易类型，1微信充值，2支付宝充值，3提现到支付宝，4提现到银行卡，5运费支付，6违约扣款，7购买积分，8违约金收入，9运费收入 */
@property (nonatomic, copy) NSString              *tradeType;
/** 交易时间 */
@property (nonatomic, copy) NSString              *createTime;
/** 交易金额,正数代表入账，负数代表出账 */
@property (nonatomic, copy) NSString              *tradeMoney;
/** 交易号 */
@property (nonatomic, copy) NSString              *tradeNo;
/** 交易状态，0操作中，1已完成，2失败 */
@property (nonatomic, copy) NSString              *state;

@end

NS_ASSUME_NONNULL_END
