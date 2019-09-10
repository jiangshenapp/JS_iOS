//
//  BaseItem.m
//  Chaozhi
//  Notes：
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "BaseItem.h"

@implementation BaseItem

- (void)setValue:(nullable id)value forUndefinedKey:(NSString *)key {
    
}

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}

- (NSString *)avatar {
    if (![_avatar hasPrefix:@"http"]) {
        _avatar = [NSString stringWithFormat:@"%@%@",PIC_URL(),_avatar];
    }
    return _avatar;
}

- (NSString *)image {
    if ([NSString isEmpty:_image]) {
        return @"";
    }
    if (![_image hasPrefix:@"http"]) {
        _image = [NSString stringWithFormat:@"%@%@",PIC_URL(),_image];
    }
    return _image;
}


@end
