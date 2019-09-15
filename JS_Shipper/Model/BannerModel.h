//
//  BannerModel.h
//  JS_Shipper
//
//  Created by Jason_zyl on 2019/9/15.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "BaseItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface BannerModel : BaseItem

/**
 * {
 "url" : "baidu.com",
 "sort" : 2,
 "beginTime" : "2019-09-03 12:00:00",
 "id" : 1,
 "endTime" : "2019-09-14 11:26:15",
 "title" : "veshi",
 "image" : "14573d05a61d4775b24fdf1f10fa8c99.jpg",
 "createBy" : 1,
 "type" : 1,
 "state" : 1,
 "createTime" : "2019-09-14 11:26:15"
 }
 */

/** 服务标题 */
@property (nonatomic, copy) NSString              *title;
/** 服务图标 */
@property (nonatomic, copy) NSString              *bannerImage;
/** 服务url */
@property (nonatomic, copy) NSString              *url;

@end

NS_ASSUME_NONNULL_END
