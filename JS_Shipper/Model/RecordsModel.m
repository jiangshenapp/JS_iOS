//
//  RecordsModel.m
//  JS_Shipper
//
//  Created by Jason_zyl on 2019/6/18.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "RecordsModel.h"

@implementation RecordsModel

- (NSString *)businessLicenceImage {
    if (_businessLicenceImage.length==0) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@%@",PIC_URL(),_businessLicenceImage];
}

@end
