//
//  JSCommunityVC.h
//  JS_Driver
//
//  Created by Jason_zyl on 2019/3/6.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "BaseVC.h"
#import "CircleListTabCell.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BMKLocationKit/BMKLocationManager.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>


NS_ASSUME_NONNULL_BEGIN

@interface JSCommunityVC : BaseVC<BMKGeoCodeSearchDelegate,BMKLocationManagerDelegate>

@end


NS_ASSUME_NONNULL_END
