//
//  JSRechargeDepositVC.h
//  JS_Driver
//
//  Created by zhanbing han on 2019/5/7.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "BaseVC.h"
#import "AccountInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSRechargeDepositVC : BaseVC

/** 账户信息 */
@property (nonatomic,retain) AccountInfo *accountInfo;

/** 当前保证金 */
@property (weak, nonatomic) IBOutlet UILabel *currentMoneyLab;
/** 需缴纳保证金 */
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
/** 选择协议 */
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

/** 违约说明 */
- (IBAction)ExplainAction:(UIButton *)sender;
/** 支付方式 */
- (IBAction)payTypeAction:(UIButton *)sender;
/** 是否同意协议 */
- (IBAction)touchAgreeAction:(UIButton *)sender;
/** 立即充值 */
- (IBAction)rechagreBtnAction:(UIButton *)sender;
/** 协议跳转 */
- (IBAction)showAgreeProtocolAction:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
