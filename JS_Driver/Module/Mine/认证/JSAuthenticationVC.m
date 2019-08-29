//
//  JSAuthenticationVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/26.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSAuthenticationVC.h"
//#import "HmSelectAdView.h"
#import "MOFSPickerManager.h" //https://www.jianshu.com/p/578065eab5ab
#import "AuthInfo.h"

@interface JSAuthenticationVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, assign) NSInteger authState; //0未认证，1审核中，2已认证，3认证失败
@property (nonatomic, assign) NSInteger photoType; //1、身份证正面 2、手持身份证 3、驾驶证 4、公司营业执照 5、司机从业资格证
@property (nonatomic, copy) NSString *idCardFrontPhoto;
@property (nonatomic, copy) NSString *idCardHandPhoto;
@property (nonatomic, copy) NSString *driverLincencePhoto;
@property (nonatomic, copy) NSString *businessLicensePhoto;
@property (nonatomic, copy) NSString *driverWorkPhoto;

@property (nonatomic, copy) NSString *currentProvince;
@property (nonatomic, copy) NSString *currentCity;
@property (nonatomic, copy) NSString *currentArea;
@property (nonatomic, copy) NSString *currentCode;

@end

@implementation JSAuthenticationVC

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.type == 0) {
        self.title = @"司机身份认证";
        self.driverTabView.hidden = NO;
        self.parkTabView.hidden = YES;
        _authState = [[UserInfo share].driverVerified integerValue];
    }
    else {
        self.title = @"园区成员认证";
        self.driverTabView.hidden = YES;
        self.parkTabView.hidden = NO;
        _authState = [[UserInfo share].parkVerified integerValue];
    }
    if (_authState == 0) { //未认证
        self.authStateLabH.constant = 0;
    } else {
        [self initAuthData];
        self.authStateLab.text = kAuthStateStrDic[@(_authState)];
        self.authStateLab.textColor = kAuthStateColorDic[@(_authState)];
        if (_authState != 3) { //认证失败
            [self initAuthView];
        }
    }
    self.photoType = 0;
    self.currentProvince = @"";
    self.currentCity = @"";
    self.currentArea = @"";
    self.currentCode = @"";
    _parkTabView.tableFooterView = [[UIView alloc] init];
    _driverTabView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - 认证信息初始化
- (void)initAuthData {
    if (self.type == 0) { //司机认证
        NSDictionary *paramDic = [NSDictionary dictionary];
        [[NetworkManager sharedManager] postJSON:URL_GetDriverVerifiedInfo parameters:paramDic completion:^(id responseData, RequestState status, NSError *error) {
            if (status == Request_Success) {
                AuthInfo *authInfo = [AuthInfo mj_objectWithKeyValues:(NSDictionary *)responseData];
                [self.idCardFrontBtn sd_setImageWithURL:[NSURL URLWithString:authInfo.idImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Authentication_img_id"]];
                [self.idCardHandBtn sd_setImageWithURL:[NSURL URLWithString:authInfo.idHandImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"authentication_img_body"]];
                [self.driverLicenceBtn sd_setImageWithURL:[NSURL URLWithString:authInfo.driverImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"authentication_img_driver"]];
                [self.driverWorkBtn sd_setImageWithURL:[NSURL URLWithString:authInfo.cyzgzImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Authentication_img_id"]];
                self.nameTF.text = authInfo.personName;
                self.idCardTF.text = authInfo.idCode;
                self.addressTF.text = authInfo.address;
                self.driverLicenceTypeTF.text = authInfo.driverLevel;
            }
        }];
    } else { //园区认证
        NSDictionary *paramDic = [NSDictionary dictionary];
        [[NetworkManager sharedManager] postJSON:URL_GetParkVerifiedInfo parameters:paramDic completion:^(id responseData, RequestState status, NSError *error) {
            if (status == Request_Success) {
                AuthInfo *authInfo = [AuthInfo mj_objectWithKeyValues:(NSDictionary *)responseData];
                self.parkNameTF.text = authInfo.companyName;
                self.organizationTypeTF.text = authInfo.companyType;
                if ([NSString isEmpty:authInfo.businessLicenceImage]) {
                    self.businessLicenseHaveBtn.selected = NO;
                    self.businessLicenseNoHaveBtn.selected = YES;
                } else {
                    self.businessLicenseHaveBtn.selected = YES;
                    self.businessLicenseNoHaveBtn.selected = NO;
                }
                self.IDNumberTF.text = authInfo.registrationNumber;
                self.parkAddressLab.text = authInfo.address;
                self.parkDetailAddressTF.text = authInfo.detailAddress;
                [self.businessLicenseBtn sd_setImageWithURL:[NSURL URLWithString:authInfo.businessLicenceImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Authentication_img_id"]];
            }
        }];
    }
}

- (void)initAuthView {
    self.bottomViewH.constant = 0;
    if (self.type == 0) { //司机认证
        self.driverTabHeadView.userInteractionEnabled = NO;
        [self.addressBtn setImage:nil forState:UIControlStateNormal];
        [self.driverLicenceTypeBtn setImage:nil forState:UIControlStateNormal];
    } else { //园区认证
        self.parkTabHeadView.userInteractionEnabled = NO;
        [self.organizationTypeBtn setImage:nil forState:UIControlStateNormal];
        [self.parkAddressBtn setImage:nil forState:UIControlStateNormal];
    }
}

/* 上传身份证正面 */
- (IBAction)uploadIdCardFrontAction:(id)sender {
    self.photoType = 1;
    [self selectPhoto];
}

/* 上传手持身份证 */
- (IBAction)uploadIdCardHandAction:(id)sender {
    self.photoType = 2;
    [self selectPhoto];
}

/* 上传驾驶证 */
- (IBAction)uploadDriveLincenceAction:(id)sender {
    self.photoType = 3;
    [self selectPhoto];
}

/* 上传司机从业资格证 */
- (IBAction)uploadDriverWorkAction:(id)sender {
    self.photoType = 5;
    [self selectPhoto];
}

/* 选择照片 */
- (void)selectPhoto {
    [self.view endEditing:YES]; //隐藏键盘
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"本地相册",@"拍照",  nil];
    sheet.tag = 100;
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger tag = actionSheet.tag;
    if (tag == 100) { //选择照片
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
    if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"关闭"]) {
        if (tag == 101) { //选择驾驶证类型
            self.driverLicenceTypeTF.text = [actionSheet buttonTitleAtIndex:buttonIndex];
        }
        if (tag == 102) { //选择机构类型
            self.organizationTypeTF.text = [actionSheet buttonTitleAtIndex:buttonIndex];
        }
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
        [self.idCardHandBtn setImage:iconImage forState:UIControlStateNormal];
    }
    if (self.photoType == 3) {
        [self.driverLicenceBtn setImage:iconImage forState:UIControlStateNormal];
    }
    if (self.photoType == 4) {
        [self.businessLicenseBtn setImage:iconImage forState:UIControlStateNormal];
    }
    if (self.photoType == 5) {
        [self.driverWorkBtn setImage:iconImage forState:UIControlStateNormal];
    }
    
    [picker dismissViewControllerAnimated:NO completion:^{
        NSData *imageData = UIImageJPEGRepresentation(iconImage, 0.1);
        NSMutableArray *imageDataArr = [NSMutableArray arrayWithObjects:imageData, nil];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"pigx",@"resourceId", nil];
        [[NetworkManager sharedManager] postJSON:URL_FileUpload parameters:dic imageDataArr:imageDataArr imageName:@"file" completion:^(id responseData, RequestState status, NSError *error) {

            if (status == Request_Success) {

                NSString *photo = responseData;
                if (self.photoType == 1) {
                    self.idCardFrontPhoto = photo;
                }
                if (self.photoType == 2) {
                    self.idCardHandPhoto = photo;
                }
                if (self.photoType == 3) {
                    self.driverLincencePhoto = photo;
                }
                if (self.photoType == 4) {
                    self.businessLicensePhoto = photo;
                }
                if (self.photoType == 5) {
                    self.driverWorkPhoto = photo;
                }
            }
        }];
    }];
}

/* 选择区域 */
- (IBAction)selectAddressAction:(id)sender {
    [self.view endEditing:YES]; //隐藏键盘
//    // 这里传进去的self.currentProvince 等等的都是本页面的存储值
//    HmSelectAdView *selectV = [[HmSelectAdView alloc] initWithLastContent:self.currentProvince ? @[self.currentProvince, self.currentCity, self.currentArea] : nil];
//    selectV.confirmSelect = ^(NSArray *address) {
//        self.currentProvince = address[0];
//        self.currentCity = address[1];
//        self.currentArea = address[2];
//        self.addressTF.text = [NSString stringWithFormat:@"%@%@%@", self.currentProvince, self.currentCity, self.currentArea];
//    };
//    [selectV show];

    [[MOFSPickerManager shareManger] showMOFSAddressPickerWithTitle:@"选择地址" cancelTitle:@"取消" commitTitle:@"完成" commitBlock:^(NSString *address, NSString *zipcode) {
        NSArray *arrAddress = [address componentsSeparatedByString:@"-"];
        NSArray *arrCode = [zipcode componentsSeparatedByString:@"-"];
        self.currentProvince = arrAddress[0];
        self.currentCity = arrAddress[1];
        self.currentArea = arrAddress[2];
        self.currentCode = arrCode[2];
        self.addressTF.text = [NSString stringWithFormat:@"%@%@%@", self.currentProvince, self.currentCity, self.currentArea];
    } cancelBlock:^{
        
    }];
}

/* 选择驾驶证类型 */
- (IBAction)selectDriveLincenceTypeAction:(id)sender {
    [self.view endEditing:YES]; //隐藏键盘
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"关闭" destructiveButtonTitle:nil otherButtonTitles:@"A1",@"A2",@"A3",@"B1",@"B2",@"C1",@"C2",@"C3",@"C4",@"D",@"E",@"F",@"M",@"N",@"P", nil];
    sheet.tag = 101;
    [sheet showInView:self.view];
}

/* 选择机构类型 */
- (IBAction)selectOrganizationTypeAction:(id)sender {
    [self.view endEditing:YES]; //隐藏键盘
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"关闭" destructiveButtonTitle:nil otherButtonTitles:@"服务中心",@"车代点",@"网点", nil];
    sheet.tag = 102;
    [sheet showInView:self.view];
}

/* 点击营业执照有 */
- (IBAction)clickBusinessLicenseHave:(id)sender {
    self.businessLicenseHaveBtn.selected = YES;
    self.businessLicenseNoHaveBtn.selected = NO;
}

/* 点击营业执照无 */
- (IBAction)clickBusinessLincenseNoHave:(id)sender {
    self.businessLicenseHaveBtn.selected = NO;
    self.businessLicenseNoHaveBtn.selected = YES;
}

/* 园区选择所在地 */
- (IBAction)selectParkAddressAction:(id)sender {
    [self.view endEditing:YES]; //隐藏键盘
//    // 这里传进去的self.currentProvince 等等的都是本页面的存储值
//    HmSelectAdView *selectV = [[HmSelectAdView alloc] initWithLastContent:self.currentProvince ? @[self.currentProvince, self.currentCity, self.currentArea] : nil];
//    selectV.confirmSelect = ^(NSArray *address) {
//        self.currentProvince = address[0];
//        self.currentCity = address[1];
//        self.currentArea = address[2];
//        self.parkAddressLab.text = [NSString stringWithFormat:@"%@%@%@", self.currentProvince, self.currentCity, self.currentArea];
//    };
//    [selectV show];
    
    [[MOFSPickerManager shareManger] showMOFSAddressPickerWithTitle:@"选择地址" cancelTitle:@"取消" commitTitle:@"完成" commitBlock:^(NSString *address, NSString *zipcode) {
        NSArray *arrAddress = [address componentsSeparatedByString:@"-"];
        NSArray *arrCode = [zipcode componentsSeparatedByString:@"-"];
        self.currentProvince = arrAddress[0];
        self.currentCity = arrAddress[1];
        self.currentArea = arrAddress[2];
        self.currentCode = arrCode[2];
        self.parkAddressLab.text = [NSString stringWithFormat:@"%@%@%@", self.currentProvince, self.currentCity, self.currentArea];
    } cancelBlock:^{
        
    }];
}

/* 上传公司营业执照 */
- (IBAction)uploadBusinessLincensePhotoAction:(id)sender {
    self.photoType = 4;
    [self selectPhoto];
}

/* 勾选协议 */
- (IBAction)selectAction:(id)sender {
    self.selectBtn.selected = !self.selectBtn.isSelected;
}

/* 用户协议 */
- (IBAction)protocalAction:(id)sender {
    [BaseWebVC showWithContro:self withUrlStr:[NSString stringWithFormat:@"%@%@",h5Url(),H5_Register] withTitle:@"用户协议" isPresent:NO];
}

/* 提交审核 */
- (IBAction)commitAction:(id)sender {
    
    [self.view endEditing:YES]; //隐藏键盘
    
    if (self.type == 0) { //司机认证
        [self driverCommitAction];
    } else { // 园区员工认证
        [self parkCommitAction];
    }
}

#pragma mark - 司机提交认证
- (void)driverCommitAction {
    if ([NSString isEmpty:self.idCardFrontPhoto]) {
        [Utils showToast:@"请上传司机本人真实身份证"];
        return;
    }
    if ([NSString isEmpty:self.idCardHandPhoto]) {
        [Utils showToast:@"请上传司机本人手持身份证照片"];
        return;
    }
    if ([NSString isEmpty:self.driverLincencePhoto]) {
        [Utils showToast:@"请上传司机本人驾驶证正本照片"];
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
    if ([NSString isEmpty:self.driverLicenceTypeTF.text]) {
        [Utils showToast:@"请选择驾驶证类型"];
        return;
    }
    if (self.selectBtn.isSelected == NO) {
        [Utils showToast:@"请勾选用户协议"];
        return;
    }
    
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
                         _idCardFrontPhoto, @"idImage",
                         _idCardHandPhoto, @"idHandImage",
                         _driverLincencePhoto, @"driverImage",
                         _driverWorkPhoto, @"cyzgzImage",
                         self.nameTF.text, @"personName",
                         self.idCardTF.text, @"idCode",
                         self.addressTF.text, @"address",
                         self.driverLicenceTypeTF.text, @"driverLevel",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_DriverVerified parameters:paramDic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            [Utils showToast:@"提交成功，请耐心等待审核"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChangeNotification object:nil];
            self.tabBarController.selectedIndex = 4;
            // 跳转到首页
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - 园区提交认证
- (void)parkCommitAction {
    
    if ([NSString isEmpty:self.parkNameTF.text]) {
        [Utils showToast:@"请输入代理点名称/个人姓名"];
        return;
    }
    if ([NSString isEmpty:self.organizationTypeTF.text]) {
        [Utils showToast:@"请选择机构类型"];
        return;
    }
    if ([NSString isEmpty:self.IDNumberTF.text]) {
        [Utils showToast:@"请输入证件类型/证件号码"];
        return;
    }
    if ([NSString isEmpty:self.parkAddressLab.text]) {
        [Utils showToast:@"请选择所在地"];
        return;
    }
    if ([NSString isEmpty:self.parkDetailAddressTF.text]) {
        [Utils showToast:@"请输入详细地址"];
        return;
    }
    if (self.businessLicenseHaveBtn.isSelected == YES && [NSString isEmpty:self.businessLicensePhoto]) {
        [Utils showToast:@"请上传公司营业执照"];
        return;
    }
    if (self.selectBtn.isSelected == NO) {
        [Utils showToast:@"请勾选用户协议"];
        return;
    }
    
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
                         self.parkNameTF.text, @"companyName",
                         kCompanyTypeStrDic[self.organizationTypeTF.text], @"companyType",
                         self.IDNumberTF.text, @"registrationNumber",
                         self.currentCode, @"addressCode",
                         self.parkAddressLab.text, @"address",
                         self.parkDetailAddressTF.text, @"detailAddress",
                         _businessLicensePhoto, @"businessLicenceImage",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_ParkVerified parameters:paramDic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            [Utils showToast:@"提交成功，前耐心等待审核"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChangeNotification object:nil];
            self.tabBarController.selectedIndex = 4;
            // 跳转到首页
            [self.navigationController popToRootViewControllerAnimated:YES];
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
