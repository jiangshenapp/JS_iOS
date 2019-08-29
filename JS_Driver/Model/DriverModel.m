//
//  DriverModel.m
//  JS_Driver
//
//  Created by Jason_zyl on 2019/6/9.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "DriverModel.h"

@implementation DriverModel

- (NSString *)avatar {
    _avatar = [NSString stringWithFormat:@"%@%@",PIC_URL(),_avatar];
    return _avatar;
}

@end
