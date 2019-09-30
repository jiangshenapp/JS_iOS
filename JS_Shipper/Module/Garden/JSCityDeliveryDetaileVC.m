//
//  JSCityDeliveryDetaileVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/6/14.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSCityDeliveryDetaileVC.h"

@interface JSCityDeliveryDetaileVC ()

@end

@implementation JSCityDeliveryDetaileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"城市配送详情";
    
    [self refreshUI];
    [self getData];
}

#pragma mark - 获取数据
- (void)getData {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@?id=%@",URL_GetParkDetail,self.carSourceID];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            weakSelf.dataModel = [RecordsModel mj_objectWithKeyValues:responseData];
            [weakSelf refreshUI];
        }
    }];
}

- (void)refreshUI {
    
    if ([self.dataModel.isCollect isEqualToString:@"1"]) {
        self.collectBtn.selected = YES;
    } else {
        self.collectBtn.selected = NO;
    }
    self.parkImgH.constant = 0; //园区地址二期
    self.tabHeadView.height = 410;
    self.dotNameLab.text = self.dataModel.companyName;
    if (![NSString isEmpty:self.dataModel.contactLocation]) {
        NSDictionary *contactLocDic = [Utils dictionaryWithJsonString:self.dataModel.contactLocation];
        NSDictionary *locDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"loc"];
        NSString *distanceStr = [NSString stringWithFormat:@"距离您%@",[Utils distanceBetweenOrderBy:[locDic[@"lat"] floatValue] :[locDic[@"lng"] floatValue] andOther:[contactLocDic[@"latitude"] floatValue] :[contactLocDic[@"longitude"] floatValue]]];
        self.dotAddressLab.text = distanceStr;
    }
    self.nameLab.text = self.dataModel.contactName;
    self.addressLab.text = self.dataModel.contactAddress;
    self.contentTV.text = self.dataModel.remark;
    self.contentTV.userInteractionEnabled = NO;
    if (self.dataModel.businessLicenceImage.length>0) {
        self.parkImgH.constant = 150;
        [self.parkImgView sd_setImageWithURL:[NSURL URLWithString:self.dataModel.businessLicenceImage] placeholderImage:DefaultImage];
        self.tabHeadView.height = 560;
    }
    [self.baseTabView reloadData];
}

#pragma mark - methods

/** 收藏 */
- (void)collectAction {
    
    if (self.collectBtn.isSelected) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.carSourceID forKey:@"parkId"];
        [[NetworkManager sharedManager] postJSON:URL_ParkRemove parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
            if (status == Request_Success) {
                [Utils showToast:@"取消收藏成功"];
                self.collectBtn.selected = !self.collectBtn.isSelected;
            }
        }];
    } else {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.carSourceID forKey:@"parkId"];
        [[NetworkManager sharedManager] postJSON:URL_ParkAdd parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
            if (status == Request_Success) {
                [Utils showToast:@"收藏成功"];
                self.collectBtn.selected = !self.collectBtn.isSelected;
            }
        }];
    }
}

/** 打电话 */
- (void)callAction {
    if (![Utils isVerified]) {
        return;
    }
    if (![Utils isBlankString:self.dataModel.contractPhone]) {
        [Utils call:self.dataModel.contractPhone];
    } else {
        [Utils showToast:@"手机号码为空"];
    }
}

/** 聊天 */
- (void)chatAction {
    if (![Utils isVerified]) {
        return;
    }
    if (![Utils isBlankString:self.dataModel.contractPhone]) {
        [CustomEaseUtils EaseChatConversationID:self.dataModel.contractPhone];
    } else {
        [Utils showToast:@"手机号码为空"];
    }
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
