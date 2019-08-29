//
//  JSFinishOrderDetailsVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/29.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSFinishOrderVC.h"

@interface JSFinishOrderVC ()

@end

@implementation JSFinishOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.orderStatusLab.hidden = YES;
    [self.bottomLeftBtn setTitle:@"查看路线" forState:UIControlStateNormal];
    [self.bottomRightBtn setTitle:@"重新发货" forState:UIControlStateNormal];
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
