//
//  JSForgetPwdVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/25.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSForgetPwdVC.h"
#import "JSResetPswVC.h"

@interface JSForgetPwdVC ()<UITextFieldDelegate>

@end

@implementation JSForgetPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

/* 下一步 */
- (IBAction)nextAction:(id)sender {
    
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
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_ResetPwdStep1 parameters:dic imageDataArr:nil imageName:nil  completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            JSResetPswVC *vc = (JSResetPswVC *)[Utils getViewController:@"Login" WithVCName:@"JSResetPswVC"];
            vc.phoneStr = self.phoneTF.text;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
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
