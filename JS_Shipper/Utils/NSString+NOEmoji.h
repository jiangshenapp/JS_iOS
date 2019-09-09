//
//  NSString+NOEmoji.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/9.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (NOEmoji)
/** *  判断字符串中是否包含非法字符 *
 @param content 需要判断的字符串 *
 @return Yes: 包含；No: 不包含 */
- (BOOL)hasIllegalCharacter;

- (NSString *)noEmoji ;
//实现
- (BOOL)isEmoji ;

@end

NS_ASSUME_NONNULL_END
