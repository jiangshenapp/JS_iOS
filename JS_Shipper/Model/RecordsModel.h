//
//  RecordsModel.h
//  JS_Shipper
//
//  Created by Jason_zyl on 2019/6/18.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "BaseItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecordsModel : BaseItem

@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *state;
@property (nonatomic,copy) NSString *cphm;
@property (nonatomic,copy) NSString *driverPhone;
@property (nonatomic,copy) NSString *classic;
@property (nonatomic,copy) NSString *carModel;
@property (nonatomic,copy) NSString *carModelName;
@property (nonatomic,copy) NSString *carLength;
@property (nonatomic,copy) NSString *carLengthName;
@property (nonatomic,copy) NSString *subscriberId;
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,copy) NSString *driverName;
@property (nonatomic,copy) NSString *arriveAddressCode;
@property (nonatomic,copy) NSString *startAddressCode;
@property (nonatomic,copy) NSString *startAddressCodeName;
/** 生效时间 */
@property (nonatomic,copy) NSString *enableTime;
/** arriveAddressCodeName */
@property (nonatomic,copy) NSString *arriveAddressCodeName;
/** receiveAddressCodeName */
@property (nonatomic,copy) NSString *receiveAddressCodeName;
@property (nonatomic,copy) NSString *isCollect;
/** 联系人 */
@property (nonatomic,copy) NSString *contactName;
/** 联系电话 */
@property (nonatomic,copy) NSString *contractPhone;
/** 联系地址 */
@property (nonatomic,copy) NSString *contactAddress;
/** 详细地址 */
@property (nonatomic,copy) NSString *detailAddress;
/** businessLicenceImage */
@property (nonatomic,copy) NSString *businessLicenceImage;
/** 园区经纬度 */
@property (nonatomic,copy) NSString *contactLocation;
@property (nonatomic,copy) NSString *image1;
@property (nonatomic,copy) NSString *image2;
@property (nonatomic,copy) NSString *image3;
@property (nonatomic,copy) NSString *image4;
/** 机构名称 */
@property (nonatomic,copy) NSString *companyName;
/** 机构类型 1服务中心，2车代点，3网点 */
@property (nonatomic,copy) NSString *companyType;
/** YES、展开 NO、隐藏 */
@property (nonatomic,assign) BOOL showFlag;

@end

NS_ASSUME_NONNULL_END
