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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *authStateH;
@property (weak, nonatomic) IBOutlet UILabel *authStateLab;
@property (weak, nonatomic) IBOutlet UITableView *personTabView;
@property (weak, nonatomic) IBOutlet UITableView *companyTabView;
@property (weak, nonatomic) IBOutlet UIView *personTabHeadView;
@property (weak, nonatomic) IBOutlet UIView *companyTabHeadView;
@property (weak, nonatomic) IBOutlet UIView *titleBgView;
@property (weak, nonatomic) IBOutlet UIButton *personBtn;
@property (weak, nonatomic) IBOutlet UIButton *companyBtn;

- (IBAction)titleViewAction:(UIButton *)sender;

/* 个人 */
@property (weak, nonatomic) IBOutlet UIButton *idCardFrontBtn;
@property (weak, nonatomic) IBOutlet UIButton *idCardBehindBtn;
@property (weak, nonatomic) IBOutlet UIButton *idCardHandBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *idCardTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;

/* 公司 */
@property (weak, nonatomic) IBOutlet UITextField *companyNameTF;
@property (weak, nonatomic) IBOutlet UITextField *companyNoTF;
@property (weak, nonatomic) IBOutlet UILabel *companyAddressLab;
@property (weak, nonatomic) IBOutlet UITextField *companyDetailAddressTF;
@property (weak, nonatomic) IBOutlet UIButton *companyPhotoBtn;
@property (weak, nonatomic) IBOutlet UIButton *companyAddressBtn;

/* 选择协议 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewH;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end

NS_ASSUME_NONNULL_END
