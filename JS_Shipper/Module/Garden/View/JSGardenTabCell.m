//
//  JSGardenTabCell.m
//  JS_Shipper
//
//  Created by Jason_zyl on 2019/6/18.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSGardenTabCell.h"

@implementation JSGardenTabCell

- (void)setModel:(RecordsModel *)model {
    
    self.timeLab.hidden = YES;
    self.startAddressLab.text = model.startAddressCodeName;
    self.endAddressLab.text = model.arriveAddressCodeName;
    if (_pageFlag == 0) {
        self.countBtn.hidden = NO;
        [self.countBtn setTitle:[Utils getTimeStrToCurrentDateWith:model.enableTime] forState:UIControlStateNormal];
        self.contentLab.text = [NSString stringWithFormat:@"%@ %@ %@/%@",model.driverName,model.cphm,model.carLengthName,model.carModelName];
    } else {
        self.countBtn.hidden = YES;
        self.contentLab.text = model.remark;
    }
    self.starView.starScore = model.score;
}

@end
