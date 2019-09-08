//
//  ListOrderModel.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/6/3.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "BaseItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface ListOrderModel : BaseItem

#pragma mark - 订单列表字段

/** 订单号 12019052911380644265990155155748 */
@property  (nonatomic , copy) NSString *orderNo;
/** 货主端状态中文 */
@property  (nonatomic , copy) NSString *stateNameConsignor;
/** 司机端状态中文 */
@property  (nonatomic , copy) NSString *stateNameDriver;
/** 发货地址 */
@property  (nonatomic , copy) NSString *sendAddress;
/** 收货地地址 */
@property  (nonatomic , copy) NSString *receiveAddress;
/** 货物类型,字典表，多个 */
@property  (nonatomic , copy) NSString *goodsType;
/** 车长，多选，逗号分隔 */
@property  (nonatomic , copy) NSString *carLength;
/** 车长名称，多选，逗号分隔*/
@property  (nonatomic , copy) NSString *carLengthName;
/** 货物体积，单位立方米 */
@property  (nonatomic , copy) NSString *goodsVolume;
/** 货物重量、吨 */
@property  (nonatomic , copy) NSString *goodsWeight;
/** 运费 */
@property  (nonatomic , copy) NSString *fee;
/** 货物名称 */
@property  (nonatomic , copy) NSString *goodsName;
/** 包装类型 */
@property  (nonatomic , copy) NSString *packType;
/** 是否需要保证金 0否 1是 */
@property  (nonatomic , copy) NSString *requireDeposit;
/** 保证金 默认0 */
@property  (nonatomic , copy) NSString *deposit;

#pragma mark - 详情字段
/** 接单司机/网点头像 */
@property  (nonatomic , copy) NSString *driverAvatar;
/** 接单司机名字 */
@property  (nonatomic , copy) NSString *driverName;
/** 接单司机/网点手机号 */
@property  (nonatomic , copy) NSString *driverPhone;
/** 通知司机数 */
@property  (nonatomic , copy) NSString *driverNum;
/** 接单网点名字 */
@property  (nonatomic , copy) NSString *dotName;
/** 车型中文 */
@property  (nonatomic , copy) NSString *carModelName;
/** 回执图片1 */
@property  (nonatomic , copy) NSString *commentImage1;
/** 回执图片2 */
@property  (nonatomic , copy) NSString *commentImage2;
/** 回执图片3 */
@property  (nonatomic , copy) NSString *commentImage3;
/** 接单会员Id */
@property  (nonatomic , copy) NSString *jdSubscriberId;
/** 收货地坐标 */
@property  (nonatomic , copy) NSString *receivePosition;
/** 发货人手机号 */
@property  (nonatomic , copy) NSString *sendMobile;
/** 收货人手机号 */
@property  (nonatomic , copy) NSString *receiveMobile;
/** 订单ID */
@property  (nonatomic , copy) NSString *ID;
/** 图片2 */
@property  (nonatomic , copy) NSString *image2;
/** 付款时间 */
@property  (nonatomic , copy) NSString *payTime;
/** 状态 0全部 货主端： (1发布中，2待司机接单，3待司机确认，4待支付，5待司机接货, 6待收货，7待确认收货，8待回单收到确认，9待评价，10已完成，11已取消，12已关闭） 司机端：（2待接单，3待确认，4待货主付款，5待接货, 6待送达，7待确认收货，8待回单收到确认，9待货主评价，10已完成，11取消，12已关闭）后台（1发布中，2待接单，3待司机确认，4待货主支付，5待司机接货, 6待货主收货，7待货主确认收货，8待回单收到确认，9待评价，10已完成，11已取消，12已关闭）*/
@property  (nonatomic , copy) NSString *state;
/** 订单完成时间 */
@property  (nonatomic , copy) NSString *finishTime;
/** 支付方式，1线上支付，2线下支付 */
@property  (nonatomic , copy) NSString *payWay;
/** 图片1 */
@property  (nonatomic , copy) NSString *image1;
/** 匹配状态，1匹配，0未匹配 */
@property  (nonatomic , copy) NSString *matchState;
/** 备注 */
@property  (nonatomic , copy) NSString *remark;
/** 付款方式，1到付，2现付 */
@property  (nonatomic , copy) NSString *payType;
/** 发布人 */
@property  (nonatomic , copy) NSString *createBy;
/** 发货地区域代码 */
@property  (nonatomic , copy) NSString *sendAddressCode;
/** 运费类型，1自己出价，2电议 */
@property  (nonatomic , copy) NSString *feeType;
/** 装货时间 */
@property  (nonatomic , copy) NSString *loadingTime;
/** 司机id */
@property  (nonatomic , copy) NSString *driverId;
/** 发货地坐标 */
@property  (nonatomic , copy) NSString *sendPosition;
/** 收货地区域代码 */
@property  (nonatomic , copy) NSString *receiveAddressCode;
/** 配送时间 */
@property  (nonatomic , copy) NSString *transferTime;
/** 发货人姓名 */
@property  (nonatomic , copy) NSString *sendName;
/** 发布时间 2019-05-29 11:38:06 */
@property  (nonatomic , copy) NSString *createTime;
/** 收货人 */
@property  (nonatomic , copy) NSString *receiveName;
/** 匹配会员id */
@property  (nonatomic , copy) NSString *matchSubscriberId;
/** 用车类型，字典 */
@property  (nonatomic , copy) NSString *useCarType;
/** 用车类型名称 */
@property  (nonatomic , copy) NSString *useCarTypeName;
/** 车型，多选，逗号分隔 */
@property  (nonatomic , copy) NSString *carModel;
/** 司机评分 */
@property  (nonatomic , assign) NSInteger score;

@end

NS_ASSUME_NONNULL_END
