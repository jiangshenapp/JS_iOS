//
//  JSReleaseOrderDetailsVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/29.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSReleaseOrderVC.h"

@interface JSReleaseOrderVC ()

@end

@implementation JSReleaseOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tileView1.hidden = NO;
    self.titleView2.hidden = YES;
    self.orderStatusLab.text = @"发布中";
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
