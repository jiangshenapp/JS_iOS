//
//  JSBaseOrderDetaileVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/29.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSBaseOrderDetailsVC.h"

@interface JSBaseOrderDetailsVC ()

@end

@implementation JSBaseOrderDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _bgScroView.contentSize = CGSizeMake(0, _receiptView.bottom+50);
    self.title = @"我的订单";
    self.tileView1.hidden = YES;
    self.titleView2.hidden = NO;
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

- (IBAction)bottomLeftBtnAction:(UIButton *)sender {
}

- (IBAction)bottomRightBtnAction:(UIButton *)sender {
}

- (IBAction)bottomBtnAction:(UIButton *)sender {
}

@end
