//
//  JSMyDepositVC.m
//  JS_Driver
//
//  Created by zhanbing han on 2019/5/6.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "JSMyDepositVC.h"
#import "JSBillDetailsVC.h"
#import "JSWithdrawalMoneyVC.h"
#import "JSRechargeDepositVC.h"

@interface JSMyDepositVC ()

@end

@implementation JSMyDepositVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的保证金";
    
    [self getData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData) name:kChangeMoneyNotification object:nil];

    self.depositLab.text = self.accountInfo.driverDeposit;
}

#pragma mark - get data

- (void)getData {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [[NetworkManager sharedManager] getJSON:URL_GetBySubscriber parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            self.accountInfo = [AccountInfo mj_objectWithKeyValues:(NSDictionary *)responseData];
            if (self.accountInfo!=nil) {
                self.depositLab.text = self.accountInfo.driverDeposit;
            }
        }
    }];
}

- (IBAction)explainAction:(id)sender {
    [Utils showToast:@"违约说明"];
}

/** 提现 */
- (IBAction)withdrawalAction:(id)sender {
    if ([self.depositLab.text floatValue]<=0) {
        [Utils showToast:@"保证金金额需要大于0元"];
        return;
    }
    JSWithdrawalMoneyVC *vc = (JSWithdrawalMoneyVC *)[Utils getViewController:@"Mine" WithVCName:@"JSWithdrawalMoneyVC"];
    vc.maxMoney = self.accountInfo.driverDeposit;
    vc.withdrawType = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}


/*
#pragma mark - Navigation
 */

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"depositDetailID"]) {
        JSBillDetailsVC *vc = segue.destinationViewController;
        vc.type = 2;
    }
    if ([segue.identifier isEqualToString:@"depositRechargeID"]) {
        JSRechargeDepositVC *vc = segue.destinationViewController;
        vc.accountInfo = self.accountInfo;
    }
}

@end
