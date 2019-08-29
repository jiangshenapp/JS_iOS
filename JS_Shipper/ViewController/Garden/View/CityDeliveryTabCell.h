//
//  CityDeliveryTabCell.h
//  JS_Shipper
//
//  Created by Jason_zyl on 2019/6/18.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordsModel.h"
#import "MyCustomButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface CityDeliveryTabCell : UITableViewCell

/** 数据源 */
@property (nonatomic,retain) RecordsModel *model;

@property (weak, nonatomic) IBOutlet UILabel *dotNameLab;
@property (weak, nonatomic) IBOutlet UILabel *dustanceLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet MyCustomButton *navBtn;
@property (weak, nonatomic) IBOutlet MyCustomButton *serviceBtn;
@property (weak, nonatomic) IBOutlet UIImageView *isShowImgView;
@property (weak, nonatomic) IBOutlet MyCustomButton *iphoneCallBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendMsgBtn;

@end

NS_ASSUME_NONNULL_END
