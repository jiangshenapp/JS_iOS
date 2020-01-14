//
//  JSDeliverConfirmVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/4/25.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSDeliverConfirmVC.h"
#import "ZHPickView.h"
#import "TZImagePickerController.h"
#import "JSConfirmAddressMapVC.h"
#import "FilterCustomView.h"
#import "JSSelectGoodsNameVC.h"

@interface JSDeliverConfirmVC ()<TZImagePickerControllerDelegate,UITextFieldDelegate>
{
   __block NSInteger imageType;
}
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

/** 运费 */
@property (nonatomic,copy) NSString *fee;
/** 运费类型，1自己出价，2电议 */
@property (nonatomic,copy) NSString *feeType;
/** 货物类型,字典表，多个 */
@property (nonatomic,copy) NSString *goodsType;
/** 货物体积，单位立方米 */
@property (nonatomic,copy) NSString *goodsVolume;
/** 货物重量、吨 */
@property (nonatomic,copy) NSString *goodsWeight;
/** 图1 */
@property (nonatomic,copy) NSString *image1;
/** 图2 */
@property (nonatomic,copy) NSString *image2;
/** 装货时间 */
@property (nonatomic,copy) NSString *loadingTime;
/** 付款方式，1到付，2现付 */
@property (nonatomic,copy) NSString *payType;
/** 支付方式，1线上支付，2线下支付 */
@property (nonatomic,copy) NSString *payWay;
/** 备注 */
@property (nonatomic,copy) NSString *remark;
/** 用车类型，字典 */
@property (nonatomic,copy) NSString *useCarType;
/** 用车类型 */
@property (nonatomic,retain) NSArray *useCarTypeArr;
/** 专线费用 */
@property (nonatomic,copy) NSString *calculateNo;
/** 专线错误提示 */
@property (nonatomic,copy) NSString *calculateErrorMsg;
@end

@implementation JSDeliverConfirmVC

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_carLengthView hiddenView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"确认订单";
    _calculateNo = @"";
    _touchType = 0;
    _carLengthView =  [[FilterCustomView alloc]init];
    _carLengthView.viewHeight = HEIGHT-kNavBarH-kTabBarSafeH;;
    _carLengthView.top = kNavBarH;
    __weak typeof(self) weakSelf = self;
    _carLengthView.getPostDic = ^(NSDictionary * _Nonnull dic, NSArray * _Nonnull titles) {
        if (weakSelf.touchType==1) {
            weakSelf.carLengthDic = dic;
            [weakSelf.carLengthBtn setTitle:[titles firstObject] forState:UIControlStateNormal];
        }
        else if (weakSelf.touchType==2) {
            weakSelf.carModelDic = dic;
            [weakSelf.carModelBtn setTitle:[titles firstObject] forState:UIControlStateNormal];
        }
    };
    _image1 = @"";
    _image2 = @"";
    _remark = @"";
    self.feeType = @"1";
    self.payWay = @"1";
    self.payType = @"2";
    self.daoPayBtn.userInteractionEnabled = NO;
    if (_isAll) { //综合发货
        _tabHeaderView.height = 1112;
        self.title = @"发货";
    }
    else {
        _tabHeaderView.height = 845;
    }
    if (![Utils isBlankString:self.subscriberId]) { //指定发布
        [_submitBtn setTitle:@"指定发布" forState:UIControlStateNormal];
    } else {
        [_submitBtn setTitle:@"下单" forState:UIControlStateNormal];
    }
    [self.baseTabView reloadData];

    self.depositFeeTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 6, 0)];
    self.depositFeeTF.leftViewMode = UITextFieldViewModeAlways;

    [self getCarLengthInfo]; //车长
    [self getCarModelInfo]; //车型
    [self getCarTypeInfo]; //用车类型
    [self initData]; //重新发货数据初始化
}

#pragma mark - 重新发货数据初始化
/** 重新发货数据初始化 */
- (void)initData {
    if (self.model != nil) {
        _carLengthDic = @{@"carLength":self.model.carLength};
        _carModelDic = @{@"carModel":self.model.carModel};
        _info2 = [[AddressInfoModel alloc] init];
        _info1 = [[AddressInfoModel alloc] init];
        _info1.address = self.model.sendAddress;
        _info1.areaCode = self.model.sendAddressCode;
        _info1.phone = self.model.sendMobile;
        _info1.name = self.model.sendName;
        NSString *sendPosition = self.model.sendPosition;
        NSDictionary *sendPositionDic = [Utils dictionaryWithJsonString:sendPosition];
        _info1.lat = [[sendPositionDic valueForKey:@"latitude"] floatValue];
        _info1.lng = [[sendPositionDic valueForKey:@"longitude"] floatValue];
        _info2.address = self.model.receiveAddress;
        _info2.areaCode = self.model.receiveAddressCode;
        _info2.phone = self.model.receiveMobile;
        _info2.name = self.model.receiveName;
        NSString *receivePosition = self.model.receivePosition;
        NSDictionary *receivePositionDic = [Utils dictionaryWithJsonString:receivePosition];
        _info2.lat = [[receivePositionDic valueForKey:@"latitude"] floatValue];
        _info2.lng = [[receivePositionDic valueForKey:@"longitude"] floatValue];
        
        _weightTF.text = self.model.goodsWeight;
        _goodAreaTF.text = self.model.goodsVolume;
        _goodsNameTypeTF.text = self.model.goodsName;
        _goodsPackTF.text = self.model.packType;
        _goodsTimeLab.text = self.model.loadingTime;
        _useCarTypeLab.text = self.model.useCarTypeName;
        _loadingTime = self.model.loadingTime;
        _useCarType = self.model.useCarType;
        _markTF.text = self.model.remark;
        _feeType = self.model.feeType;
        _priceLab.text = self.model.fee;
        _image1 = self.model.image1;
        _image2 = self.model.image2;
        _payWay = self.model.payWay;
        _payType = self.model.payType;
        
        [_startAddressBtn setTitle:self.model.sendAddress forState:UIControlStateNormal];
        [_endAddressBtn setTitle:self.model.receiveAddress forState:UIControlStateNormal];
        if (_info1&&_info2) {
            NSString *disStr = [Utils distanceBetweenOrderBy:_info1.lat :_info1.lng andOther:_info2.lat :_info2.lng];
            _distanceLab.text = [NSString stringWithFormat:@"总里程:%@",disStr];
        }
        if (![Utils isBlankString:self.model.carLengthName]) {
            [_carLengthBtn setTitle:self.model.carLengthName forState:UIControlStateNormal];
        }
        if (![Utils isBlankString:self.model.carModelName]) {
            [_carModelBtn setTitle:self.model.carModelName forState:UIControlStateNormal];
        }
        [_image1Btn sd_setImageWithURL:[NSURL URLWithString:self.model.image1] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"order_upload_icon_photo"]];
        [_image2Btn sd_setImageWithURL:[NSURL URLWithString:self.model.image2] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"order_upload_icon_photo"]];
        if ([_feeType integerValue] == 1) { //自己出价
            _chujiaBtn.selected = YES;
            _dianyiBtn.selected = NO;
        } else { //电议
            _chujiaBtn.selected = NO;
            _dianyiBtn.selected = YES;
        }
        if ([_payWay integerValue] == 1) { //线上支付
            _onPayBtn.selected = YES;
            _offPayBtn.selected = NO;
        } else { //线下支付
            _onPayBtn.selected = NO;
            _offPayBtn.selected = YES;
        }
        if ([_payType integerValue] == 1) { //到付
            _daoPayBtn.selected = YES;
            _nowPayBtn.selected = NO;
        } else { //现付
            _daoPayBtn.selected = NO;
            _nowPayBtn.selected = YES;
        }
        
        if ([self.model.deposit floatValue]>0) {
            _depositSwitchBtn.selected = YES;
            _depositFeeTF.text = self.model.deposit;
        } else {
            _depositSwitchBtn.selected = NO;
            _depositFeeTF.hidden = YES;
        }
    } else {
        _info1 = [NSKeyedUnarchiver unarchiveObjectWithFile:kSendAddressArchiver];
        _info2 = [NSKeyedUnarchiver unarchiveObjectWithFile:kReceiveAddressArchiver];
        if (_info1 && ![NSString isEmpty:_info1.address]) {
            [self.startAddressBtn setTitle:_info1.address forState:UIControlStateNormal];
        }
        if (_info2 && ![NSString isEmpty:_info2.address]) {
            [self.endAddressBtn setTitle:_info2.address forState:UIControlStateNormal];
        }
        if (_info1&&_info2) {
            NSString *disStr = [Utils distanceBetweenOrderBy:_info1.lat :_info1.lng andOther:_info2.lat :_info2.lng];
            self.distanceLab.text = [NSString stringWithFormat:@"总里程:%@",disStr];
        }
    }
}

#pragma mark - 车长
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

#pragma mark - 车型
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

#pragma mark - 用车类型
/** 用车类型 */
- (void)getCarTypeInfo {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@?type=useCarType",URL_GetDictByType];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            NSArray *arr = responseData;
            if ([arr isKindOfClass:[NSArray class]]) {
                weakSelf.useCarTypeArr = [NSArray arrayWithArray:arr];
            }
        }
    }];
}

#pragma mark - storyboard方法
/** storyboard方法 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    __weak typeof(self) weakSelf = self;
    if ([segue.identifier isEqualToString:@"start"]) {
        JSConfirmAddressMapVC *vc = segue.destinationViewController;
        vc.sourceType = 0;
        vc.getAddressinfo = ^(AddressInfoModel * _Nonnull info) {
            [weakSelf.startAddressBtn setTitle:info.address forState:UIControlStateNormal];
            weakSelf.info1 = info;
            if (weakSelf.info1&&weakSelf.info2) {
                NSString *disStr = [Utils distanceBetweenOrderBy:weakSelf.info1.lat :weakSelf.info1.lng andOther:weakSelf.info2.lat :weakSelf.info2.lng];
                weakSelf.distanceLab.text = [NSString stringWithFormat:@"总里程:%@",disStr];
            }
            [weakSelf getOrderFee];
        };
    }
    else if ([segue.identifier isEqualToString:@"end"]) {
        JSConfirmAddressMapVC *vc = segue.destinationViewController;
        vc.sourceType = 1;
        vc.getAddressinfo = ^(AddressInfoModel * _Nonnull info) {
            [weakSelf.endAddressBtn setTitle:info.address forState:UIControlStateNormal];
            weakSelf.info2 = info;
            if (weakSelf.info1&&weakSelf.info2) {
                NSString *disStr = [Utils distanceBetweenOrderBy:weakSelf.info1.lat :weakSelf.info1.lng andOther:weakSelf.info2.lat :weakSelf.info2.lng];
                weakSelf.distanceLab.text = [NSString stringWithFormat:@"总里程:%@",disStr];
            }
            [weakSelf getOrderFee];
        };
    }
}

#pragma mark - 选择车长
/** 选择车长 */
- (IBAction)carLengthAction:(id)sender {
    [self.view endEditing:YES];
    if (_carLengthArr.count==0) {
        return;
    }
    _touchType = 1;
    self.carLengthView.dataDic = @{@"carLength":self.carLengthArr};
    [_carLengthView showView];
}

#pragma mark - 选择车型
/** 选择车型 */
- (IBAction)carModelAction:(id)sender {
    [self.view endEditing:YES];
    if (_carModelArr.count==0) {
        return;
    }
    _touchType = 2;
    self.carLengthView.dataDic = @{@"carModel":self.carModelArr};
    [_carLengthView showView];
}

#pragma mark - 选择货物名称
/** 选择货物名称 */
- (IBAction)selectGoodsNameAction:(UIButton *)sender {
    [self.view endEditing:YES];
    JSSelectGoodsNameVC *vc = (JSSelectGoodsNameVC *)[Utils getViewController:@"DeliverGoods" WithVCName:@"JSSelectGoodsNameVC"];
    vc.sourceType = 0;
    [vc setSelectBlock:^(NSString *name){
        self.goodsNameTypeTF.text = name;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 选择包装类型
/** 选择包装类型 */
- (IBAction)selectGoodsPackAction:(UIButton *)sender {
    [self.view endEditing:YES];
    JSSelectGoodsNameVC *vc = (JSSelectGoodsNameVC *)[Utils getViewController:@"DeliverGoods" WithVCName:@"JSSelectGoodsNameVC"];
    vc.sourceType = 1;
    [vc setSelectBlock:^(NSString *name){
        self.goodsPackTF.text = name;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 选择装货时间
/** 选择装货时间 */
- (IBAction)selectGoodsTimeAction:(id)sender {
    [self.view endEditing:YES];
    __weak typeof(self) weakSelf = self;
    ZHPickView *pickView = [[ZHPickView alloc] init];
    [pickView setDateViewWithTitle:@"装货时间"];
    [pickView showPickView:self];
    pickView.block = ^(NSString *selectedStr) {
        weakSelf.loadingTime = selectedStr;
        weakSelf.goodsTimeLab.text = selectedStr;
        weakSelf.goodsTimeLab.textColor = [UIColor grayColor];
    };
}

#pragma mark - 选择用车类型
/** 选择用车类型 */
- (IBAction)selectUseCarTypeAction:(id)sender {
    [self.view endEditing:YES];
    __weak typeof(self) weakSelf = self;
    ZHPickView *pickView = [[ZHPickView alloc] init];
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dic in self.useCarTypeArr) {
        [arr addObject:dic[@"label"]];
    }
    [pickView setDataViewWithItem:arr title:@"用车类型"];
    [pickView showPickView:self];
    pickView.block = ^(NSString *selectedStr) {
        weakSelf.useCarType = weakSelf.useCarTypeArr[[arr indexOfObject:selectedStr]][@"value"];
        weakSelf.useCarTypeLab.text = selectedStr;
        weakSelf.useCarTypeLab.textColor = [UIColor grayColor];
        weakSelf.specificFeeView.hidden = YES;
        weakSelf.specificFeeView.superview.height = 134;
        if ([selectedStr isEqualToString:@"零担"]) {
            weakSelf.specificFeeView.hidden = NO;
            weakSelf.specificFeeView.superview.height = 84;
            [weakSelf getOrderFee];
        }
    };
}

#pragma mark - 获取专线费用
/** 获取专线费用 */
- (void)getOrderFee {
    if (![self.useCarTypeLab.text isEqual:@"零担"]) {
        return;
    }
    NSLog(@"%@",_info1.streetCode);
//    _info1.streetCode = @"330203006";
//    _info2.streetCode = @"330203008";
    if (_info1.streetCode.length==0||_info1.streetCode.length==0||_goodAreaTF.text.length==0||_weightTF.text.length==0) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@?startAddressCode=%@&arriveAddressCode=%@&goodsVolume=%@&goodsWeight=%@",URL_OrderGetFee,_info1.streetCode,_info2.streetCode,_goodAreaTF.text,_weightTF.text];
    [[NetworkManager sharedManager] getJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        weakSelf.calculateNo = @"";
        if (status==Request_Success) {
            weakSelf.specificFeeLab.text = [NSString stringWithFormat:@"%.2f元",[responseData[@"totalFee"] floatValue]];
            weakSelf.calculateNo = responseData[@"calculateNo"];
        }
    }];
}

#pragma mark - 上传照片左
/** 上传照片左 */
- (IBAction)selectPhotoAction1:(UIButton *)sender {
    [self.view endEditing:YES];
    imageType = 1;
    __weak typeof(self) weakSelf = self;
    TZImagePickerController *vc = [[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:self];;
    vc.naviTitleColor = kBlackColor;
    vc.barItemTextColor = AppThemeColor;
    vc.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos.count>0) {
            UIImage *firstimg = [photos firstObject];
            [sender setImage:firstimg forState:UIControlStateNormal];
            [weakSelf postImage:firstimg];
        }
    };
    vc.modalPresentationStyle = 0;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - 上传照片右
/** 上传照片右 */
- (IBAction)selectPhotoAction2:(UIButton *)sender {
    [self.view endEditing:YES];
    imageType = 2;
    __weak typeof(self) weakSelf = self;
    TZImagePickerController *vc = [[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:self];;
    vc.naviTitleColor = kBlackColor;
    vc.barItemTextColor = AppThemeColor;
    vc.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos.count>0) {
            UIImage *firstimg = [photos firstObject];
            [sender setImage:firstimg forState:UIControlStateNormal];
            [weakSelf postImage:firstimg];
        }
    };
    vc.modalPresentationStyle = 0;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - 上传照片
/** 上传照片 */
- (void)postImage:(UIImage *)iconImage {
    __weak typeof(self) weakSelf = self;
    NSData *imageData = UIImageJPEGRepresentation(iconImage, 0.01);
    NSMutableArray *imageDataArr = [NSMutableArray arrayWithObjects:imageData, nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"pigx",@"resourceId", nil];
    [[NetworkManager sharedManager] postJSON:UPLOAD_URL() parameters:dic imageDataArr:imageDataArr imageName:@"file" completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            NSString *photo = responseData;
            if (self->imageType==1) {
                weakSelf.image1 = photo;
            }
            else if (self->imageType==2) {
                weakSelf.image2 = photo;
            }
        }
    }];
}

#pragma mark - 需要搬货/卸货
/** 需要搬货/卸货 */
- (IBAction)needLoadGoodsType:(UIButton *)sender {
    [self.view endEditing:YES];
    sender.selected = YES;
    sender.borderColor = AppThemeColor;
    sender.borderWidth = 1;
    sender.cornerRadius = 5;
    
    NSInteger otherTag = sender.tag==100?101:100;
    UIButton *otherBtn = [self.view viewWithTag:otherTag];
    otherBtn.selected = NO;
    otherBtn.borderColor = RGBValue(0xc8c8c8);
    otherBtn.borderWidth = 1;
    otherBtn.cornerRadius = 5;
    
    _markTF.text = [NSString stringWithFormat:@"%@ %@",_markTF.text,sender.titleLabel.text];
}

#pragma mark - 自己出价/电议
/** 自己出价/电议 */
- (IBAction)feeSelectAction:(UIButton *)sender {
    self.feeType = sender.tag==110?@"1":@"2";
    sender.selected = YES;
    NSInteger otherTag = sender.tag==110?111:110;
    UIButton *otherBtn = [self.view viewWithTag:otherTag];
    otherBtn.selected = NO;
}

#pragma mark - 支付方式
/** 支付方式 */
- (IBAction)payTypeAction:(UIButton *)sender {
    self.payWay = sender.tag==120?@"1":@"2";
    sender.selected = YES;
    NSInteger otherTag = sender.tag==120?121:120;
    UIButton *otherBtn = [self.view viewWithTag:otherTag];
    otherBtn.selected = NO;
    
    if ([self.payWay isEqualToString:@"1"]) { //线上支付
        self.payType = @"2";
        self.nowPayBtn.selected = YES;
        self.daoPayBtn.userInteractionEnabled = NO;
    } else {
        self.daoPayBtn.userInteractionEnabled = YES;
    }
}

#pragma mark - 付款方式
/** 付款方式 */
- (IBAction)payTypeAction2:(UIButton *)sender {
    self.payType = sender.tag==130?@"1":@"2";
    sender.selected = YES;
    NSInteger otherTag = sender.tag==130?131:130;
    UIButton *otherBtn = [self.view viewWithTag:otherTag];
    otherBtn.selected = NO;
    
    if ([self.payType isEqualToString:@"1"]) { //到付
        self.payWay = @"2";
        self.offPayBtn.selected = YES;
        self.onPayBtn.userInteractionEnabled = NO;
    } else {
        self.onPayBtn.userInteractionEnabled = YES;
    }
}

#pragma mark - 是否需要保证金
/** 是否需要保证金 */
- (IBAction)depositSwitchAction:(id)sender {
    self.depositSwitchBtn.selected = !self.depositSwitchBtn.isSelected;
    if (self.depositSwitchBtn.isSelected == YES) {
        self.depositFeeTF.hidden = NO;
    } else {
        self.depositFeeTF.hidden = YES;
    }
}

#pragma mark - 指定发布/下单
/** 指定发布/下单 */
- (IBAction)submitAction:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *urlStr = URL_AddStepTwo;
    if (_isAll) { //综合发布
        urlStr = URL_AddOrder;
        [dic addEntriesFromDictionary:_carLengthDic];
        [dic addEntriesFromDictionary:_carModelDic];
        if (_info1.address.length==0) {
            [Utils showToast:@"请选择发货地址"];
            return;
        }
        if (_info2.address.length==0) {
            [Utils showToast:@"请选择收货地址"];
            return;
        }
        if (_info1.address.length>0) {
            [dic setObject:_info1.address forKey:@"sendAddress"];
            [dic setObject:_info1.areaCode forKey:@"sendAddressCode"];
            if (_info1.phone) {
                [dic setObject:_info1.phone forKey:@"sendMobile"];
                [dic setObject:_info1.name forKey:@"sendName"];
            }
            NSDictionary *locDic = @{@"latitude":@(_info1.lat),@"longitude":@(_info1.lng)};
            [dic setObject:[locDic jsonStringEncoded] forKey:@"sendPosition"];
        }
        if (_info2.address.length>0) {
            [dic setObject:_info2.address forKey:@"receiveAddress"];
            [dic setObject:_info2.areaCode forKey:@"receiveAddressCode"];
            if (_info2.phone.length>0) {
                [dic setObject:_info2.phone forKey:@"receiveMobile"];
                [dic setObject:_info2.name forKey:@"receiveName"];
            }
            NSDictionary *locDic = @{@"latitude":@(_info2.lat),@"longitude":@(_info2.lng)};
            [dic setObject:[locDic jsonStringEncoded] forKey:@"receivePosition"];
        }
    }
    if ([NSString isEmpty:_weightTF.text]) {
        [Utils showToast:@"请输入货物重量"];
        return;
    }
    if ([NSString isEmpty:_goodAreaTF.text]) {
        [Utils showToast:@"请输入货物体积"];
        return;
    }
    if ([NSString isEmpty:_loadingTime]) {
        [Utils showToast:@"请选择装货时间"];
        return;
    }
    //日期比较
    NSDateFormatter *dateFromatter = [[NSDateFormatter alloc] init];
    [dateFromatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *nowDate = [NSDate date];
    NSDate *selectDate = [dateFromatter dateFromString:_loadingTime];
    if ([nowDate compare:selectDate] == NSOrderedDescending){
        [Utils showToast:@"装货时间必须大于当前时间"];
        return;
    }
    if ([NSString isEmpty:_useCarType]) {
        [Utils showToast:@"请选择用车类型"];
        return;
    }
    if (_markTF.text.length>0) {
        _remark = _markTF.text;
    }
    _fee = @"";
    if ([_useCarType isEqualToString:@"零担"]) {
        if (self.calculateNo.length==0) {
            [Utils showToast:@"线路未开通，请联系客服或选择整车"];
            return;
        }
    }
    else {
        if ([_feeType integerValue]==1) {
            if ([NSString isEmpty:_priceLab.text]) {
                [Utils showToast:@"请输入价格"];
                return;
            }
            _fee = _priceLab.text;
        }
    }
    if (self.depositSwitchBtn.isSelected == YES && [NSString isEmpty:self.depositFeeTF.text]) {
        [Utils showToast:@"请输入保证金金额"];
        return;
    }
    
    if (![Utils isBlankString:_subscriberId]) {
        [dic setObject:_subscriberId forKey:@"matchId"];
    }
    if (![Utils isBlankString:_orderID]) {
        [dic setObject:_orderID forKey:@"id"];
    }
    [dic setObject:_calculateNo forKey:@"calculateNo"];
    [dic setObject:_useCarType forKey:@"useCarType"];
    [dic setObject:_loadingTime forKey:@"loadingTime"];
    [dic setObject:_goodsNameTypeTF.text forKey:@"goodsName"];
    [dic setObject:_goodsPackTF.text forKey:@"packType"];
    [dic setObject:_weightTF.text forKey:@"goodsWeight"];
    [dic setObject:_goodAreaTF.text forKey:@"goodsVolume"];
    [dic setObject:_image1 forKey:@"image1"];
    [dic setObject:_image2 forKey:@"image2"];
    [dic setObject:_remark forKey:@"remark"];
    [dic setObject:_feeType forKey:@"feeType"];
    [dic setObject:_fee forKey:@"fee"];
    [dic setObject:_payWay forKey:@"payWay"];
    [dic setObject:_payType forKey:@"payType"];
    if (_depositSwitchBtn.isSelected == YES) {
        [dic setObject:@"true" forKey:@"requireDeposit"];
        [dic setObject:_depositFeeTF.text forKey:@"deposit"];
    } else {
        [dic setObject:@"false" forKey:@"requireDeposit"];
        [dic setObject:@"0" forKey:@"deposit"];
    }
    [[NetworkManager sharedManager] postJSON:urlStr parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            //发货/收货信息清空
            AddressInfoModel *dataModel = [[AddressInfoModel alloc] init];
            dataModel.phone = [UserInfo share].mobile;
            dataModel.name = [UserInfo share].nickName;
            [NSKeyedArchiver archiveRootObject:dataModel toFile:kSendAddressArchiver];
            [NSKeyedArchiver archiveRootObject:[[AddressInfoModel alloc] init] toFile:kReceiveAddressArchiver];
            if ([Utils isBlankString:self.subscriberId]) {
                [Utils showToast:@"下单成功"];
            } else {
                [Utils showToast:@"指定发布成功"];
            }
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    // 判断是否输入内容，或者用户点击的是键盘的删除按钮
    if (![string isEqualToString:@""]) {
        // 小数点在字符串中的位置 第一个数字从0位置开始
        NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
        if (dotLocation == NSNotFound && range.location != 0) {
            //没有小数点,最大数值
            if (range.location >= 9){
                NSLog(@"单笔金额不能超过亿位");
                if ([string isEqualToString:@"."] && range.location == 9) {
                    return YES;
                }
                return NO;
            }
        }
        //判断输入多个小数点,禁止输入多个小数点
        if (dotLocation != NSNotFound){
            if ([string isEqualToString:@"."])return NO;
        }
//        if (textField.tag == 1000 || textField.tag == 1001) {
            //判断小数点后最多两位
            if (dotLocation != NSNotFound && range.location > dotLocation + 2) { return NO; }
//        }
        //判断总长度
        if (textField.text.length > 11) {
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:_goodAreaTF]||[textField isEqual:_weightTF]) {
        [self getOrderFee];
    }
}

@end
