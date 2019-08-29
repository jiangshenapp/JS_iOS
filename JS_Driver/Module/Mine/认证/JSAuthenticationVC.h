//
//  JSAuthenticationVC.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/26.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSAuthenticationVC : BaseVC

/** 0司机认证  1园区网点认证 */
@property (nonatomic,assign) NSInteger type;
/** 认证状态 */
@property (weak, nonatomic) IBOutlet UILabel *authStateLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *authStateLabH;

/* 司机 */
@property (weak, nonatomic) IBOutlet UIButton *idCardFrontBtn;
@property (weak, nonatomic) IBOutlet UIButton *idCardHandBtn;
@property (weak, nonatomic) IBOutlet UIButton *driverLicenceBtn;
@property (weak, nonatomic) IBOutlet UIButton *driverWorkBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *idCardTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UITextField *driverLicenceTypeTF;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
@property (weak, nonatomic) IBOutlet UIButton *driverLicenceTypeBtn;

@property (weak, nonatomic) IBOutlet UITableView *driverTabView;
@property (weak, nonatomic) IBOutlet UITableView *parkTabView;
@property (weak, nonatomic) IBOutlet UIView *driverTabHeadView;
@property (weak, nonatomic) IBOutlet UIView *parkTabHeadView;

/* 园区成员 */
@property (weak, nonatomic) IBOutlet UITextField *parkNameTF;
@property (weak, nonatomic) IBOutlet UITextField *organizationTypeTF;
@property (weak, nonatomic) IBOutlet UIButton *businessLicenseHaveBtn;
@property (weak, nonatomic) IBOutlet UIButton *businessLicenseNoHaveBtn;
@property (weak, nonatomic) IBOutlet UITextField *IDNumberTF;
@property (weak, nonatomic) IBOutlet UILabel *parkAddressLab;
@property (weak, nonatomic) IBOutlet UITextField *parkDetailAddressTF;
@property (weak, nonatomic) IBOutlet UIButton *businessLicenseBtn;
@property (weak, nonatomic) IBOutlet UIButton *organizationTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *parkAddressBtn;

/* 选择协议 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewH;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end

NS_ASSUME_NONNULL_END
