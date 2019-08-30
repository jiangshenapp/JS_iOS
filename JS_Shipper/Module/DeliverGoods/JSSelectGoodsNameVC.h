//
//  JSSelectGoodsNameVC.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/6/24.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^SelectBlock) (NSString *name);

@interface JSSelectGoodsNameVC : BaseVC

@property (nonatomic,copy) SelectBlock selectBlock; //选择回调

/** 0货物名称 1货品名称 */
@property (nonatomic,assign) NSInteger sourceType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewH;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UIView *nameView;

@end

NS_ASSUME_NONNULL_END
