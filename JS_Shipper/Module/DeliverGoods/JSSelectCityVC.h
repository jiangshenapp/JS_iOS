//
//  JSSelectCityVC.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/4/26.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSSelectCityVC : BaseVC
/** 选中当前城市 */
@property (nonatomic,copy) void(^getSelectDic)( NSDictionary *dic);
@end

NS_ASSUME_NONNULL_END
