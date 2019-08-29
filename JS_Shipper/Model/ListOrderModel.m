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

//- (NSString *)commentImage1 {
//    if (![_commentImage1 containsString:@"http"]) {
//        _commentImage1 = [NSString stringWithFormat:@"%@%@",PIC_URL(),_commentImage1];
//    }
//    return _commentImage1;
//}
//
//- (NSString *)commentImage2 {
//    if (![_commentImage2 containsString:@"http"]) {
//        _commentImage2 = [NSString stringWithFormat:@"%@%@",PIC_URL(),_commentImage2];
//    }
//    return _commentImage2;
//}
//
//- (NSString *)commentImage3 {
//    if (![_commentImage3 containsString:@"http"]) {
//        _commentImage3 = [NSString stringWithFormat:@"%@%@",PIC_URL(),_commentImage3];
//    }
//    return _commentImage3;
//}

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

@end
