//
//  JSOtherAccountVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/23.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSOtherAccountVC.h"
#import "WXApiManager.h"
#import "WXApiRequestHandler.h"
#import "WxAuthModel.h"

@interface JSOtherAccountVC ()<WXApiManagerDelegate>

@end

@implementation JSOtherAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"社交账户";
    
    [WXApiManager sharedManager].delegate  = self;
    
    [self getUserInfo]; //获取用户信息
}

#pragma mark - 微信绑定/解绑
- (IBAction)anthWXActionClick:(UIButton *)sender {
    if ([self.nickNameLab.text isEqualToString:@"未绑定"]) { //未绑定
        if (![Utils booWeixin]) {
            XLGAlertView *alert = [[XLGAlertView alloc]initWithTitle:@"温馨提示" content:@"请先安装微信客户端" leftButtonTitle:@"" rightButtonTitle:@"我知道了"];
            alert.doneBlock = ^{};
            return;
        }
        XLGAlertView *alert = [[XLGAlertView alloc]initWithTitle:@"温馨提示" content:@"确定要绑定微信吗" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        alert.doneBlock = ^{
            [self bingDingWX];
        };
    } else { //已绑定
        XLGAlertView *alert = [[XLGAlertView alloc]initWithTitle:@"您是否要解除与微信账号绑定？" content:@"解除绑定后将不能使用微信账号快速登录" leftButtonTitle:@"取消" rightButtonTitle:@"解除绑定"];
        alert.doneBlock = ^{
            [self unBingdingWX];
        };
    }
}

/** 解绑微信 */
- (void)unBingdingWX{
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:URL_UnbindingWxInfo parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            [Utils showToast:@"解绑成功"];
            [self getUserInfo]; //获取用户信息
        }
    }];
}

/** 绑定微信 */
- (void)bingDingWX {
    [WXApiRequestHandler sendAuthRequestScope:kAuthScope State:kAuthState OpenID:@"" InViewController:self];
}

#pragma mark - WXApiManagerDelegate
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    NSString *result = [NSString stringWithFormat:@"code:%@,state:%@,errcode:%d", response.code, response.state, response.errCode];
    NSLog(@"微信授权结果：%@",result)
    
    if (response.errCode==0) {
        NSDictionary *dic = [NSDictionary dictionary];
        NSString *urlStr = [NSString stringWithFormat:@"%@?code=%@",URL_BindingWxInfo,response.code];
        [[NetworkManager sharedManager] postJSON:urlStr parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
            if (status == Request_Success) {
                [Utils showToast:@"绑定成功"];
                [self getUserInfo]; //获取用户信息
            } else if (status == Request_Fail) {
                NSInteger code = [responseData[@"code"] integerValue];
                if (code == 2) {
                    XLGAlertView *alert = [[XLGAlertView alloc]initWithTitle:@"温馨提示" content:@"该微信号已被其他账号绑定，如果继续，原账号将自动解绑。" leftButtonTitle:@"取消" rightButtonTitle:@"继续"];
                    alert.doneBlock = ^{
                        WxAuthModel *wxAuthModel = [WxAuthModel mj_objectWithKeyValues:(NSDictionary *)responseData[@"data"]];
                        [self renewUnBingWX:wxAuthModel];
                    };
                } else {
                    [Utils showToast:responseData[@"msg"]];
                }
            }
        }];
    }
}

/** 重新绑定微信 */
- (void)renewUnBingWX:(WxAuthModel *)wxAuthModel{
    NSDictionary *dic = [NSDictionary dictionary];
    NSString *urlStr = [NSString stringWithFormat:@"%@?headimgurl=%@&nickname=%@&openid=%@&unionid=%@",URL_RebindingWxInfo,wxAuthModel.headimgurl,wxAuthModel.nickname,wxAuthModel.openid,wxAuthModel.unionid];
    [[NetworkManager sharedManager] postJSON:urlStr parameters:dic  completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            [Utils showToast:@"绑定成功"];
            [self getUserInfo]; //获取用户信息
        }
    }];
}

/** 获取用户信息 */
- (void)getUserInfo {
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] getJSON:URL_Profile parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            //缓存用户信息
            NSDictionary *userDic = responseData;
            [[UserInfo share] setUserInfo:[userDic mutableCopy]];
            if ([NSString isEmpty:[UserInfo share].openId]) {
                self.nickNameLab.text = @"未绑定";
                self.nickNameLab.textColor = kVerifiedUnCommitColor;
            } else {
                self.nickNameLab.text = [UserInfo share].nickName;
                self.nickNameLab.textColor = AppThemeColor;
            }
        }
    }];
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
