//
//  RequestURLUtil.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/9.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RequestURLUtil : NSObject

+ (void)postImageWithData:(UIImage *)image result:(void(^)(NSString *imageID))result;

@end

NS_ASSUME_NONNULL_END
