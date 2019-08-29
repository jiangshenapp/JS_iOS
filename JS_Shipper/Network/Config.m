//
//  Config.m
//  Chaozhi
//  Notes：
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "Config.h"

@implementation Config

NSString *h5Url(void) {
    if (KOnline || [Utils getServer] == 1) {
        return @"http://www.jiangshen56.com/"; //正式地址
    } else {
        return @"http://www.jiangshen56.com/"; //测试地址
    }
}

NSString *ROOT_URL(void) {
    
    if (KOnline || [Utils getServer] == 1) {
        return @"http://gateway.jiangshen56.com/logistic-biz"; //正式地址
    } else {
        return @"http://gateway.jiangshen56.com/logistic-biz"; //测试地址
    }
}

NSString *PIC_URL(void) {
    
    if (KOnline || [Utils getServer] == 1) {
        return @"http://gateway.jiangshen56.com/admin/file/download?fileName="; //正式地址
    } else {
        return @"http://gateway.jiangshen56.com/admin/file/download?fileName="; //测试地址
    }
}

@end
