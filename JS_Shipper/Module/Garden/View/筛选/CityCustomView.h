//
//  CityCustomView.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/4/20.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCustomView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CityCustomView : BaseCustomView
/** 当前定位城市 */
@property (nonatomic,copy) NSString *locName;
/** 当前数据 */
@property (nonatomic,copy) void (^getCityData)(NSDictionary *dataDic);
@end

NS_ASSUME_NONNULL_END
