//
//  ListOrderModel.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/6/3.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "ListOrderModel.h"

@implementation ListOrderModel

- (NSString *)driverAvatar {
    if (![_driverAvatar containsString:@"http"]) {
        _driverAvatar = [NSString stringWithFormat:@"%@%@",PIC_URL(),_driverAvatar];
    }
    return _driverAvatar;
}

- (NSString *)image1 {
    if (![_image1 containsString:@"http"]) {
        _image1 = [NSString stringWithFormat:@"%@%@",PIC_URL(),_image1];
    }
    return _image1;
}

- (NSString *)image2 {
    if (![_image2 containsString:@"http"]) {
        _image2 = [NSString stringWithFormat:@"%@%@",PIC_URL(),_image2];
    }
    return _image2;
}

- (NSString *)goodsVolume {
    _goodsVolume = [NSString stringWithFormat:@"%.2f",[_goodsVolume doubleValue]];
    return _goodsVolume;
}

- (NSString *)goodsWeight {
    _goodsWeight = [NSString stringWithFormat:@"%.2f",[_goodsWeight doubleValue]];
    return _goodsWeight;
}

@end
