//
//  CarModel.h
//  JS_Driver
//
//  Created by Jason_zyl on 2019/6/14.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "BaseItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface CarModel : BaseItem

/** 车辆照片 */
@property (nonatomic,copy) NSString *image2;
/** 车型ID */
@property (nonatomic,copy) NSString *carModelId;
/** 行驶证照片 */
@property (nonatomic,copy) NSString *image1;
/** 主键 */
@property (nonatomic,copy) NSString *ID;
/** 载货空间，单位立方米 */
@property (nonatomic,copy) NSString *capacityVolume;
/** 车牌号 */
@property (nonatomic,copy) NSString *cphm;
/** 载重千克位 */
@property (nonatomic,copy) NSString *capacityTonnage;
/** 车长 */
@property (nonatomic,copy) NSString *carLengthId;
/** 车辆状态，0待审核，1通过，2拒绝，3审核中 */
@property (nonatomic,copy) NSString *state;
/** 车辆状态中文 */
@property (nonatomic,copy) NSString *stateName;
/** 会员id */
@property (nonatomic,copy) NSString *subscriberId;
/** 车型中文 */
@property (nonatomic,copy) NSString *carModelName;
/** 车长中文 */
@property (nonatomic,copy) NSString *carLengthName;
/** 营运许可 */
@property (nonatomic,copy) NSString *tradingNo;
/** 运输许可 */
@property (nonatomic,copy) NSString *transportNo;

@end

NS_ASSUME_NONNULL_END
