//
//  JSPayVC.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/29.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSPayVC : BaseVC

/** 价格 */
@property (nonatomic,copy) NSString *price;
/** 订单ID */
@property (nonatomic,copy) NSString *orderID;

@property (weak, nonatomic) IBOutlet UILabel *payMoneyLab;

- (IBAction)payTypeAction:(UIButton *)sender;

- (IBAction)payAction:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
