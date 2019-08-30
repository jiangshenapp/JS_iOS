//
//  JSAllOrderVC.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/28.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "BaseVC.h"
#import "ListOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSAllOrderVC : BaseVC

/** 0全部  1发布中 2待支付 3待配送 4待收货 */
@property (nonatomic,assign) NSInteger typeFlage;

- (IBAction)titleBtnAction:(UIButton *)sender;

@end

@interface MyOrderTabCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderNoLab;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLab;
@property (weak, nonatomic) IBOutlet UILabel *startAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *endAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *goodsDetaileLab;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLab;

- (void)setContentWithModel:(ListOrderModel *)model;

@end

NS_ASSUME_NONNULL_END
