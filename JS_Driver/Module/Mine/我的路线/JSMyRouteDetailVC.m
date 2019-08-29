//
//  JSMyRouteDetailVC.m
//  JS_Driver
//
//  Created by zhanbing han on 2019/6/9.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "JSMyRouteDetailVC.h"
#import "RouteModel.h"

@interface JSMyRouteDetailVC ()

/** 路线数据 */
@property (nonatomic,retain) RouteModel *routeModel;

@end

@implementation JSMyRouteDetailVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"路线详情";
    
    [self getRouteInfo];
}

#pragma mark - 路线详情
/** 路线详情 */
- (void)getRouteInfo {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@/%@",URL_GetMyLines,_routeID];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            
            weakSelf.routeModel = [RouteModel mj_objectWithKeyValues:responseData];
            
            weakSelf.startLab.text = weakSelf.routeModel.startAddressCodeName;
            weakSelf.endLab.text = weakSelf.routeModel.arriveAddressCodeName;
            weakSelf.carLengthLab.text = weakSelf.routeModel.carLengthName;
            weakSelf.carModelLab.text = weakSelf.routeModel.carModelName;
            weakSelf.remarkLab.text = weakSelf.routeModel.remark;
            if ([weakSelf.routeModel.arriveAddressCode integerValue]==0) {
                weakSelf.endLab.text = @"全国";
            }
            if ([weakSelf.routeModel.startAddressCode integerValue]==0) {
                weakSelf.startLab.text = @"全国";
            }
            
            if (![weakSelf.routeModel.classic isEqualToString:@"0"]) {
                self.applyJingpinBtn.hidden = YES;
            }
            if ([weakSelf.routeModel.state isEqualToString:@"1"]) { //启用
                [self.openOrCloseBtn setTitle:@"停用" forState:UIControlStateNormal];
                [self.openOrCloseBtn setBackgroundColor:RGBValue(0xD0021B)];
            }
        }
    }];
}

- (IBAction)applyJingpinAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@/%@",URL_LineClassic,_routeID];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            [Utils showToast:@"申请成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (IBAction)openOrCloseAction:(id)sender {
    if ([self.openOrCloseBtn.titleLabel.text isEqualToString:@"启用"]) {
        [self startRouteAction];
    } else {
        [self stopRouteAction];
    }
}

- (void)startRouteAction {
  
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@?enable=%d&lineId=%@",URL_LineEnable,1,_routeID];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            [Utils showToast:@"启用成功"];
            [self.openOrCloseBtn setTitle:@"停用" forState:UIControlStateNormal];
            [self.openOrCloseBtn setBackgroundColor:RGBValue(0xD0021B)];
        }
    }];
}

- (void)stopRouteAction {

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@?enable=%d&lineId=%@",URL_LineEnable,0,_routeID];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            [Utils showToast:@"停用成功"];
            [self.openOrCloseBtn setTitle:@"启用" forState:UIControlStateNormal];
            [self.openOrCloseBtn setBackgroundColor:RGBValue(0x4A90E2)];
        }
    }];
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
