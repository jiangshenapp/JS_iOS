//
//  JSMyWalletVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/26.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSMyWalletVC.h"
#import "JSWithdrawalMoneyVC.h"
#import "JSRechargeVC.h"
#import "AccountInfo.h"

@implementation JSMyWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的钱包";
    
    [self getData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData) name:kChangeMoneyNotification object:nil];
}

#pragma mark - get data

- (void)getData {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [[NetworkManager sharedManager] getJSON:URL_GetBySubscriber parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            AccountInfo *accountInfo = [AccountInfo mj_objectWithKeyValues:(NSDictionary *)responseData];
            if (accountInfo!=nil) {
                self.balanceLab.text = accountInfo.balance;
            }
        }
    }];
}

// 提现
- (IBAction)withdrawalAction:(id)sender {
    JSWithdrawalMoneyVC *vc = (JSWithdrawalMoneyVC *)[Utils getViewController:@"Mine" WithVCName:@"JSWithdrawalMoneyVC"];
    vc.maxMoney = self.balanceLab.text;
    [self.navigationController pushViewController:vc animated:YES];
}

// 充值
- (IBAction)rechargeAction:(id)sender {
    JSRechargeVC *vc = (JSRechargeVC *)[Utils getViewController:@"Mine" WithVCName:@"JSRechargeVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
