//
//  JSCircleContentVC.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/2.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "BaseVC.h"
#import "JSCommunityModel.h"
#import "PostListTabCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSCircleContentVC : BaseVC
@property (weak, nonatomic) IBOutlet UIScrollView *titleScrollVew;
/** 圈子id */
@property (nonatomic,copy) NSString *circleId;
/** 数据模型 */
@property (nonatomic,retain) JSCommunityModel *dataModel;
@end

NS_ASSUME_NONNULL_END
