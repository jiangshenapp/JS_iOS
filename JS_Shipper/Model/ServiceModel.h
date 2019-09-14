//
//  ServiceModel.h
//  JS_Shipper
//
//  Created by Jason_zyl on 2019/9/14.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "BaseItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface ServiceModel : BaseItem

/**
 * {
 "title" : "服务1",
 "icon" : "7af84a5b6bd64ab3b0f94a63cffc24e8.jpg",
 "url" : "http:\/\/www.jiangshen56.com\/"
 }
 */

/** 服务标题 */
@property (nonatomic, copy) NSString              *title;
/** 服务图标 */
@property (nonatomic, copy) NSString              *icon;
/** 服务url */
@property (nonatomic, copy) NSString              *url;

@end

NS_ASSUME_NONNULL_END
