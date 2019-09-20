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
//
//- (NSString *)image1 {
//    if (_image1.length==0) {
//        return @"";
//    }
//    if (![_image1 containsString:@"http"]) {
//        _image1 = [NSString stringWithFormat:@"%@%@",PIC_URL(),_image1];
//    }
//    return _image1;
//}
//
//- (NSString *)image2 {
//    if (_image2.length==0) {
//        return @"";
//    }
//    if (![_image2 containsString:@"http"]) {
//        _image2 = [NSString stringWithFormat:@"%@%@",PIC_URL(),_image2];
//    }
//    return _image1;
//}
//
//- (NSString *)image3 {
//    if (_image3.length==0) {
//        return @"";
//    }
//    if (![_image3 containsString:@"http"]) {
//        _image3 = [NSString stringWithFormat:@"%@%@",PIC_URL(),_image3];
//    }
//    return _image3;
//}
//
//- (NSString *)image4 {
//    if (_image4.length==0) {
//        return @"";
//    }
//    if (![_image4 containsString:@"http"]) {
//        _image4 = [NSString stringWithFormat:@"%@%@",PIC_URL(),_image4];
//    }
//    return _image4;
//}

@end
