//
//  JSOrderDetailsVC.h
//  JS_Shipper
//
//  Created by Jason_zyl on 2019/6/4.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "BaseVC.h"
#import "ListOrderModel.h"
#import "YYStarView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSOrderDetailsVC : BaseVC

/** 订单编号 */
@property (nonatomic,copy) NSString *orderID;

@property (weak, nonatomic) IBOutlet YYStarView *starView;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScroView;
/** 预约N分钟视图 */
@property (weak, nonatomic) IBOutlet UIView *tileView1;
/** 张女士视图 */
@property (weak, nonatomic) IBOutlet UIView *titleView2;
/** 头像1 */
@property (weak, nonatomic) IBOutlet UIImageView *headImgView1;
/** 预约N分钟 */
@property (weak, nonatomic) IBOutlet UILabel *bookTimeLab;
/** 头像2 */
@property (weak, nonatomic) IBOutlet UIImageView *headImgView2;
/** 姓名 */
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
/** 介绍文字 */
@property (weak, nonatomic) IBOutlet UILabel *introduceLab;
/** 打电话 */
@property (weak, nonatomic) IBOutlet UIButton *iphoneBtn;
/** 发送消息 */
@property (weak, nonatomic) IBOutlet UIButton *sendMSgBtn;
/** 订单号 */
@property (weak, nonatomic) IBOutlet UILabel *orderNoLab;
/** 订单状态 */
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLab;
/** 起止点 */
@property (weak, nonatomic) IBOutlet UILabel *startAddressLab;
/** 终止点 */
@property (weak, nonatomic) IBOutlet UILabel *endAddressLab;
/** 装货时间 */
@property (weak, nonatomic) IBOutlet UILabel *goodsTomeLab;
/** 车辆信息 */
@property (weak, nonatomic) IBOutlet UILabel *carInfoLab;
/** 获物名称 */
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLab;
/** 用车类型 */
@property (weak, nonatomic) IBOutlet UILabel *carTypeLab;
/** 包装类型 */
@property (weak, nonatomic) IBOutlet UILabel *goodsPackTypeLab;

/** 支付方式 */
@property (weak, nonatomic) IBOutlet UILabel *payTypeLab;
/** 运费 */
@property (weak, nonatomic) IBOutlet UILabel *orderFeeLab;
/** 付款方式 */
@property (weak, nonatomic) IBOutlet UILabel *goodsPayTypeLab;
/** 保证金 */
@property (weak, nonatomic) IBOutlet UILabel *depositLab;
/** 简介说明 */
@property (weak, nonatomic) IBOutlet UILabel *explainLab;
/** 收件人姓名 */
@property (weak, nonatomic) IBOutlet UILabel *receiptNameLab;
/** 收件人电话 */
@property (weak, nonatomic) IBOutlet UILabel *receiptNumerLab;
@property (weak, nonatomic) IBOutlet UIView *otherInfoView;
@property (weak, nonatomic) IBOutlet UIView *receiptView;
@property (weak, nonatomic) IBOutlet UIButton *commentImage1Btn;
@property (weak, nonatomic) IBOutlet UIButton *commentImage2Btn;
@property (weak, nonatomic) IBOutlet UIButton *commentImage3Btn;

/** 底部左按钮 */
@property (weak, nonatomic) IBOutlet UIButton *bottomLeftBtn;
/** 底部右按钮 */
@property (weak, nonatomic) IBOutlet UIButton *bottomRightBtn;
/** 底部按钮 */
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;

- (IBAction)bottomLeftBtnAction:(UIButton *)sender;
- (IBAction)bottomRightBtnAction:(UIButton *)sender;
- (IBAction)bottomBtnAction:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
