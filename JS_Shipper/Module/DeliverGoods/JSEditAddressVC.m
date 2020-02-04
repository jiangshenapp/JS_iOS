//
//  JSEditAddressVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/4/26.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSEditAddressVC.h"
#import "AddressInfoModel.h"
#import "ZHPickView.h"

@interface JSEditAddressVC ()<UITextFieldDelegate>
{
    NSInteger index;
    NSArray *codeArr;
}
/** 地址模型 */
@property (nonatomic,retain) AddressInfoModel *dataModel;
/** 街道数组 */
@property (nonatomic,retain) NSArray *streetArr;
@property (weak, nonatomic) IBOutlet UITextField *streetTF;
/** 街道编码 */
@property (nonatomic,copy) NSString *streetCode;

@end

@implementation JSEditAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    index = 0;
    self.title = @"发货人";
    self.dataModel = [NSKeyedUnarchiver unarchiveObjectWithFile:kSendAddressArchiver];
    
    if (_isReceive) {
        self.title = @"收货人";
        self.dataModel = [NSKeyedUnarchiver unarchiveObjectWithFile:kReceiveAddressArchiver];
        _nameLab.placeholder = @"收货人姓名";
        _phoneLab.placeholder = @"收货人手机号";
    }
    _titleAddressLab.text = _addressInfo[@"title"];
    _addressLab.text = _addressInfo[@"address"];
    _detailAddressLab.text = self.dataModel.detailAddress;
    _nameLab.text = self.dataModel.name;
    _phoneLab.text = self.dataModel.phone;
    
    if (self.reSelectStreet == NO) {
        _streetTF.text = self.dataModel.street;
        _streetCode = self.dataModel.streetCode;
    }

    NSString  *provinceCode = _areaCode;
    NSString  *cityCode = _areaCode;
    if (_areaCode.length>2) {
        provinceCode = [_areaCode substringToIndex:2];
    }
    if (_areaCode.length>4) {
        cityCode = [_areaCode substringToIndex:4];
    }
    codeArr = @[provinceCode,cityCode,_areaCode];
    
    NSArray *provinceArr = [Utils readLocalFileWithName:@"addressDetail"];
    [self getStreetArr:provinceArr];
    NSLog(@"%@",_streetArr);
}

- (IBAction)selectStreetAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    ZHPickView *pickView = [[ZHPickView alloc] init];
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dic in self.streetArr) {
        [arr addObject:dic[@"name"]];
    }
    [pickView setDataViewWithItem:arr title:@"选择街道"];
    [pickView showPickView:self];
    pickView.block = ^(NSString *selectedStr) {
        weakSelf.streetTF.text = selectedStr;
        NSInteger tempIndex = [arr indexOfObject:selectedStr];
        weakSelf.streetCode = weakSelf.streetArr[tempIndex][@"code"];
    };
}

- (void)getStreetArr:(NSArray *)dataArr {
    if (index>=codeArr.count) {
        return;
    }
    NSString *code = codeArr[index];
    NSString *predicateStr = [NSString stringWithFormat:@"code = '%@'",code];
     NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateStr];
     NSArray *resultArr = [dataArr filteredArrayUsingPredicate:predicate];
     NSDictionary *districtInfo ;
     if (resultArr.count>0) {
         districtInfo = [resultArr firstObject];
     }
    _streetArr = districtInfo[@"childs"];
    index++;
    [self getStreetArr:_streetArr];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.tag == 100) {
        if (textField.text.length + string.length > 11) {
            return NO;
        }
    }
    return YES;
}

- (IBAction)confirmAddressAction:(UIButton *)sender {
    if ([Utils isBlankString:_streetCode]) {
        [Utils showToast:@"请选择街道"];
        return;
    }
    if (_nameLab.text.length==0) {
        [Utils showToast:@"请输入姓名"];
        return;
    }
    if (_phoneLab.text.length==0||_phoneLab.text.length!=11) {
        [Utils showToast:@"请输入手机号"];
        return;
    }
    NSString *text = @"";
    if (_detailAddressLab.text.length>0) {
        text = _detailAddressLab.text;
    }
    NSDictionary *addressDic = @{@"phone":_phoneLab.text,@"name":_nameLab.text,@"detailAddress":text,@"streetCode":_streetCode,@"street":_streetTF.text};
    if (self.getAddressInfo) {
        self.getAddressInfo(addressDic);
    }
    [self backAction];
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
