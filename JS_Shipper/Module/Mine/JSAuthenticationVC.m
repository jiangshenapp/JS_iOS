//
//  JSAuthenticationVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/26.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSAuthenticationVC.h"
#import "HmSelectAdView.h"
#import "AuthInfo.h"

@interface JSAuthenticationVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    BOOL isPerson;//判断是个人还是公司
}

@property (nonatomic, assign) NSInteger authState; //0未认证，1审核中，2已认证，3认证失败
@property (nonatomic, assign) NSInteger photoType; //1、身份证正面 2、身份证反面 3、手持身份证 4、公司营业执照
@property (nonatomic, copy) NSString *idCardFrontPhoto;
@property (nonatomic, copy) NSString *idCardBehindPhoto;
@property (nonatomic, copy) NSString *idCardHandPhoto;
@property (nonatomic, copy) NSString *companyPhoto;

@property (nonatomic, copy) NSString *currentProvince;
@property (nonatomic, copy) NSString *currentCity;
@property (nonatomic, copy) NSString *currentArea;

@end

@implementation JSAuthenticationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"货主身份认证";
    
    if ([[UserInfo share].personConsignorVerified integerValue] == 1
        || [[UserInfo share].personConsignorVerified integerValue] == 2) {
        isPerson = YES;
        UIButton *otherBtn = [self.view viewWithTag:100];
        [self titleViewAction:otherBtn];
        self.personBtn.userInteractionEnabled = NO;
        self.companyBtn.userInteractionEnabled = NO;
    } else if ([[UserInfo share].companyConsignorVerified integerValue] == 1 || [[UserInfo share].companyConsignorVerified integerValue] == 2) {
        isPerson = NO;
        UIButton *otherBtn = [self.view viewWithTag:101];
        [self titleViewAction:otherBtn];
        self.personBtn.userInteractionEnabled = NO;
        self.companyBtn.userInteractionEnabled = NO;
    } else {
        isPerson = YES;
        self.companyTabView.hidden = YES;
    }
    if (isPerson == YES) {
        _authState = [[UserInfo share].personConsignorVerified integerValue];
    } else {
        _authState = [[UserInfo share].companyConsignorVerified integerValue];
    }
    self.bottomViewH.constant = 100;
    if (_authState == 0) { //未认证
        self.authStateH.constant = 0;
    } else {
        self.authStateH.constant = 40;
        [self initAuthData];
        self.authStateLab.text = kAuthStateStrDic[@(_authState)];
        self.authStateLab.textColor = kAuthStateColorDic[@(_authState)];
        if (_authState != 3) { //认证失败
            [self initAuthView];
        }
    }
    self.photoType = 0;
    self.personTabView.tableFooterView = [[UIView alloc] init];
    self.companyTabView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - 认证信息初始化
- (void)initAuthData {
    if (isPerson) { //个人认证
        NSDictionary *paramDic = [NSDictionary dictionary];
        [[NetworkManager sharedManager] postJSON:URL_GetPersonConsignorVerifiedInfo parameters:paramDic completion:^(id responseData, RequestState status, NSError *error) {
            if (status == Request_Success) {
                AuthInfo *authInfo = [AuthInfo mj_objectWithKeyValues:(NSDictionary *)responseData];
                [self.idCardFrontBtn sd_setImageWithURL:[NSURL URLWithString:authInfo.idImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Authentication_img_idpositive"]];
                [self.idCardBehindBtn sd_setImageWithURL:[NSURL URLWithString:authInfo.idBackImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Authentication_img_id"]];
                [self.idCardHandBtn sd_setImageWithURL:[NSURL URLWithString:authInfo.idHandImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"authentication_img_body"]];
                self.nameTF.text = authInfo.personName;
                self.idCardTF.text = authInfo.idCode;
                self.addressTF.text = authInfo.address;
            }
        }];
    } else { //公司认证
        NSDictionary *paramDic = [NSDictionary dictionary];
        [[NetworkManager sharedManager] postJSON:URL_GetCompanyConsignorVerifiedInfo parameters:paramDic completion:^(id responseData, RequestState status, NSError *error) {
            if (status == Request_Success) {
                AuthInfo *authInfo = [AuthInfo mj_objectWithKeyValues:(NSDictionary *)responseData];
                self.companyNameTF.text = authInfo.companyName;
                self.companyNoTF.text = authInfo.registrationNumber;
                self.companyAddressLab.text = authInfo.address;
                self.companyDetailAddressTF.text = authInfo.detailAddress;
                [self.companyPhotoBtn sd_setImageWithURL:[NSURL URLWithString:authInfo.businessLicenceImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Authentication_img_id"]];
            }
        }];
    }
}

- (void)initAuthView {
    self.bottomViewH.constant = 0;
    if (isPerson) { //个人认证
        self.personTabHeadView.userInteractionEnabled = NO;
        [self.addressBtn setImage:nil forState:UIControlStateNormal];
    } else { //公司认证
        self.companyTabHeadView.userInteractionEnabled = NO;
        [self.companyAddressBtn setImage:nil forState:UIControlStateNormal];
    }
}

#pragma mark - methods

#pragma mark - 切换个人公司
/* 切换个人/公司 */
- (IBAction)titleViewAction:(UIButton *)sender {
    
    isPerson = sender.tag==100?YES:NO;
    
    for (NSInteger tag = 100; tag<102; tag++) {
        UIButton *btn = [self.view viewWithTag:tag];
        if ([btn isEqual:sender]) {
            btn.backgroundColor = AppThemeColor;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else {
            btn.backgroundColor = [UIColor clearColor];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    _personTabView.hidden = !isPerson;
    _companyTabView.hidden = isPerson;
    if (isPerson) {
        _authState = [[UserInfo share].personConsignorVerified integerValue];
    }
    else {
        _authState = [[UserInfo share].companyConsignorVerified integerValue];
    }
    self.bottomViewH.constant = 100;
    if (_authState == 0) { //未认证
        self.authStateH.constant = 0;
    } else {
        self.authStateH.constant = 40;
        [self initAuthData];
        self.authStateLab.text = kAuthStateStrDic[@(_authState)];
        self.authStateLab.textColor = kAuthStateColorDic[@(_authState)];
        if (_authState != 3) { //认证失败
            [self initAuthView];
        }
    }
}

/* 上传身份证正面 */
- (IBAction)uploadIdCardFrontAction:(id)sender {
    self.photoType = 1;
    [self selectPhoto];
}

/* 上传身份证反面 */
- (IBAction)uploadIdCardBehindAction:(id)sender {
    self.photoType = 2;
    [self selectPhoto];
}

/* 上传手持身份证 */
- (IBAction)uploadIdCardHandAction:(id)sender {
    self.photoType = 3;
    [self selectPhoto];
}

/* 选择照片 */
- (void)selectPhoto {
    [self.view endEditing:YES]; //隐藏键盘
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"本地相册",@"拍照",  nil];
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.allowsEditing = YES;
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:NO completion:^{}];
        }
            break;
        case 1:
        {
            if ([Utils isCameraPermissionOn]) {
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerController.allowsEditing = YES;
                imagePickerController.delegate = self;
                
                if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
                    self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
                }
                [self presentViewController:imagePickerController animated:NO completion:nil];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *iconImage = info[UIImagePickerControllerEditedImage];
    if (self.photoType == 1) {
        [self.idCardFrontBtn setImage:iconImage forState:UIControlStateNormal];
    }
    if (self.photoType == 2) {
        [self.idCardBehindBtn setImage:iconImage forState:UIControlStateNormal];
    }
    if (self.photoType == 3) {
        [self.idCardHandBtn setImage:iconImage forState:UIControlStateNormal];
    }
    if (self.photoType == 4) {
        [self.companyPhotoBtn setImage:iconImage forState:UIControlStateNormal];
    }
    
    [picker dismissViewControllerAnimated:NO completion:^{
        NSData *imageData = UIImageJPEGRepresentation(iconImage, 0.01);
        NSMutableArray *imageDataArr = [NSMutableArray arrayWithObjects:imageData, nil];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"pigx",@"resourceId", nil];
        [[NetworkManager sharedManager] postJSON:URL_FileUpload parameters:dic imageDataArr:imageDataArr imageName:@"file" completion:^(id responseData, RequestState status, NSError *error) {

            if (status == Request_Success) {

                NSString *photo = responseData;
                if (self.photoType == 1) {
                    self.idCardFrontPhoto = photo;
                }
                if (self.photoType == 2) {
                    self.idCardBehindPhoto = photo;
                }
                if (self.photoType == 3) {
                    self.idCardHandPhoto = photo;
                }
                if (self.photoType == 4) {
                    self.companyPhoto = photo;
                }
            }
        }];
    }];
}

/* 选择区域 */
- (IBAction)selectAddressAction:(id)sender {
    [self.view endEditing:YES];
    // 这里传进去的self.currentProvince 等等的都是本页面的存储值
    HmSelectAdView *selectV = [[HmSelectAdView alloc] initWithLastContent:self.currentProvince ? @[self.currentProvince, self.currentCity, self.currentArea] : nil];
    selectV.confirmSelect = ^(NSArray *address) {
        self.currentProvince = address[0];
        self.currentCity = address[1];
        self.currentArea = address[2];
        self.addressTF.text = [NSString stringWithFormat:@"%@%@%@", self.currentProvince, self.currentCity, self.currentArea];
    };
    [selectV show];
}

/* 公司选择所在地 */
- (IBAction)selectCompanyAddressAction:(id)sender {
    [self.view endEditing:YES];
    // 这里传进去的self.currentProvince 等等的都是本页面的存储值
    HmSelectAdView *selectV = [[HmSelectAdView alloc] initWithLastContent:self.currentProvince ? @[self.currentProvince, self.currentCity, self.currentArea] : nil];
    selectV.confirmSelect = ^(NSArray *address) {
        self.currentProvince = address[0];
        self.currentCity = address[1];
        self.currentArea = address[2];
        self.companyAddressLab.text = [NSString stringWithFormat:@"%@%@%@", self.currentProvince, self.currentCity, self.currentArea];
    };
    [selectV show];
}

/* 上传公司营业执照 */
- (IBAction)uploadCompanyPhotoAction:(id)sender {
    self.photoType = 4;
    [self selectPhoto];
}

/* 勾选协议 */
- (IBAction)selectAction:(id)sender {
    self.selectBtn.selected = !self.selectBtn.isSelected;
}

/* 用户协议 */
- (IBAction)protocalAction:(id)sender {
    [BaseWebVC showWithVC:self withUrlStr:[NSString stringWithFormat:@"%@%@",h5Url(),H5_Register] withTitle:@"用户协议"];
}

/* 提交审核 */
- (IBAction)commitAction:(id)sender {
    
    [self.view endEditing:YES];
    
    if (isPerson == YES) { //个人
        if ([NSString isEmpty:self.idCardFrontPhoto]) {
            [Utils showToast:@"请上传货主本人真实身份证正面"];
            return;
        }
        if ([NSString isEmpty:self.idCardBehindPhoto]) {
            [Utils showToast:@"请上传货主本人真实身份证反面"];
            return;
        }
        if ([NSString isEmpty:self.idCardHandPhoto]) {
            [Utils showToast:@"请上传货主本人手持身份证照片"];
            return;
        }
        if ([NSString isEmpty:self.nameTF.text]) {
            [Utils showToast:@"请输入姓名"];
            return;
        }
        if ([NSString isEmpty:self.idCardTF.text]) {
            [Utils showToast:@"请输入身份证号"];
            return;
        }
        if ([NSString isEmpty:self.addressTF.text]) {
            [Utils showToast:@"请选择所在区域"];
            return;
        }
        if (self.selectBtn.isSelected == NO) {
            [Utils showToast:@"请勾选用户协议"];
            return;
        }
        
        NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             _idCardFrontPhoto, @"idImage",
                             _idCardBehindPhoto, @"idBackImage",
                             _idCardHandPhoto, @"idHandImage",
                             self.nameTF.text, @"personName",
                             self.idCardTF.text, @"idCode",
                             self.addressTF.text, @"address",
                             nil];
        [[NetworkManager sharedManager] postJSON:URL_PersonConsignorVerified parameters:paramDic completion:^(id responseData, RequestState status, NSError *error) {
            if (status == Request_Success) {
                [Utils showToast:@"提交成功，前耐心等待审核"];
                [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChangeNotification object:nil];
                self.tabBarController.selectedIndex = 4;
                // 跳转到首页
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    } else {
        if ([NSString isEmpty:self.companyNameTF.text]) {
            [Utils showToast:@"请输入公司名称"];
            return;
        }
        if ([NSString isEmpty:self.companyNoTF.text]) {
            [Utils showToast:@"请输入企业信用代码/注册号"];
            return;
        }
        if ([NSString isEmpty:self.companyAddressLab.text]) {
            [Utils showToast:@"请选择所在地"];
            return;
        }
        if ([NSString isEmpty:self.companyDetailAddressTF.text]) {
            [Utils showToast:@"请输入详细地址"];
            return;
        }
        if ([NSString isEmpty:self.companyPhoto]) {
            [Utils showToast:@"请上传公司营业执照"];
            return;
        }
        if (self.selectBtn.isSelected == NO) {
            [Utils showToast:@"请勾选用户协议"];
            return;
        }
        
        NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             self.companyNameTF.text, @"companyName",
                             self.companyNoTF.text, @"registrationNumber",
                             self.companyAddressLab.text, @"address",
                             self.companyDetailAddressTF.text, @"detailAddress",
                             _companyPhoto, @"businessLicenceImage",
                             nil];
        [[NetworkManager sharedManager] postJSON:URL_CompanyConsignorVerified parameters:paramDic completion:^(id responseData, RequestState status, NSError *error) {
            if (status == Request_Success) {
                [Utils showToast:@"提交成功，前耐心等待审核"];
                [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChangeNotification object:nil];
                self.tabBarController.selectedIndex = 4;
                // 跳转到首页
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
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
