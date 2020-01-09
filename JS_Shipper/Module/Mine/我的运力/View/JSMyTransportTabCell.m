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

-(void)setDataModel:(JSTransportModel *)dataModel {
    self.titleLab.text = dataModel.cphm;
    self.nameLab.text = [NSString stringWithFormat:@"%@  %@",dataModel.nickName,dataModel.mobile];
    self.carTypeLab.text =  [NSString stringWithFormat:@"车型:%@   车长:%@",dataModel.carModelName,dataModel.carLengthName];
    self.numLab.text = @"";
    if ([dataModel.cooperated integerValue]>0) {
        self.numLab.text = @"合作过";
    }
    if (_isAdd) {
        _bookOrderBtn.userInteractionEnabled = YES;
        [_bookOrderBtn setTitle:@"添加" forState:UIControlStateNormal];
        if ([dataModel.added boolValue]) {
            _bookOrderBtn.userInteractionEnabled = NO;
            [_bookOrderBtn setTitle:@"已添加" forState:UIControlStateNormal];
        }
    }
    else {
        self.remarkLab.text = [NSString stringWithFormat:@"备注:%@",dataModel.remark];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
