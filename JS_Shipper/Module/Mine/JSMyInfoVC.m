//
//  JSMyInfoVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/29.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSMyInfoVC.h"
#import "JSAuthenticationVC.h"
#import "AEFilePath.h"


@interface JSMyInfoVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation JSMyInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"用户中心";

    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[UserInfo share].avatar] placeholderImage:[UIImage imageNamed:@"personalcenter_shipper_icon_head_land"]];
    self.nickNameLab.text = [UserInfo share].nickName;
    
    self.cacheLab.text = [AEFilePath folderSizeAtPath:kCachePath];
    
    //失败》已审核〉审核中》未提交
    if ([[UserInfo share].personConsignorVerified integerValue] == 3
        || [[UserInfo share].companyConsignorVerified integerValue] == 3) {
        self.authStateLab.text = @"认证失败";
        return;
    }
    if ([[UserInfo share].personConsignorVerified integerValue] == 2
        || [[UserInfo share].companyConsignorVerified integerValue] == 2) {
        self.authStateLab.text = @"已认证";
        return;
    }
    if ([[UserInfo share].personConsignorVerified integerValue] == 1
        || [[UserInfo share].companyConsignorVerified integerValue] == 1) {
        self.authStateLab.text = @"认证中";
        return;
    }
    if ([[UserInfo share].personConsignorVerified integerValue] == 0
        && [[UserInfo share].companyConsignorVerified integerValue] == 0) {
        self.authStateLab.text = @"未提交";
        return;
    }
}

#pragma mark - methods

/* 修改头像 */
- (IBAction)changeHeadImgAction:(id)sender {
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
    self.headImgView.image = iconImage;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        NSData *imageData = UIImageJPEGRepresentation(iconImage, 0.01);
        NSMutableArray *imageDataArr = [NSMutableArray arrayWithObjects:imageData, nil];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"pigx",@"resourceId", nil];
        [[NetworkManager sharedManager] postJSON:URL_FileUpload parameters:dic imageDataArr:imageDataArr imageName:@"file" completion:^(id responseData, RequestState status, NSError *error) {
            
            if (status == Request_Success) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:responseData,@"avatar", nil];
                [[NetworkManager sharedManager] postJSON:URL_ChangeAvatar parameters:dic imageDataArr:nil imageName:nil completion:^(id responseData, RequestState status, NSError *error) {
                    
                    if (status == Request_Success) {
                        //修改头像成功
                        [Utils showToast:@"头像修改成功"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChangeNotification object:nil];
                    }
                }];
            }
        }];
    }];
}

/* 修改昵称 */
- (IBAction)changeNickNameAction:(id)sender {
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"修改昵称" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UITextField *txt = [alertVc.textFields objectAtIndex:0];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:txt.text,@"nickname", nil];
        [[NetworkManager sharedManager] postJSON:URL_ChangeNickname parameters:dic imageDataArr:nil imageName:nil completion:^(id responseData, RequestState status, NSError *error) {
            if (status == Request_Success) {
                self.nickNameLab.text = txt.text;
                [Utils showToast:@"昵称修改成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChangeNotification object:nil];
            }
        }];
    }];
    [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = self.nickNameLab.text;
    }];
    [alertVc addAction:cancelBtn];
    [alertVc addAction:sureBtn];
    [self presentViewController:alertVc animated:YES completion:nil];
}

/* 认证 */
- (IBAction)authAction:(id)sender {
    UIViewController *vc = [Utils getViewController:@"Mine" WithVCName:@"JSAuthenticationVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

/* 清除缓存 */
- (IBAction)clearCacheAction:(id)sender {
    NSString *message = [NSString stringWithFormat:@"确定清除%@缓存吗？",[AEFilePath folderSizeAtPath:kCachePath]];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle: UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSArray *files= [[NSFileManager defaultManager] subpathsAtPath:kCachePath];
            for (NSString *p in files) {
                NSError *error;
                NSString *path = [kCachePath stringByAppendingPathComponent:p];
                if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [Utils showToast:@"缓存清除完毕"];
                [self.tableView reloadData];
            });
        });
    }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

/* 隐私政策 */
- (IBAction)privacyAction:(id)sender {
    [BaseWebVC showWithContro:self withUrlStr:[NSString stringWithFormat:@"%@%@",h5Url(),H5_Privacy] withTitle:@"隐私保护指引" isPresent:NO];
}

/* 安全退出 */
- (IBAction)logoutAction:(id)sender {
    
    [Utils logout:YES];
//    [Utils showToast:@"安全退出成功"];
//    NSDictionary *dic = [NSDictionary dictionary];
//    [[NetworkManager sharedManager] postJSON:URL_Logout parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
//        if (status == Request_Success) {
//        }
//    }];
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
