//
//  ServiceModel.m
//  JS_Shipper
//
//  Created by Jason_zyl on 2019/9/14.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "ServiceModel.h"

@implementation ServiceModel

- (NSString *)icon {
    if (![_icon containsString:@"http"]) {
        _icon = [NSString stringWithFormat:@"%@%@",PIC_URL(),_icon];
    }
    return _icon;
}

@end
