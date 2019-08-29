//
//  JSResetPswVC.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/25.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSResetPswVC : BaseVC

@property (weak, nonatomic) IBOutlet UITextField *pswTF;
@property (weak, nonatomic) IBOutlet UITextField *pswAgainTF;

/** 手机号 */
@property (nonatomic,copy) NSString *phoneStr;

@end

NS_ASSUME_NONNULL_END
