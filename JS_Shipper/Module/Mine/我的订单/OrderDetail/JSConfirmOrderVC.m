//
//  JSConfirmOrderDetailsVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/29.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSConfirmOrderVC.h"

@interface JSConfirmOrderVC ()

@end

@implementation JSConfirmOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.orderStatusLab.text = @"待确认";
    [self.bottomRightBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    
    // Do any additional setup after loading the view.
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
