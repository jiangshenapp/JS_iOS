//
//  JSMyTieZiListSwitchVC.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/11.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "YPTabBarController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSMyTieZiListSwitchVC : YPTabBarController
/** 0发布 1点赞  2评论 */
@property (nonatomic,assign) NSInteger type;
@end

NS_ASSUME_NONNULL_END
