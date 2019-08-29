//
//  OrderInfoModel.h
//  JS_Driver
//
//  Created by zhanbing han on 2019/6/11.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "BaseItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderInfoModel : BaseItem
/**  */
@property  (nonatomic , copy) NSString *jdSubscriberId;
/** 23 */
@property  (nonatomic , copy) NSString *goodsType;
/** hzb */
@property  (nonatomic , copy) NSString *receivePosition;
/**  */
@property  (nonatomic , copy) NSString *sendMobile;
/** 2222222 */
@property  (nonatomic , copy) NSString *receiveMobile;
/** 待接单 */
@property  (nonatomic , copy) NSString *stateNameDriver;
/** c9e95f3fabe1439e98d144d554b54c02.png */
@property  (nonatomic , copy) NSString *image2;
/**  */
@property  (nonatomic , copy) NSString *commentImage3;
/**  */
@property  (nonatomic , copy) NSString *payTime;
/** 状态 0全部 货主端： (1发布中，2待司机接单，3待司机确认，4待支付，5待司机接货, 6待收货，7待确认收货，8待回单收到确认，9待评价，10已完成，11已取消，12已关闭） 司机端：（2待接单，3待确认，4待货主付款，5待接货, 6待送达，7待确认收货，8待回单收到确认，9待货主评价，10已完成，11取消，12已关闭）*/
@property  (nonatomic , copy) NSString *state;
/** 72 */
@property  (nonatomic , copy) NSString *ID;
/**  */
@property  (nonatomic , copy) NSString *goodsWeight;
/** 1dd0dafe0b194746be25cf864d61de02.png */
@property  (nonatomic , copy) NSString *image1;
/** 0 */
@property  (nonatomic , copy) NSString *matchState;
/**  */
@property  (nonatomic , copy) NSString *finishTime;
/** 1 */
@property  (nonatomic , copy) NSString *payWay;
/** Eeee */
@property  (nonatomic , copy) NSString *remark;
/** 4 */
@property  (nonatomic , copy) NSString *goodsVolume;
/** 待司机接单 */
@property  (nonatomic , copy) NSString *stateNameConsignor;
/**  */
@property  (nonatomic , copy) NSString *carModelName;
/** 1 */
@property  (nonatomic , copy) NSString *payType;
/**  */
@property  (nonatomic , copy) NSString *commentImage1;
/** 家用 */
@property  (nonatomic , copy) NSString *useCarTypeName;
/** 浙江省宁波市海曙区 */
@property  (nonatomic , copy) NSString *sendAddressCodeName;
/**  */
@property  (nonatomic , copy) NSString *carLengthName;
/**  */
@property  (nonatomic , copy) NSString *carLength;
/** 2 */
@property  (nonatomic , copy) NSString *createBy;
/** 330203 */
@property  (nonatomic , copy) NSString *sendAddressCode;
/** 1 */
@property  (nonatomic , copy) NSString *feeType;
/** 浙江省宁波市海曙区 */
@property  (nonatomic , copy) NSString *receiveAddressCodeName;
/** 23 */
@property  (nonatomic , copy) NSString *fee;
/** {"longitude":121.56010742127657,"latitude":29.872025407820871} */
@property  (nonatomic , copy) NSString *sendPosition;
/**  */
@property  (nonatomic , copy) NSString *sendName;
/** 2019-06-14 14:52:00 */
@property  (nonatomic , copy) NSString *loadingTime;
/** 浙江省宁波市海曙区碶闸街25弄3 */
@property  (nonatomic , copy) NSString *sendAddress;
/** 2019-06-11 14:52:32 */
@property  (nonatomic , copy) NSString *createTime;
/** 330203 */
@property  (nonatomic , copy) NSString *receiveAddressCode;
/**  */
@property  (nonatomic , copy) NSString *driverId;
/**  */
@property  (nonatomic , copy) NSString *transferTime;
/** 浙江省宁波市海曙区江东南路339号 */
@property  (nonatomic , copy) NSString *receiveAddress;
/** 33201906111452315640 */
@property  (nonatomic , copy) NSString *orderNo;
/**  */
@property  (nonatomic , copy) NSString *receiveName;
/** 0 */
@property  (nonatomic , copy) NSString *matchSubscriberId;
/**  */
@property  (nonatomic , copy) NSString *commentImage2;
/** 1 */
@property  (nonatomic , copy) NSString *useCarType;
/**  */
@property  (nonatomic , copy) NSString *goodsTypeName;
/**  */
@property  (nonatomic , copy) NSString *carModel;

/** 货物名称 */
@property  (nonatomic , copy) NSString *goodsName;
/** 包装类型 */
@property  (nonatomic , copy) NSString *packType;
/** 是否需要保证金 0否 1是 */
@property  (nonatomic , copy) NSString *requireDeposit;
/** 保证金 默认0 */
@property  (nonatomic , copy) NSString *deposit;

@end

NS_ASSUME_NONNULL_END
