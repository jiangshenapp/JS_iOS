//
//  JSTieziListVC.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/4.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "BaseVC.h"
#import "JSCircleContentVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSTieziListVC : BaseVC
/** 类型 0 发布 1点赞 2 评论 */
@property (nonatomic,assign) NSInteger type;
@end

NS_ASSUME_NONNULL_END
