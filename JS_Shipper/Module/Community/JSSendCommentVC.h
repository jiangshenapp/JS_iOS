//
//  JSSendCommentVC.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/3.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "BaseVC.h"
#import "NSString+NOEmoji.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSSendCommentVC : BaseVC
/** <#object#> */
@property (nonatomic,copy) NSString *postId;
/** <#object#> */
@property (nonatomic,copy)  dispatch_block_t doneBlock;
@end

NS_ASSUME_NONNULL_END
