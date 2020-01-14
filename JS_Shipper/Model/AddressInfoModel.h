//
//  AddressInfoModel.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/5/29.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "BaseItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddressInfoModel : BaseItem
/** 地址 */
@property (nonatomic,copy) NSString *address; //浙江省宁波市江东区彩虹南路224
/** 地址名称 */
@property (nonatomic,copy) NSString *addressName; //白鹤,飞越广场,彩虹广场
/** 街道编码 */
@property (nonatomic,copy) NSString *streetCode;
/** 街道名字 */
@property (nonatomic,copy) NSString *street;
/** 纬度 */
@property (nonatomic,assign) CGFloat lat;
/** 经度 */
@property (nonatomic,assign) CGFloat lng;
/** 区域码 */
@property (nonatomic,copy) NSString *areaCode;
/** 姓名 */
@property (nonatomic,copy) NSString *name;
/** 手机号 */
@property (nonatomic,copy) NSString *phone;
/** 详细地址 */
@property (nonatomic,copy) NSString *detailAddress;
@end

NS_ASSUME_NONNULL_END
