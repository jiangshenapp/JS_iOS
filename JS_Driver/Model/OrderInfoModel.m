//
//  OrderInfoModel.m
//  JS_Driver
//
//  Created by zhanbing han on 2019/6/11.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "OrderInfoModel.h"

@implementation OrderInfoModel

- (NSString *)goodsVolume {
    _goodsVolume = [NSString stringWithFormat:@"%.2f",[_goodsVolume doubleValue]];
    return _goodsVolume;
}

- (NSString *)goodsWeight {
    _goodsWeight = [NSString stringWithFormat:@"%.2f",[_goodsWeight doubleValue]];
    return _goodsWeight;
}

@end
