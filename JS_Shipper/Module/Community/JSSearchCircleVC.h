//
//  JSSearchCircleVC.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/9/2.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSSearchCircleVC : BaseVC
/** 城市id */
@property (nonatomic,copy) NSString *cityID;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@end

NS_ASSUME_NONNULL_END
