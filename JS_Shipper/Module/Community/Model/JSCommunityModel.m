//
//  JSCommunityModel.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/9.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSCommunityModel.h"

@implementation JSCommunityModel

- (NSString *)image {
    if (![_image containsString:@"http"]) {
        _image = [NSString stringWithFormat:@"%@%@",PIC_URL(),_image];
    }
    return _image;
}

@end
