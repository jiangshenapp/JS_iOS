//
//  WxAuthModel.h
//  JS_Shipper
//
//  Created by Jason_zyl on 2019/10/1.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "BaseItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface WxAuthModel : BaseItem

/**
 * {
 "headimgurl" : "http:\/\/thirdwx.qlogo.cn\/mmopen\/vi_32\/WcO8NfH5bIVHLnkkGficjicv3Gd7ATwvqDKicFhicWsSjVJsUqacticIFYzTfOFT4wUoj6FANw6RL51IOIoy6JXMCog\/132",
 "unionid" : "oft4Q1DOh6uHSyK6L1ctVmhXCdMg",
 "nickname" : "幸运one",
 "openid" : "oNNk21huIhNNtOYLBLN4AbdYyi1k"
 }
 */

/** 微信头像 */
@property (nonatomic, copy) NSString              *headimgurl;
/** 微信unionid */
@property (nonatomic, copy) NSString              *unionid;
/** 微信昵称 */
@property (nonatomic, copy) NSString              *nickname;
/** 微信openid */
@property (nonatomic, copy) NSString              *openid;

@end

NS_ASSUME_NONNULL_END
