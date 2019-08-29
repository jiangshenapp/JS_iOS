//
//  JSOrderDistributionVC.m
//  JS_Driver
//
//  Created by Jason_zyl on 2019/6/19.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "JSOrderDistributionVC.h"
#import "JSMyDriverVC.h"
#import "JSMyCarVC.h"
#import "JSAllOrderVC.h"

@interface JSOrderDistributionVC ()

/** 司机model */
@property (nonatomic,retain) DriverModel *driverModel;
/** 车辆model */
@property (nonatomic,retain) CarModel *carModel;

@end

@implementation JSOrderDistributionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"分配司机";
    
    if ([[UserInfo share].parkVerified integerValue] != 2) { //2：园区已认证
        if (![Utils isBlankString:[UserInfo share].nickName]) {
            self.driverNameLab.text = [UserInfo share].nickName;
        } else {
            self.driverNameLab.text = [UserInfo share].mobile;
        }
        [self.selectDriverBtn setImage:nil forState:UIControlStateNormal];
    }
}

#pragma mark - methods

/** 选择司机 */
- (IBAction)selectDriverAction:(id)sender {
    if ([[UserInfo share].parkVerified integerValue] == 2) {
        JSMyDriverVC *vc = (JSMyDriverVC *)[Utils getViewController:@"Mine" WithVCName:@"JSMyDriverVC"];
        vc.isSelect = YES;
        [vc setSelectDriverBlock:^(DriverModel * _Nullable driverModel) {
            self.driverModel = driverModel;
            self.driverNameLab.text = driverModel.driverName;
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/** 选择车辆 */
- (IBAction)selectCarAction:(id)sender {
    JSMyCarVC *vc = (JSMyCarVC *)[Utils getViewController:@"Mine" WithVCName:@"JSMyCarVC"];
    vc.isSelect = YES;
    [vc setSelectCarBlock:^(CarModel * _Nullable carModel) {
        self.carModel = carModel;
        self.carNameLab.text = carModel.cphm;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

/** 确认分配 */
- (IBAction)submitAction:(id)sender {
    
    if ([self.driverNameLab.text isEqualToString:@"选择司机"]) {
        [Utils showToast:@"请选择司机"];
        return;
    }
    
    if ([self.carNameLab.text isEqualToString:@"选择车辆"]) {
        [Utils showToast:@"请选择车辆"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (![Utils isBlankString:self.driverModel.driverId]) {
        [dic setObject:self.driverModel.driverId forKey:@"dirverId"];
    }
    if (![Utils isBlankString:self.carModel.ID]) {
        [dic setObject:self.carModel.ID forKey:@"carId"];
    }
    [[NetworkManager sharedManager] postJSON:[NSString stringWithFormat:@"%@/%@",URL_DistributionOrder,self.orderID] parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            [Utils showToast:@"配送成功"];
            [weakSelf pushOrderList];
        }
    }];
}

- (void)pushOrderList {
    JSAllOrderVC *vc =(JSAllOrderVC *)[Utils getViewController:@"Mine" WithVCName:@"JSAllOrderVC"];
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
