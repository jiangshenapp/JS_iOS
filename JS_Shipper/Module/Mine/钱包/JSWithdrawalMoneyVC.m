//
//  JSWithdrawalMoneyVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/27.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSWithdrawalMoneyVC.h"

@interface JSWithdrawalMoneyVC ()

@end

@implementation JSWithdrawalMoneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提现";
    
    self.moneyTF.enabled = NO;
    self.moneyTF.text = self.maxMoney;
    self.maxMoneyLab.text = [NSString stringWithFormat:@"当前最大提现金额：%@元",self.maxMoney];
    [self getServiceFeeData];
}

/** 手续费 */
- (void)getServiceFeeData {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@?type=servicefee",URL_GetDictByType];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            NSArray *arr = responseData;
            if ([arr isKindOfClass:[NSArray class]]) {
                if (arr.count>0) {
                    NSDictionary *dic = [arr firstObject];
                    weakSelf.serviceFeeLab.text = [NSString stringWithFormat:@"提现手续费：%.2f%@",[dic[@"value"] floatValue],@"%"];
                }
            }
        }
    }];
}

#pragma mark - get data

- (void)getData {
    
}

#pragma mark - methods

// 选中支付宝
- (IBAction)selectAlipayAction:(id)sender {
    self.alipayBtn.selected = YES;
    self.bankCardBtn.selected = NO;
}

// 选中银行卡
- (IBAction)selectBankAction:(id)sender {
    self.alipayBtn.selected = NO;
    self.bankCardBtn.selected = YES;
}

// 申请提现
- (IBAction)commitAction:(id)sender {
    if ([Utils isBlankString:self.moneyTF.text]) {
        [Utils showToast:@"请输入提现金额"];
        return;
    }
    [self.view endEditing:YES];
    CGFloat inputMoney = [self.moneyTF.text floatValue];
    CGFloat balanceMoney = [self.maxMoney floatValue];
    if (inputMoney>balanceMoney) {
        [Utils showToast:@"超过最大提现金额，请重新输入"];
        return;
    }
    NSString *withdrawChannel = @"1";
    if (self.alipayBtn.selected == YES) {
        if ([Utils isBlankString:self.alipayAccountTF.text]) {
            [Utils showToast:@"请输入支付宝账户"];
            return;
        }
        if ([Utils isBlankString:self.alipayAccountNameTF.text]) {
            [Utils showToast:@"请输入支付宝账户姓名"];
            return;
        }
    }
    if (self.bankCardBtn.selected == YES) {
        withdrawChannel = @"2";
        if ([Utils isBlankString:self.bankCardNoTF.text]) {
            [Utils showToast:@"请输入卡号"];
            return;
        }
        if ([Utils isBlankString:self.openBankNameTF.text]) {
            [Utils showToast:@"请输入开户行"];
            return;
        }
        if ([Utils isBlankString:self.openBankBranchNameTF.text]) {
            [Utils showToast:@"请输入支行"];
            return;
        }
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *urlStr = [NSString stringWithFormat:@"%@?bankCard=%@&khh=%@&zh=%@&withdrawChannel=%@&withdrawType=%@&zfbzh=%@&zfbmc=%@",URL_BalanceWithdraw,self.bankCardNoTF.text,self.openBankNameTF.text,self.openBankBranchNameTF.text,withdrawChannel,@"2",self.alipayAccountTF.text,self.alipayAccountNameTF.text];
    [[NetworkManager sharedManager] postJSON:urlStr parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            [Utils showToast:@"申请提现成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kChangeMoneyNotification object:nil];
            [self backAction];
        }
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    NSString * toBeString = [textField.text     stringByReplacingCharactersInRange:range withString:string];
    // 判断是否输入内容，或者用户点击的是键盘的删除按钮
    if (![string isEqualToString:@""]) {
        if ([textField isEqual:self.moneyTF]) {
            // 小数点在字符串中的位置 第一个数字从0位置开始
            NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
            if (dotLocation == NSNotFound && range.location != 0) {
                //没有小数点,最大数值
                if (range.location >= 9){
                    NSLog(@"单笔金额不能超过亿位");
                    if ([string isEqualToString:@"."] && range.location == 9) {
                        return YES;
                    }
                    return NO;
                }
            }
            //判断输入多个小数点,禁止输入多个小数点
            if (dotLocation != NSNotFound){
                if ([string isEqualToString:@"."])return NO;
            }
            //判断小数点后最多两位
            if (dotLocation != NSNotFound && range.location > dotLocation + 2) { return NO; }
            //判断总长度
            if (textField.text.length > 11) {
                return NO;
            }
        }
    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
