//
//  JSHomeDetailVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/6/14.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSHomeDetailVC.h"
#import "JSDeliverConfirmVC.h"

@interface JSHomeDetailVC ()

@end

@implementation JSHomeDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [self.collectBtn setImage:[UIImage imageNamed:@"app_navigationbar_collection_default"] forState:UIControlStateNormal];
    [self.collectBtn setImage:[UIImage imageNamed:@"app_navigationbar_collection_selected"] forState:UIControlStateSelected];
    [self.collectBtn addTarget:self action:@selector(collectAction) forControlEvents:UIControlEventTouchUpInside];
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.collectBtn];
    
    [self createBottomView];
}

- (void)createBottomView {
    CGFloat viewH = 50;
    CGFloat bottomY = HEIGHT-viewH-kTabBarSafeH;
    CGFloat firstViewW = (WIDTH/2.0-30)/2.0;
    self.callBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, bottomY, firstViewW, viewH)];
    [self.callBtn setImage:[UIImage imageNamed:@"home_list_btn_phone"] forState:UIControlStateNormal];
    self.callBtn.backgroundColor = [UIColor whiteColor];
    [self.callBtn addTarget:self action:@selector(callAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.callBtn];
    
    self.chatBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.callBtn.right, bottomY, firstViewW, viewH)];
    self.chatBtn.backgroundColor = [UIColor whiteColor];
    [self.chatBtn setImage:[UIImage imageNamed:@"home_list_btn_chat"] forState:UIControlStateNormal];
    [self.chatBtn addTarget:self action:@selector(chatAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.chatBtn];
    
    self.cretaeOrderBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.chatBtn.right, bottomY, WIDTH-self.chatBtn.right, viewH)];
    self.cretaeOrderBtn.backgroundColor = AppThemeColor;
    [self.cretaeOrderBtn addTarget:self action:@selector(createOrderAction) forControlEvents:UIControlEventTouchUpInside];
    [self.cretaeOrderBtn setTitle:@"立即下单" forState:UIControlStateNormal];
    [self.view addSubview:self.cretaeOrderBtn];
}

/** 收藏 */
- (void)collectAction {
    
}

/** 打电话 */
- (void)callAction {

}

/** 聊天 */
- (void)chatAction {
    
}

/** 下单 */
- (void)createOrderAction {
    if (![Utils isVerified]) {
        return;
    }
    JSDeliverConfirmVC *vc = (JSDeliverConfirmVC *)[Utils getViewController:@"DeliverGoods" WithVCName:@"JSDeliverConfirmVC"];
    vc.subscriberId = self.dataModel.subscriberId;
    vc.isAll = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
