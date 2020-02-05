//
//  JSAddCarVC.m
//  JS_Driver
//
//  Created by zhanbing han on 2019/5/10.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "JSAddCarVC.h"
#import "TZImagePickerController.h"
#import "ZHPickView.h"
#import "JSMyCarVC.h"
#import <UIButton+WebCache.h>
#import "CarModel.h"

@interface JSAddCarVC ()
{
    NSMutableArray *carLengthNameArr;
    NSMutableArray *carModelNameArr;
    __block NSInteger imageType;
}
/** 车长数组 */
@property (nonatomic,retain) NSArray *carLengthArr;
/** 车型数组 */
@property (nonatomic,retain) NSArray *carModelArr;
/** 当前车类型 */
@property (nonatomic,copy) NSString *carModelID;
/** 当前车类型 */
@property (nonatomic,copy) NSString *useCarLengthStr;
/** 图1 */
@property (nonatomic,copy) NSString *image1;
/** 图2 */
@property (nonatomic,copy) NSString *image2;

/** 车数据 */
@property (nonatomic,retain) CarModel *carModel;
/** 车辆状态，0待审核，1通过，2拒绝，3审核中 */
@property (nonatomic,assign) NSInteger authState;

@end

@implementation JSAddCarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加车辆";
    self.baseTab.tableFooterView = [[UIView alloc]init];
    _carModelID = @"";
    _useCarLengthStr = @"";
    [self getCarModelInfo];
    [self getCarLengthInfo];
    
    if (![NSString isEmpty:_carDetailID]) {
        self.title = @"车辆详情";
        [self getData];
    }
}

- (void)getData {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@/%@",URL_GetCarDetail,_carDetailID];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            weakSelf.carModel = [CarModel mj_objectWithKeyValues:responseData];
            [weakSelf refrehsUI];
        }
    }];
}

- (void)refrehsUI {
    
    self.authState = [_carModel.state integerValue];
    if (self.authState == 2) {
        [_submitBtn setTitle:@"重新提交" forState:UIControlStateNormal];
    } else {
        [self changeView];
        if (self.authState == 1) {
            [_submitBtn setTitle:@"解绑" forState:UIControlStateNormal];
            _submitBtn.backgroundColor = RGBValue(0xD0021B);
        } else {
            _submitH.constant = 0;
        }
    }
    _carDriverLab.text = @"车辆行驶证";
    _carHeadImgLab.text = @"车头照";
    _rightBtn1.hidden = YES;
    _rightBtn2.hidden = YES;
    self.authCarH.constant = 40;
    self.authStateLab.text = _carModel.stateName;
    self.authStateLab.textColor = kCarStateColorDic[@(_authState)];
    _carNumLab.text = _carModel.cphm;
    _tradingNoTF.text = _carModel.tradingNo;
    _transportNoTF.text = _carModel.transportNo;
    _carTypeLab.text = _carModel.carModelName;
    _carLengthLab.text = _carModel.carLengthName;
    _carSpaceTF.text = [NSString stringWithFormat:@"%@方",_carModel.capacityVolume];
    _carWeightTF.text = [NSString stringWithFormat:@"%@千克",_carModel.capacityTonnage];
    [self.carDriverBtn sd_setImageWithURL:[NSURL URLWithString:_carModel.image1] forState:UIControlStateNormal placeholderImage:DefaultImage];
    [self.carHeadIMgBtn sd_setImageWithURL:[NSURL URLWithString:_carModel.image2] forState:UIControlStateNormal placeholderImage:DefaultImage];
}

- (void)changeView {
    _carModelBtn.hidden = YES;
    _carLengthModelBtn.hidden = YES;
    _carNumLab.userInteractionEnabled = NO;
    _carWeightTF.userInteractionEnabled = NO;
    _tradingNoTF.userInteractionEnabled = NO;
    _transportNoTF.userInteractionEnabled = NO;
    _carSpaceTF.userInteractionEnabled = NO;
    _carDriverBtn.userInteractionEnabled = NO;
    _carHeadIMgBtn.userInteractionEnabled = NO;
    
    _carTypeLab.right = WIDTH-12;
    _carLengthLab.right = WIDTH-12;
    _bottomH = 0;
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

- (IBAction)carDrivingLicenseAction:(UIButton *)sender {
 
    imageType = 1;
    __weak typeof(self) weakSelf = self;
    TZImagePickerController *vc = [[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:nil];;
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

- (IBAction)carHeadImgAction:(UIButton *)sender {
 
    imageType = 2;
    __weak typeof(self) weakSelf = self;
    TZImagePickerController *vc = [[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:nil];;
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

- (void)postImage:(UIImage *)iconImage {
    __weak typeof(self) weakSelf = self;
    NSData *imageData = UIImageJPEGRepresentation(iconImage, 0.1);
    NSMutableArray *imageDataArr = [NSMutableArray arrayWithObjects:imageData, nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"pigx",@"resourceId", nil];
    [[NetworkManager sharedManager] postJSON:UPLOAD_URL() parameters:dic imageDataArr:imageDataArr imageName:@"file" completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            NSString *photo = responseData;
            if (imageType==1) {
                weakSelf.image1 = photo;
            }
            else if (imageType==2) {
                weakSelf.image2 = photo;
            }
        }
    }];
}

- (IBAction)selectCarTypeAction:(id)sender {
    [self.view endEditing:YES];
    carModelNameArr = [NSMutableArray array];
    for (NSDictionary *dic in self.carModelArr) {
        [carModelNameArr addObject:dic[@"label"]];
    }
    __weak typeof(self) weakSelf = self;
    ZHPickView *pickView = [[ZHPickView alloc] init];
    [pickView setDataViewWithItem:carModelNameArr title:@"车型"];
    [pickView showPickView:self];
    pickView.block = ^(NSString *selectedStr) {
        weakSelf.carTypeLab.text = selectedStr;
        NSInteger index = [carModelNameArr indexOfObject:selectedStr];
        weakSelf.carModelID = weakSelf.carModelArr[index][@"value"];
    };
}

- (IBAction)selectCarLengthAction:(id)sender {
    [self.view endEditing:YES];
    carLengthNameArr = [NSMutableArray array];
    for (NSDictionary *dic in self.carLengthArr) {
        [carLengthNameArr addObject:dic[@"label"]];
    }
    __weak typeof(self) weakSelf = self;
    ZHPickView *pickView = [[ZHPickView alloc] init];
    [pickView setDataViewWithItem:carLengthNameArr title:@"车长"];
    [pickView showPickView:self];
    pickView.block = ^(NSString *selectedStr) {
        weakSelf.carLengthLab.text = selectedStr;
        NSInteger index = [carLengthNameArr indexOfObject:selectedStr];
        weakSelf.useCarLengthStr = weakSelf.carLengthArr[index][@"value"];
    };
}

- (void)unbindingCar {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@/%@",URL_UnbindingCar,_carDetailID];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            [Utils showToast:@"解绑成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kAddCarSuccNotification object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (IBAction)submitDataAction:(id)sender {
    
    if ([_submitBtn.titleLabel.text isEqualToString:@"解绑"]) {
        [self unbindingCar];
        return;
    }
    
    if (_carNumLab.text.length==0) {
        [Utils showToast:@"请输入车牌号码"];
        return;
    }
    if (_carTypeLab.text.length==0) {
        [Utils showToast:@"请选择车型"];
        return;
    }
    if (_carLengthLab.text.length==0) {
        [Utils showToast:@"请选择车长"];
        return;
    }
    if (_carWeightTF.text.length==0) {
        [Utils showToast:@"请输入载货重量"];
        return;
    }
    if (_carSpaceTF.text.length==0) {
        [Utils showToast:@"请输入载货空间"];
        return;
    }
    if (_image1.length==0) {
        [Utils showToast:@"请拍照上传车辆行驶证"];
        return;
    }
    if (_image2.length==0) {
        [Utils showToast:@"请拍照上传车头照"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_carWeightTF.text forKey:@"capacityTonnage"];
    [dic setObject:_tradingNoTF.text forKey:@"tradingNo"];
    [dic setObject:_transportNoTF.text forKey:@"transportNo"];
    [dic setObject:_carSpaceTF.text forKey:@"capacityVolume"];
    [dic setObject:_useCarLengthStr forKey:@"carLengthId"];
    [dic setObject:_carModelID forKey:@"carModelId"];
    [dic setObject:_carNumLab.text forKey:@"cphm"];
    [dic setObject:_image1 forKey:@"image1"];
    [dic setObject:_image2 forKey:@"image2"];
    [dic setObject:@"0" forKey:@"state"];
    NSString *urlStr = URL_AddCar;
    if ([_submitBtn.titleLabel.text isEqualToString:@"重新提交"]) {
        urlStr = [NSString stringWithFormat:@"%@/%@",URL_ReAuditCar,_carDetailID];
    }
    [[NetworkManager sharedManager] postJSON:urlStr parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            [Utils showToast:@"提交审核成功，请等待审核结果"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kAddCarSuccNotification object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
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
