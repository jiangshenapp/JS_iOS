//
//  JSRechargeVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/27.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSRechargeVC.h"
#import "PayRouteModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "Toast.h"

@interface JSRechargeVC ()<UITextFieldDelegate>

/** 支付路由数组 */
@property (nonatomic,retain) NSMutableArray *listData;
/** 支付宝支付路由 */
@property (nonatomic,retain) PayRouteModel *alipayRoute;
/** 微信支付路由 */
@property (nonatomic,retain) PayRouteModel *wechatRoute;

@end

@implementation JSRechargeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值";
    self.priceTF.delegate = self;
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
    NSString *urlStr = [NSString stringWithFormat:@"%@?business=%d&merchantId=%d",URL_GetPayRoute,2,1];
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

#pragma mark - methods

//支付宝选中
- (IBAction)alipaySelectAction:(id)sender {
    self.alipayBtn.selected = YES;
    self.wechatBtn.selected = NO;
}

//微信选中
- (IBAction)wechetSelectAction:(id)sender {
    self.alipayBtn.selected = NO;
    self.wechatBtn.selected = YES;
}

//充值
- (IBAction)payAction:(id)sender {
    if ([Utils isBlankString:self.priceTF.text]) {
        [Utils showToast:@"请输入充值金额"];
        return;
    }
    if ([self.priceTF.text floatValue]<=0) {
        [Utils showToast:@"充值金额不能低于0元"];
        return;
    }
    [self.view endEditing:YES];
    if (self.alipayBtn.isSelected == YES) {
        [self alipay];
    }
    if (self.wechatBtn.isSelected == YES) {
        [self wechatPay];
    }
}

#pragma mark - 支付宝支付
- (void)alipay {
    
    //tradeType 交易类型, 1账户充值, 5运费支付，10运力端保证金，11货主端保证金
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *urlStr = [NSString stringWithFormat:@"%@?tradeType=%@&channelType=%@&money=%@&routeId=%@",URL_Recharge,@"1",_alipayRoute.channelType,self.priceTF.text,_alipayRoute.routeId];
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
        NSString *urlStr = [NSString stringWithFormat:@"%@?tradeType=%@&channelType=%@&money=%@&routeId=%@",URL_Recharge,@"1",_wechatRoute.channelType,self.priceTF.text,_wechatRoute.routeId];
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
                    [WXApi sendReq:req];
                }
            }
        }];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    NSString * toBeString = [textField.text     stringByReplacingCharactersInRange:range withString:string];
    // 判断是否输入内容，或者用户点击的是键盘的删除按钮
    if (![string isEqualToString:@""]) {
        if ([textField isEqual:self.priceTF]) {
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
