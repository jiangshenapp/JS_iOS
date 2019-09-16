//
//  JSDeliverGoodsVC.m
//  JS_Driver
//
//  Created by Jason_zyl on 2019/3/6.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "JSDeliverGoodsVC.h"
#import <BaiduMapAPI_Utils/BMKGeometry.h>
#import "FilterCustomView.h"
#import "JSDeliverConfirmVC.h"
#import "BannerModel.h"

@interface JSDeliverGoodsVC ()<SDCycleScrollViewDelegate>
/** 起止点 */
@property (nonatomic,retain) AddressInfoModel *info1;
/** 终止点 */
@property (nonatomic,retain) AddressInfoModel *info2;
/** 车身车长 */
@property (nonatomic,retain) FilterCustomView *carLengthView;
/** 车长数组 */
@property (nonatomic,retain) NSArray *carLengthArr;
/** 车型数组 */
@property (nonatomic,retain) NSArray *carModelArr;
/** 车长 */
@property (nonatomic,retain) NSDictionary *carLengthDic;
/** 车型 */
@property (nonatomic,retain) NSDictionary *carModelDic;
/** 点击类型  1车长 2车型 */
@property (nonatomic,assign) NSInteger touchType;
/** banner数组 */
@property (nonatomic,retain) NSMutableArray *bannerArr;

@end

@implementation JSDeliverGoodsVC

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_carLengthView hiddenView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发货";
    
    [self getSysServiceBanner];
    [self getCarLengthInfo];
    [self getCarModelInfo];
}

- (void)setupView {
    _touchType = 0;
    _bannerView.delegate = self;
    _bannerView.currentPageDotColor = AppThemeColor;
    _bannerView.pageDotColor = kWhiteColor;
    
    UIButton *sender = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    [sender setTitle:@"我的运单" forState:UIControlStateNormal];
    sender.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [sender setTitleColor:kBlackColor forState:UIControlStateNormal];
    [sender addTarget:self action:@selector(showMyOrderAction) forControlEvents:UIControlEventTouchUpInside];
    sender.titleLabel.font = [UIFont systemFontOfSize:12];
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:sender];
    
    _info1 = [NSKeyedUnarchiver unarchiveObjectWithFile:kSendAddressArchiver];
    _info2 = [NSKeyedUnarchiver unarchiveObjectWithFile:kReceiveAddressArchiver];
    if (_info1) {
        [self.startAddressBtn setTitle:_info1.address forState:UIControlStateNormal];
    }
    if (_info2) {
        [self.endAddressBtn setTitle:_info2.address forState:UIControlStateNormal];
    }
    [self getDistance];
    
    _carLengthView =  [[FilterCustomView alloc] init];
    _carLengthView.viewHeight = HEIGHT-kNavBarH-kTabBarSafeH;;
    _carLengthView.top = kNavBarH;
    __weak typeof(self) weakSelf = self;
    _carLengthView.getPostDic = ^(NSDictionary * _Nonnull dic, NSArray * _Nonnull titles) {
        if (weakSelf.touchType==1) {
            weakSelf.carLengthDic = dic;
            [weakSelf.carLenthBtn setTitle:[titles firstObject] forState:UIControlStateNormal];
        }
        else if (weakSelf.touchType==2) {
            weakSelf.carModelDic = dic;
            [weakSelf.carModelBtn setTitle:[titles firstObject] forState:UIControlStateNormal];
        }
    };
}

#pragma mark - get data

/** 获取系统服务banner */
- (void)getSysServiceBanner {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"2",@"type", nil];
    [[NetworkManager sharedManager] postJSON:URL_GetBannerList parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        self.bannerArr = [BannerModel mj_objectArrayWithKeyValuesArray:responseData];
        NSMutableArray *imageArr = [NSMutableArray array];
        for (BannerModel *model in self.bannerArr) {
            [imageArr addObject:model.bannerImage];
        }
        self.bannerView.imageURLStringsGroup = imageArr;
    }];
}

/** 车长 */
- (void)getCarLengthInfo {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@?type=carLength",URL_GetDictByType];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            NSArray *arr = responseData;
            if ([arr isKindOfClass:[NSArray class]]) {
                weakSelf.carLengthArr = [NSArray arrayWithArray:arr];
            }
        }
    }];
}

/** 车型 */
- (void)getCarModelInfo {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@?type=carModel",URL_GetDictByType];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            NSArray *arr = responseData;
            if ([arr isKindOfClass:[NSArray class]]) {
                weakSelf.carModelArr = [NSArray arrayWithArray:arr];
            }
        }
    }];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    BannerModel *model = self.bannerArr[index];
    [BaseWebVC showWithContro:self withUrlStr:model.url withTitle:model.title isPresent:NO];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    __weak typeof(self) weakSelf = self;
    JSConfirmAddressMapVC *vc = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"start"]) {
        vc.sourceType = 0;
        vc.getAddressinfo = ^(AddressInfoModel * _Nonnull info) {
            [weakSelf.startAddressBtn setTitle:info.address forState:UIControlStateNormal];
            weakSelf.info1 = info;
            [weakSelf getDistance];
        };
    }
    else if ([segue.identifier isEqualToString:@"end"]) {
        vc.sourceType = 1;
        vc.getAddressinfo = ^(AddressInfoModel * _Nonnull info) {
            [weakSelf.endAddressBtn setTitle:info.address forState:UIControlStateNormal];
            weakSelf.info2 = info;
            [weakSelf getDistance];
        };
    }
}

- (void)getDistance {
    if (!_info1||!_info2) {
        return;
    }
    
    _distanceLab.text = [NSString stringWithFormat:@"总里程:%@",[Utils distanceBetweenOrderBy:_info1.lat :_info1.lng andOther:_info2.lat  :_info2.lng ]];

    
//
//    BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(_info1.lat,_info1.lng));
//    BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(_info2.lat,_info2.lng));
//  float  dist = BMKMetersBetweenMapPoints(point1,point2);
//    if (dist<1000) {
//        _distanceLab.text = [NSString stringWithFormat:@"总里程：%.2fm",dist];
//    }
//    else {
//        dist = dist/1000;
//        _distanceLab.text = [NSString stringWithFormat:@"总里程：%.2fkm",dist];
//    }
}

- (void)showMyOrderAction {
    UIViewController *vc = [Utils getViewController:@"Mine" WithVCName:@"JSAllOrderVC"];
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)sendGoodsAction:(UIButton *)sender {
    
    if (![Utils isVerified]) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary:_carLengthDic];
    [dic addEntriesFromDictionary:_carModelDic];
    if (_info1.address.length==0) {
        [Utils showToast:@"请选择发货地址"];
        return;
    }
    if (_info2.address.length==0) {
        [Utils showToast:@"请选择收获地址"];
        return;
    }
    if (_info1.address.length>0) {
        [dic setObject:[NSString stringWithFormat:@"%@%@",_info1.address,_info1.detailAddress] forKey:@"sendAddress"];
        [dic setObject:_info1.areaCode forKey:@"sendAddressCode"];
        if (_info1.phone) {
            [dic setObject:_info1.phone forKey:@"sendMobile"];
            [dic setObject:_info1.name forKey:@"sendName"];
        }
        NSDictionary *locDic = @{@"latitude":@(_info1.lat),@"longitude":@(_info1.lng)};
        [dic setObject:[locDic jsonStringEncoded] forKey:@"sendPosition"];
    }
    if (_info2.address.length>0) {
        [dic setObject:[NSString stringWithFormat:@"%@%@",_info2.address,_info2.detailAddress] forKey:@"receiveAddress"];
        [dic setObject:_info2.areaCode forKey:@"receiveAddressCode"];
        if (_info2.phone.length>0) {
            [dic setObject:_info2.phone forKey:@"receiveMobile"];
            [dic setObject:_info2.name forKey:@"receiveName"];
        }
        NSDictionary *locDic = @{@"latitude":@(_info2.lat),@"longitude":@(_info2.lng)};
        [dic setObject:[locDic jsonStringEncoded] forKey:@"receivePosition"];
    }
    [[NetworkManager sharedManager] postJSON:URL_AddStepOne parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            JSDeliverConfirmVC *vc = (JSDeliverConfirmVC *)[Utils getViewController:@"DeliverGoods" WithVCName:@"JSDeliverConfirmVC"];
            vc.orderID = [NSString stringWithFormat:@"%@",responseData];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (IBAction)carLongAction:(UIButton *)sender {
    if (_carLengthArr.count==0) {
        return;
    }
    _touchType = 1;
    self.carLengthView.dataDic = @{@"carLength":self.carLengthArr};
    [_carLengthView showView];
}

- (IBAction)carTypeAction:(id)sender {
    if (_carModelArr.count==0) {
        return;
    }
    _touchType = 2;
    self.carLengthView.dataDic = @{@"carModel":self.carModelArr};
    [_carLengthView showView];
}

@end

