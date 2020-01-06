//
//  JSLineDetailVC.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/6/14.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSHomeDetailVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSLineDetailVC : JSHomeDetailVC

@property (weak, nonatomic) IBOutlet UILabel *startAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *endAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UITextView *contentTV;
@property (weak, nonatomic) IBOutlet UILabel *carModelLab;
@property (weak, nonatomic) IBOutlet UILabel *calLengthLab;

@end

NS_ASSUME_NONNULL_END
