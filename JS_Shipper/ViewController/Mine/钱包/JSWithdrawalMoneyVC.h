//
//  JSWithdrawalMoneyVC.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/27.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSWithdrawalMoneyVC : BaseVC

/** 余额(提现最大金额) */
@property (nonatomic,copy) NSString *maxMoney;

@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UILabel *maxMoneyLab;
@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;
@property (weak, nonatomic) IBOutlet UITextField *alipayAccountTF;
@property (weak, nonatomic) IBOutlet UITextField *alipayAccountNameTF;
@property (weak, nonatomic) IBOutlet UIButton *bankCardBtn;
@property (weak, nonatomic) IBOutlet UITextField *bankCardNoTF;
@property (weak, nonatomic) IBOutlet UITextField *openBankNameTF;
@property (weak, nonatomic) IBOutlet UITextField *openBankBranchNameTF;

@end

NS_ASSUME_NONNULL_END
