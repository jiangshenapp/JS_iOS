//
//  JSLineDetaileVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/6/14.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSLineDetaileVC.h"

@interface JSLineDetaileVC ()

@end

@implementation JSLineDetaileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"精品路线详情";
    
    [self refreshUI];
    [self getData];
}

#pragma mark - 获取数据
- (void)getData {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@/%@",URL_GetLineDetail,self.carSourceID];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            weakSelf.dataModel = [RecordsModel mj_objectWithKeyValues:responseData];
            [weakSelf refreshUI];
        }
    }];
}

- (void)refreshUI {
    _startAddressLab.text = self.dataModel.startAddressCodeName;
    _endAddressLab.text = self.dataModel.arriveAddressCodeName;
    _nameLab.text = self.dataModel.driverName;
    _carModelLab.text = self.dataModel.carModelName;
    _calLengthLab.text = self.dataModel.carLengthName;
    _contentTV.text = self.dataModel.remark;
    if ([self.dataModel.isCollect isEqualToString:@"1"]) {
        self.collectBtn.selected = YES;
    } else {
        self.collectBtn.selected = NO;
    }
    _contentTV.userInteractionEnabled = NO;
}

#pragma mark - methods

/** 收藏 */
- (void)collectAction {
    
    if (self.collectBtn.isSelected) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.carSourceID forKey:@"lineId"];
        [[NetworkManager sharedManager] postJSON:URL_LineRemove parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
            if (status == Request_Success) {
                [Utils showToast:@"取消收藏成功"];
                self.collectBtn.selected = !self.collectBtn.isSelected;
            }
        }];
    } else {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.carSourceID forKey:@"lineId"];
        [[NetworkManager sharedManager] postJSON:URL_LineAdd parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
            if (status == Request_Success) {
                [Utils showToast:@"收藏成功"];
                self.collectBtn.selected = !self.collectBtn.isSelected;
            }
        }];
    }
}

/** 打电话 */
- (void)callAction {
    if (![Utils isBlankString:self.dataModel.driverPhone]) {
        [Utils call:self.dataModel.driverPhone];
    } else {
        [Utils showToast:@"手机号码为空"];
    }
}

/** 聊天 */
- (void)chatAction {
    if (![Utils isBlankString:self.dataModel.driverPhone]) {
        [CustomEaseUtils EaseChatConversationID:self.dataModel.driverPhone];
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
