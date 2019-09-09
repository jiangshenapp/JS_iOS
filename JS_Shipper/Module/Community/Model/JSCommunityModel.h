//
//  JSCommunityModel.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/9.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "BaseItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSCommunityModel : BaseItem
/** <#object#> */
@property (nonatomic,copy) NSString *admin;
/** object */
@property (nonatomic,copy) NSString *applyStatus;
/** <#object#> */
@property (nonatomic,copy) NSString *city;
/** <#object#> */
@property (nonatomic,copy) NSString *ID;
/** <#object#> */
@property (nonatomic,copy) NSString *name;
/** <#object#> */
@property (nonatomic,copy) NSString *showSide;
/** <#object#> */
@property (nonatomic,copy) NSString *status;
/** <#object#> */
@property (nonatomic,copy) NSString *stopWord;
/** <#object#> */
@property (nonatomic,copy) NSString *subjects;
/** <#object#> */
@property (nonatomic,copy) NSString *image;
@end

NS_ASSUME_NONNULL_END
