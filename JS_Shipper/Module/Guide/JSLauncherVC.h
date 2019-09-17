//
//  JSLauncherVC.h
//  JS_Shipper
//
//  Created by Jason_zyl on 2019/9/17.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSLauncherVC : BaseVC

/** 启动页完成 */
@property (nonatomic,copy) dispatch_block_t doneBlock;

@end

NS_ASSUME_NONNULL_END
