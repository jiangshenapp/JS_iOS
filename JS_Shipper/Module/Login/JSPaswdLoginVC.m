//
//  JSPaswdLoginVC.m
//  JS_Driver
//
//  Created by Jason_zyl on 2019/3/6.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "JSPaswdLoginVC.h"
#import "CustomEaseUtils.h"

@interface JSPaswdLoginVC ()<UITextFieldDelegate>

@end

@implementation JSPaswdLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.backBtn setImage:[UIImage imageNamed:@"app_navigationbar_icon_close_black"] forState:UIControlStateNormal];
    self.phoneTF.text = [CacheUtil getCacherWithKey:@"loginPhone"];
    
    if (DEBUG) {
        if ([AppChannel isEqualToString:@"1"]) { //货主端
            self.phoneTF.text = @"13758132864";
        } else { //司机端
            self.phoneTF.text = @"15737936517";
        }
        self.pswTF.text = @"000000";
    }
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
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"1", @"appType",
                         self.phoneTF.text, @"mobile",
                         self.pswTF.text, @"password",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_Login parameters:dic imageDataArr:nil imageName:nil completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            [Utils showToast:@"登录成功"];
            
            NSString *token = responseData;
            [CacheUtil saveCacher:@"token" withValue:token];
            [CacheUtil saveCacher:@"loginPhone" withValue:self.phoneTF.text];
            [CustomEaseUtils EaseMobLoginWithUser:self.phoneTF.text completion:^(NSString * _Nonnull aName, EMError * _Nonnull error) {
                
            }];
            
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
