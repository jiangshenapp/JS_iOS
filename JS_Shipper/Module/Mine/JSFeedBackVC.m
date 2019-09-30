//
//  JSFeedBackVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/4/24.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSFeedBackVC.h"

@interface JSFeedBackVC ()

@end

@implementation JSFeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"意见反馈";
    
    _contentTV.layer.borderColor = RGBValue(0xF5f5f5).CGColor;
}

/** 意见反馈 */
- (IBAction)submitAction:(id)sender {
    if ([NSString isEmpty:_contentTV.text]) {
        [Utils showToast:@"请输入您碰到的问题或对我们的建议"];
        return;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         _contentTV.text, @"contents",
                         [UserInfo share].mobile, @"mobile",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_Feedback parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            [Utils showToast:@"提交成功"];
            // 跳转到首页
            [self.navigationController popToRootViewControllerAnimated:YES];
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
