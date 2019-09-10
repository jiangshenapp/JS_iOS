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
/** 0待审核，1通过，2拒绝 */
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
///** <#object#> */
//@property (nonatomic,copy) NSString *image;
/** 0未申请  1已申请 */
//@property (nonatomic,copy) NSString *applyStatus;
@end

NS_ASSUME_NONNULL_END
