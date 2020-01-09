//
//  JsTransportModel.h
//  JS_Shipper
//
//  Created by zhanbing han on 2020/1/9.
//  Copyright © 2020 zhanbing han. All rights reserved.
//

#import "BaseItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSTransportModel : BaseItem
/** 车辆id */
@property (nonatomic,copy) NSString *carId;
/** 车辆id */
@property (nonatomic,copy) NSString *carLengthId;
/** 车辆id */
@property (nonatomic,copy) NSString *carLengthName;
/** 车辆id */
@property (nonatomic,copy) NSString *carModelId;
/** 车辆id */
@property (nonatomic,copy) NSString *carModelName;
/** 车辆id */
@property (nonatomic,copy) NSString *cphm;
/** 车辆id */
@property (nonatomic,copy) NSString *mobile;
/** 车辆id */
@property (nonatomic,copy) NSString *nickName;
/** 车辆id */
@property (nonatomic,copy) NSString *subscriberId;
/** 车辆id */
@property (nonatomic,copy) NSString *type;
/** 是否添加过 */
@property (nonatomic,copy) NSString *added;
/** 合作次数 */
@property (nonatomic,copy) NSString *cooperated;
/** <#object#> */
@property (nonatomic,copy) NSString *remark;
@end

NS_ASSUME_NONNULL_END
