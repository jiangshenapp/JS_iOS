//
//  Config.m
//  Chaozhi
//  Notes：测试环境服务地址说明：https://test.jiangshen56.com  运营平台 https://testway.jiangshen56.com 测试网关
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "Config.h"

@implementation Config

NSString *h5Url(void) {
    if (KOnline || [Utils getServer] == 1) {
        return @"https://www.jiangshen56.com/"; //正式地址
    } else {
        return @"https://www.jiangshen56.com/"; //测试地址
    }
}

NSString *ROOT_URL(void) {
    if (KOnline || [Utils getServer] == 1) {
        return @"https://gateway.jiangshen56.com/logistic-biz"; //正式地址
    } else {
        return @"http://testway.jiangshen56.com/logistic-biz"; //测试地址
    }
}

NSString *PIC_URL(void) {
    if (KOnline || [Utils getServer] == 1) {
        return @"https://gateway.jiangshen56.com/admin/file/download?fileName="; //正式地址
    } else {
        return @"http://testway.jiangshen56.com/admin/file/download?fileName="; //测试地址
    }
}

NSString *UPLOAD_URL(void) {
    if (KOnline || [Utils getServer] == 1) {
        return @"https://gateway.jiangshen56.com/admin/file/upload"; //正式地址
    } else {
        return @"http://testway.jiangshen56.com/admin/file/upload"; //测试地址
    }
}

NSString *PAY_URL(void) {
    if (KOnline || [Utils getServer] == 1) {
        return @"https://gateway.jiangshen56.com/pigx-pay-biz/pay/getRoute"; //正式地址
    } else {
        return @"http://testway.jiangshen56.com/pigx-pay-biz/pay/getRoute"; //测试地址
    }
}

@end
