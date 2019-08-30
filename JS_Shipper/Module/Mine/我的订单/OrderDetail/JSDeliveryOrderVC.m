//
//  JSDeliveryOrderDetailsVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/29.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSDeliveryOrderVC.h"

@interface JSDeliveryOrderVC ()

@end

@implementation JSDeliveryOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.orderStatusLab.text = @"车主待接货";
    self.bottomRightBtn.hidden = YES;
    self.bottomLeftBtn.hidden = YES;
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
