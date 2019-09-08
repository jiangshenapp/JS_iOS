//
//  DriverModel.h
//  JS_Driver
//
//  Created by Jason_zyl on 2019/6/9.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "BaseItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface DriverModel : BaseItem

/**
 *{
 "driverLevel" : "A1",
 "driverName" : "1",
 "mobile" : "15737936517",
 "driverId" : 2
 }*/

/** 驾照类型 */
@property (nonatomic, copy) NSString              *driverLevel;
/** 姓名 */
@property (nonatomic, copy) NSString              *driverName;
/** 手机号 */
@property (nonatomic, copy) NSString              *mobile;
/** 驾照ID */
@property (nonatomic, copy) NSString              *driverId;
/** 手机号 */
@property (nonatomic, copy) NSString              *driverPhone;
/** 头像 */
@property (nonatomic, copy) NSString              *avatar;
/** 司机评分 */
@property (nonatomic, assign) NSInteger           score;

@end

NS_ASSUME_NONNULL_END
