//
//  HomeDataModel.m
//  JS_Shipper
//
//  Created by Jason_zyl on 2019/6/18.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "HomeDataModel.h"

@implementation HomeDataModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"records":[RecordsModel class]};
}

@end
