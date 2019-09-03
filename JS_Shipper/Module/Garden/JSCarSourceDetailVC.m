//
//  JSCarSourceDetailVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/4/8.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSCarSourceDetailVC.h"
#import "YYStarView.h"

@interface JSCarSourceDetailVC ()

@property (weak, nonatomic) IBOutlet YYStarView *starView;
@property (weak, nonatomic) IBOutlet UIImageView *carImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carImgH;
@property (weak, nonatomic) IBOutlet UILabel *startAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *endAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *carNumLab;
@property (weak, nonatomic) IBOutlet UILabel *carTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *carLengthLab;
@property (weak, nonatomic) IBOutlet UITextView *remarkTV;

@end

@implementation JSCarSourceDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"车源详情";
    self.starView.starScore = 4;
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
    _carNumLab.text = self.dataModel.cphm;
    _carTypeLab.text = self.dataModel.carModelName;
    _carLengthLab.text = self.dataModel.carLengthName;
    _remarkTV.text = self.dataModel.remark;
    if ([self.dataModel.isCollect isEqualToString:@"1"]) {
        self.collectBtn.selected = YES;
    } else {
        self.collectBtn.selected = NO;
    }
    if ([Utils isBlankString:self.dataModel.image2]) {
        self.carImgH.constant = 0;
    } else {
        self.carImgH.constant = 150;
        [self.carImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PIC_URL(),self.dataModel.image2]]];
    }
    _remarkTV.userInteractionEnabled = NO;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
