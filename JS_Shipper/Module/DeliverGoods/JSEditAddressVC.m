//
//  JSEditAddressVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/4/26.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSEditAddressVC.h"
#import "AddressInfoModel.h"

@interface JSEditAddressVC ()<UITextFieldDelegate>

/** 地址模型 */
@property (nonatomic,retain) AddressInfoModel *dataModel;

@end

@implementation JSEditAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    if (_nameLab.text.length==0) {
        [Utils showToast:@"请填写收货人姓名"];
        return;
    }
    if (_phoneLab.text.length==0||_phoneLab.text.length!=11) {
        [Utils showToast:@"请填写正确的手机号码"];
        return;
    }
    NSString *text = @"";
    if (_detailAddressLab.text.length>0) {
        text = _detailAddressLab.text;
    }
    NSDictionary *addressDic = @{@"phone":_phoneLab.text,@"name":_nameLab.text,@"detailAddress":text};
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
