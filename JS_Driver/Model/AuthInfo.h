//
//  AuthInfo.h
//  JS_Driver
//
//  Created by Jason_zyl on 2019/5/12.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "BaseItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface AuthInfo : BaseItem

/* 司机认证 */
@property (nonatomic,copy) NSString *idImage; //身份证正面
@property (nonatomic,copy) NSString *idBackImage; //身份证反面
@property (nonatomic,copy) NSString *idHandImage; //手持身份证
@property (nonatomic,copy) NSString *driverImage;
    //驾驶证
@property (nonatomic,copy) NSString *cyzgzImage;
    //司机从业资格证
@property (nonatomic,copy) NSString *driverLevel; //驾驶证类别
@property (nonatomic,copy) NSString *personName; //名字
@property (nonatomic,copy) NSString *address; //地址
@property (nonatomic,copy) NSString *idCode; //身份证
@property (nonatomic,copy) NSString *auditState; //认证状态

/* 园区认证 */
@property (nonatomic,copy) NSString *registrationNumber; //证件号码
@property (nonatomic,copy) NSString *businessLicenceImage; //营业执照
@property (nonatomic,copy) NSString *companyName; //公司名称
@property (nonatomic,copy) NSString *companyType; //机构类型
@property (nonatomic,copy) NSString *detailAddress; //详细地址


/** <#object#> */
@property (nonatomic,copy) NSString *image1;
@property (nonatomic,copy) NSString *image2;

@property (nonatomic,copy) NSString *image3;
@property (nonatomic,copy) NSString *image4;
/** <#object#> */
@property (nonatomic,copy) NSString *contactLocation;
/** <#object#> */
@property (nonatomic,copy) NSString *contractPhone;
/** <#object#> */
@property (nonatomic,copy) NSString *contactName;
/** <#object#> */
@property (nonatomic,copy) NSString *contactAddress;

@end

NS_ASSUME_NONNULL_END
