//
//  JSCodeLoginVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/25.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSCodeLoginVC.h"
#import "CustomEaseUtils.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "WxAuthModel.h"
#import "JSBindingPhoneVC.h"

@interface JSCodeLoginVC ()<UITextFieldDelegate,WXApiManagerDelegate>

@end

@implementation JSCodeLoginVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _loginWXView.hidden = ![Utils booWeixin];
    [WXApiManager sharedManager].delegate  = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.backBtn setImage:[UIImage imageNamed:@"app_navigationbar_icon_close_black"] forState:UIControlStateNormal];
    self.phoneTF.text = [CacheUtil getCacherWithKey:@"loginPhone"];
    [WXApiManager sharedManager].delegate = self;
}

#pragma mark - methods
/* 获取验证码 */
- (IBAction)codeAction:(id)sender {
    
    if ([NSString isEmpty:self.phoneTF.text]
        || ![Utils validateMobile:self.phoneTF.text]) {
        [Utils showToast:@"请输入11位有效手机号"];
        return;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         self.phoneTF.text, @"mobile",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_SendSmsCode parameters:dic imageDataArr:nil imageName:nil  completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            [Utils showToast:@"验证码发送成功"];
            [self startTimeCount:self.codeBtn];
        }
    }];
}

/* 登录 */
- (IBAction)loginAction:(id)sender {
    
    if ([NSString isEmpty:self.phoneTF.text]) {
        [Utils showToast:@"请输入手机号"];
        return;
    }
    
    if (![Utils validateMobile:self.phoneTF.text]) {
        [Utils showToast:@"请输入正确的手机号"];
        return;
    }
    
    if ([NSString isEmpty:self.codeTF.text]) {
        [Utils showToast:@"请输入验证码"];
        return;
    }
    
    NSString *appType = @"2"; //司机端
    if ([AppChannel isEqualToString:@"1"]) { //货主端
        appType = @"1";
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         appType, @"appType",
                         self.phoneTF.text, @"mobile",
                         self.codeTF.text, @"code",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_SmsLogin parameters:dic imageDataArr:nil imageName:nil  completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            NSString *token = responseData;
            [CacheUtil saveCacher:@"token" withValue:token];
            [CacheUtil saveCacher:@"loginPhone" withValue:self.phoneTF.text];
            [self loginSuccess];
        }
    }];
}

/* 获取用户信息 */
- (void)getUserInfo {
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] getJSON:URL_Profile parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            //缓存用户信息
            NSDictionary *userDic = responseData;
            [[UserInfo share] setUserInfo:[userDic mutableCopy]];
            //环信登录
            NSString *appFlag = @"driver"; //司机端
            if ([AppChannel isEqualToString:@"1"]) { //货主端
                appFlag = @"shipper";
            }
            NSString *easeMobUser = [NSString stringWithFormat:@"%@%@",appFlag,[UserInfo share].mobile];
            [CustomEaseUtils EaseMobLoginWithUser:easeMobUser completion:^(NSString * _Nonnull aName, EMError * _Nonnull error) {
                
            }];
        }
    }];
}

/* 用户协议 */
- (IBAction)protocalAction:(id)sender {
    [BaseWebVC showWithVC:self withUrlStr:[NSString stringWithFormat:@"%@%@",h5Url(),H5_Register] withTitle:@"用户协议"];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.tag == 100) {
        if (textField.text.length + string.length > 11) {
            return NO;
        }
    }
    return YES;
}

/* 微信登录 */
- (IBAction)wxLoginAction:(id)sender {
    [WXApiRequestHandler sendAuthRequestScope:kAuthScope
                                        State:kAuthState
                                       OpenID:@""
                             InViewController:self];
}

#pragma mark - WXApiManagerDelegate
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    NSString *result = [NSString stringWithFormat:@"code:%@,state:%@,errcode:%d", response.code, response.state, response.errCode];
    NSLog(@"微信授权结果：%@",result)
    
    if (response.errCode==0) {
        NSDictionary *dic = [NSDictionary dictionary];
        NSString *urlStr = [NSString stringWithFormat:@"%@?code=%@",URL_WxCodeLogin,response.code];
        [[NetworkManager sharedManager] postJSON:urlStr parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
            
            if (status == Request_Success) {
                NSString *token = responseData;
                [CacheUtil saveCacher:@"token" withValue:token];
                [self loginSuccess];
            } else if (status == Request_Fail) {
                NSInteger code = [responseData[@"code"] integerValue];
                if (code == 3) { //跳转到绑定手机号页面
                    JSBindingPhoneVC *vc = (JSBindingPhoneVC *)[Utils getViewController:@"Login" WithVCName:@"JSBindingPhoneVC"];
                    WxAuthModel *wxAuthModel = [WxAuthModel mj_objectWithKeyValues:(NSDictionary *)responseData[@"data"]];
                    vc.wxAuthModel = wxAuthModel;
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    [Utils showToast:responseData[@"msg"]];
                }
            }
        }];
    }
}

/** 登录成功 */
- (void)loginSuccess {
    [Utils showToast:@"登录成功"];
    [self getUserInfo]; //获取用户信息
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStateChangeNotification object:@YES];
    // 跳转到首页
    [self.navigationController popToRootViewControllerAnimated:YES];
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
