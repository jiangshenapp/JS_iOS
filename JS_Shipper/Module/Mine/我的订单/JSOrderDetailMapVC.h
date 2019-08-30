//
//  JSOrderDetailMapVC.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/4/29.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "BaseVC.h"
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSOrderDetailMapVC : BaseVC

@property (weak, nonatomic) IBOutlet UILabel *time1Lab;
@property (weak, nonatomic) IBOutlet UILabel *info1Lab;
@property (weak, nonatomic) IBOutlet UILabel *time2Lab;
@property (weak, nonatomic) IBOutlet UILabel *info2Lab;

@end

@interface MapLogisticsTabCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *infoLab;

@end

NS_ASSUME_NONNULL_END
