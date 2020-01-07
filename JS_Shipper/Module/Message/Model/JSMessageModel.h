//
//  JSMeaageModel.h
//  JS_Shipper
//
//  Created by zhanbing han on 2020/1/7.
//  Copyright © 2020 zhanbing han. All rights reserved.
//

#import "BaseItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSMessageModel : BaseItem

@end

@interface SysMessageModel : JSMessageModel
/** <#object#> */
@property (nonatomic,copy) NSString *isRead;
/** <#object#> */
@property (nonatomic,copy) NSString *content;
/** <#object#> */
@property (nonatomic,copy) NSString *publishTime;
/** <#object#> */
@property (nonatomic,copy) NSString *ID;
/** <#object#> */
@property (nonatomic,copy) NSString *createBy;
/** <#object#> */
@property (nonatomic,copy) NSString *title;
/** <#object#> */
@property (nonatomic,copy) NSString *type;
/** <#object#> */
@property (nonatomic,copy) NSString *createTime;

@end

@interface PushMessageModel : JSMessageModel
/** <#object#> */
@property (nonatomic,copy) NSString *pushContent;
/** <#object#> */
@property (nonatomic,copy) NSString *pushTime;
/** 状态，0未读，1已读 */
@property (nonatomic,copy) NSString *state;
/** 推送账号 */
@property (nonatomic,copy) NSString *pushTarget;
@end

NS_ASSUME_NONNULL_END
