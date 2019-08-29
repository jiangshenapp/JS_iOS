//
//  JSBaseOrderDetaileVC.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/29.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSBaseOrderDetailsVC : BaseVC

@property (weak, nonatomic) IBOutlet UIScrollView *bgScroView;
/** 预约N分钟视图 */
@property (weak, nonatomic) IBOutlet UIView *tileView1;
/** 张女士视图 */
@property (weak, nonatomic) IBOutlet UIView *titleView2;
/** 预约N分钟 */
@property (weak, nonatomic) IBOutlet UILabel *bookTimeLab;
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
/** 获物类型 */
@property (weak, nonatomic) IBOutlet UILabel *goodsTypeLab;
/** 用车类型 */
@property (weak, nonatomic) IBOutlet UILabel *carTypeLab;
/** 支付方式 */
@property (weak, nonatomic) IBOutlet UILabel *payTypeLab;
/** 运费 */
@property (weak, nonatomic) IBOutlet UILabel *orderFeeLab;
/** 付款方式 */
@property (weak, nonatomic) IBOutlet UILabel *goodsPayTypeLab;
/** 简介说明 */
@property (weak, nonatomic) IBOutlet UILabel *explainLab;
/** 收件人姓名 */
@property (weak, nonatomic) IBOutlet UILabel *receiptNameLab;
/** 收件人电话 */
@property (weak, nonatomic) IBOutlet UILabel *receiptNumerLab;
@property (weak, nonatomic) IBOutlet UIView *receiptView;

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
