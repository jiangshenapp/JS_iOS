//
//  BaseCustomView.h
//  JS_Driver
//
//  Created by zhanbing han on 2019/5/22.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCustomButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseCustomView : UIView
/** 视图高度 */
@property (nonatomic,assign) CGFloat viewHeight;
- (void)showView ;
- (void)hiddenView ;
@end

NS_ASSUME_NONNULL_END
