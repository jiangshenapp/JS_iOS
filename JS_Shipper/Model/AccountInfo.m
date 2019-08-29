//
//  AccountInfo.m
//  JS_Driver
//
//  Created by zhanbing han on 2019/6/7.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "AccountInfo.h"

@implementation AccountInfo

- (NSString *)balance {
    _balance = [NSString stringWithFormat:@"%.2f",[_balance doubleValue]];
    return _balance;
}

- (NSString *)driverDeposit {
    _driverDeposit = [NSString stringWithFormat:@"%.2f",[_driverDeposit doubleValue]];
    return _driverDeposit;
}

- (NSString *)tradeDeposit {
    _tradeDeposit = [NSString stringWithFormat:@"%.2f",[_tradeDeposit doubleValue]];
    return _tradeDeposit;
}

- (NSString *)consignorDeposit {
    _consignorDeposit = [NSString stringWithFormat:@"%.2f",[_consignorDeposit doubleValue]];
    return _consignorDeposit;
}

@end
