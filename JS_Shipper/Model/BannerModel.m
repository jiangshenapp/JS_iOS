//
//  BannerModel.m
//  JS_Shipper
//
//  Created by Jason_zyl on 2019/9/15.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "BannerModel.h"

@implementation BannerModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"bannerImage":@"image"};
}

- (NSString *)bannerImage {
    if (![_bannerImage containsString:@"http"]) {
        _bannerImage = [NSString stringWithFormat:@"%@%@",PIC_URL(),_bannerImage];
    }
    return _bannerImage;
}

@end
