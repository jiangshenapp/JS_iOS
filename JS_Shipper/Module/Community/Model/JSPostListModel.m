//
//  JSPostListModel.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/9.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "JSPostListModel.h"

@implementation JSPostListModel
-(NSString *)avatar {
    if (![_avatar containsString:@"http"]) {
        _avatar = [NSString stringWithFormat:@"%@%@",PIC_URL(),_avatar];
    }
    return _avatar;
}

-(NSString *)image {
    if (![_image containsString:@"http"]&&_image.length>0) {
        _image = [NSString stringWithFormat:@"%@%@",PIC_URL(),_image];
    }
    return _image;
}
@end
