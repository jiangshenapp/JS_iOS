//
//  MyCustomButton.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/5/28.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyCustomButton : UIButton
/** 是否选中 */
@property (nonatomic,assign) BOOL isSelect;
/**  数据源 */
@property (nonatomic,retain) id dataDic;
/** 索引 */
@property (nonatomic,assign) NSInteger index;
@end

NS_ASSUME_NONNULL_END
