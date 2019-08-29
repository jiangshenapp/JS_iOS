//
//  AuthInfo.m
//  JS_Driver
//
//  Created by Jason_zyl on 2019/5/12.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "AuthInfo.h"

@implementation AuthInfo

- (NSString *)idImage {
    if (![_idImage containsString:@"http"]) {
        _idImage = [NSString stringWithFormat:@"%@%@",PIC_URL(),_idImage];
    }
    return _idImage;
}

- (NSString *)idBackImage {
    if (![_idBackImage containsString:@"http"]) {
        _idBackImage = [NSString stringWithFormat:@"%@%@",PIC_URL(),_idBackImage];
    }
    return _idBackImage;
}

- (NSString *)idHandImage {
    if (![_idHandImage containsString:@"http"]) {
        _idHandImage = [NSString stringWithFormat:@"%@%@",PIC_URL(),_idHandImage];
    }
    return _idHandImage;
}

- (NSString *)driverImage {
    if (![_driverImage containsString:@"http"]) {
        _driverImage = [NSString stringWithFormat:@"%@%@",PIC_URL(),_driverImage];
    }
    return _driverImage;
}

- (NSString *)cyzgzImage {
    if (![_cyzgzImage containsString:@"http"]) {
        _cyzgzImage = [NSString stringWithFormat:@"%@%@",PIC_URL(),_cyzgzImage];
    }
    return _cyzgzImage;
}

- (NSString *)businessLicenceImage {
    if (![_businessLicenceImage containsString:@"http"]) {
        _businessLicenceImage = [NSString stringWithFormat:@"%@%@",PIC_URL(),_businessLicenceImage];
    }
    return _businessLicenceImage;
}

@end
