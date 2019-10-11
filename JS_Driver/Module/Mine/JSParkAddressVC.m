//
//  JSParkAddressVC.m
//  JS_Driver
//
//  Created by zhanbing han on 2019/9/5.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSParkAddressVC.h"
#import "MOFSPickerManager.h"
#import "TZImagePickerController.h"
#import "RequestURLUtil.h"
#import "AuthInfo.h"

@interface JSParkAddressVC ()<TZImagePickerControllerDelegate>

/** 园区地址 */
@property (nonatomic,retain) AddressInfoModel *info1;
@property (nonatomic,copy) NSString *image1;
@property (nonatomic,copy) NSString *image2;
@property (nonatomic,copy) NSString *image3;
@property (nonatomic,copy) NSString *image4;

@property (weak, nonatomic) IBOutlet UITextField *contactNameTF;
@property (weak, nonatomic) IBOutlet UITextField *contactPhoneTF;
@property (weak, nonatomic) IBOutlet UILabel *parkAddressLab;
@property (weak, nonatomic) IBOutlet UITextField *detailAddressLab;

- (IBAction)selectParkAddressAction:(UIButton *)sender;
/** 4个选择图片的方法 tag= 100,101,102,103 */
- (IBAction)selectPhotoAction:(UIButton *)sender;
- (IBAction)submitCheckAction:(UIButton *)sender;

@end

@implementation JSParkAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"园区地址";
    _image1 = @"";
    _image2 = @"";
    _image3 = @"";
    _image4 = @"";
    __weak typeof(self) weakSelf = self;
    NSDictionary *paramDic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:URL_GetParkVerifiedInfo parameters:paramDic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            AuthInfo *authInfo = [AuthInfo mj_objectWithKeyValues:(NSDictionary *)responseData];
            weakSelf.image1 = authInfo.image1;
            weakSelf.image2 = authInfo.image2;
            weakSelf.image3 = authInfo.image3;
            weakSelf.image4 = authInfo.image4;
            weakSelf.contactNameTF.text = authInfo.contactName;
            weakSelf.contactPhoneTF.text = authInfo.contractPhone;
            weakSelf.detailAddressLab.text = authInfo.contactAddress;
            NSDictionary *dic = [Utils dictionaryWithJsonString:authInfo.contactLocation];
            if (dic.allKeys.count>0) {
                weakSelf.info1 = [AddressInfoModel mj_objectWithKeyValues:dic];
                weakSelf.parkAddressLab.textColor = [UIColor blackColor];
                weakSelf.parkAddressLab.text = weakSelf.info1.address;
            }
            if (![NSString isEmpty:weakSelf.image1]) {
                UIButton *sender1 = [weakSelf.view viewWithTag:100];
                [sender1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PIC_URL(),authInfo.image1]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"order_upload_icon_photo"]];
            }
            if (![NSString isEmpty:weakSelf.image2]) {
                UIButton *sender1 = [weakSelf.view viewWithTag:101];
                [sender1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PIC_URL(),authInfo.image2]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"order_upload_icon_photo"]];
            }
            if (![NSString isEmpty:weakSelf.image3]) {
                UIButton *sender1 = [weakSelf.view viewWithTag:102];
                [sender1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PIC_URL(),authInfo.image3]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"order_upload_icon_photo"]];
            }
            if (![NSString isEmpty:weakSelf.image4]) {
                UIButton *sender1 = [weakSelf.view viewWithTag:103];
                [sender1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PIC_URL(),authInfo.image4]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"order_upload_icon_photo"]];
            }
        }
    }];
}

- (IBAction)selectParkAddressAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    JSConfirmAddressMapVC *vc = (JSConfirmAddressMapVC *)[Utils getViewController:@"DeliverGoods" WithVCName:@"JSConfirmAddressMapVC"];
    vc.sourceType = 2;
    vc.getAddressinfo = ^(AddressInfoModel * _Nonnull info) {
        weakSelf.info1 = info;
        weakSelf.parkAddressLab.text = weakSelf.info1.address;
        weakSelf.parkAddressLab.textColor = [UIColor blackColor];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)selectPhotoAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    TZImagePickerController *vc = [[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:self];;
    vc.naviTitleColor = kBlackColor;
    vc.barItemTextColor = AppThemeColor;
    vc.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos.count>0) {
            UIImage *firstimg = [photos firstObject];
            [sender setImage:firstimg forState:UIControlStateNormal];
            [RequestURLUtil postImageWithData:firstimg result:^(NSString * _Nonnull imageID) {
                switch (sender.tag) {
                    case 100:
                        weakSelf.image1 = imageID;
                        break;
                    case 101:
                        weakSelf.image2 = imageID;
                        break;
                    case 102:
                        weakSelf.image3 = imageID;
                        break;
                    case 103:
                        weakSelf.image4 = imageID;
                        break;
                        
                    default:
                        break;
                }
            }];
        }
    };
    vc.modalPresentationStyle = 0;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)submitCheckAction:(UIButton *)sender {
    
    if ([Utils isBlankString:_contactNameTF.text]) {
        [Utils showToast:@"请输入联系人姓名"];
        return;
    }
    if ([Utils isBlankString:_contactPhoneTF.text]) {
        [Utils showToast:@"请输入联系人手机号"];
        return;
    }
    if ([Utils isBlankString:_detailAddressLab.text]) {
        [Utils showToast:@"请输入详细地址"];
        return;
    }
    if (_info1==nil) {
        [Utils showToast:@"请选择园区地址"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSDictionary *locDic = @{@"latitude":@(_info1.lat),@"longitude":@(_info1.lng),@"address":_info1.address};
    [dic setObject:[locDic jsonStringEncoded] forKey:@"contactLocation"];
    [dic setObject:_image1 forKey:@"image1"];
    [dic setObject:_image2 forKey:@"image2"];
    [dic setObject:_image3 forKey:@"image3"];
    [dic setObject:_image4 forKey:@"image4"];
    [dic setObject:_contactPhoneTF.text forKey:@"contractPhone"];
    [dic setObject:_contactNameTF.text forKey:@"contactName"];
    [dic setObject:_detailAddressLab.text forKey:@"contactAddress"];
    [[NetworkManager sharedManager] postJSON:URL_ParkSupplement parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            [Utils showToast:@"修改成功"];
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
