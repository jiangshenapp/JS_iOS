//
//  JSCommentOrderDetailsVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/29.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSCommentOrderVC.h"

@interface JSCommentOrderVC ()

@end

@implementation JSCommentOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.orderStatusLab.text = @"运输中";
    [self.bottomLeftBtn setTitle:@"查看路线" forState:UIControlStateNormal];
    [self.bottomRightBtn setTitle:@"评价" forState:UIControlStateNormal];
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
