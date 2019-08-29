//
//  JSBaseOrderDetaileVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/29.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSOrderDetailsVC.h"
#import "JSAllOrderVC.h"
#import "JSOrderDistributionVC.h"
#import "XLGMapNavVC.h"
#import "JSAuthencationHomeVC.h"

@interface JSOrderDetailsVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSDictionary *startLocDic;
    NSDictionary *endLocDic;
}
/** 订单数据 */
@property (nonatomic,retain) OrderInfoModel *model;
@property (nonatomic, assign) NSInteger photoType; //1、回执图片1 2、回执图片2 3、回执图片3
@property (nonatomic, copy) NSString *commentImage1Photo;
@property (nonatomic, copy) NSString *commentImage2Photo;
@property (nonatomic, copy) NSString *commentImage3Photo;
@end

@implementation JSOrderDetailsVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"订单详情";
    
    _bgScroView.contentSize = CGSizeMake(0, _otherInfoView.bottom+50);
    
    self.tileView1.hidden = YES;
    self.titleView2.hidden = NO;
    
    self.commentImage1Photo = @"";
    self.commentImage2Photo = @"";
    self.commentImage3Photo = @"";
    
    self.bottomBtn.backgroundColor = AppThemeColor;
    [self.bottomBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    
    [self getOrderInfo];
}

-(void)getOrderInfo {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@/%@",URL_GetOrderInfo,_orderID];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            weakSelf.model = [OrderInfoModel mj_objectWithKeyValues:responseData];
            [weakSelf refreshUI];
        }
    }];
}

- (void)refreshUI {
//    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:self.model.driverAvatar] placeholderImage:[UIImage imageNamed:@"personalcenter_driver_icon_head_land"]];
    self.nameLab.text = self.model.sendName;
    self.introduceLab.text = self.model.sendMobile;
    self.orderNoLab.text = [NSString stringWithFormat:@"订单编号：%@",self.model.orderNo];
    self.orderStatusLab.text = self.model.stateNameDriver;
    self.startAddressLab.text = self.model.sendAddress;
    self.startAddressAreaLab.text = self.model.sendAddressCodeName;
    self.endAddressLab.text = self.model.receiveAddress;
    self.endAddressAreaLab.text = self.model.receiveAddressCodeName;
    self.goodsTomeLab.text = self.model.loadingTime;
    NSString *info = @"";
    if (![NSString isEmpty:self.model.carModelName]) {
        info = [info stringByAppendingString:self.model.carModelName];
    }
    if (![NSString isEmpty:self.model.carLengthName]) {
        info = [info stringByAppendingString:self.model.carLengthName];
    }
    if (![NSString isEmpty:self.model.goodsVolume]) {
        info = [info stringByAppendingString:[NSString stringWithFormat:@"/%@方",self.model.goodsVolume]];
    }
    if (![NSString isEmpty:self.model.goodsWeight]) {
        info = [info stringByAppendingString:[NSString stringWithFormat:@"/%@吨",self.model.goodsWeight]];
    }
    self.carInfoLab.text = info;
    self.goodsNameLab.text = self.model.goodsName;
    self.carTypeLab.text = self.model.useCarTypeName;
    self.goodsPackTypeLab.text = self.model.packType;
    if ([self.model.payWay isEqualToString:@"1"]) {
        self.payTypeLab.text = @"线上支付";
    } else {
        self.payTypeLab.text = @"线下支付";
    }
    if ([self.model.feeType isEqualToString:@"1"]) {
        self.orderFeeLab.text = [NSString stringWithFormat:@"￥%@",self.model.fee];
    } else {
        self.orderFeeLab.text = @"电议";
    }
    if ([self.model.payType isEqualToString:@"1"]) {
        self.goodsPayTypeLab.text = @"到付";
    } else {
        self.goodsPayTypeLab.text = @"现付";
    }
    self.depositLab.text = [NSString stringWithFormat:@"￥%@",self.model.deposit];
    self.explainLab.text = self.model.remark;
    startLocDic = [Utils dictionaryWithJsonString:self.model.sendPosition];
    endLocDic = [Utils dictionaryWithJsonString:self.model.receivePosition];
    NSDictionary *locDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"loc"];
    _distance1Lab.text = [NSString stringWithFormat:@"距离:%@",[Utils distanceBetweenOrderBy:[locDic[@"lat"] floatValue] :[locDic[@"lng"] floatValue] andOther:[startLocDic[@"latitude"] floatValue] :[startLocDic[@"longitude"] floatValue]]];
    _distance2Lab.text = [NSString stringWithFormat:@"总里程:%@",[Utils distanceBetweenOrderBy:[startLocDic[@"latitude"] floatValue] :[startLocDic[@"longitude"] floatValue] andOther:[endLocDic[@"latitude"] floatValue] :[endLocDic[@"longitude"] floatValue]]];
    [self initView];
}

#pragma mark - init view
- (void)initView {
    
    //2待接单，3待确认，4待货主付款，5待接货, 6待送达，7待确认收货，8待回单收到确认，9待货主评价，10已完成，11取消，12已关闭
    NSInteger state = [self.model.state integerValue];
    if (state<=4) { //收货人信息加密
        self.receiptNameLab.text = [Utils changeName:self.model.receiveName];
        self.receiptNumerLab.text = [Utils changeMobile:self.model.receiveMobile];
    } else {
        self.receiptNameLab.text = self.model.receiveName;
        self.receiptNumerLab.text = self.model.receiveMobile;
    }
    if (state >= 7) {
        _receiptView.height = 120;
        _bgScroView.contentSize = CGSizeMake(0, _receiptView.bottom+10);
        [_commentImage1Btn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PIC_URL(),self.model.commentImage1]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"order_upload_icon_photo"]];
        [_commentImage2Btn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PIC_URL(),self.model.commentImage2]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"order_upload_icon_photo"]];
        [_commentImage3Btn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PIC_URL(),self.model.commentImage3]] forState:UIControlStateNormal
            placeholderImage:[UIImage imageNamed:@"order_upload_icon_photo"]];
        if (state == 7 || state == 8) {
            _commentImage1Btn.enabled = YES;
            _commentImage2Btn.enabled = YES;
            _commentImage3Btn.enabled = YES;
        }
    }
    switch (state) {
        case 1:
        case 2://待接单
            [self.bottomLeftBtn setTitle:@"拒绝接单" forState:UIControlStateNormal];
            [self.bottomRightBtn setTitle:@"立即接单" forState:UIControlStateNormal];
            break;
        case 3: //待确认
            [self.bottomLeftBtn setTitle:@"拒绝接单" forState:UIControlStateNormal];
            [self.bottomRightBtn setTitle:@"立即确认" forState:UIControlStateNormal];
            break;
        case 4: //待货主付款
            [self.bottomLeftBtn setTitle:@"取消接货" forState:UIControlStateNormal];
            [self.bottomRightBtn setTitle:@"等待货主支付" forState:UIControlStateNormal];
            self.bottomRightBtn.userInteractionEnabled = NO;
            break;
        case 5: //待接货
            [self.bottomLeftBtn setTitle:@"拒绝配送" forState:UIControlStateNormal];
            [self.bottomRightBtn setTitle:@"开始配送" forState:UIControlStateNormal];
            break;
        case 6: //待送达
            self.bottomBtn.hidden = NO;
            self.bottomLeftBtn.hidden = YES;
            self.bottomRightBtn.hidden = YES;
            [self.bottomBtn setTitle:@"我已送达" forState:UIControlStateNormal];
            break;
        case 7: //待货主确认收货
        case 8: //待回单收到确认
            self.bottomBtn.hidden = NO;
            self.bottomLeftBtn.hidden = YES;
            self.bottomRightBtn.hidden = YES;
            [self.bottomBtn setTitle:@"上传回执" forState:UIControlStateNormal];
            break;
        case 9: //待货主评价
        case 10: //已完成
        case 11: //已取消
        case 12: //已关闭
            self.orderStatusLab.hidden = YES;
            self.bottomView.hidden = YES;
            _bgScroView.height += 50;
            break;
        default:
            break;
    }
}

#pragma mark - methods

/** 打电话 */
- (IBAction)callPhone:(id)sender {
    if ([Utils isBlankString:self.model.sendMobile]) {
        [Utils showToast:@"电话号码是空号"];
        return;
    }
    [Utils call:self.model.sendMobile];
}

/** 聊天 */
- (IBAction)chatAction:(id)sender {
    [Utils showToast:@"功能暂未开通，敬请期待"];
}

- (IBAction)bottomLeftBtnAction:(UIButton *)sender {
    NSString *title = sender.titleLabel.text;
    if ([title isEqualToString:@"拒绝接单"]) {
        [self rejectOrder];
    }
    else if ([title isEqualToString:@"取消接货"]) {
         [self cancleReceiveGoodsOrder];
    }
    else if ([title isEqualToString:@"拒绝配送"]) {
        [self cancleDistributionOrder];
    }
}

- (IBAction)bottomRightBtnAction:(UIButton *)sender {
    NSString *title = sender.titleLabel.text;
    if ([title isEqualToString:@"立即接单"]) {
        if (![Utils isVerified]) {
            return;
        }
        [self receiveOrder];
    }
    else if ([title isEqualToString:@"立即确认"]) {
        [self confirmOrder];
    }
    else if([title isEqualToString:@"开始配送"]) {
         [self distributionOrder];
    }
}

- (IBAction)bottomBtnAction:(UIButton *)sender {
    NSString *title = sender.titleLabel.text;
    if ([title isEqualToString:@"我已送达"]) {
        [self completeDistributionOrder];
    }
    else if ([title isEqualToString:@"上传回执"]) {
        [self commentOrder];
    }
}

- (IBAction)showNav1Action:(UIButton *)sender {
    [XLGMapNavVC share].destionName = _model.sendAddress;
    [XLGMapNavVC startNavWithEndPt:CLLocationCoordinate2DMake([startLocDic[@"latitude"] floatValue], [startLocDic[@"longitude"] floatValue])];
}

- (IBAction)showNav2Action:(id)sender {
    [XLGMapNavVC share].destionName = _model.receiveAddress;
    [XLGMapNavVC startNavWithEndPt:CLLocationCoordinate2DMake([endLocDic[@"latitude"] floatValue], [endLocDic[@"longitude"] floatValue])];
}

/** 上传回执图片1 */
- (IBAction)uploadCommentImage1Action:(id)sender {
    self.photoType = 1;
    [self selectPhoto];
}

/** 上传回执图片2 */
- (IBAction)uploadCommentImage2Action:(id)sender {
    self.photoType = 2;
    [self selectPhoto];
}

/** 上传回执图片3 */
- (IBAction)uploadCommentImage3Action:(id)sender {
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
        [self.commentImage1Btn setImage:iconImage forState:UIControlStateNormal];
    }
    if (self.photoType == 2) {
        [self.commentImage2Btn setImage:iconImage forState:UIControlStateNormal];
    }
    if (self.photoType == 3) {
        [self.commentImage3Btn setImage:iconImage forState:UIControlStateNormal];
    }
    
    [picker dismissViewControllerAnimated:NO completion:^{
        NSData *imageData = UIImageJPEGRepresentation(iconImage, 0.1);
        NSMutableArray *imageDataArr = [NSMutableArray arrayWithObjects:imageData, nil];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"pigx",@"resourceId", nil];
        [[NetworkManager sharedManager] postJSON:URL_FileUpload parameters:dic imageDataArr:imageDataArr imageName:@"file" completion:^(id responseData, RequestState status, NSError *error) {
            
            if (status == Request_Success) {
                
                NSString *photo = responseData;
                if (self.photoType == 1) {
                    self.commentImage1Photo = photo;
                }
                if (self.photoType == 2) {
                    self.commentImage2Photo = photo;
                }
                if (self.photoType == 3) {
                    self.commentImage3Photo = photo;
                }
            }
        }];
    }];
}

#pragma mark - 回执评价
/** 回执评价 */
- (void)commentOrder {
    if ([NSString isEmpty:_commentImage1Photo]
        && [NSString isEmpty:_commentImage2Photo]
        && [NSString isEmpty:_commentImage3Photo]) {
        [Utils showToast:@"请上传回执图片"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_commentImage1Photo,@"commentImage1",
                         _commentImage2Photo,@"commentImage2",
                         _commentImage3Photo,@"commentImage3",
                         self.model.ID,@"id",nil];
    [[NetworkManager sharedManager] postJSON:URL_CommentOrder parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            [Utils showToast:@"上传回执成功"];
            [weakSelf pushOrderList];
        }
    }];
}

#pragma mark - 我已送达
/** 我已送达 */
- (void)completeDistributionOrder {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:[NSString stringWithFormat:@"%@/%@",URL_CompleteDistributionOrder,self.model.ID] parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            [Utils showToast:@"送达成功"];
            [weakSelf pushOrderList];
        }
    }];
}

#pragma mark - 拒绝接单
/** 拒绝接单 */
- (void)rejectOrder {
    __weak typeof(self) weakSelf = self;
        NSDictionary *dic = [NSDictionary dictionary];
        [[NetworkManager sharedManager] postJSON:[NSString stringWithFormat:@"%@/%@",URL_RefuseOrder,self.model.ID] parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
            if (status == Request_Success) {
                [Utils showToast:@"拒绝成功"];
                [weakSelf pushOrderList];
            }
        }];
}

#pragma mark - 接单
/** 接单 */
- (void)receiveOrder {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:[NSString stringWithFormat:@"%@/%@",URL_ReceiveOrder,self.model.ID] parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            [Utils showToast:@"接单成功"];
            [weakSelf pushOrderList];
        }
    }];
}

#pragma mark - 立即确认
/** 立即确认 */
- (void)confirmOrder {
    __weak typeof(self) weakSelf = self;
    if ([self.model.feeType integerValue]==2) {
        [Utils showToast:@"价格不可为电议 ，请联系货主修改！"];
        return;
    }
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:[NSString stringWithFormat:@"%@/%@",URL_ConfirmOrder,self.model.ID] parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            [Utils showToast:@"确认成功"];
            [weakSelf pushOrderList];
        }
    }];
}

#pragma mark - 取消接货
/** 取消接货 */
- (void)cancleReceiveGoodsOrder {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:[NSString stringWithFormat:@"%@/%@",URL_CancelReceiveOrder,self.model.ID] parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            [Utils showToast:@"取消接货成功"];
            [weakSelf pushOrderList];
        }
    }];
}

#pragma mark - 拒绝配送
/** 拒绝配送 */
- (void)cancleDistributionOrder {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:[NSString stringWithFormat:@"%@/%@",URL_CancelDistributionOrder,self.model.ID] parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            [Utils showToast:@"拒绝配送成功"];
            [weakSelf pushOrderList];
        }
    }];
}

#pragma mark - 开始配送
/** 开始配送 */
- (void)distributionOrder {
    
    JSOrderDistributionVC *vc = (JSOrderDistributionVC *)[Utils getViewController:@"Mine" WithVCName:@"JSOrderDistributionVC"];
    vc.orderID = self.model.ID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushOrderList {
    JSAllOrderVC *vc =(JSAllOrderVC *)[Utils getViewController:@"Mine" WithVCName:@"JSAllOrderVC"];
    [self.navigationController pushViewController:vc animated:YES];
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
