//
//  JSPublishTopicVC.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/3.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSSendTopicVC : BaseVC
/** 圈子id */
@property (nonatomic,copy) NSString *circleId;
/** <#object#> */
@property (nonatomic,retain) NSArray *subjectArr;
@end

NS_ASSUME_NONNULL_END
