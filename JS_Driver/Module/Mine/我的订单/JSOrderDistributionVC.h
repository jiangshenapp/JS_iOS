//
//  JSOrderDistributionVC.h
//  JS_Driver
//
//  Created by Jason_zyl on 2019/6/19.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSOrderDistributionVC : BaseVC

/** 订单编号 */
@property (nonatomic,copy) NSString *orderID;

@property (weak, nonatomic) IBOutlet UILabel *driverNameLab;
@property (weak, nonatomic) IBOutlet UILabel *carNameLab;
@property (weak, nonatomic) IBOutlet UIButton *selectDriverBtn;

@end

NS_ASSUME_NONNULL_END
