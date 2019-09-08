//
//  CZCommentView.h
//  Chaozhi
//
//  Created by zhanbing han on 2019/8/19.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZCommentView : UIView

/** 提交回调 */
@property (nonatomic,copy) void (^submitBlock)(NSString *score);

- (void)showView;

- (void)hiddenView;

@end




NS_ASSUME_NONNULL_END
