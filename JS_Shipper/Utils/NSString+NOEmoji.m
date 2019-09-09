//
//  NSString+NOEmoji.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/9.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "NSString+NOEmoji.h"

@implementation NSString (NOEmoji)
//实现
- (BOOL)isEmoji {
    if ([self length]<2)
    {
        return NO;
    }
    
    static NSCharacterSet *_variationSelectors;
    _variationSelectors = [NSCharacterSet characterSetWithRange:NSMakeRange(0xFE00, 16)];
    
    if ([self rangeOfCharacterFromSet: _variationSelectors].location != NSNotFound)
    {
        return YES;
    }
    const unichar high = [self characterAtIndex:0];
    // Surrogate pair (U+1D000-1F9FF)
    if (0xD800 <= high && high <= 0xDBFF)
    {
        const unichar low = [self characterAtIndex: 1];
        const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
        return (0x1D000 <= codepoint && codepoint <= 0x1F9FF);
        // Not surrogate pair (U+2100-27BF)
    }
    else
    {
        return (0x2100 <= high && high <= 0x27BF);
    }
}


- (NSString *)noEmoji {
    //去除表情规则
    //  \u0020-\\u007E  标点符号，大小写字母，数字
    //  \u00A0-\\u00BE  特殊标点  (¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾)
    //  \u2E80-\\uA4CF  繁简中文,日文，韩文 彝族文字
    //  \uFE30-\\uFE4F  特殊标点(︴︵︶︷︸︹)
    //  \uFF00-\\uFFEF  日文  (ｵｶｷｸｹｺｻ)
    //  \u2000-\\u201f  特殊字符(‐‑‒–—―‖‗‘’‚‛“”„‟)
    // 注：对照表 http://blog.csdn.net/hherima/article/details/9045765
    
    NSRegularExpression* expression = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSString* result = [expression stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, self.length) withTemplate:@""];
    
    return result;
}

/** *  判断字符串中是否包含非法字符 *
 @param content 需要判断的字符串 *
 @return Yes: 包含；No: 不包含 */
- (BOOL)hasIllegalCharacter{
    // 特殊字符
    
    NSString *str = @"[^%@#^*&¥'~=$<>`\x22]+";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    if (![emailTest evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}

@end
