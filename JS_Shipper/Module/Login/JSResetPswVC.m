//
//  JSResetPswVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/25.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSResetPswVC.h"

@interface JSResetPswVC ()

@end

@implementation JSResetPswVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - methods
/* 重置 */
- (IBAction)resetAction:(id)sender {
    
    if ([NSString isEmpty:self.pswTF.text]) {
        [Utils showToast:@"请输入新密码"];
        return;
    }
    
    if (self.pswTF.text.length<6 || self.pswTF.text.length>16) {
        [Utils showToast:@"请输入6-16位新密码（字母、数字）"];
        return;
    }
    
    if ([NSString isEmpty:self.pswAgainTF.text]) {
        [Utils showToast:@"请再次输入新密码"];
        return;
    }
    
    if (![self.pswTF.text isEqualToString:self.pswAgainTF.text]) {
        [Utils showToast:@"前后密码不一致，请检查"];
        return;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         self.phoneStr, @"mobile",
                         self.pswTF.text, @"password",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_ResetPwdStep2 parameters:dic imageDataArr:nil imageName:nil  completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            [Utils showToast:@"重置密码成功"];
            [Utils isLoginWithJump:YES];
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
