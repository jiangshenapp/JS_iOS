//
//  JSCityDeliveryDetailVC.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/6/14.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSHomeDetailVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSCityDeliveryDetailVC : JSHomeDetailVC

@property (weak, nonatomic) IBOutlet UIView *tabHeadView;
@property (weak, nonatomic) IBOutlet UIImageView *parkImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *parkImgH;
@property (weak, nonatomic) IBOutlet UILabel *dotNameLab;
@property (weak, nonatomic) IBOutlet UILabel *dotAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UITextView *contentTV;

@end

NS_ASSUME_NONNULL_END
