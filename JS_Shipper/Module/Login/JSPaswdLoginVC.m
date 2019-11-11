//
//  JSPaswdLoginVC.m
//  JS_Driver
//
//  Created by Jason_zyl on 2019/3/6.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "JSPaswdLoginVC.h"
#import "CustomEaseUtils.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "WxAuthModel.h"
#import "JSBindingPhoneVC.h"

@interface JSPaswdLoginVC ()<UITextFieldDelegate,WXApiManagerDelegate>

@end

@implementation JSPaswdLoginVC

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
    
//    if (DEBUG) {
//        if ([AppChannel isEqualToString:@"1"]) { //货主端
//            self.phoneTF.text = @"13758132864";
//        } else { //司机端
//            self.phoneTF.text = @"15737936517";
//        }
//        self.pswTF.text = @"000000";
//    }
    [WXApiManager sharedManager].delegate = self;
}

#pragma mark - methods

/* 返回 */
- (void)backAction {
    self.tabBarController.selectedIndex = 0;
    // 跳转到首页
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    
    if ([NSString isEmpty:self.pswTF.text]) {
        [Utils showToast:@"请输入密码"];
        return;
    }
    
    NSString *appType = @"2"; //司机端
    if ([AppChannel isEqualToString:@"1"]) { //货主端
        appType = @"1";
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         appType, @"appType",
                         self.phoneTF.text, @"mobile",
                         self.pswTF.text, @"password",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_Login parameters:dic imageDataArr:nil imageName:nil completion:^(id responseData, RequestState status, NSError *error) {
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
- (IBAction)wxLoginAction:(UIButton *)sender {
    
//    JSBindingPhoneVC *vc = (JSBindingPhoneVC *)[Utils getViewController:@"Login" WithVCName:@"JSBindingPhoneVC"];
//    WxAuthModel *wxAuthModel = [[WxAuthModel alloc] init];
//    wxAuthModel.headimgurl = @"http://thirdwx.qlogo.cn/mmopen/vi_32/kicVkG3iaZQ8Peg9vUCb3zRm7Uiasvz3bDEwGnldiaj1Tbtfoiasrb3vjdedy6RqlqBQ3Fq05N98ic9hm7zSrAJZD8LA/132";
//    wxAuthModel.unionid = @"ot7iv0VsKWGUg8fPaaYc2FNoLR_Y";
//    wxAuthModel.nickname = @"心中有路";
//    wxAuthModel.openid = @"otQoa6IV0_RVWmaxxr1OkO95RUIs";
//    wxAuthModel.headimgurl = @"http://thirdwx.qlogo.cn/mmopen/vi_32/WcO8NfH5bIVHLnkkGficjicv3Gd7ATwvqDKicFhicWsSjVJsUqacticIFYzTfOFT4wUoj6FANw6RL51IOIoy6JXMCog/132";
//    wxAuthModel.unionid = @"oft4Q1DOh6uHSyK6L1ctVmhXCdMg";
//    wxAuthModel.nickname = @"幸运one";
//    wxAuthModel.openid = @"oNNk21huIhNNtOYLBLN4AbdYyi1k";
//    vc.wxAuthModel = wxAuthModel;
//    [self.navigationController pushViewController:vc animated:YES];
    
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
