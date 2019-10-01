//
//  JSBindingPhoneVC.h
//  JS_Shipper
//
//  Created by Jason_zyl on 2019/10/1.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "BaseVC.h"
#import "WxAuthModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSBindingPhoneVC : BaseVC

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

/** 微信授权信息 */
@property (nonatomic, retain) WxAuthModel *wxAuthModel;

@end

NS_ASSUME_NONNULL_END
