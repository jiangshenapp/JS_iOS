//
//  AccountInfo.h
//  JS_Driver
//
//  Created by zhanbing han on 2019/6/7.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "BaseItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccountInfo : BaseItem

/**
 * {
 driverDepositState : 1,
 subscriberId : 2,
 id : 2,
 balanceState : 2,
 driverDeposit : 0,
 tradeDeposit : 0,
 balance : 0.01,
 consignorDeposit : 0
 }
 */

/* 运力端保证金状态, 1正常，2提现中 */
@property (nonatomic,copy) NSString *driverDepositState;
/* 会员id */
@property (nonatomic,copy) NSString *subscriberId;
/* 余额状态, 1正常，2提现中 */
@property (nonatomic,copy) NSString *balanceState;
/* 司机保证金 */
@property (nonatomic,copy) NSString *driverDeposit;
/* 交易保证金 */
@property (nonatomic,copy) NSString *tradeDeposit;
/* 余额 */
@property (nonatomic,copy) NSString *balance;
/* 货主保证金 */
@property (nonatomic,copy) NSString *consignorDeposit;

@end

NS_ASSUME_NONNULL_END
