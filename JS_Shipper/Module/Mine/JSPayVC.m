//
//  JSPayVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/29.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSPayVC.h"
#import "PayRouteModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "Toast.h"

@interface JSPayVC ()
{
    NSInteger payType; //0支付宝 1微信 2余额
}
/** 支付路由数组 */
@property (nonatomic,retain) NSMutableArray *listData;
/** 支付宝支付路由 */
@property (nonatomic,retain) PayRouteModel *alipayRoute;
/** 微信支付路由 */
@property (nonatomic,retain) PayRouteModel *wechatRoute;
@end

@implementation JSPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"在线支付";
    
    payType = 0;
    _payMoneyLab.text =[NSString stringWithFormat:@"%@", _price];
    
    [self getData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:kPaySuccNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFail) name:kPayFailNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payCancel) name:kPayCancelNotification object:nil];
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
    NSString *urlStr = [NSString stringWithFormat:@"%@?business=%d&merchantId=%d",PAY_URL(),2,1];
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

- (IBAction)payTypeAction:(UIButton *)sender {
    sender.selected = YES;
    for (NSInteger tag = 100; tag<103; tag++) {
        UIButton *payBtn = [self.view viewWithTag:tag];
        if (![sender isEqual:payBtn]) {
            payBtn.selected = NO;
        }
    }
    payType = sender.tag-100;
}

- (IBAction)payAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    if (payType==0) {
        [self alipay];
    } else if (payType==1) {
        [self wechatPay];
    } else if (payType==2) {
        [self balancePay];
    }
}

#pragma mark - 支付宝支付
- (void)alipay {
    
    //tradeType 交易类型, 1账户充值, 5运费支付，10运力端保证金，11货主端保证金
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *urlStr = [NSString stringWithFormat:@"%@?tradeType=%@&channelType=%@&money=%@&routeId=%@&orderNo=%@",URL_Recharge,@"5",_alipayRoute.channelType,self.payMoneyLab.text,_alipayRoute.routeId,_orderID];
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
        NSString *urlStr = [NSString stringWithFormat:@"%@?tradeType=%@&channelType=%@&money=%@&routeId=%@&orderNo=%@",URL_Recharge,@"5",_wechatRoute.channelType,self.payMoneyLab.text,_wechatRoute.routeId,_orderID];
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
    NSString *urlStr = [NSString stringWithFormat:@"%@?orderNo=%@",URL_RechargeOrderFee,_orderID];
    [[NetworkManager sharedManager] postJSON:urlStr parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            [self paySuccess];
        }
    }];
}

@end
