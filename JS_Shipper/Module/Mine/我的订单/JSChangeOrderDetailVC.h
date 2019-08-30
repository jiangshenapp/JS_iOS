//
//  JSChangeOrderDetailVC.h
//  JS_Shipper
//
//  Created by Jason_zyl on 2019/6/16.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "BaseVC.h"
#import "ListOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSChangeOrderDetailVC : BaseVC

/** 订单model */
@property (nonatomic,retain) ListOrderModel *model;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *feeH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payTypeH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *paymentTypeH;

@property (weak, nonatomic) IBOutlet UITextField *feeTF;
@property (weak, nonatomic) IBOutlet UILabel *payTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *paymentTypeLab;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@end

NS_ASSUME_NONNULL_END
