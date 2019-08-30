//
//  JSCancleOrderVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/29.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSCancleOrderVC.h"

@interface JSCancleOrderVC ()

@end

@implementation JSCancleOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.orderStatusLab.text  = @"车主已确认";
    self.bottomLeftBtn.hidden =YES;
    self.bottomRightBtn.hidden = YES;
    [self.bottomBtn setTitle:@"重新发货" forState:UIControlStateNormal];
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
