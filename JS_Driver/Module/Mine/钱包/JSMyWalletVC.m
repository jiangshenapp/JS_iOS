//
//  JSMyWalletVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/26.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSMyWalletVC.h"
#import "JSWithdrawalMoneyVC.h"
#import "JSMyDepositVC.h"
#import "AccountInfo.h"

@interface JSMyWalletVC ()

/** 账户信息 */
@property (nonatomic,retain) AccountInfo *accountInfo;

@end

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
            self.accountInfo = [AccountInfo mj_objectWithKeyValues:(NSDictionary *)responseData];
            if (self.accountInfo!=nil) {
                self.balanceLab.text = self.accountInfo.balance;
                self.depositLab.text = self.accountInfo.driverDeposit;
            }
        }
    }];
}

// 提现
- (IBAction)withdrawalAction:(id)sender {
    if ([self.balanceLab.text floatValue]<=0) {
        [Utils showToast:@"提现金额需要大于0元"];
        return;
    }
    JSWithdrawalMoneyVC *vc = (JSWithdrawalMoneyVC *)[Utils getViewController:@"Mine" WithVCName:@"JSWithdrawalMoneyVC"];
    vc.maxMoney = self.balanceLab.text;
    vc.withdrawType = @"2";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)depositAction:(id)sender {
    JSMyDepositVC *vc = (JSMyDepositVC *)[Utils getViewController:@"Mine" WithVCName:@"JSMyDepositVC"];
    vc.accountInfo = self.accountInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
