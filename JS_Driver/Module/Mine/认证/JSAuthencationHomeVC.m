//
//  JSAuthencationHomeVC.m
//  JS_Driver
//
//  Created by zhanbing han on 2019/5/7.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "JSAuthencationHomeVC.h"
#import "JSAuthenticationVC.h"

@interface JSAuthencationHomeVC ()

@end

@implementation JSAuthencationHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kWhiteColor;

    NSInteger driverVerified = [[UserInfo share].driverVerified integerValue];
    NSInteger parkVerified = [[UserInfo share].parkVerified integerValue];
    self.driverVerifiedLab.text = kAuthStateStrDic[@(driverVerified)];
    self.driverVerifiedLab.textColor = kAuthStateColorDic[@(driverVerified)];
    self.parkVerifiedLab.text = kAuthStateStrDic[@(parkVerified)];
    self.parkVerifiedLab.textColor = kAuthStateColorDic[@(parkVerified)];
}

/*
 */
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier containsString:@"Auth"]) {
        JSAuthenticationVC *vc = segue.destinationViewController;
        if ([segue.identifier containsString:@"driver"]) {
            vc.type = 0;
        }
        if ([segue.identifier containsString:@"company"]) {
            vc.type = 1;
        }
    }
}

@end
