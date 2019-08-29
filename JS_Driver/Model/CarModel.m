//
//  CarModel.m
//  JS_Driver
//
//  Created by Jason_zyl on 2019/6/14.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "CarModel.h"

@implementation CarModel

- (NSString *)image2 {
    if (![_image2 containsString:@"http"]) {
        _image2 = [NSString stringWithFormat:@"%@%@",PIC_URL(),_image2];
    }
    return _image2;
}

- (NSString *)image1 {
    if (![_image1 containsString:@"http"]) {
        _image1 = [NSString stringWithFormat:@"%@%@",PIC_URL(),_image1];
    }
    return _image1;
}

@end
