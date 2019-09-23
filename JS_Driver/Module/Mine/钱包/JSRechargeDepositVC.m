//
//  JSRechargeDepositVC.m
//  JS_Driver
//
//  Created by zhanbing han on 2019/5/7.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "JSRechargeDepositVC.h"
#import "PayRouteModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface JSRechargeDepositVC ()

/** 支付方式 0 支付宝  1微信  2账户余额 */
@property (nonatomic,assign) NSInteger payType;

/** 支付路由数组 */
@property (nonatomic,retain) NSMutableArray *listData;
/** 支付宝支付路由 */
@property (nonatomic,retain) PayRouteModel *alipayRoute;
/** 微信支付路由 */
@property (nonatomic,retain) PayRouteModel *wechatRoute;

@end

@implementation JSRechargeDepositVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"缴纳保证金";
    
    _payType = 0;
    _moneyTF.delegate = self;
    self.currentMoneyLab.text = [NSString stringWithFormat:@"%.2f元",[self.accountInfo.driverDeposit floatValue]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:kPaySuccNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFail) name:kPayFailNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payCancel) name:kPayCancelNotification object:nil];
    
    [self getData];
}

#pragma mark - AppDelegate支付结果回调

//支付成功
- (void)paySuccess {
    XLGAlertView *alert = [[XLGAlertView alloc] initWithTitle:@"温馨提示" content:@"支付成功" leftButtonTitle:@"" rightButtonTitle:@"确定"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kChangeMoneyNotification object:nil];
    [self backAction];
}

//支付失败
- (void)payFail {
    XLGAlertView *alert = [[XLGAlertView alloc] initWithTitle:@"温馨提示" content:@"支付失败" leftButtonTitle:@"" rightButtonTitle:@"确定"];
}

//支付取消
-(void)payCancel {
    XLGAlertView *alert = [[XLGAlertView alloc] initWithTitle:@"温馨提示" content:@"支付取消" leftButtonTitle:@"" rightButtonTitle:@"确定"];
}

#pragma mark - get data

- (void)getData {
    // business_id 1、运力端充值 2、货主端充值 3、货主端支付运费
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *urlStr = [NSString stringWithFormat:@"%@?business=%d&merchantId=%d",URL_GetPayRoute,1,1];
    [[NetworkManager sharedManager] postJSON:urlStr parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            self.listData = [PayRouteModel mj_objectArrayWithKeyValuesArray:responseData];
            for (PayRouteModel *payRouteModel in self.listData) {
                if ([payRouteModel.channelType isEqualToString:@"1"]) {
                    self.alipayRoute = payRouteModel;
                }
                if ([payRouteModel.channelType isEqualToString:@"2"]) {
                    self.wechatRoute = payRouteModel;
                }
            }
        }
    }];
}

- (IBAction)ExplainAction:(UIButton *)sender {
    [Utils showToast:@"违约说明"];
}

- (IBAction)payTypeAction:(UIButton *)sender {
    for (NSInteger index = 100; index<103; index++) {
        UIButton *tampBtn = [self.view viewWithTag:index];
        tampBtn.selected = NO;
    }
    sender.selected = YES;
    _payType = sender.tag-100;
}

- (IBAction)touchAgreeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)showAgreeProtocolAction:(UIButton *)sender {
    [Utils showToast:@"保证金协议"];
}

- (IBAction)rechagreBtnAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
//    if (self.selectBtn.selected == NO) {
//        [Utils showToast:@"请勾选保证金协议"];
//        return;
//    }
    if ([NSString isEmpty:self.moneyTF.text]) {
        [Utils showToast:@"请输入您要充值的保证金金额"];
        return;
    }
    if ([self.moneyTF.text floatValue]<=0) {
        [Utils showToast:@"缴纳保证金金额不能低于0元"];
        return;
    }
    if (self.payType == 0) { //支付宝
        [self alipay];
    }
    if (self.payType == 1) { //微信
        [self wechatPay];
    }
    if (self.payType == 2) { //余额
        [self balancePay];
    }
}

#pragma mark - 支付宝支付
- (void)alipay {
    
    //tradeType 交易类型, 1账户充值, 5运费支付，10运力端保证金，11货主端保证金
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *urlStr = [NSString stringWithFormat:@"%@?tradeType=%@&channelType=%@&money=%@&routeId=%@",URL_Recharge,@"10",_alipayRoute.channelType,self.moneyTF.text,_alipayRoute.routeId];
    [[NetworkManager sharedManager] postJSON:urlStr parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            //应用注册scheme,在Info.plist定义URL types
            NSString *appScheme = kAPPScheme;
            NSString *orderInfo = responseData[@"orderInfo"];
            
            if (![Utils isBlankString:orderInfo]) {
                
                [[AlipaySDK defaultService] payOrder:orderInfo fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    NSInteger status = [resultDic[@"resultStatus"] integerValue];
                    
                    switch (status) {
                        case 9000:
                            [self paySuccess];
                            break;
                            
                        case 8000:
                            [Utils showToast:@"订单正在处理中"];
                            break;
                            
                        case 4000:
                            [self payFail];
                            break;
                            
                        case 6001:
                            [self payCancel];
                            break;
                            
                        case 6002:
                            [Utils showToast:@"网络连接出错"];
                            break;
                            
                        default:
                            break;
                    }
                }];
            }
        }
    }];
}

#pragma mark - 微信支付
- (void)wechatPay {
    if (![WXApi isWXAppInstalled] && ![WXApi isWXAppSupportApi]) {
        [Utils showToast:@"您未安装微信客户端，请安装微信以完成支付"];
    } else {
        //tradeType 交易类型, 1账户充值, 5运费支付，10运力端保证金，11货主端保证金
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSString *urlStr = [NSString stringWithFormat:@"%@?tradeType=%@&channelType=%@&money=%@&routeId=%@",URL_Recharge,@"10",_wechatRoute.channelType,self.moneyTF.text,_wechatRoute.routeId];
        [[NetworkManager sharedManager] postJSON:urlStr parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
            if (status==Request_Success) {
                
                NSString *orderInfo = responseData[@"orderInfo"];
                
                if (![Utils isBlankString:orderInfo]) {
                    NSDictionary *orderDic = [Utils dictionaryWithJsonString:orderInfo];
                    //调起微信支付
                    PayReq *req             = [[PayReq alloc] init];
                    req.openID              = orderDic[@"appid"];
                    req.partnerId           = orderDic[@"partnerid"];
                    req.prepayId            = orderDic[@"prepayid"];
                    req.nonceStr            = orderDic[@"noncestr"];
                    NSMutableString *stamp  = orderDic[@"timestamp"];
                    req.timeStamp           = stamp.intValue;
                    req.package             = orderDic[@"package"];
                    req.sign                = orderDic[@"sign"];
                    [WXApi sendReq:req completion:nil];
                }
            }
        }];
    }
}

#pragma mark - 余额支付
- (void)balancePay {

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *urlStr = [NSString stringWithFormat:@"%@?deposit=%@",URL_RechargeDriverDeposit,self.moneyTF.text];
    [[NetworkManager sharedManager] postJSON:urlStr parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            [self paySuccess];
        }
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    NSString * toBeString = [textField.text     stringByReplacingCharactersInRange:range withString:string];
    // 判断是否输入内容，或者用户点击的是键盘的删除按钮
    if (![string isEqualToString:@""]) {
        //        if ([textField isEqual:self.textField]) {
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
        //        }
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
