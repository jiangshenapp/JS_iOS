//
//  FilterButton.h
//  JS_Shipper
//
//  Created by Jason_zyl on 2019/6/18.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FilterButton : UIButton

/** 是否选中 */
@property (nonatomic,assign) BOOL isSelect;
/** icon */
@property (nonatomic,retain)  UIImageView *imgView;
/** 文字 */
@property (nonatomic,retain) UILabel *titleLab;

@end

NS_ASSUME_NONNULL_END
