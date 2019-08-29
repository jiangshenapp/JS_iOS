//
//  RouteModel.h
//  JS_Driver
//
//  Created by Jason_zyl on 2019/6/14.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "BaseItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface RouteModel : BaseItem

/**
 * {
 "id" : 12,
 "state" : 0,
 "cphm" : "",
 "driverPhone" : "15737936517",
 "classic" : 2,
 "carLengthName" : "1.5米",
 "startAddressCodeName" : "北京市北京市大兴区",
 "carLength" : "1.5",
 "carModel" : "1",
 "carModelName" : "卡车",
 "subscriberId" : 2,
 "remark" : "简介",
 "arriveAddressCodeName" : "上海市上海市普陀区",
 "driverName" : "1",
 "classicName" : "审核中",
 "arriveAddressCode" : "310107",
 "startAddressCode" : "110115"
 }
 */

@property (nonatomic, copy) NSString *ID;
/** 状态，0未启用，1启用 */
@property (nonatomic, copy) NSString *state;
/** 车牌号码 */
@property (nonatomic, copy) NSString *cphm;
@property (nonatomic, copy) NSString *driverPhone;
/** 是否精品路线，1是，0否，2审核中 */
@property (nonatomic, copy) NSString *classic;
@property (nonatomic, copy) NSString *carLengthName;
@property (nonatomic, copy) NSString *startAddressCodeName;
@property (nonatomic, copy) NSString *carLength;
@property (nonatomic, copy) NSString *carModel;
@property (nonatomic, copy) NSString *carModelName;
/** 备注 */
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *arriveAddressCodeName;
@property (nonatomic, copy) NSString *driverName;
/** 精品线路审核状态中文 */
@property (nonatomic, copy) NSString *classicName;
@property (nonatomic, copy) NSString *arriveAddressCode;
@property (nonatomic, copy) NSString *startAddressCode;

@end

NS_ASSUME_NONNULL_END
