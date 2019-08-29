//
//  JSHomeDetaileVC.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/6/14.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "BaseVC.h"
#import "JSGardenVC.h"
#import "RecordsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSHomeDetaileVC : BaseVC

/** 车源id */
@property (nonatomic,copy) NSString *carSourceID;
/** 数据源 */
@property (nonatomic,retain) RecordsModel *dataModel;

/** 收藏按钮 */
@property (nonatomic,retain) UIButton *collectBtn;
/** 打电话按钮 */
@property (nonatomic,retain) UIButton *callBtn;
/** 聊天按钮 */
@property (nonatomic,retain) UIButton *chatBtn;
/** 打电话按钮 */
@property (nonatomic,retain) UIButton *cretaeOrderBtn;

@end

NS_ASSUME_NONNULL_END
