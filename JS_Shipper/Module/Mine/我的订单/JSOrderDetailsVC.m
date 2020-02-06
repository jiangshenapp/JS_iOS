//
//  JSOrderDetailsVC.m
//  JS_Shipper
//
//  Created by Jason_zyl on 2019/6/4.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSOrderDetailsVC.h"
#import "JSOrderDetailMapVC.h"
#import "JSPayVC.h"
#import "JSChangeOrderDetailVC.h"
#import "JSDeliverConfirmVC.h"
#import "CZCommentView.h"
#import "CustomEaseUtils.h"

@interface JSOrderDetailsVC ()

/** 修改按钮 */
@property (nonatomic,retain) UIButton *changeBtn;
/** 评价视图 */
@property (nonatomic,retain) CZCommentView *commentView;

/** 订单model */
@property (nonatomic,retain) ListOrderModel *model;

@end

@implementation JSOrderDetailsVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单详情";
    
    self.changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [self.changeBtn setTitle:@"修改" forState:UIControlStateNormal];
    [self.changeBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
    self.changeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.changeBtn addTarget:self action:@selector(changeOrderInfo) forControlEvents:UIControlEventTouchUpInside];
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.changeBtn];
    
    _bgScroView.contentSize = CGSizeMake(0, _otherInfoView.bottom+50);
    self.tileView1.hidden = YES;
    self.titleView2.hidden = NO;
}

#pragma mark - get data
- (void)getData {
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:[NSString stringWithFormat:@"%@/%@",URL_GetOrderDetail,self.orderID] parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            //将用户信息解析成model
            self.model = [ListOrderModel mj_objectWithKeyValues:(NSDictionary *)responseData];
            [self initView];
            [self initData];
        }
    }];
}

#pragma mark - init data
- (void)initData {
    
    [self.headImgView2 sd_setImageWithURL:[NSURL URLWithString:self.model.driverAvatar] placeholderImage:[UIImage imageNamed:@"personalcenter_driver_icon_head_land"]];
    self.nameLab.text = self.model.driverName;
    [self.nameLab sizeToFit];
    self.nameLab.height = 20;
    self.starView.left = self.nameLab.right+5;
    self.starView.starScore = self.model.score;
    self.introduceLab.text = self.model.driverPhone;
    self.orderNoLab.text = [NSString stringWithFormat:@"订单编号：%@",self.model.orderNo];
    self.orderStatusLab.text = self.model.stateNameConsignor;
    self.startAddressLab.text = self.model.sendAddress;
    self.endAddressLab.text = self.model.receiveAddress;
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
        info = [info stringByAppendingString:[NSString stringWithFormat:@"/%@千克",self.model.goodsWeight]];
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
    if ([self.model.payType isEqualToString:@"1"]) {
        self.goodsPayTypeLab.text = @"到付";
    } else {
        self.goodsPayTypeLab.text = @"现付";
    }
    if ([self.model.useCarType isEqualToString:@"2"]) { //零担
        self.orderFeeLab.text = [NSString stringWithFormat:@"¥%.2f",[self.model.fee floatValue]];
    } else { //整车
        if ([self.model.feeType isEqualToString:@"1"]) {
            self.orderFeeLab.text = [NSString stringWithFormat:@"¥%.2f",[self.model.fee floatValue]];
        } else {
            self.orderFeeLab.text = @"电议";
        }
    }
    self.depositLab.text = [NSString stringWithFormat:@"￥%@",self.model.deposit];
    self.explainLab.text = self.model.remark;
    self.receiptNameLab.text = self.model.receiveName;
    self.receiptNumerLab.text = self.model.receiveMobile;
}

#pragma mark - init view
- (void)initView {
    
    //1发布中，2待司机接单，3待司机确认，4待支付，5待司机接货, 6待收货，7待确认收货，8待回单收到确认，9待评价，10已完成，11已取消，12已关闭
    NSInteger state = [self.model.state integerValue];
    if (state == 3 || state == 4) { //待司机确认，修改支付信息、收货人信息；待支付，修改收货人信息；
        [self.changeBtn setTitle:@"修改" forState:UIControlStateNormal];
    } else {
        [self.changeBtn setTitle:@"再发一次" forState:UIControlStateNormal];
    }
    if (state == 1 || state == 2) {
        self.tileView1.hidden = NO;
        self.titleView2.hidden = YES;
        self.bookTimeLab.text = [NSString stringWithFormat:@"已为您通知%@个司机",self.model.driverNum];
    } else {
        if (![Utils isBlankString:self.model.dotName]) {
            self.tileView1.hidden = NO;
            self.titleView2.hidden = YES;
            [self.headImgView1 sd_setImageWithURL:[NSURL URLWithString:self.model.driverAvatar] placeholderImage:[UIImage imageNamed:@"personalcenter_driver_icon_head_land"]];
            self.bookTimeLab.text = self.model.dotName;
        }
    }
    if (state >= 8 && ![NSString isEmpty:self.model.commentImage1]) {
        _receiptView.height = 120;
        _bgScroView.contentSize = CGSizeMake(0, _receiptView.bottom+10);
        [_commentImage1Btn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PIC_URL(),self.model.commentImage1]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"order_upload_icon_photo"]];
        [_commentImage2Btn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PIC_URL(),self.model.commentImage2]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"order_upload_icon_photo"]];
        [_commentImage3Btn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PIC_URL(),self.model.commentImage3]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"order_upload_icon_photo"]];
    } else {
        _receiptView.height = 0;
        _bgScroView.contentSize = CGSizeMake(0, _receiptView.bottom+10);
    }
    switch (state) {
        case 1:
        case 2:
            [self.bottomLeftBtn setTitle:@"取消发布" forState:UIControlStateNormal];
            [self.bottomRightBtn setTitle:@"再发一次" forState:UIControlStateNormal];
            break;
        case 3: //车主待确认
            [self.bottomLeftBtn setTitle:@"取消发布" forState:UIControlStateNormal];
            [self.bottomRightBtn setTitle:@"立即支付" forState:UIControlStateNormal];
            self.bottomRightBtn.userInteractionEnabled = NO;
            self.bottomRightBtn.backgroundColor = RGBValue(0xB4B4B4);
            break;
        case 4: //车主已确认，待支付
            [self.bottomLeftBtn setTitle:@"取消发布" forState:UIControlStateNormal];
            [self.bottomRightBtn setTitle:@"立即支付" forState:UIControlStateNormal];
            break;
        case 5: //待配送
            self.bottomBtn.hidden = NO;
            self.bottomLeftBtn.hidden = YES;
            self.bottomRightBtn.hidden = YES;
            [self.bottomBtn setTitle:@"取消发货" forState:UIControlStateNormal];
            break;
        case 6: //运输中，待收货
        case 7: //待确认收货
            [self.bottomLeftBtn setTitle:@"查看路线" forState:UIControlStateNormal];
            [self.bottomRightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            break;
        case 8: //待回单收到确认
            [self.bottomLeftBtn setTitle:@"查看路线" forState:UIControlStateNormal];
            [self.bottomRightBtn setTitle:@"回单收到确认" forState:UIControlStateNormal];
            break;
        case 9: //待评价
            [self.bottomLeftBtn setTitle:@"查看路线" forState:UIControlStateNormal];
            [self.bottomRightBtn setTitle:@"评价" forState:UIControlStateNormal];
            break;
        case 10: //已完成
            self.orderStatusLab.hidden = YES;
            [self.bottomLeftBtn setTitle:@"查看路线" forState:UIControlStateNormal];
            [self.bottomRightBtn setTitle:@"重新发货" forState:UIControlStateNormal];
            break;
        case 11: //已取消
            self.bottomBtn.hidden = NO;
            self.bottomLeftBtn.hidden = YES;
            self.bottomRightBtn.hidden = YES;
            [self.bottomBtn setTitle:@"重新发货" forState:UIControlStateNormal];
            break;
        case 12: //已关闭
            
            break;
        default:
            break;
    }
}

#pragma mark - methods

/** 返回 */
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 修改/再发一次
/** 修改订单信息 */
- (void)changeOrderInfo {
    if ([self.changeBtn.titleLabel.text isEqualToString:@"修改"]) {
        JSChangeOrderDetailVC *vc = (JSChangeOrderDetailVC *)[Utils getViewController:@"Mine" WithVCName:@"JSChangeOrderDetailVC"];
        vc.model = self.model;
        [self.navigationController pushViewController:vc animated:YES];
    } else { //再发一次
        [self againPublishOrder];
    }
}

/** 打电话 */
- (IBAction)callPhone:(id)sender {
    if (![Utils isVerified]) {
        return;
    }
    if ([Utils isBlankString:self.model.driverPhone]) {
        [Utils showToast:@"电话号码是空号"];
        return;
    }
    [Utils call:self.model.driverPhone];
}

/** 聊天 */
- (IBAction)chatAction:(id)sender {
    if (![Utils isVerified]) {
        return;
    }
    if ([Utils isBlankString:self.model.driverPhone]) {
        [Utils showToast:@"电话号码是空号"];
        return;
    }
    NSString *chatID = [NSString stringWithFormat:@"driver%@",self.model.driverPhone];
    [CustomEaseUtils EaseChatConversationID:chatID];
}

- (IBAction)bottomLeftBtnAction:(UIButton *)sender {
    NSString *title = sender.titleLabel.text;
    if ([title isEqualToString:@"取消发布"]) {
        [self cancleOrder];
    }
    if ([title isEqualToString:@"查看路线"]) {
        [self showRoutOrder];
    }
}

- (IBAction)bottomRightBtnAction:(UIButton *)sender {
    NSString *title = sender.titleLabel.text;
    if ([title isEqualToString:@"再发一次"]) {
        [self againPublishOrder];
    }
    if ([title isEqualToString:@"立即支付"]) {
        [self payOrder];
    }
    if ([title isEqualToString:@"确认收货"]) {
        [self confirmGoodsOrder];
    }
    if ([title isEqualToString:@"回单收到确认"]) {
        [self comfirmReceiptOrder];
    }
    if ([title isEqualToString:@"评价"]) {
        [self commentOrder];
    }
    if ([title isEqualToString:@"重新发货"]) {
        [self againPublishOrder];
    }
}

- (IBAction)bottomBtnAction:(UIButton *)sender {
    NSString *title = sender.titleLabel.text;
    if ([title isEqualToString:@"取消发货"]) {
        [self cancleOrder];
    }
    if ([title isEqualToString:@"重新发货"]) {
        [self againPublishOrder];
    }
}

#pragma mark - 取消订单
/** 取消订单 */
- (void)cancleOrder {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:[NSString stringWithFormat:@"%@/%@",URL_CancelOrderDetail,self.model.ID] parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            [Utils showToast:@"订单取消成功"];
            [weakSelf.navigationController popToRootViewControllerAnimated:NO];
        }
    }];
}

#pragma mark - 再发一次/重新发货
/** 再发一次/重新发货 */
- (void)againPublishOrder {
    if (![Utils isVerified]) {
        return;
    }
    JSDeliverConfirmVC *vc = (JSDeliverConfirmVC *)[Utils getViewController:@"DeliverGoods" WithVCName:@"JSDeliverConfirmVC"];
    vc.isAll = YES;
    vc.model = self.model;
    if (![Utils isBlankString:self.model.matchSubscriberId]
        && ![self.model.matchSubscriberId isEqualToString:@"0"]) {
        vc.subscriberId = self.model.matchSubscriberId;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 评价
/** 评价 */
- (void)commentOrder {
    _commentView = [[CZCommentView alloc] initWithFrame:CGRectZero];;
    [self.view addSubview:_commentView];
    [_commentView showView];
    __weak typeof(self) weakSelf = self;
    _commentView.submitBlock = ^(NSString *score) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:score,@"score", nil];
        [[NetworkManager sharedManager] postJSON:[NSString stringWithFormat:@"%@/%@",URL_OrderComment,weakSelf.model.ID] parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
            if (status == Request_Success) {
                [Utils showToast:@"感谢您的评价！"];
                [weakSelf.commentView hiddenView];
                [weakSelf.navigationController popToRootViewControllerAnimated:NO];
            }
        }];
    };
}

#pragma mark - 确认收货
/** 确认收货 */
- (void)confirmGoodsOrder {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:[NSString stringWithFormat:@"%@/%@",URL_ConfirmOrder,self.model.ID] parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            [Utils showToast:@"确认收货成功"];
            [weakSelf.navigationController popToRootViewControllerAnimated:NO];
        }
    }];
}

#pragma mark - 回单收到确认
/** 回单收到确认 */
- (void)comfirmReceiptOrder {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:[NSString stringWithFormat:@"%@/%@",URL_ConfirmOrderReceipt,self.model.ID] parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            [Utils showToast:@"回执订单已确认"];
            [weakSelf.navigationController popToRootViewControllerAnimated:NO];
        }
    }];
}

#pragma mark - 立即支付
/** 立即支付 */
- (void)payOrder {
    JSPayVC *vc = (JSPayVC *)[Utils getViewController:@"Mine" WithVCName:@"JSPayVC"];
    vc.orderID  = [NSString stringWithFormat:@"%@",self.model.orderNo];
    vc.price = [NSString stringWithFormat:@"%@",self.model.fee];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 查看路线
/** 查看路线 */
- (void)showRoutOrder {
    [Utils showToast:@"功能暂未开通，敬请期待"];
//    JSOrderDetailMapVC *vc = (JSOrderDetailMapVC *)[Utils getViewController:@"Mine" WithVCName:@"JSOrderDetailMapVC"];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)commentImage1Btn:(id)sender {
    
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
