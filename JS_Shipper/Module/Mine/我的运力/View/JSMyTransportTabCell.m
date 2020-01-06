//
//  JSMyTransportTabCell.m
//  JS_Shipper
//
//  Created by zhanbing han on 2020/1/6.
//  Copyright © 2020 zhanbing han. All rights reserved.
//

#import "JSMyTransportTabCell.h"

@implementation JSMyTransportTabCell

-(void)awakeFromNib {
    [super awakeFromNib];
    self.bookOrderBtn.borderColor = AppThemeColor;
    self.bookOrderBtn.borderWidth = 2;
    self.bookOrderBtn.cornerRadius = 17;
}

-(void)setDataModel:(RecordsModel *)dataModel {
    _titleLab.text = [NSString stringWithFormat:@"%@(%@到%@)",dataModel.cphm,dataModel.startAddressCodeName,dataModel.arriveAddressCodeName];
    _nameLab.text = [NSString stringWithFormat:@"%@ %@",dataModel.driverName,dataModel.driverPhone];
    _carTypeLab.text = [NSString stringWithFormat:@"车型:%@  车长:%@",dataModel.carModelName,dataModel.carLength];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
