//
//  JSBindingPhoneVC.m
//  JS_Shipper
//
//  Created by Jason_zyl on 2019/10/1.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSBindingPhoneVC.h"
#import "CustomEaseUtils.h"
#import "AddressInfoModel.h"

@interface JSBindingPhoneVC ()<UITextFieldDelegate>

@end

@implementation JSBindingPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.backBtn setImage:[UIImage imageNamed:@"app_navigationbar_icon_close_black"] forState:UIControlStateNormal];
    self.phoneTF.text = [CacheUtil getCacherWithKey:@"loginPhone"];
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

/* 绑定 */
- (IBAction)bindingAction:(id)sender {
    
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
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         self.phoneTF.text, @"mobile",
                         self.codeTF.text, @"code",
                         self.wxAuthModel.headimgurl, @"headimgurl",
                         self.wxAuthModel.nickname, @"nickname",
                         self.wxAuthModel.openid, @"openid",
                         self.wxAuthModel.unionid, @"unionid",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_WxLogin parameters:dic imageDataArr:nil imageName:nil  completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            [Utils showToast:@"绑定成功"];
            
            NSString *token = responseData;
            [CacheUtil saveCacher:@"token" withValue:token];
            [CacheUtil saveCacher:@"loginPhone" withValue:self.phoneTF.text];
            
            [self getUserInfo]; //获取用户信息
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStateChangeNotification object:@YES];
            
            // 跳转到首页
            [self.navigationController popToRootViewControllerAnimated:YES];
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
                AddressInfoModel *dataModel = [NSKeyedUnarchiver unarchiveObjectWithFile:kSendAddressArchiver];
                if (!dataModel) {
                    dataModel = [[AddressInfoModel alloc] init];
                }
                dataModel.phone = [UserInfo share].mobile;
                dataModel.name = [UserInfo share].nickName;
                [NSKeyedArchiver archiveRootObject:dataModel toFile:kSendAddressArchiver];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
