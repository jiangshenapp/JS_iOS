//
//  JSMyDepositVC.h
//  JS_Driver
//
//  Created by zhanbing han on 2019/5/6.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "BaseVC.h"
#import "AccountInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSMyDepositVC : BaseVC

/** 账户信息 */
@property (nonatomic,retain) AccountInfo *accountInfo;

@property (weak, nonatomic) IBOutlet UILabel *depositLab;

@end

NS_ASSUME_NONNULL_END
