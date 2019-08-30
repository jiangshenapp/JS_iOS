//
//  JSRegisterVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/25.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSRegisterVC.h"
#import "JSPaswdLoginVC.h"
#import "CustomEaseUtils.h"

@interface JSRegisterVC ()<UITextFieldDelegate>

@end

@implementation JSRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - methods
/* 注册 */
- (IBAction)registerAction:(id)sender {
    
    if ([NSString isEmpty:self.phoneTF.text]
        || ![Utils validateMobile:self.phoneTF.text]) {
        [Utils showToast:@"请输入11位有效手机号"];
        return;
    }
    
    if (self.pswTF.text.length<6 || self.pswTF.text.length>16) {
        [Utils showToast:@"请设置6-16位密码（字母、数字）"];
        return;
    }
    
    if ([NSString isEmpty:self.codeTF.text]) {
        [Utils showToast:@"请输入验证码"];
        return;
    }
    
    if (self.selectBtn.isSelected == NO) {
        [Utils showToast:@"请勾选用户协议"];
        return;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         self.phoneTF.text, @"mobile",
                         self.codeTF.text, @"code",
                         self.pswTF.text, @"password",
                         nil];
    
    [[NetworkManager sharedManager] postJSON:URL_Registry parameters:dic imageDataArr:nil imageName:nil completion:^(id responseData, RequestState status, NSError *error) {

        if (status == Request_Success) {
            [Utils showToast:@"注册成功"];
            [Utils isLoginWithJump:YES];
            [CustomEaseUtils EaseMobRegisteWithUser:self.phoneTF.text completion:nil];
        }
    }];
}

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

/* 勾选协议 */
- (IBAction)selectAction:(id)sender {
    self.selectBtn.selected = !self.selectBtn.isSelected;
}

/* 用户协议 */
- (IBAction)protocalAction:(id)sender {
    [BaseWebVC showWithContro:self withUrlStr:[NSString stringWithFormat:@"%@%@",h5Url(),H5_Register] withTitle:@"用户协议" isPresent:NO];
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
